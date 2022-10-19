;; UI Options

; Disable startup message, scrollbar, toolbar, menu bar and visual bell for a
; cleaner UI. Also use smaller tab width
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq visible-bell nil)
(setq-default tab-width 2)

; Show line and column numbers. Add fringes to the sides of the screen
(global-display-line-numbers-mode)
(column-number-mode)
(fringe-mode '(16 . 24))

; Allow Emacs' window to be any size and not snap to characters
(setq frame-resize-pixelwise t)

; Set the default font
(setq user/font "JetBrains Mono Light")
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

;; Package Manager

; Set package sources
(require 'package)
(setq package-archives
	'(("melpa" . "https://melpa.org/packages/")
		("org"   . "https://orgmode.org/elpa/")
		("elpa"  . "https://elpa.gnu.org/packages")))

; Initialize package management
(package-initialize)
(unless package-archive-contents
	(package-refresh-contents))

; Require use-package for better management
(unless (package-installed-p 'use-package)
	(package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Packages

; Basic utility packages.
; diminish   -> Unclutter statusbar
; swiper     -> Fuzzy finder
; ivy        -> Completion framework
; ivy-rich   -> Extra ivy functionality
; counsel    -> Better commands (works with ivy)
; drag-stuff -> Move text up and down
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

; Packages for prettiness
; doom-themes -> Themes from Doom Emacs
; mixed-pitch -> Allow Emacs to have different sized fonts
(use-package doom-themes)
(use-package mixed-pitch
	:hook
	(org-mode . mixed-pitch-mode)
	:config
  (set-face-attribute 'fixed-pitch nil :font user/font)
  (set-face-attribute 'variable-pitch nil :font user/font))

; Evil mode (Vim keybindings)
; evil            -> Vim-like experience
; evil-collection -> Extra keys for evil
(use-package evil ; Vim keys
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
	(setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
	(define-key evil-normal-state-map (kbd "C-f") nil)
  ; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

; Custom (do not touch)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
