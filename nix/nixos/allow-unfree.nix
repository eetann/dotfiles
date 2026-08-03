# unfreeパッケージの許可設定（CUDA関連）
{ pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkgs._cuda.lib.allowUnfreeCudaPredicate;
  nixpkgs.config.cudaSupport = true;
}
