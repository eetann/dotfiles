import type {
  CommandTemplateConfig,
  CommandTemplateContext,
  CommandTemplateOption,
  CommandTemplateOptionList,
  Niwa,
} from "@niwaterm/config";
import { layouts } from "./layouts.ts";

async function runLines(
  niwa: Niwa,
  command: string,
  ctx: CommandTemplateContext,
): Promise<string[]> {
  const result = await niwa.shell.run(command, { cwd: ctx.cwd });
  if (result.exitCode !== 0) return [];
  return result.stdout
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line !== "");
}

const layoutField = {
  label: "レイアウト",
  options: Object.entries(layouts).map(
    ([name, preset]): CommandTemplateOption => ({
      label: name,
      value: name,
      description: preset.description,
    }),
  ),
  default: "work-dev",
};

interface Worktree {
  path: string;
  branch: string;
}

// `git worktree list --porcelain`は空行区切りのブロックで、1件目がメインのワークツリー
async function listWorktrees(niwa: Niwa, ctx: CommandTemplateContext): Promise<Worktree[]> {
  const lines = await runLines(niwa, "git worktree list --porcelain", ctx);
  const worktrees: Worktree[] = [];
  for (const line of lines) {
    if (line.startsWith("worktree ")) {
      worktrees.push({ path: line.slice("worktree ".length), branch: "" });
    } else if (line.startsWith("branch ") && worktrees.length > 0) {
      worktrees[worktrees.length - 1].branch = line.slice("branch refs/heads/".length);
    }
  }
  return worktrees;
}

function toWorktreeOptions(worktrees: Worktree[]): CommandTemplateOptionList {
  return worktrees
    .filter((worktree) => worktree.branch !== "")
    .map((worktree) => ({
      label: worktree.branch,
      value: worktree.branch,
      description: worktree.path,
    }));
}

export const commandTemplates: CommandTemplateConfig[] = [
  {
    id: "worktree-new",
    name: "ワークツリーを作る",
    description: "ブランチを切ってワークツリーを作り、レイアウトを当てたBoardへ切り替える",
    command: "niwa worktree new --open board-switch --layout {{layout}} --trust {{branch}}",
    fields: {
      layout: layoutField,
      branch: { label: "ブランチ名", placeholder: "feature/...", default: "feature/" },
    },
  },
  {
    id: "worktree-remote",
    name: "リモートのブランチからワークツリーを作る",
    description: "fetchしてからリモートのブランチを選んでワークツリーを作る",
    // -wはワークスペース名の部分一致でも探せるので、review用のワークスペースへ作る
    command:
      "niwa worktree new --open board-switch -w review --layout {{layout}} --trust {{branch}}",
    fields: {
      layout: layoutField,
      branch: {
        label: "リモートのブランチ",
        focus: true,
        options: async (ctx, niwa) => {
          // 認証を求められても止まらないようにプロンプトを切る。オフライン等で失敗しても手元の一覧で続ける
          await niwa.shell.run("git fetch --prune --quiet", {
            cwd: ctx.cwd,
            env: { GIT_TERMINAL_PROMPT: "0" },
          });
          // refname:shortだとorigin/HEADは"origin"だけになるので、"/"を含まない行を落とす
          return (await runLines(niwa, "git branch -r --format='%(refname:short)'", ctx)).filter(
            (name) => name.includes("/") && !name.endsWith("/HEAD"),
          );
        },
        // PRページ等でコピーしたブランチ名がクリップボードにあれば初期値にする。
        // 候補に無い値ならniwaterm側で先頭の候補へ落ちる
        default: async (_ctx, niwa) => {
          const text = (await niwa.clipboard.read()).trim();
          if (!/^[\w.-]+(\/[\w.-]+)*$/.test(text)) return undefined;
          return text.startsWith("origin/") ? text : `origin/${text}`;
        },
      },
    },
  },
  {
    id: "worktree-open",
    name: "ワークツリーを開く",
    description: "作ってあるワークツリーをBoardで開く（開いていればそのBoardへ切り替える）",
    command: "niwa worktree open --layout {{layout}} {{worktree}}",
    fields: {
      layout: layoutField,
      worktree: {
        label: "ワークツリー",
        options: async (ctx, niwa) => toWorktreeOptions(await listWorktrees(niwa, ctx)),
      },
    },
  },
  {
    id: "worktree-remove",
    name: "ワークツリーを削除する",
    description: "ワークツリーとブランチを削除してBoardを閉じる",
    command: "niwa worktree remove --delete-branch {{worktree}}",
    fields: {
      worktree: {
        label: "ワークツリー",
        // メインのワークツリーは消せないので候補から外す
        options: async (ctx, niwa) => toWorktreeOptions((await listWorktrees(niwa, ctx)).slice(1)),
      },
    },
  },
];
