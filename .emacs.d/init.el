;;; init.el -- my init file
;;; Commentary:

;; I suppose this is where the comments go?

;;; Code:
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(show-paren-mode t)
(column-number-mode 1)
(setq inhibit-startup-message t)
(fringe-mode 10)
(setq visible-bell 1)
(require 'package)
(setq make-backup-files nil)
(set-frame-font "Inconsolata-12")
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
             ;; ("marmalade" . "http://marmalade-repo.org/packages/")
			 ( "jcs-elpa" . "https://jcs-emacs.github.io/jcs-elpa/packages/")
			 ("melpa" . "http://melpa.org/packages/")))


;; Install package.el so we can use package.el for the remainder of the config
;; (setq my-package-list '(use-package))
;; idk, was complaining
;; (package-initialize)
;; (unless (package-installed-p 'quelpa)
;;   (with-temp-buffer
;;     (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
;;     (eval-buffer)
;;     (quelpa-self-upgrade)))
;; (require 'quelpa-use-package)
(require 'use-package)
;; Make org-mode src block indentation behave as expected
(setq org-src-preserve-indentation t)
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "SOLVED/NOT-FILED" "|" "DONE" "CANCELLED")))


(use-package org-modern
  :ensure t
  :init (global-org-modern-mode)
  :config
  (setq org-agenda-files (directory-files-recursively "~/PARA/resources" "\\.org$"))
  (visual-line-mode))
  
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (evil-mode 1)
  :config
  ;; (define-key evil-normal-state-map (kbd "g d") 'slime-edit-definition)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-normal-state-map (kbd "a") 'ace-jump-mode)
  (define-key evil-normal-state-map (kbd "z d")  'evil-close-folds)
  (define-key evil-normal-state-map (kbd "z s") 'evil-open-folds)
  (define-key evil-normal-state-map (kbd "q") nil))

(use-package hideshow
  :hook (prog-mode . hs-minor-mode)
  :config
  (with-eval-after-load 'evil
    (define-key evil-normal-state-map (kbd "z l") 'hs-hide-level)
    (define-key evil-normal-state-map (kbd "z c") 'hs-hide-block)
    (define-key evil-normal-state-map (kbd "z o") 'hs-show-block)
    (define-key evil-normal-state-map (kbd "z M") 'hs-hide-all)
    (define-key evil-normal-state-map (kbd "z r") 'hs-show-all)))


(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Displays options for completing an incomplete key sequence in minibuffer
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1)
  :diminish which-key)

;; Eglot is the built in LSP client for emacs
(use-package eglot
  :ensure t
  :config (progn
	    (add-to-list 'eglot-server-programs '((tsx-ts-mode) "typescript-language-server" "--stdio" "--log-level" "4"))
	    (add-to-list 'eglot-server-programs '((typescript-ts-mode) "typescript-language-server" "--stdio" "--log-level" "4")))
  (setq eglot-confirm-server-initiated-edits nil)
  :hook ((python-mode . eglot-ensure)
	 (haskell-mode . eglot-ensure)
	 (js-mode . eglot-ensure)
	 (tsx-ts-mode . eglot-ensure)
	 (typescript-ts-mode . eglot-ensure)
	 (typescript-mode . eglot-ensure)
	 (racket-mode . eglot-ensure)
	 (js-jsx-mode . eglot-ensure)
	 (c-mode . eglot-ensure)))


(add-hook 'js-jsx-mode-hook
	  (lambda () (setq js-indent-level 2)))

;; Autocomplete
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.2)
  (global-company-mode t))


(use-package ace-jump-mode
  :ensure t
  :bind ("C-c SPC" . ace-jump-mode))

(use-package color-identifiers-mode
    :ensure t
    :hook python-mode)

(use-package rainbow-delimiters
  :ensure t)
  
(use-package vterm
  :ensure t)

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))


(use-package blacken
  :ensure t
  :init
  (setq-default blacken-fast-unsafe t)
  (setq-default blacken-line-length 80))


(use-package multiple-cursors
  :ensure t)

(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" . typescript-ts-mode)
  :init
  (add-hook 'typescript-mode-hook #'auto-revert-mode))

(use-package tsx-ts-mode
  :mode ("\\.tsx\\'" . tsx-ts-mode)
  :init
  (add-hook 'tsx-ts-mode-hook #'auto-revert-mode))

(use-package apheleia
  :ensure t
  :init (apheleia-global-mode +1))

(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode))
  :init
  (add-hook 'clojure-mode-hook #'yas-minor-mode)         
  (add-hook 'clojure-mode-hook #'subword-mode)           
  (add-hook 'clojure-mode-hook #'smartparens-mode)       
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'clojure-mode-hook #'eldoc-mode)             
  (add-hook 'clojure-mode-hook #'idle-highlight-mode))

(use-package chatgpt
  :ensure t
  :init (setq openai-key (with-temp-buffer (insert-file-contents "~/.secrets/openai") (buffer-string))))
  
(use-package cider
  :ensure t
  :defer t
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t                  
        cider-repl-display-in-current-window t
        cider-repl-use-clojure-font-lock t    
        cider-prompt-save-file-on-load 'always-save
        cider-font-lock-dynamically '(macro core function var)
        nrepl-hide-special-buffers t            
        cider-overlays-use-font-lock t)         
  (cider-repl-toggle-pretty-printing))


(use-package smartparens
  :defer t
  :ensure t
  :diminish smartparens-mode
  :init
  (setq sp-override-key-bindings
        '(("C-<right>" . nil)
          ("C-<left>" . nil)
          ("C-)" . sp-forward-slurp-sexp)
          ("M-<backspace>" . nil)
          ("C-(" . sp-forward-barf-sexp)))
  (smartparens-global-mode)
  :config
  (use-package smartparens-config)
  (sp-use-smartparens-bindings)
  (sp--update-override-key-bindings)
  :commands (smartparens-mode show-smartparens-mode))

;; Major mode for OCaml programming
(use-package tuareg
  :ensure t
  :mode (("\\.ml[iylp]?$" . tuareg-mode)
	 ("\\.ocamlinit\\'" . tuareg-mode)))

(use-package rjsx-mode
  :ensure t
  :mode ("\\.js\\'" . rjsx-mode))

;; Home baked addiitons
(load-file "/home/stefan/PARA/projects/emacs-vitest-runer/vitest.el")
(require 'vitest)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#1E1C31" "#FF8080" "#95FFA4" "#FFE9AA" "#91DDFF" "#C991E1" "#AAFFE4" "#CBE3E7"])
 '(custom-enabled-themes '(doom-gruvbox))
 '(custom-safe-themes
   '("e2c926ced58e48afc87f4415af9b7f7b58e62ec792659fcb626e8cba674d2065" "846b3dc12d774794861d81d7d2dcdb9645f82423565bfb4dad01204fa322dbd5" "47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" "f7fed1aadf1967523c120c4c82ea48442a51ac65074ba544a5aefc5af490893b" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "850bb46cc41d8a28669f78b98db04a46053eca663db71a001b40288a9b36796c" "c2aeb1bd4aa80f1e4f95746bda040aafb78b1808de07d340007ba898efa484f5" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "4133d2d6553fe5af2ce3f24b7267af475b5e839069ba0e5c80416aa28913e89a" "1278c5f263cdb064b5c86ab7aa0a76552082cf0189acf6df17269219ba496053" "6f4421bf31387397f6710b6f6381c448d1a71944d9e9da4e0057b3fe5d6f2fad" "4a5aa2ccb3fa837f322276c060ea8a3d10181fecbd1b74cb97df8e191b214313" "1d44ec8ec6ec6e6be32f2f73edf398620bb721afeed50f75df6b12ccff0fbb15" "4b6b6b0a44a40f3586f0f641c25340718c7c626cbf163a78b5a399fbe0226659" "e8df30cd7fb42e56a4efc585540a2e63b0c6eeb9f4dc053373e05d774332fc13" "b5803dfb0e4b6b71f309606587dd88651efe0972a5be16ece6a958b197caeed8" "b186688fbec5e00ee8683b9f2588523abdf2db40562839b2c5458fcfb322c8a4" "db3e80842b48f9decb532a1d74e7575716821ee631f30267e4991f4ba2ddf56e" "9b54ba84f245a59af31f90bc78ed1240fca2f5a93f667ed54bbf6c6d71f664ac" "e6f3a4a582ffb5de0471c9b640a5f0212ccf258a987ba421ae2659f1eaa39b09" "5784d048e5a985627520beb8a101561b502a191b52fa401139f4dd20acb07607" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "84b14a0a41bb2728568d40c545280dbe7d6891221e7fbe7c2b1c54a3f5959289" "4b0e826f58b39e2ce2829fab8ca999bcdc076dec35187bf4e9a4b938cb5771dc" "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" "23c806e34594a583ea5bbf5adf9a964afe4f28b4467d28777bcba0d35aa0872e" "333958c446e920f5c350c4b4016908c130c3b46d590af91e1e7e2a0611f1e8c5" "a6e620c9decbea9cac46ea47541b31b3e20804a4646ca6da4cce105ee03e8d0e" "0d01e1e300fcafa34ba35d5cf0a21b3b23bc4053d388e352ae6a901994597ab1" "fe2539ccf78f28c519541e37dc77115c6c7c2efcec18b970b16e4a4d2cd9891d" "028c226411a386abc7f7a0fba1a2ebfae5fe69e2a816f54898df41a6a3412bb5" "613aedadd3b9e2554f39afe760708fc3285bf594f6447822dd29f947f0775d6c" "3d47380bf5aa650e7b8e049e7ae54cdada54d0637e7bac39e4cc6afb44e8463b" "f91395598d4cb3e2ae6a2db8527ceb83fed79dbaf007f435de3e91e5bda485fb" "18bec4c258b4b4fb261671cf59197c1c3ba2a7a47cc776915c3e8db3334a0d25" "e19ac4ef0f028f503b1ccafa7c337021834ce0d1a2bca03fcebc1ef635776bea" "c5ded9320a346146bbc2ead692f0c63be512747963257f18cc8518c5254b7bf5" "a0be7a38e2de974d1598cf247f607d5c1841dbcef1ccd97cded8bea95a7c7639" "40b961730f8d3c63537d6c3e6601f15c6f6381b9239594c7bf80b7c6a94d3c24" "d6844d1e698d76ef048a53cefe713dbbe3af43a1362de81cdd3aefa3711eae0d" "82ef0ab46e2e421c4bcbc891b9d80d98d090d9a43ae76eb6f199da6a0ce6a348" "b0e446b48d03c5053af28908168262c3e5335dcad3317215d9fdeb8bac5bacf9" "da53441eb1a2a6c50217ee685a850c259e9974a8fa60e899d393040b4b8cc922" "6c98bc9f39e8f8fd6da5b9c74a624cbb3782b4be8abae8fd84cbc43053d7c175" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "3d54650e34fa27561eb81fc3ceed504970cc553cfd37f46e8a80ec32254a3ec3" "da186cce19b5aed3f6a2316845583dbee76aea9255ea0da857d1c058ff003546" "266ecb1511fa3513ed7992e6cd461756a895dcc5fef2d378f165fed1c894a78c" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "f6665ce2f7f56c5ed5d91ed5e7f6acb66ce44d0ef4acfaa3a42c7cfe9e9a9013" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "246a9596178bb806c5f41e5b571546bb6e0f4bd41a9da0df5dfbca7ec6e2250c" "d47f868fd34613bd1fc11721fe055f26fd163426a299d45ce69bef1f109e1e71" "1f1b545575c81b967879a5dddc878783e6ebcca764e4916a270f9474215289e5" "a82ab9f1308b4e10684815b08c9cac6b07d5ccb12491f44a942d845b406b0296" "8146edab0de2007a99a2361041015331af706e7907de9d6a330a3493a541e5a6" "4f1d2476c290eaa5d9ab9d13b60f2c0f1c8fa7703596fa91b235db7f99a9441b" "5f19cb23200e0ac301d42b880641128833067d341d22344806cdad48e6ec62f6" "a7b20039f50e839626f8d6aa96df62afebb56a5bbd1192f557cb2efb5fcfb662" "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01" "6c531d6c3dbc344045af7829a3a20a09929e6c41d7a7278963f7d3215139f6a7" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "cbdf8c2e1b2b5c15b34ddb5063f1b21514c7169ff20e081d39cf57ffee89bc1e" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" default))
 '(debug-on-error nil)
 '(ein:output-area-inlined-images t)
 '(exwm-floating-border-color "#292F37")
 '(fci-rule-color "#858FA5")
 '(highlight-tail-colors ((("#29323c" "#1f2921") . 0) (("#2c3242" "#212928") . 20)))
 '(ignored-local-variable-values
   '((vc-prepare-patches-separately)
     (diff-add-log-use-relative-names . t)
     (vc-git-annotate-switches . "-w")))
 '(jdee-db-active-breakpoint-face-colors (cons "#100E23" "#906CFF"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#100E23" "#95FFA4"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#100E23" "#565575"))
 '(objed-cursor-color "#FF8080")
 '(org-agenda-files
   '("/home/stefan/PARA/archive/arachne/README.org" "/home/stefan/PARA/archive/dolos/lisp/README.org" "/home/stefan/PARA/archive/hermes.lisp/README.org" "/home/stefan/PARA/archive/project/cram-incremental-reading/README.org" "/home/stefan/PARA/archive/project/cramv3/notes/blocknote.org" "/home/stefan/PARA/archive/project/cramv3/notes/design.org" "/home/stefan/PARA/archive/project/cramv3/notes/incremental-reading.org" "/home/stefan/PARA/archive/ocaml_journey.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_04_01_notes_on_learning_clojure.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_04_12_notes_on_real_analysis.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_04_13_more_real_analysis.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_06_10_bottom_up_top_down_applications_and_libraries.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_06_10_parent_child_patterns.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_06_12_event_systems.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_06_13_eventual_consistency_and_products.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_07_10_async_function_pitfalls.org" "/home/stefan/PARA/areas/devnotes/scrawls/2024_07_10_the_problem_with_frontend_development.org" "/home/stefan/PARA/areas/devnotes/stackspace/2024-07-20.org" "/home/stefan/PARA/areas/writing/a_journey_through_fire_island.org" "/home/stefan/PARA/areas/writing/ok.org" "/home/stefan/PARA/areas/writing/on_plot.org" "/home/stefan/PARA/projects/loki/README.org" "/home/stefan/PARA/projects/loki/todo.org" "/home/stefan/PARA/projects/stackspace/design-docs/search.org" "/home/stefan/PARA/projects/stackspace/design-docs/zettle.org" "/home/stefan/PARA/projects/stackspace/design-docs/zettle2.org" "/home/stefan/PARA/resources/document-notes/designing-data-intensive-applications.org" "/home/stefan/PARA/resources/document-notes/how-to-take-smart-notes.org" "/home/stefan/PARA/resources/document-notes/prosemirror-guide.org" "/home/stefan/PARA/resources/document-notes/react-ui-testing.org" "/home/stefan/PARA/resources/document-notes/tip-tap-docs.org" "/home/stefan/PARA/resources/notes/lang/css/custom-properties.org" "/home/stefan/PARA/resources/notes/lang/css/pseudo-classes.org" "/home/stefan/PARA/resources/notes/lang/elisp/aOverview.org" "/home/stefan/PARA/resources/notes/lang/elisp/managing-processes.org" "/home/stefan/PARA/resources/notes/lang/elisp/writing-a-major-mode.org" "/home/stefan/PARA/resources/notes/lang/typescript/declare.org" "/home/stefan/PARA/resources/notes/lang/typescript/functions.org" "/home/stefan/PARA/resources/notes/lang/typescript/new-project.org" "/home/stefan/PARA/resources/notes/lang/typescript/tips-and-tricks.org" "/home/stefan/PARA/resources/notes/lang/typescript/vitest.org" "/home/stefan/PARA/resources/notes/lib/react/aOverview.org" "/home/stefan/PARA/resources/notes/lib/react/context.org" "/home/stefan/PARA/resources/notes/lib/react/hooks.org" "/home/stefan/PARA/resources/notes/lib/react/integratingWithExternalState.org" "/home/stefan/PARA/resources/notes/lib/react/portal.org" "/home/stefan/PARA/resources/notes/lib/react/testing.org" "/home/stefan/PARA/resources/notes/lib/tiptap/linking-two-editors.org" "/home/stefan/PARA/resources/notes/lib/tiptap/mentons.org" "/home/stefan/PARA/resources/notes/lib/tiptap/rendering-notes-with-react.org" "/home/stefan/PARA/resources/notes/lib/zustand.org" "/home/stefan/PARA/resources/notes/linux/write-persistence.org" "/home/stefan/PARA/resources/notes/search/prefix.org" "/home/stefan/PARA/resources/notes/tanstack_router.org" "/home/stefan/PARA/resources/notes/zustand_router.org" "/home/stefan/PARA/resources/programming-languages/clojure.org" "/home/stefan/PARA/resources/programming-languages/ocaml.org" "/home/stefan/PARA/resources/programming-languages/python.org" "/home/stefan/PARA/resources/scrawls/2024-07-29.org" "/home/stefan/PARA/resources/wiki/csplit.org" "/home/stefan/PARA/resources/devlog.org" "/home/stefan/PARA/resources/todo.org"))
 '(org-format-latex-options
   '(:foreground default :background default :scale 2.5 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-src-preserve-indentation t)
 '(package-selected-packages
   '(magit treesit-auto org-modern org-modern-mode exlixir-mode color-theme-sanityinc-tomorrow lua-mode hcl-mode ein hlinum idle-highlight-mode rjsx-mode chatgpt slime-quicklisp slime-quickload slime-fancy slime-company slime-asdf racket-mode quick-mode quick geiser-racket general rainbow-delimiters-mode vterm flycheck-eglot haskell-mode rust-mode neotree elixir-mode evil typescript-mode buttercup quelpa-leaf quelpa-use-package apheleia tree-sitter-langs aphelia tree-stiter-langs tree-sitter web-mode fountain-mode request yaml-mode dockerfile-mode w3m dante lsp-haskell rainbow-identifiers eglot merlin-eldoc prism which-key rainbow-delimiters slime doom-themes flycheck flymake-cursor lsp-treemacs lsp-ivy lsp-ui color-identifiers-mode ace-jump-mode lsp-mode use-package company))
 '(pdf-view-midnight-colors (cons "#CBE3E7" "#1E1C31"))
 '(rustic-ansi-faces
   ["#1E1C31" "#FF8080" "#95FFA4" "#FFE9AA" "#91DDFF" "#C991E1" "#AAFFE4" "#CBE3E7"])
 '(typescript-indent-level 2)
 '(vc-annotate-background "#1E1C31")
 '(vc-annotate-color-map
   (list
    (cons 20 "#95FFA4")
    (cons 40 "#b8f7a6")
    (cons 60 "#dbf0a8")
    (cons 80 "#FFE9AA")
    (cons 100 "#ffd799")
    (cons 120 "#ffc488")
    (cons 140 "#FFB378")
    (cons 160 "#eda79b")
    (cons 180 "#db9cbd")
    (cons 200 "#C991E1")
    (cons 220 "#db8bc0")
    (cons 240 "#ed85a0")
    (cons 260 "#FF8080")
    (cons 280 "#d4757d")
    (cons 300 "#aa6a7a")
    (cons 320 "#805f77")
    (cons 340 "#858FA5")
    (cons 360 "#858FA5")))
 '(vc-annotate-very-old-color nil)
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
