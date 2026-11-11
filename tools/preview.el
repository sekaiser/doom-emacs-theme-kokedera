;;; preview.el --- Render a specimen from actual Emacs faces -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'org)

(defconst kokedera-preview-root
  (file-name-directory (directory-file-name (file-name-directory load-file-name))))
(add-to-list 'custom-theme-load-path kokedera-preview-root)
(load-theme 'doom-kokedera-summer t)

(defun kokedera-preview-escape (text)
  (dolist (pair '(("&" . "&amp;") ("<" . "&lt;") (">" . "&gt;") ("\"" . "&quot;")) text)
    (setq text (replace-regexp-in-string (car pair) (cdr pair) text t t))))

(defun kokedera-preview-spec (face)
  (let ((spec (cadr (assq 'doom-kokedera-summer (get face 'theme-face)))))
    (cadr (or (cl-find-if
               (lambda (entry)
                 (equal (and (listp (car entry)) (assq 'min-colors (car entry)))
                        '(min-colors 257)))
               spec)
              (assq t spec)))))

(defun kokedera-preview-attribute (face attribute &optional seen)
  "Resolve ATTRIBUTE from FACE, including inherited and combined faces."
  (cond
   ((null face) nil)
   ((and (listp face) (keywordp (car face))) (plist-get face attribute))
   ((listp face)
    (cl-loop for item in face
             thereis (kokedera-preview-attribute item attribute seen)))
   ((and (symbolp face) (not (memq face seen)))
    (let* ((spec (kokedera-preview-spec face))
           (value (plist-get spec attribute))
           (inherit (if (plist-member spec :inherit)
                        (plist-get spec :inherit)
                      (and (facep face) (face-attribute face :inherit nil nil)))))
      (or (and value (not (eq value 'unspecified)) value)
          (and (not (memq inherit '(nil unspecified)))
               (kokedera-preview-attribute inherit attribute (cons face seen))))))))

(defun kokedera-preview-text (x y text &optional face size)
  (let* ((color (or (kokedera-preview-attribute face :foreground) (doom-color 'fg)))
         (weight (if (memq (kokedera-preview-attribute face :weight)
                           '(bold semi-bold ultra-bold)) "700" "400"))
         (slant (if (memq (kokedera-preview-attribute face :slant)
                          '(italic oblique)) "italic" "normal")))
    (insert (format "<text x=\"%s\" y=\"%s\" fill=\"%s\" font-size=\"%s\" font-weight=\"%s\" font-style=\"%s\">%s</text>\n"
                    x y color (or size 14) weight slant (kokedera-preview-escape text)))))

(defun kokedera-preview-rect (x y width height color &optional radius)
  (insert (format "<rect x=\"%s\" y=\"%s\" width=\"%s\" height=\"%s\" rx=\"%s\" fill=\"%s\"/>\n"
                  x y width height (or radius 0) color)))

(defun kokedera-preview-buffer (text mode x y)
  "Render TEXT fontified by MODE, with fixed-width token positions."
  (let ((buffer (generate-new-buffer " *Kokedera specimen*"))
        rows)
    (unwind-protect
        (with-current-buffer buffer
          (insert text)
          (funcall mode)
          (font-lock-ensure)
          (goto-char (point-min))
          (let ((row 0))
            (while (< (point) (point-max))
              (let ((end (line-end-position))
                    (column 0)
                    tokens)
                (while (< (point) end)
                  (let* ((start (point))
                         (next (next-single-property-change start 'face nil end))
                         (token (buffer-substring-no-properties start next))
                         (face (get-text-property start 'face)))
                    (push (list column token face) tokens)
                    (setq column (+ column (string-width token)))
                    (goto-char next)))
                (push (cons row (nreverse tokens)) rows)
                (forward-line 1)
                (setq row (1+ row))))))
      (kill-buffer buffer))
    (dolist (row (nreverse rows))
      (dolist (token (cdr row))
        (kokedera-preview-text (+ x (* 8.4 (nth 0 token))) (+ y (* 21 (car row)))
                               (nth 1 token) (nth 2 token))))))

(let ((output (expand-file-name "assets/preview.svg" kokedera-preview-root)))
  (make-directory (file-name-directory output) t)
  (with-temp-file output
    (insert "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1440\" height=\"900\" viewBox=\"0 0 1440 900\" role=\"img\" aria-labelledby=\"title desc\">\n")
    (insert "<title id=\"title\">Kokedera Summer for Doom Emacs</title>\n")
    (insert "<desc id=\"desc\">Face specimen rendered from the loaded Emacs theme, with fontified Emacs Lisp and Org buffers, selection, diagnostics and normal and bright ANSI colors. This is not a screenshot.</desc>\n")
    (insert "<g font-family=\"'Fira Code', 'DejaVu Sans Mono', monospace\" xml:space=\"preserve\">\n")
    (kokedera-preview-rect 0 0 1440 900 (doom-color 'bg-alt))
    (kokedera-preview-text 44 65 "Kokedera Summer" 'outline-1 32)
    (kokedera-preview-text 46 98 "DOOM EMACS  /  FACE SPECIMEN" 'shadow 13)
    (kokedera-preview-text 1040 65 "forest · leaf · stream" 'font-lock-type-face 15)
    (kokedera-preview-text 1040 94 "Original Zed palette" 'shadow 13)
    (dolist (x '(44 732))
      (kokedera-preview-rect x 137 664 617 (doom-color 'border) 9)
      (kokedera-preview-rect (1+ x) 138 662 615 (doom-color 'bg) 8)
      (kokedera-preview-rect (+ x 1) 138 662 38 (doom-color 'base2) 8)
      (kokedera-preview-rect (+ x 1) 162 662 14 (doom-color 'base2))
      (kokedera-preview-rect (+ x 1) 722 662 31 (doom-color 'modeline-bg)))
    (kokedera-preview-text 64 162 "garden.el" 'default)
    (kokedera-preview-text 752 162 "notebook.org" 'default)
    (kokedera-preview-rect 45 421 662 21 (doom-color 'line-bg))
    (kokedera-preview-buffer
     ";;; garden.el --- A small, quiet workspace
;; Kokedera Summer / Doom Emacs

(defgroup garden nil
  \"A place to think.\"
  :group 'tools)

(defcustom garden-directory \"~/garden/\"
  \"Where the notes take root.\"
  :type 'directory)

(defun garden-open (name)
  \"Visit the note called NAME.\"
  (interactive \"sNote: \")
  (let ((file (expand-file-name
               (concat name \".org\")
               garden-directory)))
    (unless (file-exists-p file)
      (message \"Planting a new note: %s\" name))
    (find-file file)))

(provide 'garden)
" #'emacs-lisp-mode 64 212)
    (kokedera-preview-buffer
     "#+title: A summer notebook

* Working in the garden
Keep the palette quiet. Let the work stand out.

** The next small thing
- [X] Keep the source colors
- [X] Bring Org and Magit along
- [ ] Plant something new

#+begin_src emacs-lisp
(setq doom-theme 'doom-kokedera-summer)
#+end_src

| Surface  | Color   |
|----------+---------|
| Forest   | #0c1a0b |
| Leaf     | #7fd05f |
| Stream   | #1fb87a |

A link to Kokedera and =inline code=.
" #'org-mode 752 212)
    (kokedera-preview-text 64 743 "NORMAL   garden.el                 Emacs Lisp" 'default 12)
    (kokedera-preview-text 752 743 "NORMAL   notebook.org                    Org" 'default 12)
    (kokedera-preview-text 45 795 "ANSI" 'shadow 12)
    (let ((colors '("black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"))
          (i 0))
      (dolist (color colors)
        (kokedera-preview-rect (+ 110 (* i 52)) 780 44 18
                               (kokedera-preview-attribute (intern (concat "ansi-color-" color)) :foreground) 3)
        (kokedera-preview-rect (+ 110 (* i 52)) 803 44 18
                               (kokedera-preview-attribute (intern (concat "ansi-color-bright-" color)) :foreground) 3)
        (setq i (1+ i))))
    (kokedera-preview-rect 625 780 180 42 (doom-color 'region-bg) 4)
    (kokedera-preview-text 646 807 "Selection" 'default 14)
    (kokedera-preview-rect 832 780 180 42 (doom-color 'search-bg) 4)
    (kokedera-preview-text 862 807 "Search match" 'default 14)
    (kokedera-preview-text 1080 794 "+ additions" 'diff-added 14)
    (kokedera-preview-text 1245 794 "warnings" 'warning 14)
    (kokedera-preview-text 1080 820 "− deletions" 'diff-removed 14)
    (kokedera-preview-text 1245 820 "types" 'font-lock-type-face 14)
    (kokedera-preview-text 45 865 "Palette: Florian Mühlhans  ·  Emacs port: sekaiser  ·  MIT" 'shadow 12)
    (insert "</g>\n</svg>\n"))
  (princ (format "Wrote %s\n" output)))

;;; preview.el ends here
