# agent-skills-nix: Claude Codeのスキルを宣言的に管理
#
# mainパターン（スキルソースはflake.nixのinputsに直接記載）
# https://github.com/Kyure-A/agent-skills-nix
# { inputs, ... }:
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
    };

    skills.enableAll = true;

    targets.claude.enable = true;
    targets.codex.enable = true;
  };
}
