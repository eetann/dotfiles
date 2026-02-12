{ pkgs, ... }:

let
  git-worktree-runner = pkgs.stdenvNoCC.mkDerivation {
    pname = "git-worktree-runner";
    version = "2.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "coderabbitai";
      repo = "git-worktree-runner";
      rev = "d7d0db887da6383ae07da2dfc5fece5615e31358";
      hash = "sha256-yJ8LfZEokFv3bMmRxwbKSn8XMBk92+boDcx9fM+1pb0=";
    };

    nativeBuildInputs = [ pkgs.installShellFiles ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # share配下にソース一式を配置
      mkdir -p $out/share/git-worktree-runner
      cp -r bin lib adapters templates $out/share/git-worktree-runner/
      chmod +x $out/share/git-worktree-runner/bin/*

      # GTR_DIRを設定して実行するラッパースクリプトを作成
      mkdir -p $out/bin
      cat > $out/bin/gtr <<WRAPPER
      #!/usr/bin/env bash
      export GTR_DIR="$out/share/git-worktree-runner"
      exec "$out/share/git-worktree-runner/bin/gtr" "\$@"
      WRAPPER
      chmod +x $out/bin/gtr

      cat > $out/bin/git-gtr <<WRAPPER
      #!/usr/bin/env bash
      export GTR_DIR="$out/share/git-worktree-runner"
      exec "$out/share/git-worktree-runner/bin/gtr" "\$@"
      WRAPPER
      chmod +x $out/bin/git-gtr

      # シェル補完をインストール
      # installShellCompletion --bash completions/gtr.bash
      # installShellCompletion --fish completions/git-gtr.fish
      installShellCompletion --zsh completions/_git-gtr

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Bash製Gitワークツリーマネージャー";
      homepage = "https://github.com/coderabbitai/git-worktree-runner";
      license = licenses.asl20;
      platforms = platforms.unix;
      mainProgram = "git-gtr";
    };
  };
in
{
  home.packages = [ git-worktree-runner ];
}
