// deno-lint-ignore-file no-unversioned-import
import type { UserCompletionSource } from "jsr:@yuki-yano/zeno";
import { join } from "jsr:@std/path";

// ロックファイルの存在でパッケージマネージャを判定
async function detectPackageManager(dir: string): Promise<string> {
  const lockFiles: [string, string][] = [
    ["bun.lock", "bun"],
    ["yarn.lock", "yarn"],
    ["pnpm-lock.yaml", "pnpm"],
  ];
  for (const [file, runner] of lockFiles) {
    try {
      await Deno.stat(join(dir, file));
      return runner;
    } catch {
      // ファイルが存在しない場合は次へ
    }
  }
  return "npm";
}

// package.json の scripts を取得
async function getPackageJsonScripts(
  dir: string,
): Promise<ReadonlyArray<string>> {
  try {
    const raw = await Deno.readTextFile(join(dir, "package.json"));
    const pkg = JSON.parse(raw) as { scripts?: Record<string, string> };
    if (!pkg.scripts) return [];
    const runner = await detectPackageManager(dir);
    return Object.entries(pkg.scripts).map(
      ([name, script]) => `${runner}\t${name}\t${script}`,
    );
  } catch {
    return [];
  }
}

// mise tasks の一覧を取得
async function getMiseTasks(): Promise<ReadonlyArray<string>> {
  try {
    const cmd = new Deno.Command("mise", {
      args: ["tasks", "--no-header"],
      stdout: "piped",
      stderr: "null",
    });
    const { stdout } = await cmd.output();
    const output = new TextDecoder().decode(stdout).trim();
    if (!output) return [];
    return output.split("\n").map((line) => {
      // mise tasks --no-header の出力: "タスク名  説明" （空白区切り）
      const [name, ...descParts] = line.trim().split(/\s+/);
      const desc = descParts.join(" ");
      return `mise\t${name}\t${desc}`;
    });
  } catch {
    return [];
  }
}

export const runCompletions: UserCompletionSource[] = [
  {
    name: "統合タスクランナー",
    patterns: ["^run $"],
    sourceFunction: async ({ currentDirectory }) => {
      const [scripts, miseTasks] = await Promise.all([
        getPackageJsonScripts(currentDirectory),
        getMiseTasks(),
      ]);
      return [...scripts, ...miseTasks];
    },
    options: {
      "--no-select-1": true,
      "--prompt": "'Run> '",
    },
    callbackFunction: ({ selected }) => {
      return selected.map((line) => {
        const [runner, name] = line.split("\t");
        return `${runner} run ${name}`;
      });
    },
  },
];
