{
  pkgs,
  wrappers,
  ...
}: {
  environment.systemPackages = [
    (wrappers.wrappers.git.wrap {
      inherit pkgs;

      settings = {
        user = {
          name = "jonas-elhs";
          email = "jonas.elhs@outlook.com";
        };
      };
    })
  ];
}
