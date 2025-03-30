{ inputs, config, pkgs, lib, ... }:

{
  # macOS system defaults configuration
  # This sets various macOS settings that would normally be configured through System Preferences
  
  system.defaults = {
    # Login window settings
    loginwindow = {
      LoginwindowText = "";                    # No custom text on login screen
      GuestEnabled = false;                    # Disable guest account
      DisableConsoleAccess = true;             # Disable console login
    };

    # Dock settings
    dock = {
      autohide = true;                         # Automatically hide the dock
      orientation = "right";                   # Place dock on the right side
      show-process-indicators = true;          # Show indicators for open applications
      show-recents = true;                     # Show recent applications
      static-only = true;                      # Only show running applications
      wvous-tr-corner = 1;                     # Top right corner: Disabled
      wvous-br-corner = 1;                     # Bottom right corner: Disabled
      mru-spaces = false;                      # Don't automatically rearrange spaces
    };

    # Finder settings
    finder = {
      AppleShowAllExtensions = true;           # Show all file extensions
      ShowPathbar = true;                      # Show path bar
      FXEnableExtensionChangeWarning = false;  # Don't warn when changing extensions
      _FXShowPosixPathInTitle = true;          # Show full POSIX path in Finder title
      CreateDesktop = false;                   # Don't show icons on the desktop
    };

    # Global system settings
    NSGlobalDomain = {
      # Input settings
      "com.apple.swipescrolldirection" = false;  # Natural scrolling disabled
      AppleKeyboardUIMode = 3;                   # Full keyboard access for all controls
      
      # Visual settings
      AppleShowAllFiles = true;                  # Show hidden files
      NSNavPanelExpandedStateForSaveMode = true; # Expanded save panel by default
      NSNavPanelExpandedStateForSaveMode2 = true;
      
      # Behavior settings
      NSAutomaticCapitalizationEnabled = false;  # Disable auto-capitalization
      NSAutomaticDashSubstitutionEnabled = false;# Disable dash substitution
      NSAutomaticPeriodSubstitutionEnabled = false; # Disable period substitution
      NSAutomaticQuoteSubstitutionEnabled = false; # Disable quote substitution
      NSAutomaticSpellingCorrectionEnabled = false; # Disable spelling correction
      
      # Uncomment to hide menu bar (works with Aerospace)
      # _HIHideMenuBar = true;
    };

    # Trackpad settings
    trackpad = {
      Clicking = true;                         # Enable tap to click
      TrackpadRightClick = true;               # Enable two-finger right click
    };
    
    # Screenshots settings
    screencapture = {
      location = "~/Pictures/Screenshots";     # Save screenshots to Pictures/Screenshots
      disable-shadow = true;                   # Disable window shadows in screenshots
    };
  };
  
  # Enable firewall
  system.defaults.alf = {
    globalstate = 1;                           # Enable firewall
    allowsignedenabled = 1;                    # Allow signed apps
    allowdownloadsignedenabled = 1;            # Allow downloaded signed apps
  };
}