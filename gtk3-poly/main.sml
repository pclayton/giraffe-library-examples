

local
  val sourceId = ref NONE

  fun watchingStdIn () =
    case ! sourceId of
      NONE => false
    | SOME id => not (GLib.Source.isDestroyed (GLib.MainContext.findSourceById (GLib.MainContext.default ()) id))

  fun watchStdIn () =
    if watchingStdIn ()
    then ()
    else
      let
        val id =
          GLib.ioAddWatch (
            GLib.IOChannel.unixNew Posix.FileSys.stdin,
            GLib.PRIORITY_LOW,
            let open GLib.IOCondition in flags [IN, PRI, HUP] end,
            fn _ => GLib.SOURCE_CONTINUE
          )

        val () = sourceId := SOME id
      in
        ()
      end

  fun getChar () =
    if isSome (TextIO.canInput (TextIO.stdIn, 1))
    then
      TextIO.input1 TextIO.stdIn
    else
      let
        open Thread.Thread
        val attrs = getAttributes ()
        val () = setAttributes [InterruptState InterruptDefer]
        val _ = GLib.MainContext.iteration (GLib.MainContext.default ()) true;  (* blocks *)
        val () = setAttributes attrs
      in
        getChar ()
      end
in
  fun enterGtkShellWithArgs (args : string list, init : string list -> unit) =
    let
      val argv = Utf8CPtrArrayN.fromList args
      val () = init (Utf8CPtrArrayN.toList (Gtk.init argv))

      val () = print "Entered GTK shell\n"
      val () = watchStdIn ()
      val () = PolyML.shell1 getChar
      val () = print "Exited GTK shell\n"
    in
      ()
    end

  fun enterGtkShell () = enterGtkShellWithArgs ([], ignore)
end

val () = PolyML.onEntry (fn () => PolyML.print_depth 999)
;

val main = PolyML.rootFunction
