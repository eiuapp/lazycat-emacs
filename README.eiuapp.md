在 emacs 下使用 lazycat-emacs 的配置

## git merge

当 manateelazycat/lazycat-emacs 有更新时，merge新代码

```
git checkout master
git pull origin master
git checkout eiuapp
git pull origin eiuapp
git merge master
git submodule init
git submodule update --remote
```

 
## git diff

### 放入 eiuapp 分支的修改代码 ###

这部分已经在 eiuapp 中, 当再次更新或merge master 分支时,不需要改动.


```
Head:     eiuapp upgrade lazy-load.
Tag:      3.0 (831)

Untracked files (1)
README.eiuapp.md

Unstaged changes (6)
modified   site-lisp/config/init-sdcv.el
@@ -90,22 +90,22 @@
 
 (setq sdcv-say-word-p t)	     ;say word after search
 (setq sdcv-dictionary-simple-list    ;星际译王屏幕取词词典, 简单, 快速
-      '("懒虫简明英汉词典"
-        "懒虫简明汉英词典"
-        "KDic11万英汉词典"))
+      '("lazyworm-ec"
+        "lazyworm-ce"
+        "kdic-ec-11w"))
 (setq sdcv-dictionary-complete-list     ;星际译王的词典, 完全, 详细
       '(
-        "懒虫简明英汉词典"
+        "lazyworm-ec"      ;;  "懒虫简明英汉词典"
         "英汉汉英专业词典"
         "XDICT英汉辞典"
         "stardict1.3英汉辞典"
         "WordNet"
         "XDICT汉英辞典"
         "Jargon"
-        "懒虫简明汉英词典"
+        "lazyworm-ce"      ;;  "懒虫简明汉英词典"
         "FOLDOC"
         "新世纪英汉科技大词典"
-        "KDic11万英汉词典"
+        "kdic-ec-11w"      ;;  "KDic11万英汉词典"
         "朗道汉英字典5.0"
         "CDICT5英汉辞典"
         "新世纪汉英科技大词典"
modified   site-lisp/extensions/lazycat-theme
@@ -1 +1 @@
-Subproject commit 6d59ca1e01d450beae6603dd786f8e7bd4087826
+Subproject commit 6d59ca1e01d450beae6603dd786f8e7bd4087826-dirty
modified   site-lisp/extensions/sdcv
@@ -1 +1 @@
-Subproject commit 87eca55bdfc7c361b2831375144ad9d3d4af1d6f
+Subproject commit 87eca55bdfc7c361b2831375144ad9d3d4af1d6f-dirty
modified   site-lisp/sdcv-dict/stardict-kdic-ec-11w-2.4.2/kdic-ec-11w.ifo
@@ -2,7 +2,7 @@ StarDict's dict ifo file
 version=2.4.2
 wordcount=112344
 idxfilesize=2105186
-bookname=KDic11万英汉词典
+bookname=kdic-ec-11w
 description=胡正制作。
 date=2006.5.17
 sametypesequence=m
modified   site-lisp/sdcv-dict/stardict-lazyworm-ce-2.4.2/lazyworm-ce.ifo
@@ -2,7 +2,7 @@ StarDict's dict ifo file
 version=2.4.2
 wordcount=119592
 idxfilesize=2269830
-bookname=懒虫简明汉英词典
+bookname=lazyworm-ce
 author=懒虫
 description=胡正制作。
 date=2006.5.17
modified   site-lisp/sdcv-dict/stardict-lazyworm-ec-2.4.2/lazyworm-ec.ifo
@@ -2,7 +2,7 @@ StarDict's dict ifo file
 version=2.4.2
 wordcount=452185
 idxfilesize=10106758
-bookname=懒虫简明英汉词典
+bookname=lazyworm-ec
 author=懒虫
 description=胡正制作。
 date=2006.5.17

Recent commits
2599333 eiuapp master origin/master upgrade lazy-load.
14693bc Add lazy-load submodule.
6722307 Refacotry code.
005fe1a upgrade awesome-tab.
a6ead1b upgrade aweshell.
cf731c2 Binding C-M-SPC with mark-sexp.
b0c8b2a upgrade.
7f98157 upgrade aweshell.
d80a9e9 upgrade awesome-tray.
cc26f48 upgrade aweshell.
```


### git submodule 要修改的部分 ###

要让emacs启动, 其中 lazycat-theme 与 sdcv 部分 要修改

```
modified   site-lisp/extensions/lazycat-theme
@@ -1 +1 @@
-Subproject commit 6d59ca1e01d450beae6603dd786f8e7bd4087826
+Subproject commit 6d59ca1e01d450beae6603dd786f8e7bd4087826-dirty
modified   site-lisp/extensions/sdcv
@@ -1 +1 @@
-Subproject commit 87eca55bdfc7c361b2831375144ad9d3d4af1d6f
+Subproject commit 87eca55bdfc7c361b2831375144ad9d3d4af1d6f-dirty
```

具体如下：

- ~/lazycat-emacs/site-lisp/extensions/sdcv/sdcv.el

```bash
v@DESKTOP-APB1HCJ:~/lazycat-emacs/site-lisp/extensions/sdcv$ git diff
diff --git a/sdcv.el b/sdcv.el
index 67e538e..95029db 100755
--- a/sdcv.el
+++ b/sdcv.el
@@ -578,12 +578,22 @@ Argument DICTIONARY-LIST the word that need transform."
       )))

 (defun sdcv-translate-result (word dictionary-list)
+;;(message "sdcv-translate-result word is %s" word)
+;;(message "sdcv-translate-result dictionary-list is %s" dictionary-list)
+;;(message (format "LANG=en_US.UTF-8 %s -n %s %s --data-dir=%s"
+;;            sdcv-program
+;;            (mapconcat (lambda (dict)
+;;                         (concat "-u \"" dict "\""))
+;;                       dictionary-list " ")
+;;            word
+;;            sdcv-dictionary-data-dir))
   "Call sdcv to search word in dictionary list, return filtered
 string of results."
   (sdcv-filter
    (shell-command-to-string
     ;; Set LANG environment variable, make sure `shell-command-to-string' can handle CJK character correctly.
-    (format "LANG=en_US.UTF-8 %s -x -n %s %s --data-dir=%s"
+    ;; (format "LANG=en_US.UTF-8 %s -x -n %s %s --data-dir=%s"
+    (format "LANG=en_US.UTF-8 %s -n %s %s --data-dir=%s"
             sdcv-program
             (mapconcat (lambda (dict)
                          (concat "-u \"" dict "\""))
@@ -594,6 +604,7 @@ string of results."
 (defun sdcv-filter (sdcv-string)
   "This function is for filter sdcv output string,.
 Argument SDCV-STRING the search string from sdcv."
+;;(message "sdcv-filter sdcv-string is %s" sdcv-string)
   (setq sdcv-string (replace-regexp-in-string sdcv-filter-string "" sdcv-string))
   (if (equal sdcv-string "")
       sdcv-fail-notify-string
v@DESKTOP-APB1HCJ:~/lazycat-emacs/site-lisp/extensions/sdcv$
```

- ~/lazycat-emacs/site-lisp/extensions/lazycat-theme/lazycat-theme.el

```bash
v@DESKTOP-APB1HCJ:~/lazycat-emacs/site-lisp/extensions/lazycat-theme$ git diff
diff --git a/lazycat-theme.el b/lazycat-theme.el
index ab2f31f..2eccea1 100755
--- a/lazycat-theme.el
+++ b/lazycat-theme.el
@@ -7,7 +7,7 @@
  ((featurep 'cocoa)
   (setq emacs-font-name "Monaco"))
  ((string-equal system-type "gnu/linux")
-  (setq emacs-font-name "Droid Sans Mono")))
+  (setq emacs-font-name "Source Code Pro")))
 (if (display-grayscale-p)
     (progn
       (set-frame-font (format "%s-%s" (eval emacs-font-name) (eval emacs-font-size)))
v@DESKTOP-APB1HCJ:~/lazycat-emacs/site-lisp/extensions/lazycat-theme$
```


