BUILD_OPTIONS=-DCMAKE_BUILD_TYPE=Debug

PKG = rime
CC 	= gcc

ifeq '$(findstring ;,$(PATH))' ';'
    UNAME := Windows
else
    UNAME := $(shell uname 2>/dev/null || echo Unknown)
    UNAME := $(patsubst CYGWIN%,Cygwin,$(UNAME))
    UNAME := $(patsubst MSYS%,MSYS,$(UNAME))
    UNAME := $(patsubst MINGW%,MSYS,$(UNAME))
endif

ifndef EMACS_MAJOR_VERSION
	EMACS_MAJOR_VERSION = 26
endif

ifdef MODULE_FILE_SUFFIX
	SUFFIX = $(MODULE_FILE_SUFFIX)
else
	SUFFIX = .so
endif

ifeq ($(UNAME),MSYS)
	BUILD_OPTIONS+= -G "MSYS Makefiles"
endif

BUILD_OPTIONS += -DEMACS_MAJOR_VERSION=$(EMACS_MAJOR_VERSION)

# TODO
ifeq "$(TRAVIS)" "true"

build/librime-emacs.so:
	mkdir -p build
	cd build && cmake .. $(BUILD_OPTIONS) && make

else

TARGET = librime-emacs$(SUFFIX)

ELS  = $(PKG).el
ELCS = $(ELS:.el=.elc)

EMACS      ?= emacs
EMACS_ARGS ?=

LOAD_PATH  ?= -L . -L build

CLEAN  = $(ELCS) $(PKG)-autoloads.el build $(TARGET)

all: clean $(TARGET)

clean:
	@printf "Cleaning...\n"
	@rm -rf $(CLEAN)

loaddefs: $(PKG)-autoloads.el

module: build/$(TARGET)

build/$(TARGET):
	@printf "Building $<\n"
	@mkdir -p build
	@cd build && cmake .. $(BUILD_OPTIONS) && make

$(TARGET): build/$(TARGET)

lib: clean $(TARGET) loaddefs

define LOADDEFS_TMPL
;;; $(PKG)-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (directory-file-name \
(or (file-name-directory #$$) (car load-path))))

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; $(PKG)-autoloads.el ends here
endef
export LOADDEFS_TMPL
#'

$(PKG)-autoloads.el: $(ELS)
	@printf "Generating $@\n"
	@printf "%s" "$$LOADDEFS_TMPL" > $@
	@$(EMACS) -Q --batch --eval "(progn\
	(setq make-backup-files nil)\
	(setq vc-handled-backends nil)\
	(setq default-directory (file-truename default-directory))\
	(setq generated-autoload-file (expand-file-name \"$@\"))\
	(setq find-file-visit-truename t)\
	(update-directory-autoloads default-directory))"

endif

