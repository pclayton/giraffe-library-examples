use "$(GIRAFFE_SML_LIB)/general/polyml.sml";
use "$(GIRAFFE_SML_LIB)/ffi/polyml.sml";
(* Override PolyMLFFI to use dynamic loading for library dependencies *)
structure PolyMLFFI =
  struct
    open PolyMLFFI
    val externalFunctionSymbol = getSymbol
    val externalDataSymbol = getSymbol
  end
;
use "$(GIRAFFE_SML_LIB)/gir/polyml.sml";
use "$(GIRAFFE_SML_LIB)/glib-2.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/gobject-2.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/gio-2.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/gmodule-2.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/cairo-1.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/pango-1.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/pangocairo-1.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/gdkpixbuf-2.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/atk-1.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/gdk-3.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/xlib-2.0/polyml.sml";
use "$(GIRAFFE_SML_LIB)/gtk-3.0/polyml.sml";
