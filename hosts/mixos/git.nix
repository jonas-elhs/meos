{
  pkgs,
  wrappers,
  ...
}: {
  environment.systemPackages = [
    (wrappers.git.wrap {
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
