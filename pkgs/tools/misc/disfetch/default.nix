{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disfetch";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "q60";
    repo = "disfetch";
    rev = version;
    sha256 = "sha256-T6FepZBlB1ZZMVFS7zXqSDFCsHbbVNkJNwIHpQ5Ex68=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin disfetch
    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet another *nix distro fetching program, but less complex";
    homepage = "https://github.com/q60/disfetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vel ];
  };
}
