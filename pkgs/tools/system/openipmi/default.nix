{ stdenv, fetchurl, popt, ncurses, python3, readline, lib }:

stdenv.mkDerivation rec {
  pname = "OpenIPMI";
  version = "2.0.31";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI-${version}.tar.gz";
    sha256 = "05wpkn74nxqp5p6sa2yaf2ajrh8b0gfkb7y4r86lnigz4rvz6lkh";
  };

  buildInputs = [ ncurses popt python3 readline ];

  outputs = [ "out" "lib" "dev" "man" ];

  meta = with lib; {
    homepage = "https://openipmi.sourceforge.io/";
    description = "A user-level library that provides a higher-level abstraction of IPMI and generic services";
    license = with licenses; [ gpl2Only lgpl2Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ arezvov SuperSandro2000 ];
  };
}
