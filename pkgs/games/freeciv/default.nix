{ lib, stdenv, fetchFromGitHub, autoreconfHook, lua5_3, pkg-config, python3
, zlib, bzip2, curl, xz, gettext, libiconv
, sdlClient ? true, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_gfx, freetype, fluidsynth
, gtkClient ? stdenv.isLinux, gtk3
, qtClient ? false, qt5
, server ? true, readline
, enableSqlite ? true, sqlite
}:

stdenv.mkDerivation rec {
  pname = "freeciv";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "freeciv";
    repo = "freeciv";
    rev = "R${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-7KVtBGihABpcbUm5ac2fuBVaDvbucEJSREPulGUdnUE=";
  };

  postPatch = ''
    for f in {common,utility}/*.py; do
      substituteInPlace $f \
        --replace '/usr/bin/env python3' ${python3.interpreter}
    done
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ]
    ++ lib.optional qtClient [ qt5.wrapQtAppsHook ];

  buildInputs = [ lua5_3 zlib bzip2 curl xz gettext libiconv ]
    ++ lib.optionals sdlClient [ SDL SDL_mixer SDL_image SDL_ttf SDL_gfx freetype fluidsynth ]
    ++ lib.optionals gtkClient [ gtk3 ]
    ++ lib.optionals qtClient  [ qt5.qtbase ]
    ++ lib.optional server readline
    ++ lib.optional enableSqlite sqlite;

  dontWrapQtApps = true;

  configureFlags = [ "--enable-shared" ]
    ++ lib.optional sdlClient "--enable-client=sdl"
    ++ lib.optionals qtClient [
      "--enable-client=qt"
      "--with-qt5-includes=${qt5.qtbase.dev}/include"
    ] ++ lib.optionals gtkClient [ "--enable-client=gtk3.22" ]
    ++ lib.optional enableSqlite "--enable-fcdb=sqlite3"
    ++ lib.optional (!gtkClient) "--enable-fcmp=cli"
    ++ lib.optional (!server)    "--disable-server";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Multiplayer (or single player), turn-based strategy game";
    longDescription = ''
      Freeciv is a Free and Open Source empire-building strategy game
      inspired by the history of human civilization. The game commences in
      prehistory and your mission is to lead your tribe from the stone age
      to the space age...
    '';
    homepage = "http://www.freeciv.org"; # http only
    license = licenses.gpl2;
    maintainers = with maintainers; [ pierron ];
    platforms = platforms.unix;
    hydraPlatforms = platforms.linux; # sdl-config times out on darwin
  };
}
