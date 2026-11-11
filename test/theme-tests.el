;;; theme-tests.el --- Palette and face regression tests -*- lexical-binding: t; -*-

(require 'ert)
(require 'cl-lib)
(require 'json)
(require 'doom-themes)
(require 'org)
(require 'ansi-color)
(require 'gnus-group)

(defconst kokedera-test-root
  (file-name-directory (directory-file-name (file-name-directory load-file-name))))

(add-to-list 'custom-theme-load-path kokedera-test-root)
(load-theme 'doom-kokedera-summer t)

(defconst kokedera-test-source
  (let ((json-object-type 'alist)
        (json-array-type 'list)
        (json-key-type 'string))
    (json-read-file
     (expand-file-name "test/fixtures/kokedera-summer.json" kokedera-test-root))))

(defun kokedera-test-style (key)
  (cdr (assoc key (cdr (assoc "style" (cdr (assoc "theme" kokedera-test-source)))))))

(defun kokedera-test-syntax (key)
  (cdr (assoc "color" (cdr (assoc key (kokedera-test-style "syntax"))))))

(defun kokedera-test-face (face &optional colors)
  "Get FACE's theme attributes for COLORS, defaulting to true color."
  (let* ((spec (cadr (assq 'doom-kokedera-summer (get face 'theme-face))))
         (entry
          (or (cl-find-if
               (lambda (entry)
                 (let* ((display (car entry))
                        (minimum (and (listp display) (assq 'min-colors display))))
                   (and minimum (= (cadr minimum) (or colors 257)))))
               spec)
              (assq t spec))))
    (cadr entry)))

(defmacro kokedera-test-with-theme (&rest body)
  (declare (indent 0) (debug t))
  `(let ((doom-themes-enable-bold t)
         (doom-themes-enable-italic t)
         (doom-kokedera-summer-brighter-comments nil))
     (load-theme 'doom-kokedera-summer t)
     ,@body))

(ert-deftest kokedera-loads-and-reloads ()
  (kokedera-test-with-theme
    (should (custom-theme-p 'doom-kokedera-summer))
    (should (memq 'doom-kokedera-summer custom-enabled-themes))
    (disable-theme 'doom-kokedera-summer)
    (enable-theme 'doom-kokedera-summer)
    (should (equal (doom-color 'bg) (kokedera-test-style "editor.background")))))

(ert-deftest kokedera-core-surfaces-match-zed ()
  (kokedera-test-with-theme
    (dolist (mapping '((default :background "editor.background")
                       (default :foreground "editor.foreground")
                       (fringe :background "editor.gutter.background")
                       (line-number :foreground "editor.line_number")
                       (line-number-current-line :foreground "editor.active_line_number")
                       (mode-line :background "status_bar.background")
                       (tab-bar-tab :background "tab.active_background")
                       (tab-bar-tab-inactive :background "tab.inactive_background")
                       (vertico-current :background "element.selected")
                       (corfu-default :background "elevated_surface.background")
                       (window-divider :foreground "border")))
      (should (equal (plist-get (kokedera-test-face (nth 0 mapping)) (nth 1 mapping))
                     (kokedera-test-style (nth 2 mapping)))))
    (should (equal (plist-get (kokedera-test-face 'cursor) :background)
                   (cdr (assoc "cursor" (car (kokedera-test-style "players"))))))))

(ert-deftest kokedera-syntax-matches-zed ()
  (kokedera-test-with-theme
    (dolist (mapping '((font-lock-comment-face . "comment")
                       (font-lock-doc-face . "comment.doc")
                       (font-lock-function-name-face . "function")
                       (font-lock-function-call-face . "function")
                       (font-lock-keyword-face . "keyword")
                       (font-lock-preprocessor-face . "preproc")
                       (font-lock-type-face . "type")
                       (font-lock-constant-face . "constant")
                       (font-lock-number-face . "number")
                       (font-lock-string-face . "string")
                       (font-lock-escape-face . "string.escape")
                       (font-lock-variable-name-face . "variable")
                       (font-lock-variable-use-face . "variable")
                       (font-lock-property-name-face . "property")
                       (font-lock-property-use-face . "property")
                       (font-lock-operator-face . "operator")
                       (font-lock-punctuation-face . "punctuation")
                       (font-lock-delimiter-face . "punctuation.delimiter")))
      (should (equal (plist-get (kokedera-test-face (car mapping)) :foreground)
                     (kokedera-test-syntax (cdr mapping)))))))

(ert-deftest kokedera-ansi-normal-and-bright-match-zed ()
  (kokedera-test-with-theme
    (dolist (color '("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"))
      (let ((normal (kokedera-test-style (concat "terminal.ansi." color)))
            (bright (kokedera-test-style (concat "terminal.ansi.bright_" color))))
        (dolist (attribute '(:foreground :background))
          (should (equal (plist-get (kokedera-test-face (intern (concat "ansi-color-" color)))
                                    attribute)
                         normal))
          (should (equal (plist-get (kokedera-test-face (intern (concat "ansi-color-bright-" color)))
                                    attribute)
                         bright)))
        (should (equal (plist-get (kokedera-test-face (intern (concat "vterm-color-" color)))
                                  :foreground)
                       normal))
        (should (equal (plist-get (kokedera-test-face (intern (concat "vterm-color-" color)))
                                  :background)
                       bright))))
    (should (equal (append ansi-color-names-vector nil)
                   (mapcar (lambda (color)
                             (kokedera-test-style (concat "terminal.ansi." color)))
                           '("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"))))))

(ert-deftest kokedera-alpha-overlays-are-composited ()
  (kokedera-test-with-theme
    (let* ((bg (kokedera-test-style "editor.background"))
           (selection (cdr (assoc "selection" (car (kokedera-test-style "players")))))
           (opaque (doom-blend (substring selection 0 7) bg
                               (/ (string-to-number (substring selection 7 9) 16) 255.0))))
      (should (equal (plist-get (kokedera-test-face 'region) :background) opaque))
      (should (eq (plist-get (kokedera-test-face 'region) :extend) t))
      (should (eq (plist-get (kokedera-test-face 'region) :foreground) 'unspecified)))))

(ert-deftest kokedera-diagnostics-keep-source-colors ()
  (kokedera-test-with-theme
    (dolist (package '("flymake" "flycheck"))
      (dolist (pair '(("error" . "error") ("warning" . "warning")))
        (let ((underline (plist-get
                          (kokedera-test-face (intern (concat package "-" (car pair))))
                          :underline)))
          (should (eq (plist-get underline :style) 'wave))
          (should (equal (plist-get underline :color) (kokedera-test-style (cdr pair)))))))
    (should (equal (plist-get (kokedera-test-face 'diff-added) :foreground)
                   (kokedera-test-style "created")))
    (should (equal (plist-get (kokedera-test-face 'diff-removed) :foreground)
                   (kokedera-test-style "deleted")))))

(ert-deftest kokedera-brighter-comments-are-opt-in ()
  (kokedera-test-with-theme
    (should (equal (plist-get (kokedera-test-face 'font-lock-comment-face) :foreground)
                   (kokedera-test-syntax "comment")))
    (let ((doom-kokedera-summer-brighter-comments t))
      (load-theme 'doom-kokedera-summer t)
      (should (equal (plist-get (kokedera-test-face 'font-lock-comment-face) :foreground)
                     (kokedera-test-syntax "comment.doc"))))))

(ert-deftest kokedera-respects-bold-and-italic-preferences ()
  (kokedera-test-with-theme
    (should (eq (plist-get (kokedera-test-face 'font-lock-comment-face) :slant) 'italic))
    (should (eq (plist-get (kokedera-test-face 'outline-1) :weight) 'bold))
    (let ((doom-themes-enable-bold nil)
          (doom-themes-enable-italic nil))
      (load-theme 'doom-kokedera-summer t)
      (should (eq (plist-get (kokedera-test-face 'font-lock-comment-face) :slant) 'normal))
      (should (eq (plist-get (kokedera-test-face 'outline-1) :weight) 'normal)))))

(ert-deftest kokedera-terminal-fallbacks-and-valid-attributes ()
  (kokedera-test-with-theme
    ;; Validate every generated face spec, including faces whose packages
    ;; are not loaded.  A T weight/slant can otherwise escape a batch test.
    (dolist (setting (get 'doom-kokedera-summer 'theme-settings))
      (when (eq (car setting) 'theme-face)
        (dolist (entry (nth 3 setting))
          (let ((attributes (cadr entry)))
            (when (plist-member attributes :weight)
              (should (memq (plist-get attributes :weight)
                            '(unspecified normal bold semi-bold ultra-bold light))))
            (when (plist-member attributes :slant)
              (should (memq (plist-get attributes :slant)
                            '(unspecified normal italic oblique))))))))
    (dolist (colors '(16 256 257))
      (dolist (face '(default font-lock-keyword-face font-lock-string-face
                     font-lock-type-face region vertico-current mode-line))
        (should (kokedera-test-face face colors)))
      (should-not (equal (plist-get (kokedera-test-face 'default colors) :background)
                        (plist-get (kokedera-test-face 'default colors) :foreground))))))

(ert-deftest kokedera-org-inherits-outline-and-fontifies ()
  (kokedera-test-with-theme
    (should (eq (face-attribute 'org-level-1 :inherit nil nil) 'outline-1))
    (with-temp-buffer
      (insert "* Summer\nSome =literal= text.\n#+begin_src emacs-lisp\n(message \"green\")\n#+end_src\n")
      (org-mode)
      (font-lock-ensure)
      (goto-char (point-min))
      (search-forward "Summer")
      (should (memq 'org-level-1
                    (ensure-list (get-text-property (1- (point)) 'face)))))))

;;; theme-tests.el ends here
