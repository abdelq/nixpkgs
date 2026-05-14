{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  pkg-config,
  libcec,
  libevdev,
  plasma-wayland-protocols,
  plasma-workspace,
  qtwayland,
  sdl3,
  xwiimote,
}:

mkKdeDerivation {
  pname = "plasma-remotecontrollers";
  version = "unstable-2026-05-05";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma-bigscreen";
    repo = "plasma-remotecontrollers";
    rev = "43cff966637d4adf8445558ba167f762e68f7707";
    hash = "sha256-mArYtF0IiTmY91+d+HvXD8Sg2imqfR4s4MXtPZ+nUtc=";
  };

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    libcec
    libevdev
    plasma-wayland-protocols
    qtwayland
    sdl3
    xwiimote
  ];

  dontQmlLint = true; # FIXME: qmllint fails to resolve the KCM's nested QML import paths.

  extraCmakeFlags = [
    # FIXME: work around Qt 6.10 cmake API changes
    "-DQT_FIND_PRIVATE_MODULES=1"
  ];

  postPatch = ''
    # Plasma version numbers are required to match, but we are building an
    # unreleased package against a stable Plasma release.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(PROJECT_VERSION "6.4.50")' 'set(PROJECT_VERSION "${plasma-workspace.version}")'
  '';

  meta = {
    platforms = lib.platforms.linux;
  };
}
