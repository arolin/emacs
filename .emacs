;; on linux in your main .emacs file just put
;; (load "~/emacs/.emacs")

(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'color-theme)

(color-theme-initialize)

(defun fix-colors ()
  "fix colors in vmware"
    (interactive)
    (when (eq 1 1)
      (color-theme-gray1)
      (color-theme-billw)
      (color-theme-blue-gnus)
      )
    )

(global-set-key (kbd "C-c C-c") 'fix-colors)

;; If this line fails...
(package-initialize)
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; ;; Once you have added your preferred archive, you need to update the local package list using:
;; (package-refresh-contents)
;; (package-install 'markdown-mode)
;; (package-install 'auto-complete)
;; (package-install 'yasnippet)
;; (package-install 'jedi)


(tool-bar-mode -1)
(menu-bar-mode -1)


(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
               "site-lisp/magit/Documentation/"))

(setq-default
    indent-tabs-mode nil
    tab-width 4
    tab-stop-list (quote (4 8))
    c-basic-offset 4
)
(setq-default indent-tabs-mode nil)

(setq tab-width 4) ; or any other preferred value
(setq compilation-auto-jump-to-first-error t)
(setq compilation-skip-threshold 2)

(setq backup-directory-alist
          `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms
          `((".*" ,(concat user-emacs-directory "autosave"))))

(global-set-key (kbd "C-S-b") 'compile)
(global-set-key (kbd "<C-S-tab>") (lambda() (interactive) (other-window -1)))
(global-set-key (kbd "<C-tab>") 'other-window)
(global-set-key (kbd "M-C-B") 'recompile)
(global-set-key (kbd "C-S-f") 'grep-find)
(global-set-key (kbd "C-$") 'toggle-truncate-lines)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-=") 'text-scale-decrease)
(global-set-key (kbd "C-x C-l") 'downcase-dwim)
(global-set-key (kbd "C-x C-u") 'upcase-dwim)
(global-set-key (kbd "C-c s") 'shell)
(global-set-key [C-mouse-4] 'text-scale-increase)
(global-set-key [C-mouse-5] 'text-scale-decrease)

(defun unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
      (when mark-ring
        (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
        (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
        (when (null (mark t)) (ding))
        (setq mark-ring (nbutlast mark-ring))
        (goto-char (marker-position (car (last mark-ring))))))
(defun xah-pop-local-mark-ring ()
  "Move cursor to last mark position of current buffer.
Call this repeatedly will cycle all positions in `mark-ring'.
URL `http://ergoemacs.org/emacs/emacs_jump_to_previous_position.html'
Version 2016-04-04"
  (interactive)
  (set-mark-command t))

(global-set-key (kbd "C-.") 'xah-pop-local-mark-ring)
(global-set-key (kbd "C-,") 'unpop-to-mark-command)


(defun marker-is-point-p (marker)
  "test if marker is current point"
  (and (eq (marker-buffer marker) (current-buffer))
       (= (marker-position marker) (point))))

(defun push-mark-maybe () 
  "push mark onto `global-mark-ring' if mark head or tail is not current location"
  (if (not global-mark-ring) (error "global-mark-ring empty")
    (unless (or (marker-is-point-p (car global-mark-ring))
                (marker-is-point-p (car (reverse global-mark-ring))))
      (push-mark))))


(defun backward-global-mark () 
  "use `pop-global-mark', pushing current point if not on ring."
  (interactive)
  (push-mark-maybe)
  (when (marker-is-point-p (car global-mark-ring))
    (call-interactively 'pop-global-mark))
  (call-interactively 'pop-global-mark))

(defun forward-global-mark ()
  "hack `pop-global-mark' to go in reverse, pushing current point if not on ring."
  (interactive)
  (push-mark-maybe)
  (setq global-mark-ring (nreverse global-mark-ring))
  (when (marker-is-point-p (car global-mark-ring))
    (call-interactively 'pop-global-mark))
  (call-interactively 'pop-global-mark)
  (setq global-mark-ring (nreverse global-mark-ring)))

(global-set-key (kbd "M-,") (quote backward-global-mark))
(global-set-key (kbd "M-.") (quote forward-global-mark))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add revert to save-some-buffers
(when (boundp 'save-some-buffers-action-alist)
  (setq save-some-buffers-action-alist
        (cons
         (list
          ?%
          #'(lambda (buf)
              (with-current-buffer buf
                (set-buffer-modified-p nil))
              nil)
          "mark buffer unmodified.")
         (cons
          (list
           ?,
           #'(lambda (buf)
               (with-current-buffer buf
                 (revert-buffer t))
               nil)
           "revert buffer.")
          save-some-buffers-action-alist))))

(provide 'setup-save-some-buffers)
;; Add revert to save-some-buffers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(desktop-save-mode t)
 '(grep-find-command
   (quote
    ("grep -nIHR  * --exclude=*{#,~} --exclude=*{.log} --exclude-dir=Debug --exclude-dir=obj" . 12)))
 '(package-selected-packages
   (quote
    (markdown-mode   auto-complete auto-complete-c-headers yasnippet auto-complete csv-mode magit)))
 '(tramp-default-method "ssh")
 '(truncate-lines nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(magit-define-popup-option 'magit-pull-popup
  ?s "recurse submodules" "--recurse-submodules=yes")

(require 'qt-pro)
(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qt-pro-mode))

(electric-pair-mode t)
(load "~/emacs/.emacs.d/lisp/load-ide.el")

(when (eq 'windows-nt system-type)
  (setq directory-abbrev-alist '(("/mnt/hgfs/" . "c:\\")))
  (setq exec-path (append '("c:\\Python\\WinPython-64bit-3.6.3.0Qt5\\python-3.6.3.amd64\\") exec-path))
  (setq python-shell-interpreter "python.exe")
  (defun toggle-full-screen () (interactive) (shell-command "emacs_fullscreen.exe"))
  (global-set-key [f11] 'toggle-full-screen)
p  )

(when (eq 'gnu/linux system-type)
  (defun toggle-fullscreen ()
    "Toggle full screen on X11"
    (interactive)
    (when (eq window-system 'x)
      (set-frame-parameter
       nil 'fullscreen
       (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))

  (global-set-key [f11] 'toggle-fullscreen)
  (toggle-fullscreen)
  )



;; Helper to move stuff out of the way when pasting
(defun my-insert-recangle-push-lines ()
  (interactive)
  (narrow-to-region (point) (mark))
  (yank-rectangle)
  (widen))

(global-set-key (kbd "C-x r Y") #'my-insert-recangle-push-lines)


(fix-colors)
