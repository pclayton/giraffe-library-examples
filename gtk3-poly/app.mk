################################################################################
# Application-specific values

NAME := gtk3-poly


# Poly/ML target
#
# Define:
#   SRC_POLYML      - the SML source files for Poly/ML
#   TARGET_POLYML   - the binary to be built with Poly/ML

ifdef POLYML_VERSION

SRC_POLYML := $(shell cat polyml-app.sml | sed -n 's|^use "\([^"]*\)";$$|\1|p')

TARGET_POLYML := $(NAME)

endif


# Library dependencies
#
# Define:
#   LIB_NAMES       - list of the libraries that the application references

LIB_NAMES := \
	glib-2.0 \
	gobject-2.0 \
	gio-2.0 \
	gmodule-2.0 \
	atk-1.0 \
	cairo-1.0 \
	harfbuzz-0.0 \
	pangocairo-1.0 \
	pango-1.0 \
	gdkpixbuf-2.0 \
	gdk-3.0 \
	xlib-2.0 \
	gtk-3.0 \
	gtksource-3.0 \
	vte-2.91


# Note that LIB_NAMES does _not_ contain pkg-config names but GIR namespace
# names, which are also the directory names in $(GIRAFFEHOME)/lib/sml.
