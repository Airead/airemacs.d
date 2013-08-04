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
                        "./lib/auto-complete"
                        "./lib/yasnippet"
                        "./lib/org"
                        "./lib/xcscope"
                        "./lib/xpycscope"
                        "./lib/w3m"
                        "./lib/color-theme"
                        "./lib/color-theme/emacs-color-theme-solarized"
                        "./lib/emacs-jedi"
                        "./lib/cedet-1.1/common"
                        "./lib/ecb-2.40"
                        "./lib/ess-12.09-2/lisp"
                        "./lib/magit"
                        "./lib/ein"
                        "./lib/bookmark+"
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

;;; use ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;; dired+
(require 'dired+)

;;; Continue to display the matching parentheses
(show-paren-mode t)

;;; Set font
(add-to-list 'default-frame-alist '(font . "monaco"))

;;; open recent files
(recentf-mode 1)
(global-set-key "\C-xrf" 'recentf-open-files)

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
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
 "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
 "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
 "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

(define-key python-mode-map (kbd "C-c n") 'ein:connect-to-notebook-buffer)

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
         "** TODO %? %<<%Y-%m-%d %H:%M>> \n %i\n")
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
(add-hook 'c-mode-hook
          (lambda ()
            (define-key c-mode-map [(control f3)]  'cscope-set-initial-directory)
            (define-key c-mode-map [(control f4)]  'cscope-unset-initial-directory)
            (define-key c-mode-map [(control f5)]  'cscope-find-this-symbol)
            (define-key c-mode-map [(control f6)]  'cscope-find-global-definition)
            (define-key c-mode-map [(control f7)]  'cscope-find-global-definition-no-prompting)
            (define-key c-mode-map [(control f8)]  'cscope-pop-mark)
            (define-key c-mode-map [(control f9)]  'cscope-next-symbol)
            (define-key c-mode-map [(control f10)] 'cscope-next-file)
            (define-key c-mode-map [(control f11)] 'cscope-prev-symbol)
            (define-key c-mode-map [(control f12)] 'cscope-prev-file)
            (define-key c-mode-map [(meta f9)]  'cscope-display-buffer)
            (defin-ekey c-mode-map [(meta f10)] 'cscope-display-buffer-toggle)
            ))


;;; pyscope
(require 'xpycscope)
(define-key python-mode-map [(control f3)]  'pycscope-set-initial-directory)
(define-key python-mode-map [(control f4)]  'pycscope-unset-initial-directory)
(define-key python-mode-map [(control f5)]  'pycscope-find-this-symbol)
(define-key python-mode-map [(control f6)]  'pycscope-find-global-definition)
(define-key python-mode-map [(control f7)]  'pycscope-find-global-definition-no-prompting)
(define-key python-mode-map [(control f8)]  'pycscope-pop-mark)
(define-key python-mode-map [(control f9)]  'pycscope-next-symbol)
(define-key python-mode-map [(control f10)] 'pycscope-next-file)
(define-key python-mode-map [(control f11)] 'pycscope-prev-symbol)
(define-key python-mode-map [(control f12)] 'pycscope-prev-file)
(define-key python-mode-map [(meta f9)]  'pycscope-display-buffer)
(define-key python-mode-map [(meta f10)] 'pycscope-display-buffer-toggle)
(define-key python-mode-map (kbd "C-c n") 'ein:connect-to-notebook-buffer)

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

;;; define key for view-mode
(require 'view)
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
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(define-key python-mode-map (kbd "C-M-.") 'jedi:goto-definition)
(define-key python-mode-map (kbd "C-M-,") 'jedi:goto-definition-pop-marker)


;; (setq jedi:server-args
;;       '("--sys-path" "./lib/emacs-jedi"))

;; for buildout
(defun find-parent-with-file (path filename)
  "Traverse PATH upwards until we find FILENAME in the dir.
If we find it return the path of that dir, othwise nil is
returned."
  (if (file-exists-p (concat (expand-file-name path) "/" filename))
      path
    (let ((parent-dir (file-name-directory (directory-file-name path))))
      ;; Make sure we do not go into infinite recursion
      (if (string-equal path parent-dir)
          nil
        (find-parent-with-file parent-dir filename)))))

(defun buildout-find-bin (exec)
      "Find a buildout-relative binary script and return absolute path or `exc`"
      (let* ((buildout-directory (find-parent-with-file default-directory "buildout.cfg"))
            (bin-path (concat buildout-directory "bin/" exec)))
        (if (file-exists-p bin-path) bin-path exec)))

(defun check-jedi-python ()
  "Update the path to python for jedi-mode if we switch to a Buildout project."
  (let ((bin (buildout-find-bin "python")))
    (set (make-local-variable 'jedi:server-command) (list bin jedi:server-script))))
(add-hook 'python-mode-hook 'check-jedi-python)

;;; ERC
(require 'erc-join)
(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist
      '(
        ("freenode.net" "#ubuntu-cn" "##0x71" "#openbrd")
        ))


;;; ein (emacs ipython notebook)
(require 'ein)
;; (setq ein:use-auto-complete t)
;; Or, to enable "superpack" (a little bit hacky improvements):
(setq ein:use-auto-complete-superpack t)
(setq ein:use-smartrep t)

;;; rfc mode
(setq auto-mode-alist
      (cons '("/rfc[0-9]+\\.txt\\(\\.gz\\)?\\'" . rfcview-mode)
            auto-mode-alist))
(autoload 'rfcview-mode "rfcview" nil t)

;;; outline minor mode key binding
(require 'outline)
(add-hook 'python-mode-hook '(lambda ()
                               (outline-minor-mode 1)))
(set-display-table-slot
 standard-display-table
 'selective-display
 (let ((face-offset (* (face-id 'shadow) (lsh 1 22))))
   (vconcat (mapcar (lambda (c) (+ face-offset c)) " [...] "))))

(define-key python-mode-map (kbd "M-p") (lambda () (interactive)
                                          (outline-backward-same-level 1)
                                          (back-to-indentation)))
(define-key python-mode-map (kbd "M-n") (lambda () (interactive)
                                          (outline-forward-same-level 1)
                                          (back-to-indentation)))
(define-key python-mode-map (kbd "C-M-u") (lambda () (interactive)
                                            (outline-up-heading 1)
                                            (back-to-indentation)))
(define-key python-mode-map (kbd "C-M-p") (lambda () (interactive)
                                            (outline-previous-visible-heading 1)
                                            (back-to-indentation)))
(define-key python-mode-map (kbd "C-M-n") (lambda () (interactive)
                                            (outline-next-visible-heading 1)
                                            (back-to-indentation)))
(define-key python-mode-map (kbd "M-<up>") 'outline-move-subtree-up)
(define-key python-mode-map (kbd "M-<down>") 'outline-move-subtree-down)

; Outline-minor-mode key map
(define-prefix-command 'cm-map nil "Outline-")
; HIDE
(define-key cm-map "q" 'hide-sublevels)    ; Hide everything but the top-level headings
(define-key cm-map "t" 'hide-body)         ; Hide everything but headings (all body lines)
(define-key cm-map "o" 'hide-other)        ; Hide other branches
(define-key cm-map "c" 'hide-entry)        ; Hide this entry's body
(define-key cm-map "l" 'hide-leaves)       ; Hide body lines in this entry and sub-entries
(define-key cm-map "d" 'hide-subtree)      ; Hide everything in this entry and sub-entries
; SHOW
(define-key cm-map "a" 'show-all)          ; Show (expand) everything
(define-key cm-map "e" 'show-entry)        ; Show this heading's body
(define-key cm-map "i" 'show-children)     ; Show this heading's immediate child sub-headings
(define-key cm-map "k" 'show-branches)     ; Show all sub-headings under this heading
(define-key cm-map "s" 'show-subtree)      ; Show (expand) everything in this heading & below
; MOVE
(define-key cm-map "u" 'outline-up-heading)                ; Up
(define-key cm-map "n" 'outline-next-visible-heading)      ; Next
(define-key cm-map "p" 'outline-previous-visible-heading)  ; Previous
(define-key cm-map "f" 'outline-forward-same-level)        ; Forward - same level
(define-key cm-map "b" 'outline-backward-same-level)       ; Backward - same level
(global-set-key "\M-o" cm-map)

;;; flymake
(when (load "flymake" t)
      (defun flymake-pylint-init ()
        (let* ((temp-file (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
          (list "flake8" (list local-file))))
      (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))
(add-hook 'python-mode-hook (lambda ()
                              (flymake-mode 1)))
(setq flymake-no-changes-timeout 3600)
(setq flymake-start-syntax-check-on-newline nil)
(define-key python-mode-map [(control f2)] 'flymake-goto-next-error)

(require 'flymake-cursor)

(custom-set-faces
 '(flymake-errline ((((class color)) (:underline "red"))))
 '(flymake-warnline ((((class color)) (:underline "blue")))))

;;; bookmark+
;(require 'bookmark+)

;; ;;; pymacs
(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")
;; ;;(eval-after-load "pymacs"
;; ;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;; ;;; ropemacs
(setq pymacs-load-path (list (get-path "./lib/pymacs")))
(pymacs-load "ropemacs" "rope-")
; (defun rope-before-save-actions() ())
; (defun rope-after-save-actions() ())

;;; file-cache
(defun file-cache-add-this-file ()
  (and buffer-file-name
       (file-exists-p buffer-file-name)
       (file-cache-add-file buffer-file-name)))
(add-hook 'kill-buffer-hook 'file-cache-add-this-file)

;;; py autopep8
(require 'py-autopep8)
(define-key python-mode-map (kbd "C-c f") 'python-fmt)

;;; M-r instead C-x r
(setq new-M-r (lookup-key global-map (kbd "C-x r")))
(global-set-key (kbd "M-r") new-M-r)


;;; end of my emacs configuration
