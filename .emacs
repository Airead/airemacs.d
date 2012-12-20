;;;; Bob's .emacs file
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
                        "./lib"
                        "./lib/icicles"
                        ))
(setq load-path (append
                 (get-custom-load-path custom-lib-path) nil
                 load-path nil))
  
;;; Text mode and Auto Fill mode
;; The next two lines put Emacs into Text mode and Auto Fill mode, and
;; are for writers who want to start writing prose rather than code.
(setq-default major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)

;;; Keybinding for `occur'
(global-set-key "\C-co" 'occur)

;;; Rebind `C-x C-b' for `buffer-menu'
(global-set-key "\C-x\C-b" 'buffer-menu)

;;; Continue to display the matching parentheses
(show-paren-mode nil)

