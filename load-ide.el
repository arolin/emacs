

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet)
(yas-global-mode t)

;; auto complete C++-headers
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories
               '("c:/Qt/Qt5.9.4/5.9.4/msvc2015_64/include/
                  c:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/Linux/include/usr/include/
                  c:/sandbox/xPlatEnscoApp"))
  )

  

;; call ac-c-headers from c/c++ hooks
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)


(require 'protobuf-mode)
;;
;; You can customize this mode just like any mode derived from CC Mode.  If
;; you want to add customizations specific to protobuf-mode, you can use the
;; `protobuf-mode-hook'. For example, the following would make protocol-mode
;; use 2-space indentation:
;;
(defconst my-protobuf-style
  '((c-basic-offset . 2)
    (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)))
