;;; init-git.el --- Init for git

;; Filename: init-git.el
;; Description: Init for git
;; Author: Andy Stewart <lazycat.manatee@gmail.com>
;; Maintainer: Andy Stewart <lazycat.manatee@gmail.com>
;; Copyright (C) 2014, Andy Stewart, all rights reserved.
;; Created: 2014-01-03 23:04:31
;; Version: 0.1
;; Last-Updated: 2014-01-03 23:04:31
;;           By: Andy Stewart
;; URL: http://www.emacswiki.org/emacs/download/init-git.el
;; Keywords:
;; Compatibility: GNU Emacs 24.3.50.1
;;
;; Features that might be required by this library:
;;
;;
;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Init for git
;;

;;; Installation:
;;
;; Put init-git.el to your load-path.
;; The load-path is usually ~/elisp/.
;; It's set in your ~/.emacs like this:
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;;
;; And the following to your ~/.emacs startup file.
;;
;; (require 'init-git)
;;
;; No need more.

;;; Customize:
;;
;;
;;
;; All of the above can customize by:
;;      M-x customize-group RET init-git RET
;;

;;; Change log:
;;
;; 2014/01/03
;;      * First released.
;;

;;; Acknowledgements:
;;
;;
;;

;;; TODO
;;
;;
;;

;;; Require


;;; Code:

(require 'magit)
(require 'magit-extension)

;; Magit configuration.
(setq magit-commit-ask-to-stage nil)    ;don't ask stage question

;; Make path column have enough space to display.
(setq magit-submodule-list-columns
      '(("Path"     80 magit-modulelist-column-path   nil)
        ("Version"  30 magit-repolist-column-version  nil)
        ("Branch"   20 magit-repolist-column-branch   nil)
        ("B<U" 3 magit-repolist-column-unpulled-from-upstream   ((:right-align t)))
        ("B>U" 3 magit-repolist-column-unpushed-to-upstream     ((:right-align t)))
        ("B<P" 3 magit-repolist-column-unpulled-from-pushremote ((:right-align t)))
        ("B>P" 3 magit-repolist-column-unpushed-to-pushremote   ((:right-align t)))
        ("B"   3 magit-repolist-column-branches                 ((:right-align t)))
        ("S"   3 magit-repolist-column-stashes                  ((:right-align t)))))

(defvar one-key-menu-magit-alist nil
  "The `one-key' menu alist for MAGIT.")

(setq one-key-menu-magit-alist
      '(
        (("s" . "Magit status") . magit-status)
        (("c" . "Magit commit") . magit-commit)
        (("u" . "Magit push") . magit-push-current-to-upstream)
        (("i" . "Magit pull") . magit-pull-from-upstream)
        (("l" . "Magit log") . magit-log-all)
        (("b" . "Magit buffer") . magit-process-buffer)
        (("m" . "Magit submodule add") . magit-submodule-add+)
        (("d" . "Magit submodule remove") . magit-submodule-remove)
        (("M" . "Magit submodule list") . magit-list-submodules)
        (("D" . "Magit discarded") . magit-discard)
        (("," . "Magit init") . magit-init)
        (("." . "Magit add remote") . magit-remote-add)
        (("h" . "Magithub menu") . one-key-menu-magithub)
        ))

(defun one-key-menu-magit ()
  "The `one-key' menu for MAGIT."
  (interactive)
  (one-key-menu "MAGIT" one-key-menu-magit-alist t))

(defvar one-key-menu-magithub-alist nil
  "The `one-key' menu alist for MAGITHUB.")

(setq one-key-menu-magithub-alist
      '(
        (("h" . "Browse") . magithub-browse)
        (("i" . "Create issue") . magithub-issue-new)
        (("b" . "Browse issue") . magithub-issue-browse)
        (("B" . "Browse pull") . magithub-pull-browse)
        ))

(defun one-key-menu-magithub ()
  "The `one-key' menu for MAGITHUB."
  (interactive)
  (require 'magithub)
  (one-key-menu "MAGITHUB" one-key-menu-magithub-alist t))

(defun magit-submodule-add+ (url)
  (interactive "sURL: ")
  (magit-submodule-add
   url
   (concat (file-name-as-directory lazycat-emacs-extension-dir) (file-name-base url))
   (file-name-base url)))

(provide 'init-git)

;;; init-git.el ends here
