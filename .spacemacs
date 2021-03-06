;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     sql
     python
     elixir
     html
     clojure
     emoji
     typescript
     nginx
     docker
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     csv
     helm
     ;; auto-completion
     ;; better-defaults
     emacs-lisp
     elm
     git
     github
     ;; ivy
     javascript
     (keyboard-layout :variables
                      kl-layout 'dvp)
                      ;; kl-layout 'dvorak)
     markdown
     ;; multiple-cursors
     neotree
     org
     osx
     ruby
     yaml
     shell-scripts
     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages
   '(
     prettier-js
     rjsx-mode
     company-flow
     graphql-mode
     )

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(
                                    wolfram-mode
                                    ebuild-mode
                                    )
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; JUAN'S CUSTOMIZATIONS
   ;; exec-path-from-shell-check-startup-files nil
   indent-tabs-mode nil
   ;; js2-mode
   js2-basic-offset 2
   js-indent-level 2
   typescript-indent-level 2
   ;; web-mode
   css-indent-offset 2
   web-mode-markup-indent-offset 2
   web-mode-css-indent-offset 2
   web-mode-less-indent-offset 2
   web-mode-code-indent-offset 2
   web-mode-attr-indent-offset 2
   ;; elm
   elm-sort-imports-on-save t
   elm-format-on-save t

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default nil)
   dotspacemacs-verify-spacelpa-archives nil

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(
                         monokai
                         spacemacs-dark
                         spacemacs-light
                         )
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '(
                               ;; "Inter"
                               "Office Code Pro"
                               ;; "Source Sans Pro"
                               :size 12
                               ;; :size 16
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; failing tests
   dotspacemacs-mode-line-theme 'spacemacs

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  ;; Emoji support https://github.com/syl20bnr/spacemacs/issues/6654#issuecomment-236733588
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend)

  (setq-default
   require-final-newline t
   magit-commit-show-diff nil)
  (add-hook
   'before-save-hook
   'delete-trailing-whitespace)

  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  ;; dummy silence definition
  (add-hook 'change-major-mode-after-body-hook 'fci-mode)
  (add-hook 'coffee-mode-hook 'company-mode)
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (add-hook 'markdown-mode-hook 'auto-fill-mode)
  ;; jsx
  ;; (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("\\.mdx?\\'" . markdown-mode))
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (remove-hook 'scss-mode-hook 'flycheck-mode)
  (add-hook 'typescript-mode-hook 'prettier-js-mode)
  (add-hook 'typescript-tsx-mode-hook 'prettier-js-mode)
  (add-hook 'rjsx-mode 'yas-minor-mode)
  (setq prettier-js-args '(
                           "--single-quote"
                           "--trailing-comma" "es5"
                           "--no-semi"
                           "--write"
                           ))

  (add-to-list 'safe-local-variable-values
               '(prettier-js-args
                 .
                 '(
                   "--single-quote"
                   "--no-semi"
                   "--write"
                   )
                 ))

  (setq-default evil-escape-key-sequence "uu")

  (defun nothing () ())
  (define-key evil-normal-state-map (kbd "<down-mouse-1>") 'nothing)
  (define-key evil-normal-state-map (kbd "C-SPC") 'nothing)
  (define-key evil-normal-state-map (kbd "<drag-mouse-1>") 'nothing)
  (define-key evil-normal-state-map (kbd "<C-down-mouse-1>") 'nothing)
  (define-key evil-normal-state-map (kbd "<M-down-mouse-1>") 'nothing)
  (define-key evil-normal-state-map (kbd "<mouse-2>") 'nothing)
  (define-key evil-normal-state-map (kbd "<M-drag-mouse-1>") 'nothing)
  (define-key evil-normal-state-map (kbd "<M-mouse-1>") 'nothing)
  (define-key evil-normal-state-map (kbd "<M-mouse-2>") 'nothing)
  (define-key evil-normal-state-map (kbd "<M-mouse-3>") 'nothing)
  (define-key evil-normal-state-map (kbd "<S-mouse-1>") 'nothing)
  (define-key evil-normal-state-map (kbd "<S-mouse-2>") 'nothing)
  (define-key evil-normal-state-map (kbd "<S-mouse-3>") 'nothing)
  (define-key evil-normal-state-map (kbd "<mouse-3>") 'nothing)
  (dolist (mouse '("<down-mouse-1>" "<mouse-1>"))
    (global-unset-key (kbd mouse)))

  ;; (defun silence ()
  ;;   (interactive))
  ;; ;; don't jump the cursor around in the window on clicking
  ;; (define-key evil-motion-state-map [down-mouse-1] 'silence)
  ;; ;; also avoid any '<mouse-1> is undefined' when setting to 'undefined
  ;; (define-key evil-motion-state-map [mouse-1] 'silence)

  ;; vim noh as ctrl
  (define-key evil-normal-state-map (kbd "<escape>") 'evil-search-highlight-persist-remove-all)

  ;; custom commands
  (evil-define-key 'normal org-mode-map (kbd "m") 'org-todo)
  (evil-define-key 'normal org-mode-map (kbd "d") 'evil-backward-char)

  ;; ;; magit
  (evil-define-key 'normal magit-mode-map (kbd "d") 'evil-backward-char)
  (evil-define-key 'normal magit-mode-map (kbd "h") 'evil-next-line)
  (evil-define-key 'normal magit-mode-map (kbd "t") 'evil-previous-line)
  (evil-define-key 'normal magit-mode-map (kbd "n") 'evil-forward-char)

  (defun insert-console-log ()
    "Insert console.log of the variable at point."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "console.log(\"%s\", %s)"
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-console-error ()
    "Insert console.error of the variable at point."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "console.error(\"%s\", %s)"
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-property-setter ()
    "Insert `this.<property> = property` for use inside of a class constructor."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "this.%s = %s"
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-log-cljs ()
    "Insert clojurescript equivalent of console logging."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "(js/console.log \"%s\" (clj->js %s))"
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-let-log-clj ()
    "Insert clojure equivalent of console logging, when inside a let statement."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "_ (println \"%s\" %s)"
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-log-clj ()
    "Insert clojure equivalent of console logging."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "(println \"%s\" %s)"
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-log-python ()
    "Insert python equivalent of console logging."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "print('%s', ( %s ))"
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-log-elixir ()
    "Insert elixir equivalent of console logging."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "IO.inspect %s, label: \"\\n%s\""
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-snag-clj ()
    "Insert statement to capture variable for repl."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (insert (format "(def %s %s)"
                      (car kill-ring)
                      (car kill-ring)))))

  (defun insert-ticket-header ()
    "Insert a heading with the ticket name and a place for the ticket link."
    (interactive)
    (let ((beg nil)
          (end nil))
      (back-to-indentation)
      (setq beg (point))
      (end-of-line)
      (setq end (point))
      (kill-region beg end)
      (let* ((ticket-link (replace-regexp-in-string "\n"
                                                    ""
                                                    (car kill-ring)))
             (ticket-number (replace-regexp-in-string "https://artifactteam.atlassian.net/browse/"
                                                      ""
                                                      ticket-link)))
        (insert (format "* %s\n** Ticket\n%s"
                        ticket-number
                        ticket-link)))))

  ;; Copy file name with line numbers
  (defun copy-file-name-with-lines ()
    "Copy the path to the current file, including line numbers if
they are in visual mode."
    (interactive)
    (let* ((directory-abbrev-alist '(("/Users/juan" . "~")
                                     ("~/code/td/circleci/" . "")
                                     ("~/code/td/" . "")
                                     ("~/code/personal/" . "")
                                     ))
           (file-name (abbreviate-file-name buffer-file-name)))
      (if (use-region-p)
          (let* (
                 (start (min (region-beginning) (region-end)))
                 (end (max (region-beginning) (region-end)))
                 (start-line (line-number-at-pos start))
                 (end-line (when end (line-number-at-pos end))))
            (kill-new (format "%s#L%d-L%d"
                              file-name
                              start-line
                              end-line)))
        (kill-new file-name)
        (evil-exit-visual-state 't))))
  (spacemacs/set-leader-keys "fY" 'copy-file-name-with-lines)

  ;; Dvorak window movement
  (spacemacs/set-leader-keys "ww" 'ace-window)
  (spacemacs/set-leader-keys "wd" 'evil-window-left)
  (spacemacs/set-leader-keys "wn" 'evil-window-right)
  (spacemacs/set-leader-keys "wh" 'evil-window-down)
  (spacemacs/set-leader-keys "wt" 'evil-window-up)
  (spacemacs/set-leader-keys "wx" 'spacemacs/delete-window)

  ;; better logging functions
  (spacemacs/set-leader-keys-for-major-mode 'rjsx-mode "l" 'insert-console-log)
  (spacemacs/set-leader-keys-for-major-mode 'rjsx-mode "e" 'insert-console-error)
  (spacemacs/set-leader-keys-for-major-mode 'rjsx-mode "p" 'insert-property-setter)
  (spacemacs/set-leader-keys-for-major-mode 'clojurescript-mode "l" 'insert-log-cljs)
  (spacemacs/set-leader-keys-for-major-mode 'clojure-mode "l" 'insert-log-clj)
  (spacemacs/set-leader-keys-for-major-mode 'clojure-mode "L" 'insert-let-log-clj)
  (spacemacs/set-leader-keys-for-major-mode 'clojure-mode "R" 'insert-snag-clj)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode "l" 'insert-ticket-header)
  (spacemacs/set-leader-keys-for-major-mode 'typescript-mode "l" 'insert-console-log)
  (spacemacs/set-leader-keys-for-major-mode 'typescript-tsx-mode "l" 'insert-console-log)
  (spacemacs/set-leader-keys-for-major-mode 'elixir-mode "l" 'insert-log-elixir)
  (spacemacs/set-leader-keys-for-major-mode 'python-mode "l" 'insert-log-python)

  ;; neotree collapse
  (spacemacs/set-leader-keys-for-major-mode 'neotree-mode "RET" 'spacemacs/neotree-collapse)

  ;; treemacs
  (evil-define-key 'normal treemacs-mode-map (kbd "d") 'evil-backward-char)
  (evil-define-key 'normal treemacs-mode-map (kbd "h") 'evil-next-line)
  (evil-define-key 'normal treemacs-mode-map (kbd "t") 'treemacs-next-line)
  (evil-define-key 'normal treemacs-mode-map (kbd "n") 'evil-forward-char)
  (evil-define-key 'normal treemacs-mode-map (kbd "j") 'evil-forward-char)

  ;; Load node path
  (load-file "~/add-node-modules-path/add-node-modules-path.el")
  (eval-after-load 'rjsx-mode
    '(add-hook 'rjsx-mode-hook #'add-node-modules-path))
  (eval-after-load 'typescript-mode
    '(add-hook 'typescript-mode-hook #'add-node-modules-path))

  (setq magit-display-buffer-function
        (lambda (buffer)
          (display-buffer
           buffer (if (and (derived-mode-p 'magit-mode)
                           (memq (with-current-buffer buffer major-mode)
                                 '(magit-process-mode
                                   magit-revision-mode
                                   magit-diff-mode
                                   magit-stash-mode
                                   magit-status-mode)))
                      nil
                    '(display-buffer-same-window)))))
  (setq js2-strict-missing-semi-warning nil)
  ;; (setq neo-force-change-root t)
  (setq-default dotspacemacs-layers
                '((spell-checking :variables
                                  spell-checking-enable-by-default nil)))

  ;; add support for experimental flow
  ;; (load-file "~/.config/spacemacs/flow.el")
  ;; (init-flowjs)
  ;; (setq flow_binary "yarn flow")
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (vimrc-mode helm-gtags ggtags dactyl-mode counsel-gtags evil-nerd-commenter yapfify yaml-mode ws-butler winum which-key wgrep web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package unfill toc-org tide typescript-mode tagedit spaceline powerline smex smeargle slim-mode slack emojify circe oauth2 websocket scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rjsx-mode reveal-in-osx-finder restart-emacs rbenv rake rainbow-delimiters pyvenv pytest pyenv-mode py-isort pug-mode prettier-js popwin pip-requirements phpunit phpcbf php-extras php-auto-yasnippets persp-mode pcre2el pbcopy paradox ox-gfm osx-trash osx-dictionary orgit org-projectile org-category-capture org-present org-pomodoro org-plus-contrib org-mime org-download org-bullets open-junk-file nginx-mode neotree mwim move-text mmm-mode minitest markdown-toc markdown-mode magit-gitflow magit-gh-pulls macrostep lorem-ipsum livid-mode skewer-mode simple-httpd live-py-mode linum-relative link-hint less-css-mode launchctl js2-refactor js2-mode js-doc ivy-hydra insert-shebang indent-guide ibuffer-projectile hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-gitignore request helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag haml-mode graphql-mode google-translate golden-ratio gnuplot gitignore-mode github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gist gh marshal logito pcache ht gh-md fuzzy flyspell-correct-ivy flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck-elm flycheck flx-ido flx fish-mode fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-mc evil-matchit evil-magit magit git-commit ghub let-alist with-editor evil-lispy lispy zoutline evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-commentary evil-args evil-anzu anzu evil goto-chg undo-tree emoji-cheat-sheet-plus emmet-mode elm-mode elisp-slime-nav dumb-jump drupal-mode php-mode dockerfile-mode docker json-mode tablist magit-popup docker-tramp json-snatcher json-reformat diminish diff-hl cython-mode csv-mode counsel-projectile projectile counsel swiper ivy company-web web-completion-data company-tern dash-functional tern company-statistics company-shell company-flow company-emoji company-anaconda company command-log-mode column-enforce-mode coffee-mode clojure-snippets clj-refactor hydra inflections edn multiple-cursors paredit peg clean-aindent-mode cider-eval-sexp-fu eval-sexp-fu highlight cider seq spinner queue pkg-info clojure-mode epl chruby bundler inf-ruby bind-map bind-key auto-yasnippet yasnippet auto-highlight-symbol auto-dictionary auto-compile packed anaconda-mode pythonic f dash s alert log4e gntp aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core async ac-ispell auto-complete popup monokai-theme)))
 '(safe-local-variable-values
   (quote
    ((prettier-js-args "--no-semi" "--trailing-comma" "es5" "--print-width" "120" "--write")
     (prettier-js-args "--no-semi" "--trailing-comma" "es5" "--single-quote" "--write")
     (prettier-js-args "--no-semi" "--trailing-comma" "es5" "--single-quote" "--print-width" "120" "--write")
     (prettier-js-args "--single-quote" "--no-semi" "--write")
     (prettier-js-args quote
                       ("--single-quote" "--no-semi" "--write"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 257)) (:foreground "#F8F8F2" :background "#272822")) (((class color) (min-colors 89)) (:foreground "#F5F5F5" :background "#1B1E1C")))))
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil-nerd-commenter yapfify yaml-mode ws-butler winum which-key wgrep web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package unfill toc-org tide typescript-mode tagedit spaceline powerline smex smeargle slim-mode slack emojify circe oauth2 websocket scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rjsx-mode reveal-in-osx-finder restart-emacs rbenv rake rainbow-delimiters pyvenv pytest pyenv-mode py-isort pug-mode prettier-js popwin pip-requirements phpunit phpcbf php-extras php-auto-yasnippets persp-mode pcre2el pbcopy paradox ox-gfm osx-trash osx-dictionary orgit org-projectile org-category-capture org-present org-pomodoro org-plus-contrib org-mime org-download org-bullets open-junk-file nginx-mode neotree mwim move-text mmm-mode minitest markdown-toc markdown-mode magit-gitflow magit-gh-pulls macrostep lorem-ipsum livid-mode skewer-mode simple-httpd live-py-mode linum-relative link-hint less-css-mode launchctl js2-refactor js2-mode js-doc ivy-hydra insert-shebang indent-guide ibuffer-projectile hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-gitignore request helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag haml-mode graphql-mode google-translate golden-ratio gnuplot gitignore-mode github-search github-clone github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gist gh marshal logito pcache ht gh-md fuzzy flyspell-correct-ivy flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck-elm flycheck flx-ido flx fish-mode fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-mc evil-matchit evil-magit magit git-commit ghub let-alist with-editor evil-lispy lispy zoutline evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-commentary evil-args evil-anzu anzu evil goto-chg undo-tree emoji-cheat-sheet-plus emmet-mode elm-mode elisp-slime-nav dumb-jump drupal-mode php-mode dockerfile-mode docker json-mode tablist magit-popup docker-tramp json-snatcher json-reformat diminish diff-hl cython-mode csv-mode counsel-projectile projectile counsel swiper ivy company-web web-completion-data company-tern dash-functional tern company-statistics company-shell company-flow company-emoji company-anaconda company command-log-mode column-enforce-mode coffee-mode clojure-snippets clj-refactor hydra inflections edn multiple-cursors paredit peg clean-aindent-mode cider-eval-sexp-fu eval-sexp-fu highlight cider seq spinner queue pkg-info clojure-mode epl chruby bundler inf-ruby bind-map bind-key auto-yasnippet yasnippet auto-highlight-symbol auto-dictionary auto-compile packed anaconda-mode pythonic f dash s alert log4e gntp aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core async ac-ispell auto-complete popup monokai-theme)))
 '(safe-local-variable-values
   (quote
    ((prettier-js-args "--single-quote" "--no-semi" "--write")
     (prettier-js-args quote
                       ("--single-quote" "--no-semi" "--write"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 257)) (:foreground "#F8F8F2" :background "#272822")) (((class color) (min-colors 89)) (:foreground "#F5F5F5" :background "#1B1E1C")))))
