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
    ];
  };
}
