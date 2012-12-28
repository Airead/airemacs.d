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
                        "./lib/auto-complete-1.3.1"
                        "./lib/yasnippet"
                        "./lib/org"
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

;;; line number mode
(linum-mode)
(menu-bar-mode 0)

;;; set time locale
(setq system-time-locale "C")

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

;;; auto complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/airead/study/git-proj/airemacs.d/lib/auto-complete-1.3.1/dict")
(ac-config-default)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

;;; linux kernel code style
(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4))
(add-to-list 'auto-mode-alist '("\.c$" . linux-c-mode))
(add-to-list 'auto-mode-alist '("\.h$" . linux-c-mode))

;;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;;; smart compile
(require 'smart-compile)
(global-set-key (kbd "<f9>") 'smart-compile)

;;; move temp and autosave file to temporary dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; org mode
(require 'org-install)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; gtd: get thing done
(setq org-todo-keywords
      '((sequence "TODO(t!)" "NEXT(n)" "WAITTING(w)" "SOMEDAY(s)" "|" "DONE(d@/!)" "ABORT(a@/!)")
        ))
(setq org-directory "~/Dropbox/GTD/") 
(setq org-capture-templates 
      '(("n" "New" entry (file+headline "inbox.org" "Inbox")
         "* %? %<<%Y-%m-%d %H:%M>> \n %i\n")
        ("t" "Task" entry (file+headline "task.org" "Task")
         "** TODO %?\n %i\n")
        ("c" "Calendar" entry (file+headline "task.org" "Calendar") 
         "** TODO %?\n %i\n")
        ("i" "Idea" entry (file+headline "task.org" "Ideas")
         "** %?\n %i\n")
        ("r" "Note" entry (file+headline "note.org" "Note")
         "* %?\n %i\n" )
        ("p" "Project" entry (file "project.org") 
         "* %? %^g\n %i\n")
        ("b" "overwork" plain (file+headline "~/work/addban.org" "Addban")
         "  %<<%Y-%m-%d %Ea %H:%M>> %?")))
(setq org-default-notes-file (concat org-directory "/inbox.org"))

;;; graphviz-dot-mode
(load-library "graphviz-dot-mode")

;;; end of my emacs configuration

