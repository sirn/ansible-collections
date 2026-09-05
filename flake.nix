{
  description = "sirn.collections Ansible collection development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python310.withPackages (ps: with ps; [ pip ]);
      in
      {
        devShell = with pkgs; mkShell {
          name = "ansible-collections-dev";

          packages = [
            ansible
            ansible-lint
            yamllint
            python
          ];
        };
      }
    );
}
