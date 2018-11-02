;; on linux in your main .emacs file just put
;; (load ~/emacs/.emacs)
;; (add-to-list 'load-path "~/emacs/.emacs.d/lisp/")

;; If this line fails...
(package-initialize)
;; (require 'package)
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;; ;; Once you have added your preferred archive, you need to update the local package list using:

;; M-x package-refresh-contents RET

;; ;; Once you have done that, you can install Magit and its dependencies using:

;; M-x package-install RET magit RET

(add-to-list 'load-path "~/.emacs.d/lisp/")

(server-start)
(tool-bar-mode -1)
(require 'color-theme)

(color-theme-initialize)
(color-theme-billw)



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
(setq compilation-auto-jump-to-first-error 1)

(global-set-key (kbd "C-S-b") 'compile)
(global-set-key (kbd "<C-S-tab>") (lambda() (interactive) (other-window -1)))
(global-set-key (kbd "<C-tab>") 'other-window)
(global-set-key (kbd "M-C-B") 'recompile)
(global-set-key (kbd "C-S-f") 'grep-find)
(global-set-key (kbd "C-c $") 'toggle-truncate-lines)

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(grep-find-command
   (quote
    ("grep -nIHR  * --exclude=*{#,~} --exclude=*{.log} --exclude-dir=Debug --exclude-dir=obj" . 12)))
 '(truncate-lines nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
