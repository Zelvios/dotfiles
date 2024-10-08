{
  lib,
  osConfig,
  userInfo,
  inputs,
  pkgs,
  ...
}: {
  # If we're on Wayland, tell that to Firefox.
  home.sessionVariables = lib.mkIf osConfig.desktop.greeter.useWayland {
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      ExtensionUpdate = false;
      ExtensionSettings."{8446b178-c865-4f5c-8ccc-1d7887811ae3}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/file/3990315/catppuccin_mocha_lavender_git-2.0.xpi";
        installation_mode = "force_installed";
      };

      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always";
    };

    profiles.${userInfo.username} = {
      search = {
        default = "Google";
        force = true;

        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };

          "NixOS Wiki" = {
            urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nw"];
          };

          "Urban Dictionary" = {
            urls = [{template = "https://www.urbandictionary.com/define.php?term={searchTerms}";}];

            iconUpdateURL = "https://www.urbandictionary.com/favicon-32x32.png";
            updateInterval = 24 * 60 * 60 * 1000; # Once every day.
            definedAliases = ["@urban"];
          };

          # Disable other search engines.
          "DuckDuckGo".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
        };
      };

      settings = {
        # Auto-focus Firefox when opening link in other applications.
        "browser.tabs.loadDivertedInBackground" = false;
        # Enable autoscrolling.
        "general.autoScroll" = true;
        # Disable password saving.
        "signon.rememberSignons" = false;
        # Auto-enable extensions.
        "extensions.autoDisableScopes" = 0;
        # Enable HTTPS-Only mode.
        "dom.security.https_only_mode" = true;

        # Telemetry.
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "extensions.webcompat-reporter.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.urlbar.eventTelemetry.enabled" = false;

        # Pocket Extension.
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;

        # Privacy.
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        "browser.send_pings" = false;
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
      };

      bookmarks = [
        {
          toolbar = true;
          bookmarks = [
            {
              name = "Proton";
              bookmarks = [
                {
                  name = "Mail";
                  keyword = "ma";
                  url = "https://mail.proton.me/u/0";
                }
              ];
            }
            {
              name = "GitHub";
              keyword = "gh";
              url = "https://github.com";
            }
          ];
        }
      ];

      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        istilldontcareaboutcookies
        clearurls
        privacy-badger
        duckduckgo-privacy-essentials
        darkreader
        sponsorblock
        return-youtube-dislikes
      ];
    };
  };
}
