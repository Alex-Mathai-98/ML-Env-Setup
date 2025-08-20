# ML-Env-Setup

1. To avoid losing out on any variables already stored in your ~/.bashrc file, you can add an additional line to ~/.zshrc file.

`source ~/.bashrc`

This will load anything specific to your bashrc file already present. 
**Check if there is really a need to add this line. It can most probably just be skipped.**

2. Very likely, you might have to copy the `conda initialize` commands in the `~/.bashrc` file into the `~/.zshrc` file. So that the `conda activate` command works fine.

3. I have modified the `.tmux.conf` file to automatically load `zsh`, the command assumes the path `/usr/bin/zsh`; but on other computers it can also be `/usr/zsh`.

---

Common Problems

0. You might have to modify the bash file a bit (especially the `install` command) in case you change your OS - like AmazonLinux for example.
1. If you have shifted from bash to zsh, then VSCode "+" button will still select the "bash" as the default shell.
2. You can change this by pressing "+", then pressing "Select Default Profile" and then choosing "zsh".


Or otherwise, as suggested by Claude
// In settings.json
"terminal.integrated.defaultProfile.linux": "zsh"
