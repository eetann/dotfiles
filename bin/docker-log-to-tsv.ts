#!/usr/bin/env bun

import { parseArgs } from "node:util";
import { createReadStream, createWriteStream } from "node:fs";
import { stat } from "node:fs/promises";
import { resolve } from "node:path";
import readline from "node:readline";

// ANSIエスケープシーケンスを削除
function removeAnsiEscapeSequences(text: string): string {
  // ANSIエスケープシーケンスのパターン
  const ansiPattern = /\x1b\[[0-9;]*m/g;
  // #033 形式のエスケープシーケンスも削除
  const octPattern = /#033\[[0-9;]*m/g;

  return text
    .replace(ansiPattern, '')
    .replace(octPattern, '');
}

// 日時を変換する関数 (Sep 11 04:55:00 -> 2025-09-11 04:55:00 +0000)
function convertDateTime(month: string, day: string, time: string): string {
  const monthMap: { [key: string]: string } = {
    'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
    'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
    'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
  };

  const currentYear = new Date().getFullYear();
  const monthNum = monthMap[month] || '01';
  const dayPadded = day.padStart(2, '0');

  return `${currentYear}-${monthNum}-${dayPadded} ${time} +0000`;
}

// TSV用に値をサニタイズ
function sanitizeForTsv(value: string): string {
  // タブと改行はスペースに置換
  return value.replace(/[\t\r\n]+/g, " ");
}

// ログの1行をパース
function parseDockerLogLine(line: string): string[] {
  // ANSIエスケープシーケンスを除去
  const cleanLine = removeAnsiEscapeSequences(line);

  // 基本的なパターン: Sep 11 04:55:00 ip-xxx-xxx-x-xx api/xxxxxxxxxxxx[xxxx]: ...
  const basicMatch = cleanLine.match(/^(\w+)\s+(\d+)\s+(\d{2}:\d{2}:\d{2})\s+([^\s]+)\s+([^\s]+):\s*(.*)$/);

  if (!basicMatch) {
    // パースできない行はそのまま1列として返す
    return [cleanLine];
  }

  const [, month, day, time, host, container, message] = basicMatch;
  const datetime = convertDateTime(month, day, time);

  // HTTP リクエストのパターンをチェック
  // 例: GET /foo?name=bar 304 4.360 ms - -
  const httpMatch = message.match(/^(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS)\s+([^\s]+)\s+(\d+)\s+([^\s]+)\s+ms\s+-\s+([^\s]+)$/);

  if (httpMatch) {
    const [, method, path, status, responseTime, size] = httpMatch;
    return [
      datetime,
      host,
      container,
      method,
      path,
      status,
      responseTime,
      size
    ];
  }

  // HTTPリクエストではない場合、メッセージ全体を1つのフィールドとして扱う
  return [
    datetime,
    host,
    container,
    '', // method (空)
    '', // path (空)
    '', // status (空)
    '', // responseTime (空)
    message // その他のログメッセージ
  ];
}

async function convertDockerLogToTsv(inFile: string): Promise<string> {
  const inPath = resolve(process.cwd(), inFile);
  // 出力パスの決定（.tsvを付与）
  const outPath = inPath.replace(/\.[^.]+$/, '.tsv');

  // ファイル存在チェック
  await stat(inPath);

  // ヘッダー行を定義
  const headers = ['datetime', 'host', 'container', 'method', 'path', 'status', 'response_time', 'message'];

  await new Promise<void>((resolvePromise, rejectPromise) => {
    const rs = createReadStream(inPath, { encoding: "utf8" });
    const ws = createWriteStream(outPath, { encoding: "utf8" });
    const rl = readline.createInterface({ input: rs, crlfDelay: Infinity });

    // ヘッダー行を書き込む
    ws.write(headers.join("\t") + "\n");

    rl.on("line", (line) => {
      if (line.length === 0) {
        // 空行はスキップ
        return;
      }

      const fields = parseDockerLogLine(line);
      const sanitizedFields = fields.map(sanitizeForTsv);

      // フィールド数を揃える（8列）
      while (sanitizedFields.length < 8) {
        sanitizedFields.push('');
      }

      ws.write(sanitizedFields.join("\t") + "\n");
    });

    rl.on("close", () => {
      ws.end();
    });

    ws.on("finish", () => resolvePromise());
    rs.on("error", rejectPromise);
    ws.on("error", rejectPromise);
  });

  return outPath;
}

async function main() {
  const { positionals } = parseArgs({
    args: Bun.argv.slice(2),
    options: {},
    strict: false,
    allowPositionals: true,
  });

  if (positionals.length === 0) {
    console.error("使い方: bun ~/dotfiles/bin/docker-log-to-tsv.ts <docker.log> [more.log ...]");
    console.error("例: bun ~/dotfiles/bin/docker-log-to-tsv.ts foo.log");
    process.exit(1);
  }

  for (const f of positionals) {
    try {
      const out = await convertDockerLogToTsv(f);
      console.log(`変換完了: ${resolve(process.cwd(), f)} -> ${out}`);

      // ファイルサイズの比較
      const inStats = await stat(f);
      const outStats = await stat(out);
      console.log(`元のサイズ: ${inStats.size.toLocaleString()} bytes`);
      console.log(`TSVサイズ: ${outStats.size.toLocaleString()} bytes`);
    } catch (err: any) {
      console.error(`エラー (${f}):`, err?.message ?? err);
    }
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
