# agent-skills-nix: Claude Codeのスキルを宣言的に管理
#
# mainパターン（スキルソースはflake.nixのinputsに直接記載）
# https://github.com/Kyure-A/agent-skills-nix
{ inputs, ... }:
{
  programs.agent-skills = {
    enable = true;

    sources = {
      # 既存スキル（dotfilesローカル）
      local = {
        path = ./.;
      };
      # design-skills（GitHub）
      # design = {
      #   path = inputs.design-skills;
      #   subdir = "skills";
      # };
      # playwright-cli（GitHub）
      playwright-cli = {
        path = inputs.playwright-cli-skills;
        subdir = "skills";
      };
      # drawio-mcp（GitHub）
      drawio = {
        path = inputs.drawio-mcp;
        subdir = "skill-cli";
      };
    };

    skills.enableAll = true;

    targets.claude.enable = true;
    targets.codex.enable = true;

    # 仕事用の設定ディレクトリ（_work）にも同じスキルを配置する。
    # structure は symlink-tree のまま（link はシェル変数展開が効かないため）。
    targets.claude-work = {
      enable = true;
      dest = "$HOME/.claude_work/skills";
    };
    targets.codex-work = {
      enable = true;
      dest = "$HOME/.codex_work/skills";
    };
  };
}
