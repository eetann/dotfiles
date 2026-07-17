# agent-skills-nix: Claude Codeのスキルを宣言的に管理
#
# mainパターン（スキルソースはflake.nixのinputsに直接記載）
# https://github.com/Kyure-A/agent-skills-nix
{ inputs, lib, ... }:
let
  # 仕事用の設定ディレクトリ（_work）には置きたくないスキルID。
  # agent-skills-nixはターゲット単位でのスキル絞り込みに対応していないため、
  # 同期後にactivationスクリプトでディレクトリごと削除する。
  workExcludeSkills = [ "grilling" ];
in
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
      # grilling（GitHub, mattpocock/skills）
      # https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md
      grilling = {
        path = inputs.mattpocock-skills;
        subdir = "skills/productivity/grilling";
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

  # workExcludeSkillsに挙げたスキルを、agent-skills本体の同期後にwork系ディレクトリから削除する。
  home.activation.agent-skills-work-exclude = lib.hm.dag.entryAfter [ "agent-skills" ] (
    lib.concatMapStringsSep "\n" (skill: ''
      $DRY_RUN_CMD rm -rf $VERBOSE_ARG "$HOME/.claude_work/skills/${skill}"
      $DRY_RUN_CMD rm -rf $VERBOSE_ARG "$HOME/.codex_work/skills/${skill}"
    '') workExcludeSkills
  );
}
