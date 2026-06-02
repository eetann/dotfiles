# unfreeパッケージの許可設定
{ lib, ... }:
{
  # orbstackなど特定のunfreeパッケージのみ許可
  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg) [ "orbstack" ];
}
