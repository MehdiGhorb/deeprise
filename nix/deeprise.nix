{
  lib,
  stdenvNoCC,
  callPackage,
  bun,
  nodejs,
  sysctl,
  makeBinaryWrapper,
  models-dev,
  ripgrep,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  node_modules ? callPackage ./node-modules.nix { },
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "deeprise";
  inherit (node_modules) version src;
  inherit node_modules;

  nativeBuildInputs = [
    bun
    nodejs # for patchShebangs node_modules
    installShellFiles
    makeBinaryWrapper
    models-dev
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
  env.DEEPRISE_DISABLE_MODELS_FETCH = true;
  env.DEEPRISE_VERSION = finalAttrs.version;
  env.DEEPRISE_CHANNEL = "local";

  buildPhase = ''
    runHook preBuild

    cd ./packages/deeprise
    bun --bun ./script/build.ts --single --skip-install
    bun --bun ./script/schema.ts schema.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/deeprise-*/bin/deeprise $out/bin/deeprise
    install -Dm644 schema.json $out/share/deeprise/schema.json

    wrapProgram $out/bin/deeprise \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            ripgrep
          ]
          # bun runs sysctl to detect if running on rosetta2
          ++ lib.optional stdenvNoCC.hostPlatform.isDarwin sysctl
        )
      }

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    # trick yargs into also generating zsh completions
    installShellCompletion --cmd deeprise \
      --bash <($out/bin/deeprise completion) \
      --zsh <(SHELL=/bin/zsh $out/bin/deeprise completion)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" "DEEPRISE_DISABLE_MODELS_FETCH" ];
  versionCheckProgramArg = "--version";

  passthru = {
    jsonschema = "${placeholder "out"}/share/deeprise/schema.json";
  };

  meta = {
    description = "The open source coding agent";
    homepage = "https://github.com/MehdiGhorb/autonomous_coding_agent";
    license = lib.licenses.mit;
    mainProgram = "deeprise";
    inherit (node_modules.meta) platforms;
  };
})
