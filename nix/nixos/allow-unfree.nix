# unfreeパッケージの許可設定（CUDA関連 + claude-code）
{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    pkgs._cuda.lib.allowUnfreeCudaPredicate pkg || builtins.elem (lib.getName pkg) [ "claude-code" ];
  nixpkgs.config.cudaSupport = true;
}
