{ basePyproject }:

basePyproject.override {
  content = {
    tool.poetry.dependencies = {
      cupy-cuda12x = "*";
      torch = "~2.3.0";
      xformers = "*";
      torchaudio = "*";
      torchvision = "*";
    };
  };
}
