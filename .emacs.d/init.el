;; ターミナル以外でEmacsを立ち上げてもpathが通るようにする
(defun set-exec-path-from-shell-PATH ()
    "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
    (interactive)
    (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
      (setenv "PATH" path-from-shell)
      (setq exec-path (split-string path-from-shell path-separator))))
(set-exec-path-from-shell-PATH)

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;;;;;;;;;;;;;;;;;;;;;;el-get;;;;;;;;;;;;;;;;;;;;;;

;; php-mode
(el-get-bundle php-mode)

;; auto-complete
(el-get-bundle auto-complete)

(el-get-bundle ac-php)

(el-get-bundle helm-gtags)

(el-get-bundle flycheck)

;; tree-undo
(el-get-bundle undo-tree)

(el-get-bundle josteink/csharp-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                 setting                  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; C-hをdeleteに
(global-set-key "\C-h" 'delete-backward-char)

; バックアップファイルを作らない
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq next-line-add-newlines nil)

; スタート画面を非表示
(setq inhibit-startup-screen t)

; GUIのバーを非表示
(tool-bar-mode 0)
(menu-bar-mode -1)

; タイトルパーにファイルのフルパスを表示する
(setq frame-title-format "%f")

;; タブ文字ではなくスペースを使う
(setq-default indent-tabs-mode nil)

;; タブ幅をスペース4つ分にする
(setq-default tab-width 4)

; 空白文字を強制表示
(require 'whitespace)
(global-whitespace-mode 1)
(setq whitespace-style '(face
                         trailing
                         tabs
                         spaces
                         empty
                         space-mark
                         tab-mark
                         ))
(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
(setq whitespace-space-regexp "\\(\u3000+\\)")

;; フレーム(ウィンドウ)の透明度を設定する
(set-frame-parameter (selected-frame) 'alpha '(0.90))

;; カーソルのある行をハイライトする
(global-hl-line-mode t)

; 行列数を表示
(line-number-mode t)
(global-linum-mode t)
(column-number-mode t)

; 対応する括弧を光らせる
(show-paren-mode t)

; スクロールは1行ずつ
(setq scroll-step 1)

(global-undo-tree-mode t) ; デフォルトをundo-treeのundoにする
;; C-M-z でredoを行えるようにする
(define-key global-map (kbd "C-M-z") 'undo-tree-redo)

; タグジャンプ設定
(add-to-list 'load-path "/usr/local/share/gtags")
(add-hook 'helm-gtags-mode-hook
      '(lambda ()
         ;;入力されたタグの定義元へジャンプ
         (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
         ;;入力タグを参照する場所へジャンプ
         (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
         ;;入力したシンボルを参照する場所へジャンプ
         (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
         ;;タグ一覧からタグを選択し, その定義元にジャンプする
         (local-set-key (kbd "M-l") 'helm-gtags-select)
         ;;ジャンプ前の場所に戻る
         (local-set-key (kbd "C-t") 'helm-gtags-pop-stack)))
(add-hook 'php-mode-hook 'helm-gtags-mode)

; 関数名補完設定
(add-hook 'php-mode-hook '(lambda ()
                           (auto-complete-mode t)
                           (require 'ac-php)
                           (setq ac-sources  '(ac-source-php ) )
                           (yas-global-mode 1)

                           (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
                           (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back   ) ;go back
                           ))

; 構文エラーチェック設定
(add-hook 'after-init-hook #'global-flycheck-mode)

;; UndoをC-zにする
(define-key global-map (kbd "C-z") 'undo)




(global-undo-tree-mode t) ; デフォルトをundo-treeのundoにする
;; C-M-z でredoを行えるようにする
(define-key global-map (kbd "C-M-z") 'undo-tree-redo)

