;;; duplicate-lines.el --- Duplicate current line & selection

;; Copyright © 2018 Seongjun Yun
;; Author: Seongjun Yun
;; URL: https://github.com/ntalbs/duplicate-lines
;; Version: 0.0.1

(defun line-start-p (p)
    (goto-char p)
    (= 0 (current-column)))

(defun expand-selection (p1 p2)
  (let (start end)
    (cond (mark-active
           (goto-char p1)
           (beginning-of-line)
           (setq start (point))
           (goto-char p2)
           (unless (= 0 (current-column)) (unless (= 0 (forward-line)) (newline)))
           (setq end (point)))
          (t
           (beginning-of-line)
           (setq start (point))
           (unless (= 0 (forward-line)) (newline))
           (setq end (point))))
    (setq deactivate-mark nil)
    (goto-char end)
    (set-mark start)))

(defun move-to-yank-pos (p)
  (goto-char p)
  (unless (line-start-p p)
    (unless (= 0 (forward-line))
      (newline))))

(defun duplicate-region (p1 p2)
  (interactive "r")
  (let (start end len text)
    (expand-selection p1 p2)
    (setq start (region-beginning)
          end   (region-end)
          len   (- end start)
          text  (buffer-substring start end))
    (move-to-yank-pos end)
    (insert text)
    (set-mark (- (point) len))
    (setq deactivate-mark nil)
    (setq transient-mark-mode (cons 'only t))))

(defun duplicate-region-default-binding ()
  (interactive)
  (global-set-key (kbd "s-<down>") 'duplicate-region))

(provide 'duplicate-lines)

;;; duplicate-block.el ends here
