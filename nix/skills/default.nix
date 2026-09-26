# agent-skills-nix: Claude Codeのスキルを宣言的に管理
#
# mainパターン（スキルソースはflake.nixのinputsに直接記載）
# https://github.com/Kyure-A/agent-skills-nix
{ inputs, lib, ... }:
let
  # 仕事用の設定ディレクトリ（_work）には置きたくないスキルID。
  # agent-skills-nixはターゲット単位でのスキル絞り込みに対応していないため、
  # 同期後にactivationスクリプトでディレクトリごと削除する。
  workExcludeSkills = [
    "grilling"
    "adr-creator"
    "rrmap"
  ];

  # スキルソース一覧。enableAllの対象はこの定義から自動で作る。
  skillSources = {
    # 既存スキル（dotfilesローカル）
    local = {
      path = ./.;
    };
    # playwright-cli（GitHub）
    playwright-cli = {
      path = inputs.playwright-cli-skills;
      subdir = "skills";
    };
    # drawio-mcp（GitHub）
    drawio = {
      path = inputs.drawio-mcp;
      subdir = "plugins/claude-code/skills";
    };
    # grilling（GitHub, mattpocock/skills）
    # https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md
    grilling = {
      path = inputs.mattpocock-skills;
      subdir = "skills/productivity/grilling";
    };
    # natural-japanese（GitHub, coji/natural-japanese）
    # https://github.com/coji/natural-japanese
    natural-japanese = {
      path = inputs.natural-japanese;
      subdir = "skills";
    };
    # rrmap（GitHub, eetann/rrmap）
    # https://github.com/eetann/rrmap
    rrmap = {
      path = inputs.rrmap-skills;
      subdir = ".claude/skills";
    };
    # eli5（GitHub, anthropics/claude-plugins-community）
    # https://github.com/anthropics/claude-plugins-community/tree/main/eli5
    eli5 = {
      path = inputs.claude-plugins-community;
      subdir = "eli5/skills";
    };
  };

  # transformでSKILL.mdへ追記するスキルを持つソース。
  # 同じスキルIDがenableAll側とexplicit側の両方に入るとID衝突でevalが落ちるため、
  # ここに挙げたソースはenableAllの対象から外し、explicitだけで拾う。
  # 注意: 該当ソースに別のスキルが増えたら、そのスキルはexplicitへ明示的に足すこと。
  explicitOnlySources = [ "natural-japanese" ];

  # natural-japaneseのSKILL.md末尾に足す、この環境固有の検査工程。本文は別ファイル。
  # textlint本体はnix/pkgs/textlint-ai-jaでビルドし、nix/home/packages.nix経由で
  # PATHに入れている（コマンド名: textlint-ai-ja）。
  # 先頭の改行は、上流SKILL.mdの末尾との間に空行を1つ入れるため。
  textlintSection = "\n" + builtins.readFile ./natural-japanese-textlint.md;
in
{
  programs.agent-skills = {
    enable = true;

    sources = skillSources;

    skills = {
      # explicitで拾うソース以外は全部入れる
      enableAll = builtins.attrNames (builtins.removeAttrs skillSources explicitOnlySources);

      explicit = {
        # SKILL.mdの末尾にtextlintの検査工程を追記して配布する
        natural-japanese = {
          from = "natural-japanese";
          path = "natural-japanese";
          transform =
            {
              original,
              dependencies,
            }:
            original + textlintSection;
        };
      };
    };

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
