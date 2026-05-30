{config, ...}: {
  users.users.${config.preferences.username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "input"];
    initialPassword = config.preferences.username;
  };
}
