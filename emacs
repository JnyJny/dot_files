;;
;; file: .emacs 
;;

;; turn stuff on
(display-time)
(global-font-lock-mode t)


;; turn stuff off
;;(tool-bar-mode 0)
(menu-bar-mode 0)
(blink-cursor-mode 0)
(setq inhibit-startup-message t)
(put 'eval-expression 'disabled nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq mouse-yank-at-point 't)

;; path
(setq exec-path (append (list "/usr/local/bin") exec-path))

;; load path

(add-to-list 'load-path "/Users/ejo/.emacs.d/lisp")

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

(require 'kivy-mode)
(add-to-list 'auto-mode-alist '("\\.kv\\'" . kivy-mode))

;; markdown
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;; Keys I'm used to.
(global-set-key "\C-x\C-x" 'save-buffer)
(global-set-key "\C-xk" 'kill-buffer)
(global-set-key "\C-k" 'kill-line)
(global-set-key "\C-y" 'yank)
(global-set-key "\C-d" 'kill-forward-character)
(global-set-key "\C-h" 'kill-backward-character)
(global-set-key "\C-b" 'backward-char)
(global-set-key "\C-f" 'forward-char)
(global-set-key "\C-x\C-f" 'find-file)

(global-set-key "\M-f" 'fill-paragraph)
(global-set-key "\M-\ " 'set-mark-command)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-w" 'copy-region-as-kill)
(global-set-key "\M-k" 'copy-line-as-kill)
(global-set-key "\M-r" 'replace-string)
(global-set-key "\M-R" 'replace-regexp)
(global-set-key "\M-=" 'count-region)

(add-hook 'c-mode-hook 'c-mode-fixup)
(add-hook 'asm-mode-hook 'asm-mode-fixup)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'java-mode-hook 'java-mode-fixup)
(add-hook 'compilation-mode-hook 'compilation-mode-fixup)

;; Fixups
;; 
(defun c-mode-fixup () 
  "Erik's c-mode customizations."
  (local-set-key "\M-m" '(lambda () 
                           (interactive) 
                           (save-buffer) 
                           (compile "make")))
  (local-set-key "\C-c\C-f" 'c-comment-template-function)
  ;; make sure case labels are indented in one level from switches
  (setq c-offsets-alist (cons '(case-label . +) c-offsets-alist))
  )

(defun asm-mode-fixup () 
  "Erik's asm-mode customizations."
  (local-set-key "\M-m" '(lambda () 
                           (interactive) 
                           (save-buffer) 
                           (compile "make -j2")))
  )

(defun java-mode-fixup ()
  "Erik's java-mode customizations."
  (setq c-basic-offset 2)
  (setq c-offsets-alist (cons '(case-label . +) c-offsets-alist))
  (local-set-key "\M-m" '(lambda ()
			   (interactive)
			   (save-buffer)
			   (cd (vc-find-root buffer-file-name "pom.xml"))
			   (compile-maven))))

(defun compilation-mode-fixup ()
  "Erik's compilation-mode customizations."
  (setq compilation-scroll-output 'first-error)
  (setq compilation-skip-threshod 2)
  )

(defun compile-maven ()
  "Traveling up the path, find a pom.xml and 'compile mvn'."
  (interactive)
  (when (locate-dominating-file default-directory "pom.xml")
    (with-temp-buffer
      (cd (locate-dominating-file default-directory "pom.xml"))
          (compile "mvn"))))


(defun python-shell-send-buffer-no-prompt (&optional arg)
  (python-shell-get-or-create-process "python3.4 -i" nil t))

;;(defun copy-from-osx ()
;;  (shell-command-to-string "pbpaste"))
;;
;;(defun paste-to-osx (text &optional push)
;;  (let ((process-connection-type nil))
;;    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
;;      (process-send-string proc text)
;;      (process-send-eof proc))))
;;(setq interprogram-cut-function 'paste-to-osx)
;;(setq interprogram-paste-function 'copy-from-osx)


;; HTML mode configuration stuff
;;(setq html-helper-do-write-file-hooks t) ;; changed default to t
;;(setq html-helper-build-new-buffer t)    ;; changed default to t
;;(setq tempo-interactive nil)
;;
;;(add-to-list 'auto-mode-alist '("\\.d\\'" . d-mode))

(setq auto-mode-alist
      (append '(
;;      (append '(("\\.xml$"  . xml-mode)
;;      (append '(("\\.dtd$"  . xml-mode);
		("\\.x$"     . c-mode)
		("\\.cu$"    . c-mode)
		("\\.d\\'" . d-mode)
		) auto-mode-alist))

;; C mode customization

(defun c-comment-template-function (funcname)
  "Insert a comment block to describe a C function."
  (interactive "sFunction Name: ") 
  (save-excursion
    (insert "/* NAME: " funcname "\n *\n * FUNCTION:\n *\n * RETURNS:\n */\n"))
  )

(defun c-comment-template-structure (structname structtype)
  "Insert a comment block to describe a C structure."
  (interactive "sStructure Name:\nsStructure Type: ")
  (save-excursion
    (insert 
     "/* NAME: "
     (if (> (chars-in-string structtype) 0)
	 (concat  structname ", " structtype)
       (concat structname))
     "\n *\n * METHODS:\n *\n * PURPOSE:\n *\n */\n"
     )
    (if (> (chars-in-string structtype) 0)
	(insert "typedef struct " structname "{\n\n} " structtype ";\n")
      (insert "struct " structname "{\n\n};")))
  )


(defun c-title ()
  "Places a title line of the form:
/* <filename> (<username>@<hostname>) <createdate> Modified: <changedate>*/
on the first line of a buffer invoked on.  Multiple invocations attempt to
just update the Modified time."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (looking-at (concat
		     (regexp-quote "/*") ".*" (regexp-quote "Modified: " )))
	(put-title (concat (buffer-substring (point-min) (match-end 0))
			   (e-date t) " */") t)
      (put-title (concat "/* " (buffer-name) " (" (user-login-name ) "@"
			 (nth 0 
			      (split-string (system-name) (regexp-quote ".")))
			 ") " (e-date) " Modified: " (e-date t) " */\n") nil)
      )
    )
  )

(defun put-title (str &optional replace)
  "Put str on the first line of the current buffer."
  (save-excursion
    (goto-char (point-min))
    (insert str)
    (if replace (kill-line))
    )
  )
 
(defun e-date (&optional use-time)
  "Re-format the string returned by current-time-string to be:
DD Month YY (opt hh:mm)"
  (setq sp " ")
  (setq s (current-time-string))
  (concat (substring s 8 10) sp (substring s 4 7) sp (substring s 22 24)
	  sp (if use-time (concat sp (substring s 11 16))))
)


(defun count-region (start end)
  "Count lines, words and characters in region."
  (interactive "r")
  (let ((l (count-lines start end))
	(w (count-words start end))
	(c (- end start)))
    (message "Region has %d line%s, %d word%s and %d character%s."
	     l (if (= 1 l) "" "s")
	     w (if (= 1 w) "" "s")
	     c (if (= 1 c) "" "s"))))

(defun count-words (start end)
  "Return number of words between START and END."
  (let ((count 0))
    (save-excursion
      (save-restriction
	(narrow-to-region start end)
	(goto-char (point-min))
	(while (forward-word 1)
	  (setq count (1+ count)))))
    count))


;; NMSU stuff that I've grown used to.. 

(defun kill-current-line ()
  "Kill the current line.  Much like the use of Unix's 'kill' which 
is usually bound to ^u."
  (interactive)
  (kill-region 
   (progn (beginning-of-line)
	  (point))
   (progn (end-of-line)
	  (point))))

(defun copy-line-as-kill ()
  "Save the line as if killed, but don't kill it."
  (interactive)
  (setq line (buffer-substring
                (save-excursion (beginning-of-line) (point))
                (save-excursion (end-of-line) (point))
             )
  )
  (if (eq last-command 'kill-region)
      (kill-append line)
    (setq kill-ring (cons line kill-ring))
    (if (> (length kill-ring) kill-ring-max)
    (setcdr (nthcdr (1- kill-ring-max) kill-ring) nil))
  )
  (setq this-command 'kill-region)
  (setq kill-ring-yank-pointer kill-ring)
)

(defun kill-backward-character()
  "kill instead of delete character"
  (interactive)
  (delete-backward-char 1 t))
	
(defun kill-forward-character()
  "kill instead of delete character"
  (interactive)
  (delete-backward-char -1 t))


;; Custom gorp

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(asm-comment-char 33)
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil)
 '(markdown-command "python3 -m markdown")
 '(mode-line-inverse-video t)
 '(python-shell-interpreter "python3.4")
 '(shell-file-name "/bin/tcsh")
 '(vc-path (quote ("/usr/local/bin"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "red"))))
 '(font-lock-constant-face ((((class color) (background dark)) (:foreground "slate grey"))))
 '(font-lock-function-name-face ((((class color) (background dark)) (:foreground "lightblue"))))
 '(font-lock-keyword-face ((((class color) (background dark)) (:foreground "purple"))))
 '(font-lock-string-face ((((class color) (background dark)) (:foreground "Salmon"))))
 '(font-lock-type-face ((((class color) (background dark)) (:foreground "goldenrod"))))
 '(font-lock-variable-name-face ((((class color) (background dark)) (:foreground "yellow"))))
 '(font-lock-warning-face ((((class color) (background dark)) (:bold t :foreground "red"))))
 '(mode-line ((t (:background "yellow" :foreground "red" :inverse-video t))))
 '(region ((t (:inverse-video t)))))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
