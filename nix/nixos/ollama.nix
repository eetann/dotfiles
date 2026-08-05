# WSLホスト(Windows)側のNVIDIAドライバをGPUとして使えるようにし、
# Ollamaをそのアクセラレーションで動かす
{ pkgs, ... }:
{
  wsl.useWindowsDriver = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
      # opencode等が長いプロンプトを送るため、デフォルトの4096から拡張
      # (16GB VRAMなら9BモデルQ4_K_Mで32768でも収まる想定。OOMする場合は16384等に下げる)
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };

  # /usr/lib/wsl/lib配下のバイナリ(nvidia-smi等)はWindows側が提供する
  # 非Nixビルドのため、標準の動的リンカが存在せずそのままでは実行できない。
  # nix-ldで動的リンカを補う
  programs.nix-ld.enable = true;

  # nvidia-smiは動作確認・デバッグ用のラッパーとして提供する。
  # LD_LIBRARY_PATHはコマンド実行時にだけ設定し、システム全体には汚染させない
  # (nix-ldは呼び出し元が設定したLD_LIBRARY_PATHをそのまま使う実装のため、
  #  ここで設定すればNIX_LD_LIBRARY_PATH側の追加設定は不要)
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nvidia-smi" ''
      export LD_LIBRARY_PATH="/usr/lib/wsl/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec /usr/lib/wsl/lib/nvidia-smi "$@"
    '')
  ];
}
