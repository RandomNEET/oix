''
  layout {
      gaps 10
      background-color "transparent"
      center-focused-column "never"
      preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
      }
      default-column-width { proportion 0.5; }
      focus-ring {
          width 2
      }
      border {
          off
      }
      shadow {
          softness 30
          spread 5
          offset x=0 y=5
      }
  }

  overview {
      zoom 0.5
      workspace-shadow {
          off
      }
  }

  prefer-no-csd

  hotkey-overlay {
      skip-at-startup
      hide-not-bound
  }

  screenshot-path "~/pic/screenshots/screenshot from %Y-%m-%d %H-%M-%S.png"
''
