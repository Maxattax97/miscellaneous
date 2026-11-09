{
  description = "Max's personal CLI set; packages.txt maps each tool to where it used to come from";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      lines = lib.splitString "\n" (builtins.readFile ./packages.txt);
      rows = map (l: lib.filter (w: w != "") (lib.splitString " " l)) (
        lib.filter (l: l != "" && !lib.hasPrefix "#" l) lines
      );
      flags = r: if lib.length r > 2 then lib.splitString "," (lib.elemAt r 2) else [ ];
      pkgFor = pkgs: r: lib.getAttrFromPath (lib.splitString "." (lib.elemAt r 1)) pkgs;
      env =
        pkgs: name: keep:
        pkgs.buildEnv {
          inherit name;
          paths = map (pkgFor pkgs) (lib.filter keep rows);
          # Python tools share console scripts (ansible, ansible-lint, molecule) and toolchains overlap.
          ignoreCollisions = true;
        };
      forAll = f: lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in
    {
      packages = forAll (pkgs: rec {
        all = env pkgs "misc-all" (_: true);
        # For machines that also install the Entegrata dev-tools flake as its own profile entry.
        personal = env pkgs "misc-personal" (r: !lib.elem "base" (flags r));
        default = all;
      });
    };
}
