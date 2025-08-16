#    Module Git (Home Manager)
{
  config,
  pkgs,
  ...
}: {
  # ╭──────────────────────────────────────────────────────────────╮
  # │                              GIT                             │
  # ╰──────────────────────────────────────────────────────────────╯
  programs.git = {
    enable = true;
    userName = "JeremieAlcaraz";
    userEmail = "hello@jeremiealcaraz.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
