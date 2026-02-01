# macOSシステム設定（system.defaults）
{ ... }:
{
  # nix-darwinのバージョン管理
  system.stateVersion = 5;

  system.keyboard = {
    enableKeyMapping = true;
    # CapsLockをControlにマッピング
    remapCapsLockToControl = true;
  };

  system.defaults = {

    # Dock設定
    dock = {
      autohide = true; # 自動的に隠す
      orientation = "left"; # 左側に配置
      tilesize = 40; # アイコンサイズ
      magnification = false; # 拡大機能OFF
      show-recents = false; # 最近使ったアプリを非表示
    };

    # Finder設定
    # 設定変更後はFinderの再起動が必要。コマンド:
    #   killall Finder
    finder = {
      AppleShowAllFiles = true; # 隠しファイルを表示
      ShowPathbar = true; # パスバー表示
      ShowStatusBar = false; # ステータスバー非表示
      FXPreferredViewStyle = "Nlsv"; # リスト表示
      FXDefaultSearchScope = "SCcf"; # 現在のフォルダを検索
    };

    # スクリーンキャプチャ設定
    screencapture = {
      location = "~/Downloads"; # 保存場所
      type = "png"; # ファイル形式
      disable-shadow = false; # 影を有効
    };

    # トラックパッド設定
    trackpad = {
      Clicking = true; # タップでクリック
      TrackpadRightClick = true; # 二本指で右クリック
      TrackpadThreeFingerDrag = true; # 三本指でドラッグ
    };

    # グローバル設定（NSGlobalDomain）
    NSGlobalDomain = {
      # 外観
      AppleInterfaceStyle = "Dark"; # ダークモード
      AppleShowScrollBars = "Always"; # スクロールバーを常に表示
      AppleShowAllExtensions = true; # 拡張子を表示

      # キーボード
      KeyRepeat = 2; # キーリピート速度（かなり速い、30ms）
      InitialKeyRepeat = 25; # リピート開始遅延（短い、417ms）

      # 自動補正機能（すべてOFF）
      NSAutomaticCapitalizationEnabled = false; # 自動大文字化
      NSAutomaticSpellingCorrectionEnabled = false; # 自動スペル修正
      NSAutomaticQuoteSubstitutionEnabled = false; # スマート引用符
      NSAutomaticDashSubstitutionEnabled = false; # スマートダッシュ
      NSAutomaticPeriodSubstitutionEnabled = false; # 自動ピリオド挿入

      # スクロール
      "com.apple.swipescrolldirection" = true; # ナチュラルスクロール
    };
  };
}
