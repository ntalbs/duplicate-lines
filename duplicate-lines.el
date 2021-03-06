;;; duplicate-lines.el --- Duplicate the current line or region

;; Copyright © 2018 Seongjun Yun
;; Author: Seongjun Yun
;; Keywords: convenience duplicate line region selection
;; URL: https://github.com/ntalbs/duplicate-lines
;; Version: 0.0.1

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;;; Commentary:
;; Provides a function that duplicates current line or region.
;; If the active region doesn't start at the beginning of the line or
;; doesn't end at the end of the line, it will be expanded.
;; After duplicate, it will keep the selection of duplicated region.
;; Basically, the behaviour should be similar to Eclipse or IntelliJ IDEA.

;;; Code:

(defun duplicate-lines-line-start-after-forward-line-p ()
  "Return 't if the position is beginning of line after foward-line."
  (forward-line)
  (= 0 (current-column)))

(defun duplicate-lines-select-current-line ()
  "Select current line."
  (let (start end)
    (beginning-of-line)
    (setq start (point))
    (unless (duplicate-lines-line-start-after-forward-line-p) (newline))
    (setq end (point))
    (setq deactivate-mark nil)
    (set-mark start)))

(defun duplicate-lines-expand-selection ()
  "Expand selection to contain while lines."
  (let ((start (region-beginning))
        (end   (region-end)))
    (goto-char start)
    (beginning-of-line)
    (setq start (point))
    (goto-char end)
    (unless (= 0 (current-column))
      (unless (duplicate-lines-line-start-after-forward-line-p)
        (newline)))
    (setq end (point))
    (setq deactivate-mark nil)
    (set-mark start)))

(defun duplicate-lines-at (p text n)
  "Duplicate TEXT N times at P."
  (dotimes (i (or n 1)) (insert text))
  (set-mark p)
  (setq deactivate-mark nil))

;;;###autoload
(defun duplicate-lines (n)
  "Duplicate line or region N times.
If it has active mark (P1, P2), it will expand the selection and duplicate it.
If it doesn't have active mark, it will select current line and duplicate it."
  (interactive "p")
  (if mark-active
      (duplicate-lines-expand-selection)
    (duplicate-lines-select-current-line))
  (let (start end len text)
    (setq start (region-beginning)
          end   (region-end)
          len   (- end start)
          text  (buffer-substring start end))
    (duplicate-lines-at end text n)
    (setq transient-mark-mode (cons 'only t))))

;;;###autoload
(defun duplicate-lines-default-binding ()
  "Default binding of `duplicate-lines`, M-s-<down>."
  (interactive)
  (global-set-key (kbd "M-s-<down>") 'duplicate-lines))

(provide 'duplicate-lines)
;;; duplicate-lines.el ends here
