local
  open MenuBuilder
in
  val menuData =
    Menu [
      Section (
        NONE,
        Menu [
          Item (SOME "Normal Menu Item", SOME "win.normal-menu-item"),
          Submenu (
            SOME "Submenu",
            Menu [
              Item (SOME "Submenu Item", SOME "win.submenu-item")
            ]
          ),
          Item (SOME "Toggle Menu Item", SOME "win.toggle-menu-item")
        ]
      ),
      Section (
        NONE,
        Menu [
          Item (SOME "Radio 1", SOME "win.radio::1"),
          Item (SOME "Radio 2", SOME "win.radio::2"),
          Item (SOME "Radio 3", SOME "win.radio::3")
        ]
      )
    ]
end

fun changeLabelButton label _ _ =
  Gtk.Label.setLabel label "Text set from button"

fun normalMenuItem label _ _ =
  Gtk.Label.setLabel label "Text set from normal menu item"

fun toggleMenuItem label action _ =
  let
    val newState =
      GLib.Variant.newBoolean (
        not (GLib.Variant.getBoolean (Gio.Action.getState action))
      )
    val () = Gio.Action.changeState action newState
    val () =
      Gtk.Label.setLabel label (
        "Text set from toggle menu item. Toggle state: "
         ^ Bool.toString (GLib.Variant.getBoolean newState)
      )
  in
    ()
  end

fun submenuItem label _ _ =
  Gtk.Label.setLabel label "Text set from submenu item"

fun radio label action =
  fn
    SOME parameter =>
      let
        val newState = GLib.Variant.newString (#1 (GLib.Variant.getString parameter))
        val () = Gio.Action.changeState action parameter
        val str = "From Radio menu item " ^ #1 (GLib.Variant.getString newState)
        val () = Gtk.Label.setLabel label str
      in
        ()
      end
  | NONE => raise Fail "parameter expected but none provided"


fun activate app () =
  let
    open Gtk

    val window = ApplicationWindow.new app
    val box = Box.new (Orientation.VERTICAL, 12)
    val menubutton = MenuButton.new ()
    val button1 = Button.newWithLabel "Change Label Text"
    val actionGroup = Gio.SimpleActionGroup.new ()
    val label = Label.new (SOME "Initial Text")

    fun addSimpleAction (simpleAction, f) =
      let
        val action = Gio.SimpleAction.asAction simpleAction
        val _ = Signal.connect simpleAction (Gio.SimpleAction.activateSig, f label action)
        val () = Gio.ActionMap.addAction (Gio.SimpleActionGroup.asActionMap actionGroup) action
      in
        ()
      end

    val action = Gio.SimpleAction.new ("change-label-button", NONE)
    val () = addSimpleAction (action, changeLabelButton)

    val action = Gio.SimpleAction.new ("normal-menu-item", NONE)
    val () = addSimpleAction (action, normalMenuItem)

    val v = GLib.Variant.newBoolean true
    val action = Gio.SimpleAction.newStateful ("toggle-menu-item", NONE, v)
    val () = addSimpleAction (action, toggleMenuItem)

    val action = Gio.SimpleAction.new ("submenu-item", NONE)
    val () = addSimpleAction (action, submenuItem)

    val v = GLib.Variant.newString "1"
    val vt = GLib.VariantType.new "s"
    val action = Gio.SimpleAction.newStateful ("radio", SOME vt, v)
    val () = addSimpleAction (action, radio)

    val () =
      Widget.insertActionGroup window
        ("win", SOME (Gio.SimpleActionGroup.asActionGroup actionGroup))

    val () = Widget.setMarginTop label 12
    val () = Widget.setMarginBottom label 12
    val () = Container.add box label
    val () = Widget.setHalign menubutton Align.CENTER

    val menuModel = MenuBuilder.buildMenu menuData
    val menu = Popover.newFromModel (NONE, menuModel)
    val () = MenuButton.setPopover menubutton (SOME menu)
    val () = Container.add box menubutton
    val () = Widget.setHalign button1 Align.CENTER
    val () = Actionable.setActionName (Button.asActionable button1) (SOME "win.change-label-button")
    val () = Container.add box button1
    val () = Container.add window box
    val () = Widget.showAll window
  in
    ()
  end

fun main () =
  let
    val app = Gtk.Application.new (SOME "org.gtk.example", Gio.ApplicationFlags.flags [])
    val id = Signal.connect app (Gio.Application.activateSig, activate app)

    val argv = Utf8CPtrArrayN.fromList (CommandLine.name () :: CommandLine.arguments ())
    val status = Gio.Application.run app argv

    val () = Signal.handlerDisconnect app id
  in
    Giraffe.exit status
  end
    handle e => Giraffe.error 1 ["Uncaught exception\n", exnMessage e, "\n"]
