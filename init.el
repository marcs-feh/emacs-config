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
(set-face-attribute 'default nil
	:font "JetBrains Mono Light"
	:height 118)

; Load theme
(load-theme 'wombat t)

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
