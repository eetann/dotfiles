# ディスク容量を圧迫しがちなものを定期的に掃除する。
# launchd.agents/systemd.userはそれぞれ対応OS以外では無視されるので、
# macOS(launchd)とNixOS-WSL(systemdのユーザータイマー)の両方を書いておけば分岐は不要。
{
  config,
  pkgs,
  lib,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";

  # gomi(rmの代わりに使っているゴミ箱CLI)には自動削除の機能がなく、
  # `gomi --prune=<期間>` を手で打つしかないため定期実行する。
  # -f を付けないと削除前に確認プロンプトが出て、非対話の定期実行では止まってしまう。
  # 2週間より前にゴミ箱へ移したものを完全に削除する
  gomiPrune = [
    "${pkgs.gomi}/bin/gomi"
    "--prune=2w"
    "-f"
  ];

  # 消しても必要になったら再取得されるだけのキャッシュを削除するスクリプト
  cleanupCaches = "${dotfilesDir}/bin/cleanup-caches";
in
{
  # gomiのゴミ箱: 毎日
  launchd.agents.gomi-prune = {
    enable = true;
    config = {
      ProgramArguments = gomiPrune;
      # スリープ中で実行時刻を逃した場合は、復帰後に1回だけ実行される
      StartCalendarInterval = [
        {
          Hour = 12;
          Minute = 0;
        }
      ];
    };
  };

  systemd.user.services.gomi-prune = {
    Unit.Description = "Prune old files from gomi trash";
    Service = {
      Type = "oneshot";
      ExecStart = lib.concatStringsSep " " gomiPrune;
    };
  };
  systemd.user.timers.gomi-prune = {
    Unit.Description = "Run gomi prune daily";
    Timer = {
      OnCalendar = "daily";
      # PCが止まっていて実行時刻を逃した場合は、次の起動時に実行する
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # キャッシュ: 毎月1日と15日（≒2週に1回）
  # launchdのStartIntervalは再起動のたびにカウントがリセットされるため、
  # 「2週間ごと」ではなく日付指定にしている
  launchd.agents.cleanup-caches = {
    enable = true;
    config = {
      ProgramArguments = [ cleanupCaches ];
      StartCalendarInterval = [
        {
          Day = 1;
          Hour = 12;
          Minute = 0;
        }
        {
          Day = 15;
          Hour = 12;
          Minute = 0;
        }
      ];
      # launchdのPATHは/usr/bin:/bin:/usr/sbin:/sbinだけなので、nixで入れたpnpm等が見つかるようにする
      EnvironmentVariables.PATH = lib.concatStringsSep ":" [
        "${config.home.profileDirectory}/bin"
        "/run/current-system/sw/bin"
        "/opt/homebrew/bin"
        "/usr/bin"
        "/bin"
        "/usr/sbin"
        "/sbin"
      ];
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/cleanup-caches.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/cleanup-caches.log";
    };
  };

  # NixOSはsystemdのユーザーサービスのPATHに/etc/profiles/per-user/$USER/binが入っているので設定不要
  systemd.user.services.cleanup-caches = {
    Unit.Description = "Clean up package manager and build caches";
    Service = {
      Type = "oneshot";
      ExecStart = cleanupCaches;
    };
  };
  systemd.user.timers.cleanup-caches = {
    Unit.Description = "Run cache cleanup on the 1st and 15th";
    Timer = {
      OnCalendar = "*-*-01,15 12:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
