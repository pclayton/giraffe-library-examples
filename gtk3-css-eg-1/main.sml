fun applyCss () =
  let
    val screen = Gdk.Screen.getDefault ()
    val cssProvider = Gtk.CssProvider.new ()
    val _ = Gtk.CssProvider.loadFromPath cssProvider "main.css"
    val () =
      Gtk.StyleContext.addProviderForScreen
        (Option.valOf screen, Gtk.CssProvider.asStyleProvider cssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)
  in
    ()
  end
    handle
      Option => GiraffeLog.critical "Error: could not get screen\n"
    | GLib.Error (_, error) => GiraffeLog.critical (#get GLib.Error.message error)

fun onButtonClicked optOverlay (widget : 'a Gtk.Button.class) () =
  let
    val label = Gtk.Button.getLabel widget
    val () = print (concat ["Button ", label, " Pressed", "\n"])
  in
    case optOverlay of
      SOME overlay =>
        let
          val visible = Gtk.Widget.getVisible overlay
          val () = Gtk.Widget.setVisible overlay (not visible)
        in
          ()
        end
    | NONE => ()
  end

fun getObject subclass builder name =
  case Gtk.Builder.getObject builder name of
    SOME object => GObject.ObjectClass.toDerived subclass object
  | NONE => Giraffe.error 1 ["Error getting builder object: \"", name, "\" not found\n"]

fun onActivate app () =
  let
    open Gtk

    val builder = Gtk.Builder.new ()
    val _ =
      Gtk.Builder.addFromFile builder "main.ui"
        handle
          GLib.Error (_, error) =>
            Giraffe.error 1 [#get GLib.Error.message error, "\n"]

    val window = getObject ApplicationWindowClass.t builder "mainwin"
    val () = Window.setApplication window (SOME app)
    val () = Window.setTitle window "CSS in GTK3 Test"
    val () = Window.setDefaultSize window (800, 800)

    (* Setup main box *)
    val main = getObject BoxClass.t builder "main"
    val btn =
      GObject.Object.new (
        ButtonClass.t,
        [
          Property.init Button.labelProp (SOME "Toggle Overlay"),
          Property.init Widget.valignProp Align.START,
          Property.init Widget.halignProp Align.CENTER
        ]
      )
    val overlay = getObject BoxClass.t builder "overlay"
    val _ = Signal.connect btn (Button.clickedSig, onButtonClicked (SOME overlay) btn)
    val () = Box.packStart main (btn, true, true, 0)
    val () = Widget.showAll main

    (* Setup overlay box *)
    val btn =
      GObject.Object.new (
        ButtonClass.t,
        [
          Property.init Button.labelProp (SOME "Touch Me"),
          Property.init Widget.valignProp Align.CENTER,
          Property.init Widget.halignProp Align.CENTER
        ]
      )
    val _ = Signal.connect btn (Button.clickedSig, onButtonClicked NONE btn)
    val () = Box.packStart overlay (btn, true, true, 0)
    val () = Widget.showAll overlay
    val () = applyCss ()
    val () = Window.present window
  in
    ()
  end

fun main () =
  let
    val app = Gtk.Application.new (SOME "dk.rasmil.gtk3csspimp", Gio.ApplicationFlags.FLAGS_NONE)
    val _ = Signal.connect app (Gio.Application.activateSig, onActivate app)

    val argv = Utf8CPtrArrayN.fromList (CommandLine.name () :: CommandLine.arguments ())
    val status = Gio.Application.run app argv
  in
    Giraffe.exit status
  end
    handle e => Giraffe.error 1 ["Uncaught exception\n", exnMessage e, "\n"]
