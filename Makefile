# Copyright (C) 2010-2021 Daniel Baumann <daniel.baumann@progress-linux.org>
#
# SPDX-License-Identifier: MIT
#
# Permission to use, copy, modify, distribute, and sell this software and its
# documentation for any purpose is hereby granted without fee, provided that
# the above copyright notice appear in all copies and that both that
# copyright notice and this permission notice appear in supporting
# documentation, and that the name of the authors not be used in
# advertising or publicity pertaining to distribution of the software without
# specific, written prior permission.  The authors makes no representations
# about the suitability of this software for any purpose.  It is provided
# "as is" without express or implied warranty.
#
# THE AUTHORS DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO
# EVENT SHALL THE AUTHORS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
# DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

SHELL := sh -e

all: build

ast_dp501fw.h:
	@echo "# Getting sources"
	wget https://gitlab.freedesktop.org/xorg/driver/xf86-video-ast/raw/master/src/ast_dp501fw.h -O ast_dp501fw.h || \
	curl https://gitlab.freedesktop.org/xorg/driver/xf86-video-ast/raw/master/src/ast_dp501fw.h -o ast_dp501fw.h

ast_dp501_fw.bin: ast_dp501fw.h
	@echo "# Creating firmware"
	grep ^0x ast_dp501fw.h  | sed -e 's|,};$$|,|' | xxd -r -p - ast_dp501_fw.bin

build: ast_dp501_fw.bin

install: build
	@echo "# Installing firmware"
	mkdir -p $(DESTDIR)/lib/firmware
	cp *.bin $(DESTDIR)/lib/firmware

uninstall:
	@echo "# Uninstalling firmware"
	for FILE in *.bin; do rm -f $(DESTDIR)/lib/firmware/$${FILE}; done
	rmdir --ignore-fail-on-non-empty --parents $(DESTDIR)/lib/firmware > /dev/null 2>&1 || true

reinstall: clean uninstall install

clean:
	@echo "# Removing firmware"
	rm -f *.bin

distclean: clean
	@echo "# Removing sources"
	rm -f *.h
