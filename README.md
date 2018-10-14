# (Opinionated) dotfiles and setup scripts

## Basic requirements (TODO: complete the list)

### macOS
```
brew update
sudo mkdir /usr/local/Frameworks
sudo chown $(whoami):admin /usr/local/Frameworks
brew install python3
```
Pick package is needed to run setup-new-machine. This is how to install it on macOS:
```
python3 -m pip install pick
```

### Linux
```
sudo apt install python3-pip
sudo pip3 install pick
```

## Installers and dotfiles

Not all things were made into installers or dotfiles. That's because either there are tools available on the internet that already do something I need really well or some actions need to be performed in rare situations. The following are those kinds of tools and actions. I keep them here to remember they exist and how to use them but they may not be needed on a daily basis or manually installing them is easier than preparing an installer.

### Moving Docker Machine configuration, including private keys, across computers
Docker Machine does not provide commands for exporting and importing information about servers is created (the ones visible when using `docker-machine ls`). So [there's a tool for that](https://github.com/bhurlow/machine-share/). Keep in mind the `machine-export` command will also archive private keys from the ~/.docker/machine/certs directory. It's not safe to move an archive like this between machines and there's rarely a need to do so. But if it's required (like when I was transfering my development environment from my local Macbook Air to an AWS VPS) it can be useful. `machine-share` is a npm package.

### Basic entry files to setup up a new machine

#### Dotfiles
For a full list of options, run `./install-dotfiles -h`.

**Primary usage:**
Run `./install-dotfiles -p dotfiles && . "~/.bash_profile"` first and provide a path to the dotfiles directory as the first parameter. The dotfiles directory will be copied into the user's directory under `dotfiles` and its `install` file linked to the system (inside `~/.bash_profile` on macOS by default, check the home directory (`cd ~`) to make sure or let `install-dotfiles` create `~/.bash_profile` for you) to run on every system boot. Default dotfiles are provided alongside this README.md, inside the `dotfiles` directory.

#### Software installations
Run `install installations` to get an interactive list of interactive and non-interactive "installers" available inside the `installations` directory, placed alongside this readme. The recommended order of installation is indicated by installer names which directly correspond to files inside the directory containing installers. All installers must be executable (use `chmod u+x -R "$(pwd)/installations"` to make all files executable). A special file named `.post-install-each` can be placed inside the installations directory or any of its subdirectories. It will be executed after every successfull installer execution.

### Helpful functions
All extra functions from dotfiles are available under the "ą__" (alt+a on macOS followed by two underscores) prefix for easier distinction in the shell. They're also all available without the prefix.

#### `edit-directory <optional path>`
Opens a directory using the `editor.py` handler. By default, the directory will open in VSCode. If no directory is given, will open the current directory (cwd).

#### `add-all-keys`
Executing `add-all-keys <keys>` will add all private keys inside the `keys` directory to the current ssh agent. The script omits files ending with `.pub`, assuming those contain only public keys.

#### `local-forward` and `local-forward-stop`
These functions make it easier to setup tunnels to localhost ports on a remote machine to the same local port on the caller. By default, the remote host is identified using a global variable `DEVELOPMENT_MACHINE_SSH_HOST`. The variable's value is `development-machine` by default and references a host inside ~/.ssh/config, so it must be defined there. `local-forward` makes using a VPS as a remote development machine much easier. For example, it's very easy to test a website on `development-machine` remotely and privately on port 3000 by executing `local-forward 3000`. To add more ports, execute the function with ports as parameters. To replace old ports with new ones, add a `-r` flag and to remove all ports, use the `-r` without providing any ports as parameters or execute `local-forward-stop`. To use a different host, use `--host <host>`.

#### `keygen <path to private key>`
Will generate a new private and public key pair. The private key will be located at the provided path and its public key right next to it with a ".key" suffix.

#### `key-fingerprint <path to public key>`
Will return the md5 representation of a key which is used on sites such as GitHub.

#### `dev-term`
Opens a [Eternal Terminal (et)](https://mistertea.github.io/EternalTerminal/) shell in the terminal and logs into `DEVELOPMENT_MACHINE_SSH_HOST` which is equal `development-machine` (defined inside `~/.ssh/config`).

Note: ET has one significant advantage over [Mosh](https://mosh.org/) - it's possible to still scroll the terminal in macOS and see previous commands when using it.

#### Docker commands
- `d` is shorthand for docker
- `dc` is shorthand for docker-compose
- `dm` is shorthand for docker-machine
- `docker-clean-images` saves hard drive space by removing unused Docker images
- `docker-clean-containers` removes unused containers
- `dme <docker machine name>` sets the Docker Machine environment to manage a different host
- `dmu` unsets the Docker Machine environment so it manages the local host again

#### Stats
- `mem` shows meomry usage
- `disk` shows disk usage

#### Process management
- `process-from-tcp-port <port number>` will find processes using the specified port
- `kill-process-hard <PID>` will forcefully kill a process identified by PID

#### Other shortcuts
- `c` clears the terminal
- `ni` is `npm install`
- `nu` is `npm uninstall`
- `..` does `cd ..`
