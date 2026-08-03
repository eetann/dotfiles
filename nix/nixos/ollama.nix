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
    };
  };
}
