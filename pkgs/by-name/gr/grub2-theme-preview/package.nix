{
  lib,
  python3Packages,
  pkgs,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "grub2-theme-preview";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "grub2-theme-preview";
    tag = version;
    hash = "sha256-JJOFgID/53dscHdXvt3aMfswsla401F0rAjPOYEzx3o=";
  };

  pyproject = true;
  build-system = with python3Packages; [ setuptools ];

  makeWrapperArgs = [
    ''--add-flags "--grub2-mkrescue=${lib.getExe' pkgs.grub2 "grub-mkrescue"}"''
    ''--add-flags "--qemu=${lib.getExe pkgs.qemu}" ''
    ''--add-flags "--xorriso=${lib.getExe' pkgs.libisoburn "xorriso"}"''
    ''--set 'G2TP_GRUB_LIB' "${pkgs.grub2}/lib/grub"''
    ''--set 'G2TP_OVMF_IMAGE' "${pkgs.OVMF}/FV/OVMF_CODE.fd"''
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to preview a GRUB 2.x theme using KVM / QEMU";
    homepage = "https://github.com/hartwork/grub2-theme-preview";
    changeLog = "https://github.com/hartwork/grub2-theme-preview/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      acuteaangle
    ];
    mainProgram = "grub2-theme-preview";
  };
}
