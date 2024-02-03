;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "gumelarme"
      user-mail-address "gumelar.pn@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "Blex Mono Nerd Font" :size 13 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))
                                        ;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq fcitx-remote-command "fcitx5-remote")

;; = Org related configs

;; == Org journal
;; (setq org-journal-dir "~/sync/org/journal")
;; (setq org-journal-file-type `monthly) ;; values: daily, weekly, monthly, yearly

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/sync/org/")
(after! org
  ;; == Capture
  (setq org-capture-templates
        '(("i" "Inbox" entry
           (file+headline +org-capture-todo-file "Inbox")
           "** TODO %?\n")
          ("w" "Workstations" entry
           (file+headline +org-capture-todo-file "Workstations")
           "** TODO %?\n")
          ("s" "School Stuffs" entry
           (file+headline +org-capture-todo-file "School")
           "** TODO %?\n")

          ;; TODO: prompt select heading using vertico
          ;; ("p" "Projects" entry
          ;;  (file+olp +org-capture-todo-file "Projects")
          ;;  "** TODO %?\n")
          ))

  ;; This export configuration is to enable chinese in latex
  ;; works for normal text too
  (map! :map org-mode-map  "C-c C-r" #'verb-command-map)
  (setq org-latex-pdf-process
        '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

  ;; Uncomment this this to enable bibtex on export
  ;; (setq org-latex-pdf-process (list "latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f  %f
  ;; "bibtex %b"
  ;; "latexmk -shell-escape -bibtex -f -pdf %f"))
  )

;; == Roam
(after! org-roam
  (setq org-roam-directory (file-truename "~/sync/org")
        org-roam-db-location (file-truename "~/sync/org/roam.db"))

  (setq org-roam-capture-templates
        '(("d" "default" plain "%?" :target
           (file+head "main/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("r" "reference" plain "%?" :target
           (file+head "reference/${title}.org" "#+title: ${title}\n")
           :unnarrowed t)
          )))

;; == Citations
(after! citar
  (setq! citar-bibliography '("~/sync/org/biblio.bib")
         citar-library-paths '("~/sync/zotero/")
         citar-notes-paths '("~/sync/org/reference")
         citar-org-roam-subdir '("reference"))

  ;; # TODO: Define custom `citar-note-format-function'
  ;; the default is `citar-org-format-note-default'
  (add-to-list 'citar-templates '(note . ":: ${title}"))
  )



;; = Langs
(setq-hook! 'web-mode-hook +format-with-lsp t)
(setq-hook! 'web-mode-hook +format-with 'prettier)

(use-package! apheleia
  :config (add-to-list 'apheleia-formatters '(nixfmt  "alejandra" "-")))

(use-package! web-mode
  :config (add-to-list 'auto-mode-alist '("\\.astro\\'" . web-mode)))

(after! web-mode
  (setq web-mode-enable-front-matter-block t))

(use-package! zig-mode
  :hook ((zig-mode . lsp-deferred))
  :custom (zig-format-on-save nil)
  :config
  (after! lsp-mode
    (add-to-list 'lsp-language-id-configuration '(zig-mode . "zig"))
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "zls")
      :major-modes '(zig-mode)
      :server-id 'zls))))


;; (after! dap-mode
;;   (setq dap-python-debugger 'debugpy))

(after! lsp-clangd
  (setq lsp-clients-clangd-args '("--clang-tidy"
                                  "--enable-config"
                                  "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))

(after! clojure-mode
  (setq cider-font-lock-dynamically '(macro core function var)))

(after! pyim
  (require 'pyim-basedict)
  (pyim-basedict-enable))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
