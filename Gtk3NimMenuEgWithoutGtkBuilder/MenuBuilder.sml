structure MenuBuilder =
  struct
    datatype menu =
      Menu of menu_item list

    and menu_item =
      Submenu of string option * menu
    | Section of string option * menu
    | Item    of string option * string option


    fun buildMenu (Menu items) =
      let
        val menu = Gio.Menu.new ()
        val menuItems = List.map buildMenuItem items
        val () = List.app (Gio.Menu.appendItem menu) menuItems
      in
        menu
      end

    and buildMenuItem item =
      case item of
        Submenu (label, menu) => Gio.MenuItem.newSubmenu (label, buildMenu menu)
      | Section (label, menu) => Gio.MenuItem.newSection (label, buildMenu menu)
      | Item (label, detailedAction) => Gio.MenuItem.new (label, detailedAction)
  end
