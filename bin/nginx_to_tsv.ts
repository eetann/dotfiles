#!/usr/bin/env bun

import { parseArgs } from "node:util";
import { createReadStream, createWriteStream } from "node:fs";
import { stat } from "node:fs/promises";
import { resolve } from "node:path";
import readline from "node:readline";

type TokenizeOptions = {
  respectQuotes?: boolean;
  respectBrackets?: boolean; // [ ... ] を一塊として扱う
};

function tokenize(line: string, opts: TokenizeOptions = {}): string[] {
  const respectQuotes = opts.respectQuotes !== false;
  const respectBrackets = opts.respectBrackets !== false;

  const tokens: string[] = [];
  let buf = "";
  let inQuotes = false;
  let bracketDepth = 0;

  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    const prev = i > 0 ? line[i - 1] : "";

    if (respectQuotes && ch === '"' && prev !== "\\" && bracketDepth === 0) {
      inQuotes = !inQuotes;
      continue; // 引用符そのものは捨てる
    }

    if (respectBrackets) {
      if (!inQuotes && ch === "[") {
        bracketDepth++;
        continue; // '[' 自体は捨てる
      }
      if (!inQuotes && ch === "]" && bracketDepth > 0) {
        bracketDepth--;
        continue; // ']' 自体は捨てる
      }
    }

    const isWs = ch === " " || ch === "\t";
    if (!inQuotes && bracketDepth === 0 && isWs) {
      if (buf.length > 0) {
        tokens.push(buf);
        buf = "";
      }
      // 連続する空白はまとめる
      continue;
    }

    buf += ch;
  }

  if (buf.length > 0) tokens.push(buf);
  return tokens;
}

function sanitizeForTsv(value: string): string {
  // TSV の列構造を保つため、タブと改行はスペース 1 つに置換する。
  // それ以外の文字はそのまま（UTF-8 を想定）。
  return value.replace(/[\t\r\n]+/g, " ");
}

async function convertLogToTsv(inFile: string): Promise<string> {
  const inPath = resolve(process.cwd(), inFile);
  // 出力パスの決定（拡張子に関わらず .tsv を付与）
  const outPath = inPath.endsWith(".log")
    ? `${inPath}.tsv`
    : `${inPath}.tsv`;

  // 早めに明確なエラーを出すための存在チェック。
  await stat(inPath);

  await new Promise<void>((resolvePromise, rejectPromise) => {
    const rs = createReadStream(inPath, { encoding: "utf8" });
    const ws = createWriteStream(outPath, { encoding: "utf8" });
    const rl = readline.createInterface({ input: rs, crlfDelay: Infinity });

    rl.on("line", (line) => {
      if (line.length === 0) {
        ws.write("\n");
        return;
      }
      const fields = tokenize(line, { respectQuotes: true, respectBrackets: true });
      const out = fields.map(sanitizeForTsv).join("\t");
      ws.write(out + "\n");
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
    options: {
      // 将来のフラグ用の予約（例: --header, --stdout）
    },
    strict: false,
    allowPositionals: true,
  });

  if (positionals.length === 0) {
    console.error("Usage: bun run ~/dotfiles/bin/nginx_to_tsv.ts <access.log> [more.log ...]");
    process.exit(1);
  }

  for (const f of positionals) {
    try {
      const out = await convertLogToTsv(f);
      console.log(`Converted: ${resolve(process.cwd(), f)} -> ${out}`);
      console.log("Input/Output encoding: UTF-8");
    } catch (err: any) {
      console.error(`Error while converting ${f}:`, err?.message ?? err);
      // 他のファイルの処理は続行
    }
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
