# Kokedera Summer for Doom Emacs — archived

This independent port is retired in favor of the [official Kokedera Emacs themes](https://github.com/cappuccinotogo/kokedera-theme-extension-emacs) by Florian Mühlhans.

The official themes work directly with Doom Emacs. A separate Doom port is unnecessary. This repository retains the original port, tests and Git history for reference; future palette and theme fixes belong upstream.

## Use the official theme

In Doom's `packages.el`:

```elisp
(package! kokedera-themes
  :recipe (:host github
           :repo "cappuccinotogo/kokedera-theme-extension-emacs"))
```

In `config.el`:

```elisp
(setq doom-theme 'kokedera-summer)
```

Run `doom sync` and restart Emacs. For Nix-managed Doom, point the existing non-flake theme input at `github:cappuccinotogo/kokedera-theme-extension-emacs`, keep its source directory on `custom-theme-load-path`, and rebuild the configuration.

The official theme has different choices for some faces. Any desired Doom-specific styling can live in small personal overrides.

## License

The historical port remains under the [MIT license](LICENSE). Original palette copyright © 2026 Florian Mühlhans; Emacs port copyright © 2026 sekaiser.
