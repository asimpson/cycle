with (import <nixpkgs> {});

stdenv.mkDerivation rec {
  pname = "cycle";
  version = "v0.3.0";

  sbclCore = sbcl.overrideAttrs (oldAttrs: rec {
    enableFeatures = oldAttrs.enableFeatures ++ ["sb-core-compression"];
    buildInputs = oldAttrs.buildInputs ++ [zlib];
    sbclBootstrapHost = "${sbclBootstrap}/bin/sbcl --disable-debugger --no-userinit --no-sysinit";
    buildPhase = ''
      runHook preBuild
      sh make.sh --prefix=$out --xc-host="${sbclBootstrapHost}" ${if stdenv.hostPlatform.system == "aarch64-darwin" then "--arch=arm64" else ""} "--with-sb-core-compression"
      runHook postBuild
    '';
  });

  src = fetchFromGitHub {
    owner = "asimpson";
    repo = pname;
    rev = version;
    hash = "sha256-AEGceS5hX8VrBYHeViCaR++DI2kBeR2IWcD9TH2Ea5U=";
  };

  buildInputs = [
    curl
    sbclCore
  ];

  preBuild = ''
    export HOME=$out
    mkdir -p $out/ql
    mkdir -p $out/bin
    curl -kL -o $out/ql/quicklisp.lisp "https://beta.quicklisp.org/quicklisp.lisp"
    sbcl --load $out/ql/quicklisp.lisp \
         --eval "(quicklisp-quickstart:install :path \"$out/ql/quicklisp\")" \
         --eval "(quit)" && \
    sbcl --load $out/ql/quicklisp/setup.lisp \
         --eval "(ql::without-prompting (ql:add-to-init-file))" \
         --eval "(quit)"
  '';

  installPhase = ''
    mv cycle $out/bin
  '';
}
