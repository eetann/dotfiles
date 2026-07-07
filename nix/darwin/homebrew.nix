{
  homebrew = {
    enable = true;

    onActivation = {
      # ここに書いてないパッケージを勝手にアンインストールしない（既存brewを守る）
      cleanup = "none";
      autoUpdate = false;
      upgrade = false;
    };

    taps = [
    ];

    brews = [
    ];

    casks = [
      # MeetingBar: Nix(home.packages)で入れると、アプリ本体が
      # /nix/store配下の読み取り専用＆シンボリックリンクになり、
      # macOSの通知許可(TCC)に正しく登録されず「通知パネルに設定されていません」となる。
      # Homebrew caskなら/Applicationsに実体が置かれ署名も保たれるため通知が機能する。
      "meetingbar"

      # Thaw: メニューバー管理アプリ。TCC(アクセシビリティ等)権限が必要になるため
      # meetingbarと同様にNix(home.packages)ではなくHomebrew caskで入れる。
      "thaw"
    ];
  };
}
