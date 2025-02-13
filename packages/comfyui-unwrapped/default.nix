{ emptyPyproject, fetchFromGitHub, lib, python3 }:

let
  pyproject = emptyPyproject.override {
    content = {
      tool.poetry.name = "comfyui-unwrapped";
      tool.poetry.version = "0.0.0";
    };
  };

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    fetchSubmodules = false;
    rev = "0c7c98a965bff25f9398a4b28dfc274bedad9f6c";
    hash = "sha256-KO6Ae7uUUNRaDLj/ScaaNcuDXnuNCv0oBYRqe/x6BRs=";
  };

  shortRev = builtins.substring 0 8 src.rev;
in

python3.pkgs.buildPythonPackage {
  name = "comfyui-unwrapped";
  version = "0.0.0";

  format = "pyproject";

  inherit src;

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = [
    python3.pkgs.aiohttp
    python3.pkgs.einops
    python3.pkgs.kornia
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.psutil
    python3.pkgs.pyyaml
    python3.pkgs.requests
    python3.pkgs.safetensors
    python3.pkgs.scipy
    python3.pkgs.sentencepiece
    python3.pkgs.soundfile
    python3.pkgs.spandrel
    python3.pkgs.spandrel-extra-arches
    python3.pkgs.tokenizers
    python3.pkgs.torch
    python3.pkgs.torchaudio
    python3.pkgs.torchsde
    python3.pkgs.torchvision
    python3.pkgs.tqdm
    python3.pkgs.transformers
    python3.pkgs.typing-extensions
  ];

  patches = [
    ./0001-fix-paths.patch
    ./0002-fix-version.patch
  ];

  postPatch = ''
    cp ${pyproject} pyproject.toml
    substituteInPlace server.py \
      --subst-var-by version ${lib.escapeShellArg shortRev}
    rm --force --recursive .ci script_examples tests-unit web new_updater.py
  '';

  pythonImportsCheck = [
    "folder_paths"
  ];

  passthru = {
    check-pkgs.ignoredModuleNames = [
      "^intel_extension_for_pytorch$"
      "^new_updater$"
      "^torch_directml$"
      "^xformers(\\..+)?$"
    ];
  };

  meta = {
    license = lib.licenses.gpl3;
  };
}
