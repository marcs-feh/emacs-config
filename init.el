;; UI Options

; Disable startup message, scrollbar, toolbar, menu bar and visual bell for a
; cleaner UI. Also use smaller tab width
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq visible-bell nil)
(setq-default tab-width 2)

; Make scrolling smoother and make lines scroll sooner.
;(setq scroll-conservatively 9999)
(setq scroll-step 1)
(setq scroll-margin 8)

; Show line and column numbers. Add fringes to the sides of the screen
(global-display-line-numbers-mode)
(column-number-mode)
(fringe-mode '(16 . 24))

; Allow Emacs' window to be any size and not snap to characters
(setq frame-resize-pixelwise t)

; Set the default font
(defconst user/font "JetBrains Mono Light")
(set-face-attribute 'default nil
	:font user/font
	:height 118)

; Load theme
(load-theme 'doom-dark+ t)

;; General Options

; Make so that ESC can quit prompts. Disable auto-save and backup files.
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(setq auto-save-default nil)
(setq make-backup-files nil)

; Performance enhancing options, garbage collect on idle and window focus loss
; wait until Emacs has allocated more memory before running gc. Disable show-paren
(defun MiB (n) (* n 1024 1024))
(add-hook 'after-init-hook
  #'(lambda ()
			(setq gc-cons-threshold (MiB 64))))
(add-hook 'focus-out-hook 'garbage-collect)
(run-with-idle-timer 5 t 'garbage-collect)
(show-paren-mode 0)

;; Package Manager
; Set package sources
(require 'package)
(setq package-archives
	'(("melpa" . "https://melpa.org/packages/")
		("org"   . "https://orgmode.org/elpa/")
		("elpa"  . "https://elpa.gnu.org/packages/")))

; Initialize package management
(package-initialize)
;(unless package-archive-contents
;	(package-refresh-contents))

; Require use-package for better management
(unless (package-installed-p 'use-package)
	(package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Packages

; Core utility packages.
; diminish   -> Unclutter statusbar
; swiper     -> Fuzzy finder
; hideshow   -> folding(built-in)
; ivy        -> Completion framework
; ivy-rich   -> Extra ivy functionality
; counsel    -> Better commands (works with ivy)
; drag-stuff -> Move text up and down
; general    -> Unified keybinding macros
(use-package diminish)

(use-package swiper)

(use-package ivy
	:diminish
	:bind (:map ivy-minibuffer-map
				 ("TAB" . ivy-alt-done)
				 ("C-l" . ivy-alt-done)
				 ("C-j" . ivy-next-line)
				 ("C-k" . ivy-previous-line)
				 :map ivy-switch-buffer-map
				 ("C-k" . ivy-previous-line)
				 ("C-l" . ivy-done)
				 ("C-d" . ivy-switch-buffer-kill)
				 :map ivy-reverse-i-search-map
				 ("C-k" . ivy-previous-line)
				 ("C-d" . ivy-reverse-i-search-kill))
	:config
	(ivy-mode 1))

(use-package general
	:config
	(general-evil-setup t)
	(general-auto-unbind-keys))

(add-hook 'prog-mode-hook 'hs-minor-mode)

(use-package ivy-rich
	:after ivy
	:init
	(ivy-rich-mode 1))

(use-package counsel
	:diminish
	:bind (("C-M-j" . 'counsel-switch-buffer)
				 :map minibuffer-local-map
				 ("C-r" . 'counsel-minibuffer-history))
	:custom
	(counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
	:config
	(counsel-mode 1))

(use-package drag-stuff
	:init
	(drag-stuff-mode t))

; Evil mode (Vim keybindings)
; evil            -> Vim-like experience
; evil-collection -> Extra keys for evil
(use-package evil ; Vim keys
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
	(setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
	(setq evil-want-fine-undo 'fine)
  :config
  (evil-mode 1)
	(define-key evil-normal-state-map (kbd "C-f") nil)
  ; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

; Packages for prettiness
; doom-themes        -> Themes from Doom Emacs
; mixed-pitch        -> Allow Emacs to have different sized fonts
; rainbow-delimiters -> Match delimiters by colors

(use-package doom-themes)

(use-package mixed-pitch
	:hook
	(org-mode . mixed-pitch-mode)
	:config
  (set-face-attribute 'fixed-pitch nil :font user/font)
  (set-face-attribute 'variable-pitch nil :font user/font))

(use-package rainbow-delimiters
	:hook
	(prog-mode . rainbow-delimiters-mode))

; Org Mode
; org-mode -> Markup format, organize things, etc.

(use-package org)

; LSP Support
; lsp-mode -> LSP client for Emacs
; company  -> Completion
(use-package lsp-mode)
(use-package company)

; Extra language modes
; lua-mode -> Lua programming
(use-package lua-mode)

;; Keybindings

; Unbind conflicting/bad keybindings
(general-unbind
	"C-z"
	"C-j"
	"C-k")

(general-unbind 'motion
	"L" "H")

; Create a leader key definer for later use
(defconst user/leader-key "SPC")
(general-create-definer leader-def
	:states 'normal
	:prefix user/leader-key)

; Global keybindings
(general-define-key
	:states 'motion
	"H"   'switch-to-prev-buffer
	"L"   'switch-to-next-buffer
	"f"   'evil-close-fold
	"F"   'evil-open-fold
	"M-h" 'evil-window-left
	"M-j" 'evil-window-down
	"M-k" 'evil-window-up
	"M-l" 'evil-window-right
	"C-s" 'save-buffer)

(general-define-key
	"C-j" 'drag-stuff-down
	"C-k" 'drag-stuff-up)

(leader-def
	"e"   'counsel-switch-buffer
	"o"   'find-file
	"C-u" 'counsel-unicode-char
	"w"   'delete-trailing-whitespace
	"c"   'delete-window
	"C-c" 'evil-delete-buffer
	"C-l" 'split-window-horizontally
	"C-j" 'split-window-vertically)

;; Diminish modes

(diminish 'eldoc-mode)
(diminish 'evil-collection-unimpaired-mode)

;; Extra conf
;; Improve org mode looks
(setq org-startup-indented t
				org-pretty-entities t
				org-hide-emphasis-markers nil
				org-startup-with-inline-images t
				org-image-actual-width '(300))

; Custom (do not touch)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit outline-1 :extend nil :height 1.25))))
 '(org-level-2 ((t (:inherit outline-2 :extend nil :height 1.15))))
 '(org-level-3 ((t (:inherit outline-3 :extend nil :height 1.1)))))

