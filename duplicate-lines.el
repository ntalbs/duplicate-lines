;;; duplicate-lines.el --- Duplicate current line & selection

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

(defun duplicate-lines-line-start-p ()
  "Return 't if current position is beginning of line."
  (= 0 (current-column)))

(defun duplicate-lines-line-start-after-forward-line-p ()
  "Return 't if the position is beginning of line after foward-line."
  (forward-line)
  (duplicate-lines-line-start-p))

(defun duplicate-lines-expand-selection (p1 p2)
  "Expand selection to contain while lines.
Expand P1 to beginning of line and P2 to end of line (or more precisely)
the beginning of next line."
  (let (start end)
    (cond (mark-active
           (goto-char p1)
           (beginning-of-line)
           (setq start (point))
           (goto-char p2)
           (unless (= 0 (current-column))
             (unless (duplicate-lines-line-start-after-forward-line-p)
               (newline)))
           (setq end (point)))
          (t
           (beginning-of-line)
           (setq start (point))
           (unless (duplicate-lines-line-start-after-forward-line-p) (newline))
           (setq end (point))))
    (setq deactivate-mark nil)
    (goto-char end)
    (set-mark start)))

;;;###autoload
(defun duplicate-lines (p1 p2)
  "Duplicate line or region.
If it has active mark (P1, P2), it will expand the selection and duplicate it.
If it doesn't have active mark, it will select current line and duplicate it."
  (interactive "r")
  (let (start end len text)
    (duplicate-lines-expand-selection p1 p2)
    (setq start (region-beginning)
          end   (region-end)
          len   (- end start)
          text  (buffer-substring start end))
    (insert text)
    (set-mark (- (point) len))
    (setq deactivate-mark nil)
    (setq transient-mark-mode (cons 'only t))))

;;;###autoload
(defun duplicate-lines-default-binding ()
  "Default binding of `duplicate-lines`, M-s-<down>."
  (interactive)
  (global-set-key (kbd "M-s-<down>") 'duplicate-region))

(provide 'duplicate-lines)
;;; duplicate-lines.el ends here
