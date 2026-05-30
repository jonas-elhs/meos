# TODO: wrapper module (systemd service how??)
{...}: {
  services.keyd = {
    enable = true;

    keyboards.default = {
      settings = {
        main = {
          capslock = "overload(control, esc)";
          esc = "capslock";
        };
      };
    };
  };
}
