// deno-lint-ignore no-unversioned-import
import type { Snippet } from "jsr:@yuki-yano/zeno";

// 長いコマンドの展開
export const commandSnippets: Snippet[] = [
  {
    name: "blog new article",
    keyword: "BLOG",
    snippet: "node bin/new.mjs --slug",
  },
  {
    name: "claude code",
    keyword: "cc",
    snippet: "claude-chill -- claude",
  },
  {
    name: "claude code continue",
    keyword: "ccc",
    snippet: "claude-chill -- claude --continue",
  },
  {
    name: "codex",
    keyword: "cx",
    snippet: "codex",
  },
  {
    name: "docker compose",
    keyword: "DC",
    snippet: "docker-compose",
  },
  {
    name: "explorer",
    keyword: "E",
    snippet: "/mnt/c/windows/explorer.exe .",
  },
  {
    name: "php artisan",
    keyword: "PA",
    snippet: "php artisan",
  },
  {
    name: "difit",
    keyword: "difit",
    snippet: "bun x difit .",
  },
  {
    name: "nb add today's daily",
    keyword: "nbd",
    snippet: 'date "+nb a daily-%Y-%m-%d.md"',
    evaluate: true,
  },
  {
    // difitで今のHEADとdevelopmentブランチの比較
    name: "difit to dev",
    keyword: "difitd",
    snippet: "bun x difit @ development",
  },
  {
    name: "nvim-noplugin",
    keyword: "nvimno",
    snippet: "nvim --noplugin -u NONE",
  },
  {
    name: "SJIS to UTF-8",
    keyword: "UTF",
    snippet: "nkf -w --overwrite",
  },
  {
    name: "tmux popup neovim",
    keyword: "TN",
    snippet: `tmux popup -E -w 95% -h 95% -d '#{pane_current_path}' 'nvim -c "{{command_here)}}"'`,
  },
  {
    name: "tree",
    keyword: "TREE",
    snippet:
      "tree -a -I '.git|node_modules|dist|vendor|platforms' --charset unicode",
  },
  {
    name: "git switch",
    keyword: "gs",
    snippet: "git switch",
  },
  {
    name: "git worktree new brach",
    keyword: "gwn",
    snippet: "git worktree add -b",
  },
  {
    name: "git worktree already exists brach",
    keyword: "gwe",
    snippet: "git worktree add ../",
  },
  {
    name: "link mise.local.toml in worktree",
    keyword: "wtmise",
    snippet:
      'ln -s "$(git rev-parse --path-format=relative --git-common-dir | xargs dirname)/mise.local.toml" mise.local.toml && mise trust',
  },
  {
    name: "home-manager switch",
    keyword: "hms",
    snippet: "home-manager switch --flake ~/dotfiles",
  },
  {
    // 指定したcsvの2列目に重複したデータがないか調べる
    // 列を変えるなら`-f2`の部分を変更する
    name: "csv checker for duplicates col2",
    keyword: "csv_checker_for_duplicates_col2",
    snippet: "tail -n +2 {{csv_here}} | cut -d, -f2 | sort | uniq -d",
  },
  {
    // カレントディレクトリのcsvファイルを全部tsvに変換
    // ログをスプレッドシートに貼るときに便利
    name: "all csv to tsv",
    keyword: "all_csv_to_tsv",
    snippet: "for f (*.csv) bun run ~/dotfiles/bin/csv_to_tsv.ts --file $f",
  },
  {
    name: "mdjanai",
    keyword: "mdjanai",
    snippet: "node ~/ghq/github.com/eetann/mdjanai/dist/index.js",
  },
  {
    name: "convert to avif",
    keyword: "AVIF",
    snippet:
      'ffmpeg -i screenshot.png "$R2_BACKUP_PATH/works/{{image_name}}.avif"',
  },
  {
    name: "gtr init",
    keyword: "GTRINIT",
    snippet:
      'git gtr config set gtr.worktrees.dir "../" && git gtr config set gtr.worktrees.prefix "$(basename $PWD)@"',
  },
];
