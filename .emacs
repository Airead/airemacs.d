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

;;; useful variable
(defvar emacs-load-file-name load-file-name
  "Store the filename that yasnippet.el was originally loaded from.")

;;; some useful function
(defun get-path (path)
  "get absolute path"
  (concat (file-name-directory emacs-load-file-name) path))

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
                        "./lib/xcscope"
                        "./lib/w3m"
                        "./lib/color-theme"
                        "./lib/color-theme/emacs-color-theme-solarized"
                        "../emacs-jedi"
                        "./lib/cedet-1.1/common"
                        "./lib/ecb-2.40"
                        "./lib/ess-12.09-2/lisp"
                        "./lib/magit"
                        "./lib/ein"
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

;;; mutiline comment
(setq comment-style 'multi-line)

;;; line number mode
(global-linum-mode t)
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

;; ;;; pymacs
;; (require 'pymacs)
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; (autoload 'pymacs-autoload "pymacs")
;; ;;(eval-after-load "pymacs"
;; ;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;; ;;; ropemacs
;; (setq pymacs-load-path '("./lib/pymacs"))
;; (pymacs-load "ropemacs" "rope-")

;;; auto complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/airead/study/git-proj/airemacs.d/lib/auto-complete-1.3.1/dict")
(ac-config-default)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

;;; linux kernel code style
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))

;; (defun linux-c-mode ()
;;   "C mode with adjusted defaults for use with the Linux kernel."
;;   (interactive)
;;   (c-mode)
;;   (c-set-style "K&R")
;;   (setq tab-width 4)
;;   (setq indent-tabs-mode nil)
;;   (setq c-basic-offset 4))
;; (add-to-list 'auto-mode-alist '("\.c$" . linux-c-mode))
;; (add-to-list 'auto-mode-alist '("\.h$" . linux-c-mode))

;;; yasnippet
(require 'yasnippet)
(add-to-list 'yas-snippet-dirs (get-path "airsnippets"))
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
(setq org-tag-alist '(("OFFICE" . ?o)
                     ("HOME" . ?h)
                     ("AVOCATION" . ?a)
                     ("WAIT" . ?w)
                     ("IMPORTANT" . ?i)
                     ("URGENT" . ?u)
                     ("LIVING" . ?l)))
(setq org-refile-targets '(("task.org" :maxlevel . 1)
                           ("finished.org" :maxlevel . 1)))
(setq org-directory "~/Dropbox/GTD/") 
(setq cur-year-month (format-time-string "%Y-%m" (current-time)))
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
        ("b" "overwork" plain (file+headline "~/work/addban.org" "2013-05")
        "   %<<%Y-%m-%d %a %H:%M>> %?")))
(setq org-default-notes-file (concat org-directory "/inbox.org"))
;; set agenda files
(setq org-agenda-files (list "~/Dropbox/GTD/task.org"
                             "~/Dropbox/GTD/project.org"))

;;; graphviz-dot-mode
(load-library "graphviz-dot-mode")

;;; xcscope
(require 'xcscope)
(define-key global-map [(control f3)]  'cscope-set-initial-directory)
(define-key global-map [(control f4)]  'cscope-unset-initial-directory)
(define-key global-map [(control f5)]  'cscope-find-this-symbol)
(define-key global-map [(control f6)]  'cscope-find-global-definition)
(define-key global-map [(control f7)]  'cscope-find-global-definition-no-prompting)
(define-key global-map [(control f8)]  'cscope-pop-mark)
;;	(define-key global-map [(control f9)]  'cscope-next-symbol)
;;	(define-key global-map [(control f10)] 'cscope-next-file)
;;	(define-key global-map [(control f11)] 'cscope-prev-symbol)
;;	(define-key global-map [(control f12)] 'cscope-prev-file)
;;      (define-key global-map [(meta f9)]  'cscope-display-buffer)
;;      (defin-ekey global-map [(meta f10)] 'cscope-display-buffer-toggle)

;;; w3m
(require 'w3m)

;;; php mode
(require 'php-mode)

;;; markdown-mode
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown" . markdown-mode))

;;; web mode
(unless (fboundp 'prog-mode) (defalias 'prog-mode 'fundamental-mode))
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

;;; if 0 end
;;Highlight #if 0 to #endif
(defun my-c-mode-font-lock-if0 (limit)
  (save-restriction
    (widen)
    (save-excursion
      (goto-char (point-min))
      (let ((depth 0) str start start-depth)
        (while (re-search-forward "^\\s-*#\\s-*\\(if\\|else\\|endif\\)" limit 'move)
          (setq str (match-string 1))
          (if (string= str "if")
              (progn
                (setq depth (1+ depth))
                (when (and (null start) (looking-at "\\s-+0"))
                  (setq start (match-end 0)
                        start-depth depth)))
            (when (and start (= depth start-depth))
              (c-put-font-lock-face start (match-beginning 0) 'font-lock-comment-face)
              (setq start nil))
            (when (string= str "endif")
              (setq depth (1- depth)))))
        (when (and start (> depth 0))
          (c-put-font-lock-face start (point) 'font-lock-comment-face)))))
  nil)

(defun my-c-mode-common-hook ()
  (font-lock-add-keywords
   nil
   '((my-c-mode-font-lock-if0 (0 font-lock-comment-face prepend))) 'add-to-end))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;; open recent files
(recentf-mode 1)
(global-set-key "\C-xrf" 'recentf-open-files)

;;; define key for view-mode
(global-set-key "\C-cv" 'view-mode)
(define-key view-mode-map (kbd "j") 'next-line)
(define-key view-mode-map (kbd "k") 'previous-line)
(define-key view-mode-map (kbd "l") 'forward-char)
(define-key view-mode-map (kbd "h") 'backward-char)

;;; gdb bindkey
(add-hook 'gdb-mode-hook '(lambda ()
	        (define-key c-mode-base-map [(f5)] 'gud-go)
                            (define-key c-mode-base-map [(f7)] 'gud-step)
                            (define-key c-mode-base-map [(f5)] 'gud-go)
                            (define-key c-mode-base-map [(f8)] 'gud-next)))

;;; color theme
(load-library "color-theme")
(require 'color-theme-solarized)
(setq solarized-termcolors 256)
(setq solarized-contrast 'normal)
(color-theme-solarized-light)

;;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: For Emacs >= 23.2, you must place this *before* any
;; CEDET component (including EIEIO) gets activated by another 
;; package (Gnus, auth-source, ...).
(load-library "cedet.el")

;; Enable EDE (Project Management) features
(global-ede-mode 1)

;; Enable EDE for a pre-existing C++ project
;; (ede-cpp-root-project "NAME" :file "~/myproject/Makefile")


;; Enabling Semantic (code-parsing, smart completion) features
;; Select one of the following:

;; * This enables the database and idle reparse engines
(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode,
;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as intellisense mode,
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-gaudy-code-helpers)

;; * This enables the use of Exuberant ctags if you have it installed.
;;   If you use C++ templates or boost, you should NOT enable it.
;; (semantic-load-enable-all-exuberent-ctags-support)
;;   Or, use one of these two types of support.
;;   Add support for new languages only via ctags.
;; (semantic-load-enable-primary-exuberent-ctags-support)
;;   Add support for using ctags as a backup parser.
;; (semantic-load-enable-secondary-exuberent-ctags-support)

;; Enable SRecode (Template management) minor-mode.
;; (global-srecode-minor-mode 1)

;;; ecb
(require 'ecb-autoloads)

;;; lua-mode
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;;; ess for R
(require 'ess-site)

;;; turn on iswitch mode
(iswitchb-mode 1)

;;; magit
(require 'magit)
(global-set-key "\C-ci" 'magit-status)

;;; jedi
(setq jedi:setup-keys t)
(autoload 'jedi:setup "jedi" nil t)

;;; ERC
(require 'erc-join)
(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist
          '(
            ("freenode.net" "#ubuntu-cn" "##0x71" "#openbrd")
            ))


;;; ein (emacs ipython notebook)
(require 'ein)

;;; end of my emacs configuration
