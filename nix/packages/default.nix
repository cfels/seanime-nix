{ ... }:
let
  pname = "seanime-denshi";
in
{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      packages = {
        ${pname} = pkgs.callPackage ./unwrapped.nix { };
        default = config.packages.${pname};
      };
    };
}
