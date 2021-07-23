final: prev:
{
  vscode-extensions = with final.vscode-utils; prev.vscode-extensions // {
    astro-build.astro-vscode = extensionFromVscodeMarketplace {
      name = "astro-vscode";
      publisher = "astro-build";
      version = "0.5.0";
      sha256 = "ipPn29T6EUBNLd9OsfJbeU76n2TViBjy18Lk+lH0yJQ=";
    };
    roscop.activefileinstatusbar = extensionFromVscodeMarketplace {
      name = "ActiveFileInStatusBar";
      publisher = "RoscoP";
      version = "1.0.3";
      sha256 = "5GJODdKL8949a8KR2O7hGsRgAknfPyNEJ+9aiEYYemk=";
    };
    nash.awesome-flutter-snippets = extensionFromVscodeMarketplace {
      name = "awesome-flutter-snippets";
      publisher = "Nash";
      version = "2.0.4";
      sha256 = "p0/96R3Fg3Z12r3S9i7Vc4gN4kM2DhyTwCh+s2x3fRI=";
    };
    coenraads.bracket-pair-colorizer-2 = extensionFromVscodeMarketplace {
      name = "bracket-pair-colorizer-2";
      publisher = "CoenraadS";
      version = "0.2.0";
      sha256 = "kOqD7k5Z2aGek/XGCGEDRpS29NCYJTVzQqABXpd791o=";
    };
    dzhavat.css-initial-value = extensionFromVscodeMarketplace {
      name = "css-initial-value";
      publisher = "dzhavat";
      version = "0.2.3";
      sha256 = "ILjKZcvobNfNPS/MjH9MO/QJfN/WE1YuixAG9SlIL74=";
    };
    dart-code.dart-code = extensionFromVscodeMarketplace {
      name = "dart-code";
      publisher = "Dart-Code";
      version = "3.18.0";
      sha256 = "E+qrY7wOvengOs2yKqhh+5dRLu3dUu6yWxGcwD7QHuI=";
    };
    dart-code.flutter = extensionFromVscodeMarketplace {
      name = "flutter";
      publisher = "Dart-Code";
      version = "3.18.0";
      sha256 = "nvKBPSe0+WQ8m88WrQqhzVrqYBjcBhiz6EuJ38gTFhQ=";
    };
    icrawl.discord-vscode = extensionFromVscodeMarketplace {
      name = "discord-vscode";
      publisher = "icrawl";
      version = "4.1.0";
      sha256 = "BRJQiveizMeygXO3XXoUqvWoq1Z1jjBohYMB1KXKwtA=";
    };
    mikestead.dotenv = extensionFromVscodeMarketplace {
      name = "dotenv";
      publisher = "mikestead";
      version = "1.0.1";
      sha256 = "dieCzNOIcZiTGu4Mv5zYlG7jLhaEsJR05qbzzzQ7RWc=";
    };
    eamodio.gitlens = extensionFromVscodeMarketplace {
      name = "gitlens";
      publisher = "eamodio";
      version = "11.1.3";
      sha256 = "hqJg3jP4bbXU4qSJOjeKfjkPx61yPDMsQdSUVZObK/U=";
    };
    zignd.html-css-class-completion = extensionFromVscodeMarketplace {
      name = "html-css-class-completion";
      publisher = "Zignd";
      version = "1.20.0";
      sha256 = "3BEppTBc+gjZW5XrYLPpYUcx3OeHQDPW8z7zseJrgsE=";
    };
    mathiasfrohlich.kotlin = extensionFromVscodeMarketplace {
      name = "Kotlin";
      publisher = "mathiasfrohlich";
      version = "1.7.1";
      sha256 = "MuAlX6cdYMLYRX2sLnaxWzdNPcZ4G0Fdf04fmnzQKH4=";
    };
    yzhang.markdown-all-in-one = extensionFromVscodeMarketplace {
      name = "markdown-all-in-one";
      publisher = "yzhang";
      version = "3.4.0";
      sha256 = "C5d2I0srdUGcmmvW2tRlMvD1RyFsUqECIQ0xLZ7ODkY=";
    };
    shd101wyy.markdown-preview-enhanced = extensionFromVscodeMarketplace {
      name = "markdown-preview-enhanced";
      publisher = "shd101wyy";
      version = "0.5.15";
      sha256 = "uR6wX0L2ceI8iZJc6ZSxR+iVx0N1qd4dO3eVLE+X6d4=";
    };
    pkief.material-icon-theme = extensionFromVscodeMarketplace {
      name = "material-icon-theme";
      publisher = "PKief";
      version = "4.4.0";
      sha256 = "yiM+jtc7UW8PQTwmHmXHSSmvYC73GLh/cLYnmYqONdU=";
    };
    zhuangtongfa.material-theme = extensionFromVscodeMarketplace {
      name = "Material-theme";
      publisher = "zhuangtongfa";
      version = "3.9.12";
      sha256 = "D1CpuaCZf1kkpc+le2J/prPrOXhqDwtphVk4ejtM8AQ=";
    };
    ibm.output-colorizer = extensionFromVscodeMarketplace {
      name = "output-colorizer";
      publisher = "IBM";
      version = "0.1.2";
      sha256 = "Z22nS9dW1w7L9taO3PkxzQA9tOqsPjQPY17ZMam9M0U=";
    };
    alefragnani.pascal = extensionFromVscodeMarketplace {
      name = "pascal";
      publisher = "alefragnani";
      version = "9.2.0";
      sha256 = "mFNxz5qwClDeLtE1W9S6k7uSeXFVClHvIKD2QE1DmAE=";
    };
    alefragnani.pascal-formatter = extensionFromVscodeMarketplace {
      name = "pascal-formatter";
      publisher = "alefragnani";
      version = "2.4.0";
      sha256 = "cx8NfAEwneEWkoUoqEXSfvwNSYzRHSSKsH5kx0I5QWo=";
    };
    esbenp.prettier-vscode = extensionFromVscodeMarketplace {
      name = "prettier-vscode";
      publisher = "esbenp";
      version = "5.8.0";
      sha256 = "x6/bBeHi/epYpRGy4I8noIsnwFdFEXk3igF75y5h/EA=";
    };
    jeroen-meijer.pubspec-assist = extensionFromVscodeMarketplace {
      name = "pubspec-assist";
      publisher = "jeroen-meijer";
      version = "2.2.1";
      sha256 = "555vpI6QqP9bpfLFIH2whRsAjsnQnwOjMXAnCF0Y30E=";
    };
    ms-python.python = extensionFromVscodeMarketplace {
      name = "python";
      publisher = "ms-python";
      version = "2020.12.424452561";
      sha256 = "ji5MS4B6EMehah8mi5qbkP+snCoVQJC5Ss2SG1XjoH0=";
    };
    arrterian.nix-env-selector = extensionFromVscodeMarketplace {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "1.0.7";
      sha256 = "DnaIXJ27bcpOrIp1hm7DcrlIzGSjo4RTJ9fD72ukKlc=";
    };
    humao.rest-client = extensionFromVscodeMarketplace {
      name = "rest-client";
      publisher = "humao";
      version = "0.24.4";
      sha256 = "NUmjnPS4bJghCtU8a9RTKhqkxuwj2DTivlG5Ac8t/aU=";
    };
    adpyke.codesnap = extensionFromVscodeMarketplace {
      name = "codesnap";
      publisher = "adpyke";
      version = "1.2.0";
      sha256 = "rhpEN7h3cu5qKG+b+gIMB7zGXc2K64BVoEj6jqe0v3A=";
    };
    msjsdiag.vscode-react-native = extensionFromVscodeMarketplace {
      name = "vscode-react-native";
      publisher = "msjsdiag";
      version = "1.2.0";
      sha256 = "1ESN47fzDrK6keoZqGvauAeDNREl/C9wp2vcA86Jqp0=";
    };
    dbaeumer.vscode-eslint = extensionFromVscodeMarketplace {
      name = "vscode-eslint";
      publisher = "dbaeumer";
      version = "2.1.14";
      sha256 = "bVGmp871yu1Llr3uJ+CCosDsrxJtD4b1+CR+omMUfIQ=";
    };
    pflannery.vscode-versionlens = extensionFromVscodeMarketplace {
      name = "vscode-versionlens";
      publisher = "pflannery";
      version = "1.0.9";
      sha256 = "cPESnrSnCurVUEgPh6g4Tk7PY3K4du6w9pcOZUYf1bM=";
    };
    svelte.svelte-vscode = extensionFromVscodeMarketplace {
      name = "svelte-vscode";
      publisher = "svelte";
      version = "102.8.0";
      sha256 = "sopN6tYQiqsJ1Z/aiBOOjGckutkIQCwPGFnmw9BXN3g=";
    };
    dendron.dendron = extensionFromVscodeMarketplace {
      name = "dendron";
      publisher = "dendron";
      version = "0.23.0";
      sha256 = "UnVF6pO7wsuumUm/Ge2xteM9tpsc17qqNALfb6ddyIk=";
    };
    github.vscode-codeql = extensionFromVscodeMarketplace {
      name = "vscode-codeql";
      publisher = "GitHub";
      version = "1.3.8";
      sha256 = "6m17GKiALWuJKpE5sxleF4PJpbFVmYllnT3dgJX6sqs=";
    };
    rust-lang.rust = extensionFromVscodeMarketplace {
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.8";
      sha256 = "Y33agSNMVmaVCQdYd5mzwjiK5JTZTtzTkmSGTQrSNg0=";
    };
    b4dm4n.nixpkgs-fmt = extensionFromVscodeMarketplace {
      name = "nixpkgs-fmt";
      publisher = "B4dM4n";
      version = "0.0.1";
      sha256 = "vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
    };
    tamasfe.even-better-toml = extensionFromVscodeMarketplace {
      name = "even-better-toml";
      publisher = "tamasfe";
      version = "0.9.1";
      sha256 = "phuj7xeTRvLsAHw6b6xrIWPI3YITAoD04VGem/s8yiU=";
    };
    bradlc.vscode-tailwindcss = extensionFromVscodeMarketplace {
      name = "vscode-tailwindcss";
      publisher = "bradlc";
      version = "0.6.13";
      sha256 = "xJXrAJGhai5TDZ2h4D7XWhLedn8MNMHA/FeehUTNGyU=";
    };
  };
}
