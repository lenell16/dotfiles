{ inputs, config, pkgs, lib, ... }:{
system.defaults = {
  loginwindow = {
    LoginwindowText = "";
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };
  dock = {
    autohide = true;
    orientation = "right";
    show-process-indicators = true;
    show-recents = true;
    static-only = true;
    wvous-tr-corner = 1;
    wvous-br-corner = 1;
    mru-spaces = false;
  };
  finder = {
    AppleShowAllExtensions = true;
    ShowPathbar = true;
    FXEnableExtensionChangeWarning = false;
  };
  NSGlobalDomain = {
    "com.apple.swipescrolldirection" = false;
    # _HIHideMenuBar = true;
  };
  # NSGlobalDomain = {
  #   AppleKeyboardUIMode = 3;
  #   "com.apple.keyboard.fnState" = true;
  # };
};
}
