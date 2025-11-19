{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.zen;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.zen = {
    enable = lib.mkEnableOption "Zen";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Zen";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zen-browser =
      {
        enable = true;
      }
      // {
        default = let
          accent = colors.accent;
          background = colors.background.base;
          text = colors.foreground.base;
          highlight = colors.foreground.dark;
          inactive = colors.inactive;
        in {
          policies = {
            DisableAppUpdate = true;
            DisableTelemetry = true;
          };
          profiles = {
            default = {
              id = 0;

              extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
                ublock-origin
              ];
              settings = {
                "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
                "zen.urlbar.behavior" = "float";
                "zen.welcome-screen.seen" = true;
                "browser.aboutConfig.showWarning" = false;
                "browser.shell.checkDefaultBrowser" = false;
              };

              userChrome = ''
                /*
                sidebar transition
                blur url bar
                */

                * {
                  /* Font */
                  font-family: ${layout.font.name} !important;
                  color: ${text} !important;

                  /* Transparent Background */
                  &,
                  &::before,
                  &::after {
                    background: transparent !important;
                  }
                }

                /* Colored Background */
                body {
                  background: ${background}${layout.background.opacity_hex} !important;
                }
                .browserSidebarContainer {
                  background: ${background} !important;
                  border-radius: ${layout.border.radius.inner}px !important;
                }

                /* Transitions */
                .tab-background {
                  transition: background 0.2s ease;
                }

                /* Tabbar */
                #tabbrowser-tabs {
                  margin-top: 0px !important;

                  #zen-tabs-wrapper {
                    width: 100% !important;
                    margin-left: 0px !important;

                    zen-workspace {
                      width: 100% !important;

                      .zen-workspace-tabs-section {
                        padding: 0px !important;
                      }
                    }
                  }

                  #zen-essentials:has(tab) {
                    margin-bottom: ${layout.gap.inner}px !important;
                  }

                  .zen-workspace-pinned-tabs-section {
                    .vertical-pinned-tabs-container-separator {
                      margin: ${layout.gap.inner}px 0px 0px 0px !important;
                    }

                    &[hide-separator] .vertical-pinned-tabs-container-separator {
                      margin: 0px !important;
                    }
                  }
                }

                /* Tabs */
                tab.tabbrowser-tab {
                  &:not([zen-essential]):not([zen-glance-tab]) {
                    margin: 4px 0px 0px 0px !important;

                    &:first-child {
                      margin-top: 0px !important;
                    }
                  }

                  &:hover .tab-background {
                    background: ${highlight}${layout.background.opacity_hex} !important;
                  }

                  &[selected]:not(:hover) {
                    .tab-close-button {
                      display: none !important;
                    }
                  }

                  .tab-background {
                    margin: 0 !important;
                    border-radius: ${layout.border.radius.inner}px !important;

                    &:is([selected], [multiselected]) {
                      border: ${layout.border.width}px solid ${accent} !important;
                    }
                  }

                  &[zen-essential] .tab-background {
                    border: ${layout.border.width}px solid ${inactive} !important;

                    &:is([selected], [multiselected]) {
                      border: ${layout.border.width}px solid ${accent} !important;
                    }
                  }
                }

                /* Collapsed Mode */
                #main-window:not([zen-sidebar-expanded]):not(zen-single-toolbar) {
                  #TabsToolbar {
                    height: 9999px !important;
                  }

                  #navigator-toolbox {
                    margin-right: ${layout.gap.inner}px !important;
                    max-width: unset !important;
                    min-width: unset !important;
                    width: 36px !important;
                  }

                  #zen-appcontent-navbar-wrapper {
                    display: block !important;

                    #urlbar[zen-floating-urlbar] {
                      &, *, #urlbar-background {
                        opacity: 1 !important;
                      }
                    }
                  }

                  .tab-background {
                    width: 36px !important;
                    height: 36px !important;
                  }
                }

                /* Compact Mode */
                #zen-main-app-wrapper[zen-compact-mode=true] {
                  #navigator-toolbox {
                    opacity: 0;
                    z-index: -999;
                    width: 0;
                  }

                  #zen-appcontent-wrapper {
                    margin-left: ${layout.gap.inner}px !important;
                  }
                }

                /* URL Bar Mode */
                #main-window[zen-sidebar-expanded=true]:not(zen-single-toolbar) {
                  #zen-appcontent-navbar-container {
                    display: block;
                  }
                }

                /* Popups */
                #urlbar-container #urlbar #urlbar-background,
                #zen-welcome-pages,
                slot[part~=content],
                arrowscrollbox[part~=content],
                tooltip,
                .dialogBox {
                  background: ${background}${layout.background.opacity_hex} !important;
                  border: ${layout.border.width}px solid ${accent} !important;
                  border-radius: ${layout.border.radius.size}px !important;
                  backdrop-filter: blur(${layout.blur.amount}px) !important;
                }

                /* Spacing */
                #navigator-toolbox {
                  padding: 0px !important;
                  margin: ${layout.gap.inner}px 0px ${layout.gap.inner}px ${layout.gap.inner}px !important;
                }
                #zen-appcontent-wrapper {
                  margin: ${layout.gap.inner}px ${layout.gap.inner}px ${layout.gap.inner}px 0px !important;
                }
                #zen-tabbox-wrapper {
                  margin: 0px !important;
                }
                #zen-sidebar-splitter {
                  width: ${layout.gap.inner}px !important;
                  max-width: unset !important;
                  min-width: unset !important;
                }

                /* Hide */
                #urlbar-input::placeholder {
                  color: transparent;
                }

                #nav-bar:has(#urlbar:not([zen-floating-urlbar])) *,
                #zen-appcontent-navbar-wrapper * {
                  opacity: 0 !important;
                }
                #nav-bar,
                #nav-bar-customization-target,
                #urlbar-container,
                #zen-appcontent-navbar-wrapper {
                  position: absolute !important;
                }

                #zen-appcontent-navbar-wrapper,
                #zen-sidebar-top-buttons,
                #zen-sidebar-foot-buttons,
                #identity-box,
                #tabbrowser-arrowscrollbox-periphery,
                #remote-control-box,
                #urlbar-search-button,
                #page-action-buttons,
                scrollbar,
                .urlbarView,
                .zen-current-workspace-indicator,

                #tabbarItemsMenuSeparator,
                #zen-context-menu-compact-mode,
                #zen-toolbar-context-tabs-right,
                #viewToolbarsMenuSeparator,
                #zenToolbarThemePicker,
                #toolbar-context-customize {
                  display: none !important;
                }
              '';
              userContent = ''
              '';
            };
          };
        };
      }.${
        cfg.style
      };
  };
}
