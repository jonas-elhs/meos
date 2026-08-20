{
  pkgs,
  wrappers,
  ...
}: {
  environment.systemPackages = [
    (wrappers.jujutsu.wrap {
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
