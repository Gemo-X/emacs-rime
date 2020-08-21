(require 'package)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'dash)
  (package-install 'dash))

(require 'seq)
(require 'dash)

(require 'rime)

(rime-compile-module)

(setq default-input-method "rime"
      rime-show-candidate 'posframe)

(toggle-input-method)

(rime-lib-select-schema "terra_pinyin")

