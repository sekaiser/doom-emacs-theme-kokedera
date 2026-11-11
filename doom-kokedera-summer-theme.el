;;; doom-kokedera-summer-theme.el --- Kokedera Summer for Doom -*- lexical-binding: t; no-byte-compile: t; -*-

;; Copyright (C) 2026 sekaiser
;; Palette Copyright (C) 2026 Florian Mühlhans
;; SPDX-License-Identifier: MIT

;; Author: sekaiser
;; URL: https://github.com/sekaiser/doom-emacs-theme-kokedera
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (doom-themes "2.3.0"))
;; Keywords: faces, themes

;;; Commentary:
;;
;; A faithful port of Kokedera Summer by Florian Mühlhans.
;; https://github.com/cappuccinotogo/kokedera-theme-extension-zed
;;
;; Buffer, syntax and ANSI colors follow the source palette.  Translucent
;; overlays are composited against the editor background for Emacs.  Doom's
;; base faces provide package coverage; the overrides below preserve Summer's
;; syntax roles and adapt editor-specific surfaces.
;;
;; Set `doom-theme' to `doom-kokedera-summer' in Doom, or use:
;;   (load-theme 'doom-kokedera-summer t)

;;; Code:

(require 'doom-themes)

(defgroup doom-kokedera-summer-theme nil
  "Kokedera Summer theme options."
  :group 'doom-themes
  :prefix "doom-kokedera-summer-")

(defcustom doom-kokedera-summer-brighter-comments nil
  "Use Summer's documentation color for ordinary comments.
The default matches Zed's deliberately subdued comments.  Set this before
loading the theme, or reload the theme after changing it."
  :type 'boolean
  :group 'doom-kokedera-summer-theme)

(def-doom-theme doom-kokedera-summer
  "Dense summer greens, golden strings and a teal stream."

  ;; Each triplet supplies true-color, 256-color and 16-color values.
  ((bg         '("#0c1a0b" "#121212" "black"))
   (bg-alt     '("#0e1d0d" "#1c1c1c" "black"))
   (base0      '("#0a1708" "#121212" "black"))
   (base1      bg)
   (base2      '("#112510" "#1c1c1c" "black"))
   (base3      '("#223b1c" "#303030" "green"))
   (base4      '("#4b6540" "#5f5f5f" "brightblack"))
   (base5      '("#5e8d4a" "#5f875f" "brightblack"))
   (base6      '("#7d9f6e" "#87af5f" "green"))
   (base7      '("#9fd67f" "#afd787" "white"))
   (base8      '("#e5f5d3" "#d7ffd7" "brightwhite"))
   (fg         '("#d2e7bd" "#d7d7af" "white"))
   (fg-alt     base6)

   (grey       base4)
   (red        '("#c45a5a" "#d75f5f" "red"))
   (orange     '("#d1a44e" "#d7af5f" "yellow"))
   (green      '("#3dd65a" "#5fd75f" "green"))
   (teal       '("#1fb87a" "#00af87" "cyan"))
   (yellow     '("#cfae3a" "#d7af5f" "yellow"))
   (blue       teal)
   (dark-blue  '("#1f9e64" "#00af5f" "cyan"))
   (magenta    '("#9a7abf" "#af87af" "magenta"))
   (violet     magenta)
   (cyan       '("#3dbf9f" "#5fafaf" "cyan"))
   (dark-cyan  '("#2e9a80" "#008787" "cyan"))

   (leaf       '("#7fd05f" "#87d75f" "green"))
   (accent     '("#56d165" "#5fd75f" "brightgreen"))
   (keyword    '("#2ec75a" "#00d75f" "brightgreen"))
   (gold       '("#e0c565" "#d7d75f" "yellow"))
   (doc        '("#6e8e5b" "#5f875f" "brightblack"))
   (delimiter  '("#6d905b" "#5f875f" "brightblack"))
   (border     '("#2c4725" "#3a3a3a" "brightblack"))
   (selection  '("#1d3d18" "#1c3a1c" "green"))
   (active     '("#214321" "#1c4c1c" "green"))
   (cursor     '("#4bf05f" "#5fff5f" "brightgreen"))

   (bright-red     '("#d47070" "#d78787" "brightred"))
   (bright-blue    '("#3fd0a8" "#5fd7af" "brightcyan"))
   (bright-magenta '("#b49ad4" "#afafd7" "brightmagenta"))
   (bright-cyan    '("#62c9ae" "#5fd7af" "brightcyan"))

   ;; Composited Zed overlays (alpha / 255, foreground over bg).
   (line-bg       (doom-blend bg "#ffffff" (- 1 (/ 8.0 255))))
   (region-bg     (doom-blend bg "#2f8a3d" (- 1 (/ 77.0 255))))
   (search-bg     (doom-blend bg "#e0c565" (- 1 (/ 64.0 255))))
   (added-bg      (doom-blend green bg (/ 32.0 255)))
   (deleted-bg    (doom-blend red bg (/ 32.0 255)))
   (modified-bg   (doom-blend yellow bg (/ 32.0 255)))

   ;; Doom's semantic slots also theme packages not explicitly overridden.
   (highlight      accent)
   (vertical-bar   border)
   (builtin        teal)
   (comments       (if doom-kokedera-summer-brighter-comments doc base4))
   (doc-comments   doc)
   (constants      orange)
   (functions      leaf)
   (keywords       keyword)
   (methods        leaf)
   (operators      fg-alt)
   (type           teal)
   (strings        gold)
   (variables      base7)
   (numbers        orange)
   (region         region-bg)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    yellow)
   (vc-added       green)
   (vc-deleted     red)
   (modeline-bg    bg-alt)
   (modeline-bg-alt base2)
   (modeline-bg-inactive base0)
   (modeline-fg    fg)
   (modeline-fg-alt fg-alt))

  (;; Core editor surfaces.
   (cursor :background cursor)
   (hl-line :background line-bg :extend t)
   (fringe :background bg :foreground base4)
   (region :background region-bg :foreground 'unspecified
           :distant-foreground 'unspecified :extend t)
   (secondary-selection :background selection :extend t)
   (highlight :background selection :foreground fg)
   (shadow :foreground base4)
   (minibuffer-prompt :foreground accent :weight (if bold 'bold 'normal))
   (link :foreground cyan :underline t)
   (link-visited :foreground teal :underline t)
   ((line-number &override) :background bg :foreground base4)
   ((line-number-current-line &override) :background line-bg :foreground accent)
   (fill-column-indicator :foreground base3)
   (whitespace-space :foreground border)
   (whitespace-tab :foreground border)
   (whitespace-newline :foreground border)
   (window-divider :foreground border)
   (window-divider-first-pixel :foreground border)
   (window-divider-last-pixel :foreground border)
   (internal-border :background border)
   (child-frame-border :background border)
   (tooltip :background base2 :foreground fg)
   (header-line :background bg-alt :foreground fg-alt :box nil)
   (mode-line :background modeline-bg :foreground modeline-fg :box nil)
   (mode-line-active :inherit 'mode-line)
   (mode-line-inactive :background modeline-bg-inactive :foreground fg-alt :box nil)
   (mode-line-emphasis :foreground accent :weight (if bold 'bold 'normal))
   (mode-line-highlight :background selection :foreground fg)
   (tab-bar :background bg :foreground fg)
   (tab-bar-tab :background base2 :foreground fg :box nil)
   (tab-bar-tab-inactive :background bg-alt :foreground fg-alt :box nil)
   (tab-line :background bg :foreground fg)
   (tab-line-tab-current :background base2 :foreground fg)
   (tab-line-tab-inactive :background bg-alt :foreground fg-alt)
   (solaire-default-face :inherit 'default :background bg-alt)
   (solaire-hl-line-face :inherit 'hl-line :background active :extend t)

   ;; Exact syntax roles, including Emacs 29+ tree-sitter faces.
   ((font-lock-comment-face &override) :slant (if italic 'italic 'normal))
   ((font-lock-doc-face &override) :slant (if italic 'italic 'normal))
   (font-lock-number-face :foreground numbers)
   (font-lock-operator-face :foreground operators)
   (font-lock-function-call-face :foreground functions :slant 'normal)
   (font-lock-variable-use-face :foreground variables)
   (font-lock-property-name-face :foreground variables :weight 'normal)
   (font-lock-property-use-face :foreground variables :weight 'normal)
   (font-lock-punctuation-face :foreground operators)
   (font-lock-bracket-face :foreground operators)
   (font-lock-delimiter-face :foreground delimiter)
   (font-lock-misc-punctuation-face :foreground operators)
   (font-lock-preprocessor-face :foreground keywords)
   (font-lock-preprocessor-char-face :foreground keywords)
   (font-lock-escape-face :foreground magenta :weight (if bold 'bold 'normal))
   (font-lock-regexp-grouping-backslash :foreground magenta :weight (if bold 'bold 'normal))
   (font-lock-regexp-grouping-construct :foreground magenta)
   (font-lock-negation-char-face :foreground operators)
   (highlight-numbers-number :foreground numbers)

   ;; Search and structural editing: readable text on tinted surfaces.
   (isearch :background gold :foreground bg :weight (if bold 'bold 'normal))
   (isearch-fail :background red :foreground bg)
   (lazy-highlight :background search-bg :foreground fg :weight 'normal)
   (match :background search-bg :foreground gold :weight (if bold 'bold 'normal))
   (show-paren-match :background active :foreground accent :weight (if bold 'bold 'normal))
   (show-paren-mismatch :background red :foreground bg :weight (if bold 'bold 'normal))
   (evil-ex-lazy-highlight :inherit 'lazy-highlight)
   (evil-ex-substitute-matches :background deleted-bg :foreground red)
   (evil-ex-substitute-replacement :background added-bg :foreground green)

   ;; Completion menus.
   (vertico-current :background selection :foreground fg :extend t)
   (corfu-default :background base2 :foreground fg)
   (corfu-current :background selection :foreground fg)
   (corfu-border :background border)
   (company-tooltip :background base2 :foreground fg)
   (company-tooltip-selection :background selection :foreground fg)
   (company-tooltip-common :foreground accent :weight (if bold 'bold 'normal))
   (company-tooltip-annotation :foreground fg-alt)
   (company-tooltip-annotation-selection :foreground fg-alt)
   (company-scrollbar-bg :background base2)
   (company-scrollbar-fg :background base4)
   (completions-common-part :foreground accent :weight (if bold 'bold 'normal))
   (completions-first-difference :foreground gold :weight (if bold 'bold 'normal))
   (orderless-match-face-0 :foreground accent :weight (if bold 'bold 'normal))
   (orderless-match-face-1 :foreground gold :weight (if bold 'bold 'normal))
   (orderless-match-face-2 :foreground cyan :weight (if bold 'bold 'normal))
   (orderless-match-face-3 :foreground base7 :weight (if bold 'bold 'normal))
   (marginalia-documentation :foreground doc-comments)
   (marginalia-file-priv-dir :foreground teal)

   ;; Outline / Org: a green-to-teal hierarchy, gold for actionable text.
   (outline-1 :foreground accent :weight (if bold 'bold 'normal) :extend t)
   (outline-2 :foreground leaf :weight (if bold 'bold 'normal) :extend t)
   (outline-3 :foreground teal :weight (if bold 'bold 'normal) :extend t)
   (outline-4 :foreground base7 :weight (if bold 'bold 'normal) :extend t)
   (outline-5 :foreground cyan :weight (if bold 'bold 'normal) :extend t)
   (outline-6 :foreground gold :weight (if bold 'bold 'normal) :extend t)
   (outline-7 :foreground fg-alt :weight (if bold 'bold 'normal) :extend t)
   (outline-8 :foreground doc :weight (if bold 'bold 'normal) :extend t)
   (org-document-title :foreground accent :weight (if bold 'bold 'normal) :height 1.25)
   (org-document-info :foreground fg-alt)
   (org-block :background bg-alt :extend t)
   (org-block-begin-line :background base2 :foreground doc :extend t)
   (org-block-end-line :background base2 :foreground doc :extend t)
   (org-code :foreground gold)
   (org-verbatim :foreground gold)
   (org-quote :background bg-alt :foreground fg-alt :slant (if italic 'italic 'normal) :extend t)
   (org-table :foreground teal)
   (org-link :inherit 'link)
   (org-todo :foreground yellow :weight (if bold 'bold 'normal))
   (org-done :foreground green :weight (if bold 'bold 'normal))
   (org-checkbox :foreground accent :weight (if bold 'bold 'normal))
   (org-date :foreground teal)
   (org-tag :foreground fg-alt :weight 'normal)
   (org-special-keyword :foreground doc)
   (markdown-header-face :foreground accent :weight (if bold 'bold 'normal))
   (markdown-code-face :background bg-alt :foreground gold)

   ;; Diffs keep addition / change / deletion semantics distinct.
   (diff-added :background added-bg :foreground green :extend t)
   (diff-removed :background deleted-bg :foreground red :extend t)
   (diff-changed :background modified-bg :foreground yellow :extend t)
   (diff-refine-added :background (doom-blend green bg 0.25)
                      :foreground green :inverse-video nil)
   (diff-refine-removed :background (doom-blend red bg 0.25)
                        :foreground red :inverse-video nil)
   (magit-diff-added :inherit 'diff-added)
   (magit-diff-removed :inherit 'diff-removed)
   (magit-diff-added-highlight :background (doom-blend green bg 0.2)
                              :foreground green :extend t)
   (magit-diff-removed-highlight :background (doom-blend red bg 0.2)
                                :foreground red :extend t)
   (magit-section-heading :foreground accent :weight (if bold 'bold 'normal))
   (magit-section-highlight :background bg-alt :extend t)
   (magit-branch-local :foreground teal)
   (magit-branch-remote :foreground leaf)
   (magit-hash :foreground doc)
   (diff-hl-insert :background added-bg :foreground green)
   (diff-hl-change :background modified-bg :foreground yellow)
   (diff-hl-delete :background deleted-bg :foreground red)

   ;; Diagnostics retain underlines rather than recoloring source text.
   (flycheck-error :underline `(:style wave :color ,red))
   (flycheck-warning :underline `(:style wave :color ,yellow))
   (flycheck-info :underline `(:style wave :color ,teal))
   (flymake-error :underline `(:style wave :color ,red))
   (flymake-warning :underline `(:style wave :color ,yellow))
   (flymake-note :underline `(:style wave :color ,teal))
   (lsp-face-highlight-read :background (doom-blend bg "#2f8a3d" (- 1 (/ 37.0 255))))
   (lsp-face-highlight-write :background (doom-blend bg "#2f8a3d" (- 1 (/ 64.0 255))))
   (lsp-face-highlight-textual :background region-bg)

   ;; Doom modeline, directories and dashboards.
   (doom-modeline-bar :background keyword)
   (doom-modeline-buffer-path :foreground fg-alt :weight (if bold 'bold 'normal))
   (doom-modeline-buffer-file :foreground fg :weight (if bold 'bold 'normal))
   (doom-modeline-buffer-modified :foreground yellow :weight (if bold 'bold 'normal))
   (doom-modeline-project-dir :foreground accent :weight (if bold 'bold 'normal))
   (doom-modeline-info :foreground green)
   (doom-modeline-warning :foreground yellow)
   (doom-modeline-urgent :foreground red)
   (dired-directory :foreground teal :weight (if bold 'bold 'normal))
   (dired-symlink :foreground cyan)
   (treemacs-directory-face :foreground teal)
   (treemacs-root-face :foreground accent :weight (if bold 'bold 'normal))
   (doom-dashboard-banner :foreground accent)
   (doom-dashboard-menu-title :foreground leaf)
   (doom-dashboard-menu-desc :foreground fg)
   (doom-dashboard-footer :foreground doc)

   ;; Clear Gnus' default inheritance; Doom 2.3.0 otherwise forms a cycle
   ;; with newer Emacs versions when Org loads its Gnus link backend.
   (gnus-group-news-low-empty :inherit 'unspecified :foreground base5
                             :weight 'normal)

   ;; Zed's exact normal + bright ANSI palette.
   (ansi-color-black :foreground base2 :background base2)
   (ansi-color-red :foreground red :background red)
   (ansi-color-green :foreground green :background green)
   (ansi-color-yellow :foreground yellow :background yellow)
   (ansi-color-blue :foreground blue :background blue)
   (ansi-color-magenta :foreground magenta :background magenta)
   (ansi-color-cyan :foreground cyan :background cyan)
   (ansi-color-white :foreground fg :background fg)
   (ansi-color-bright-black :foreground base4 :background base4)
   (ansi-color-bright-red :foreground bright-red :background bright-red)
   (ansi-color-bright-green :foreground accent :background accent)
   (ansi-color-bright-yellow :foreground gold :background gold)
   (ansi-color-bright-blue :foreground bright-blue :background bright-blue)
   (ansi-color-bright-magenta :foreground bright-magenta :background bright-magenta)
   (ansi-color-bright-cyan :foreground bright-cyan :background bright-cyan)
   (ansi-color-bright-white :foreground base8 :background base8)
   ;; vterm uses foreground for normal and background for bright ANSI colors.
   (vterm-color-black :foreground base2 :background base4)
   (vterm-color-red :foreground red :background bright-red)
   (vterm-color-green :foreground green :background accent)
   (vterm-color-yellow :foreground yellow :background gold)
   (vterm-color-blue :foreground blue :background bright-blue)
   (vterm-color-magenta :foreground magenta :background bright-magenta)
   (vterm-color-cyan :foreground cyan :background bright-cyan)
   (vterm-color-white :foreground fg :background base8))

  ((ansi-color-names-vector
    (vector (doom-color 'base2) (doom-color 'red)
            (doom-color 'green) (doom-color 'yellow)
            (doom-color 'blue) (doom-color 'magenta)
            (doom-color 'cyan) (doom-color 'fg)))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-directory load-file-name)))

(provide 'doom-kokedera-summer-theme)
;;; doom-kokedera-summer-theme.el ends here
