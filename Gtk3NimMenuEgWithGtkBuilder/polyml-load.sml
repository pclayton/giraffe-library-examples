let
  val curDir = OS.FileSys.getDir ();
  val smlDir =
    case OS.Process.getEnv "GIRAFFE_SML_LIB" of
      SOME dir => dir
    | NONE     => raise Fail "GIRAFFE_SML_LIB not set"
in
  PolyML.Compiler.reportExhaustiveHandlers := false;
  PolyML.Compiler.reportUnreferencedIds := false;
  OS.FileSys.chDir smlDir;
  PolyML.use "polyml.sml";
  OS.FileSys.chDir curDir;
  PolyML.Compiler.reportUnreferencedIds := true;
  app PolyML.use [
    "polyml.sml",
    "export.sml"
  ];
  OS.Process.exit OS.Process.success : unit
end
  handle e => (app print [exnMessage e, "\n"]; OS.Process.exit OS.Process.failure)
