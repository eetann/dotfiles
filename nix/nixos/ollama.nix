# WSLホスト(Windows)側のNVIDIAドライバをGPUとして使えるようにし、
# Ollamaをそのアクセラレーションで動かす
{
  pkgs,
  lib,
  config,
  ...
}:
{
  wsl.useWindowsDriver = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
    };
  };

  # /usr/lib/wsl/lib配下のバイナリ(nvidia-smi等)はWindows側が提供する
  # 非Nixビルドのため、標準の動的リンカが存在せずそのままでは実行できない。
  # nix-ldで動的リンカを補い、動作確認用にnvidia-smiを実行可能にする
  # (NIX_LDはnix-ldモジュールが自動設定するため上書きしない。
  #  NIX_LD_LIBRARY_PATHはattrsOfのマージが型不一致で効かないためmkForceで連結する)
  programs.nix-ld.enable = true;
  environment.variables.NIX_LD_LIBRARY_PATH = lib.mkForce "${config.environment.sessionVariables.NIX_LD_LIBRARY_PATH}:/usr/lib/wsl/lib";
}
