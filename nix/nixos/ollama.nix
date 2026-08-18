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
      # opencode等が長いプロンプトを送るため、デフォルトの4096から拡張。
      # gemma-4-26B-A4B(QAT UD-Q4_K_XL, 14.2GB)をRTX 5070 Ti(16GB)にフルGPUロードしつつ
      # 128Kコンテキストを確保する構成を想定。OOMする場合は65536等に下げる
      OLLAMA_CONTEXT_LENGTH = "131072";
      # KVキャッシュ量子化(下記)の前提条件。有効化しないとOLLAMA_KV_CACHE_TYPEが効かない
      OLLAMA_FLASH_ATTENTION = "1";
      # KVキャッシュをq4_0に量子化してメモリ使用量を約1/4に削減し、
      # 16GB VRAMでも大きいコンテキストを確保できるようにする(全ロードモデル共通設定)
      OLLAMA_KV_CACHE_TYPE = "q4_0";
    };
  };

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
