# Docker (NixOS-WSL用)
# MacはOrbStack(pkgs.orbstack)がdocker CLIを同梱しているため、
# NixOS側でdockerデーモンとCLIを有効化する
{ ... }:
{
  virtualisation.docker.enable = true;
}
