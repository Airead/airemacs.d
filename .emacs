;;;; Airead's .emacs file
;; 2012/12/20 10:54:01 (before the end of the world)
;;
;; Each section in this file is introduced by a line beginning with
;; four semicolons;; and each entry is introduced by a line beginning
;; with three semicolons.
;;

;;;; The Help Key
;; Control-h is the help key after typing control-h, type a letter to
;; indicate the subject about which you want help.  For an explanation
;; of the help facility, type control-h two times in a row.
;;
;; To find out about any mode, type control-h m while in that mode.
;; For example, to find out about mail mode, enter mail mode and then
;; type control-h m.

;; some useful function
(defun clear-site-lisp-path (lists)
  "Clear site-lisp path.
Beasue I run emacs with `-Q', and hope
that all runngin scripts in my emacs are controllable"
  (let ((own-path))
    (dolist (l lists)
      (or (string-match "site-lisp" l)
          (setq own-path (cons l own-path))))
    own-path))

(defun get-custom-load-path (paths)
  "get custiom load path.
Convert relative(MUST) path to absolute path."
  (let ((cur-dir (file-name-directory load-file-name))
        absolute-lib-path)
    (dolist (l custom-lib-path)
      (add-to-list 'absolute-lib-path (expand-file-name l cur-dir)))
    absolute-lib-path))
  
;;; set my own load-path
(setq load-path (clear-site-lisp-path load-path))
(setq custom-lib-path '(
                        "./"
                        "./extension"
                        "./lib"
                        "./lib/icicles"
                        "./lib/pymacs"
                        ))
(setq load-path (append
                 (get-custom-load-path custom-lib-path) nil
                 load-path nil))
  
;;; Text mode and Auto Fill mode
;; The next two lines put Emacs into Text mode are for writers who
;; want to start writing prose rather than code.
(setq-default major-mode 'text-mode)
;;(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)

;;; Keybinding for `occur'
(global-set-key "\C-co" 'occur)

;;; Rebind `C-x C-b' for `buffer-menu'
(global-set-key "\C-x\C-b" 'buffer-menu)

;;; Continue to display the matching parentheses
(show-paren-mode t)

;;; Set font
(add-to-list 'default-frame-alist '(font . "monaco"))

;;; icices
(load-library "icicles")
(icy-mode 1)

;;; highlight symbol 
(require 'highlight-symbol)
(global-set-key (kbd "C-'") 'highlight-symbol-at-point)
(global-set-key (kbd "C-M-'") 'highlight-symbol-remove-all)
(global-set-key (kbd "C-,") 'highlight-symbol-prev)
(global-set-key (kbd "C-.") 'highlight-symbol-next)

;;; table bar and binding
(require 'tabbar)
(tabbar-mode t)
(global-set-key [s-up] 'tabbar-backward-group)
(global-set-key [s-down] 'tabbar-forward-group)
(global-set-key (kbd "C-:") 'tabbar-backward)
(global-set-key (kbd "C-\"") 'tabbar-forward)

;;; add own python mode
(require 'python)
(setq
 python-shell-interpreter "ipython2.7"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
 "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
 "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
 "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;;; pymacs
(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;;; ropemacs
(setq pymacs-load-path '("./lib/pymacs"))
(pymacs-load "ropemacs" "rope-")