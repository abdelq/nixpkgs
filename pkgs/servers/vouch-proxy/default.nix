{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vouch-proxy";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    rev = "v${version}";
    sha256 = "sha256-thA3hsGNDifUc0XFsOB8cjJTrz4NY+NtK05a20AFzJ8=";
  };

  vendorSha256 = "sha256-ifH+420FIrib+zQtzzHtMMYd84BED+vgnRw4xToYIl4=";

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  preCheck = ''
    export VOUCH_ROOT=$PWD
  '';

  meta = with lib; {
    homepage = "https://github.com/vouch/vouch-proxy";
    description = "An SSO and OAuth / OIDC login solution for NGINX using the auth_request module";
    license = licenses.mit;
    maintainers = with maintainers; [ em0lar ];
  };
}
