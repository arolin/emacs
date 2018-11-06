;; WORKAROUND https://github.com/magit/magit/issues/2395
(define-derived-mode magit-staging-mode magit-status-mode "Magit staging"
  "Mode for showing staged and unstaged changes."
  :group 'magit-status)
(defun magit-staging-refresh-buffer ()
  (magit-insert-section (status)
    (magit-insert-untracked-files)
    (magit-insert-unstaged-changes)
    (magit-insert-staged-changes)))
(defun magit-staging ()
  (interactive)
  (magit-mode-setup #'magit-staging-mode))

(defvar-local magit-git--git-dir-cache nil)
(defvar-local magit-git--toplevel-cache nil)
(defvar-local magit-git--cdup-cache nil)

(defun memoize-rev-parse (fun &rest args)
  (pcase (car args)
    ("--git-dir"
     (unless magit-git--git-dir-cache
       (setq magit-git--git-dir-cache (apply fun args)))
     magit-git--git-dir-cache)
    ("--show-toplevel"
     (unless magit-git--toplevel-cache
       (setq magit-git--toplevel-cache (apply fun args)))
     magit-git--toplevel-cache)
    ("--show-cdup"
     (let ((cdup (assoc default-directory magit-git--cdup-cache)))
       (unless cdup
         (setq cdup (cons default-directory (apply fun args)))
         (push cdup magit-git--cdup-cache))
       (cdr cdup)))
    (_ (apply fun args))))

(advice-add 'magit-rev-parse-safe :around #'memoize-rev-parse)

(defvar-local magit-git--config-cache (make-hash-table :test 'equal))

(defun memoize-git-config (fun &rest keys)
  (let ((val (gethash keys magit-git--config-cache :nil)))
    (when (eq val :nil)
      (setq val (puthash keys (apply fun keys) magit-git--config-cache)))
    val))

(advice-add 'magit-get :around #'memoize-git-config)
(advice-add 'magit-get-boolean :around #'memoize-git-config)
