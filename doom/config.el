;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
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
(setq doom-theme 'doom-material)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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

(cua-mode +1)

(global-unset-key (kbd "C-z"))

(map! :after multiple-cursors-core
      :map mc/keymap
      "<return>" nil)

(custom-set-variables
 '(py-shell-switch-buffers-on-execute nil))

(setq projectile-enable-caching nil
      comment-empty-lines t
      isearch-wrap-pause 'no)

(after! treemacs
  (treemacs-follow-mode 1))

(defun al/delete-current-line ()
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (progn
          (setq beg (region-beginning) end (region-end))
          (save-excursion
            (setq beg (progn (goto-char beg) (line-beginning-position))
                  end (progn (goto-char end) (line-end-position))))
          (delete-region beg end)
          (delete-line)
          )
      (save-excursion
        (delete-region
         (progn (forward-visible-line 0) (point))
         (progn (forward-visible-line 1) (point))))
      )))

(defun al/current-line-empty-p ()
  (save-excursion
    (beginning-of-line)
    (looking-at-p "[[:blank:]]*$")))

(defun al/comment-line ()
  (interactive)
  (if (and (al/current-line-empty-p) (not (region-active-p)))
      (sp-comment)
    (save-excursion
      (comment-line nil)
      (setq deactivate-mark nil)
      )
    ))

(defun al/indent-right ()
  (interactive)
  (if (region-active-p)
      (save-excursion
        (indent-rigidly-right-to-tab-stop (region-beginning) (region-end))
        (setq deactivate-mark nil)
        )
    (doom/dumb-indent)
    ))

(defun al/indent-left ()
  (interactive)
  (if (region-active-p)
      (save-excursion
        (indent-rigidly-left-to-tab-stop (region-beginning) (region-end))
        (setq deactivate-mark nil)
        )
    (doom/dumb-dedent)
    ))

(map! :after python
      :map python-mode-map
      "<backtab>" nil
      ;; "C-'" #'run-python
      "C-'" #'python-shell-send-buffer)

(map! :map isearch-mode-map
      "C-r" #'isearch-repeat-backward
      "C-f" #'isearch-repeat-forward)

(map! "C-p" #'projectile-find-file
      "C-e" #'treemacs
      "C-d" #'mc/mark-next-like-this
      "C-S-d" #'mc/mark-all-like-this
      "C-f" #'isearch-forward
      "C-r" #'isearch-backward
      "C-s" #'save-buffer
      "C-/" #'al/comment-line
      "C-w" #'kill-buffer
      "C-z" #'undo-fu-only-undo
      "C-S-z" #'undo-fu-only-redo
      "C-a" #'mark-whole-buffer
      "C-<tab>" #'+vertico/switch-workspace-buffer
      "S-<delete>" #'al/delete-current-line
      "C-S-f" #'+default/search-project
      "<tab>" #'al/indent-right
      "<backtab>" #'al/indent-left
      )
