# Dotfiles and setup scripts

![Functions usage example](./readme-media/functions-usage-example.gif)

## Basic requirements

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

Docker Machine does not provide commands for exporting and importing information about servers it created (the ones visible when using `docker-machine ls`). So [there's a tool for that](https://github.com/bhurlow/machine-share/). Keep in mind the `machine-export` command will also archive private keys from the ~/.docker/machine/certs directory. It's not safe to move an archive like this between machines and there's rarely a need to do so. But if it's required (like when I was transfering my development environment from my local Macbook Air to an AWS VPS) it can be useful. `machine-share` is a npm package.

### Basic entry files to setup up a new machine

#### Dotfiles

For a full list of options, run `./install-dotfiles -h`.

**Primary usage:**

Run `./install-dotfiles dotfiles && . "~/.zshrc"` first and provide a path to the dotfiles directory as the first parameter. The dotfiles directory will be copied into the user's directory under `~/dotfiles` and its `install` file linked to the system (inside `~/.zshrc` on macOS by default, check the home directory (`cd ~`) to make sure or let `install-dotfiles` create `~/.zshrc` for you) to run on every system boot. Default dotfiles are provided alongside this README.md, inside the `dotfiles` directory.

The script also installs recommended auxiliary scripts. To turn this feature off, add the `-na` flag.

#### Software installations

Run `./install-aux-scripts installations` to get an interactive list of interactive and non-interactive "installers" available inside the `/installations` directory. The recommended order of installation is indicated by installer names which directly correspond to files inside the directory containing installers. All installers must be executable (use `chmod u+x -R "$(pwd)/installations"` to make all files executable). A special file named `.post-install-each` can be placed inside the installations directory or any of its subdirectories. It will be executed after every successfull installer execution.

### Helpful functions

All extra functions from dotfiles are available under the "ą\_\_" (alt+a on macOS followed by two underscores) prefix for easier distinction in the shell. They're also all available without the prefix.

#### `ą__edit-directory <optional path>`

Opens a directory using the `editor.py` handler. By default, the directory will open in VSCode. If no directory is given, will open the current directory (cwd).

#### `ą__add-all-keys`

Executing `add-all-keys <keys>` will add all private keys inside the `keys` directory to the current ssh agent. The script omits files ending with `.pub`, assuming those contain only public keys.

#### `ą__local-forward` and `local-forward-stop`

These functions make it easier to setup tunnels to localhost ports on a remote machine to the same local port on the caller. By default, the remote host is identified using a global variable `DEVELOPMENT_MACHINE_SSH_HOST`. The variable's value is `development-machine` by default and references a host inside ~/.ssh/config, so it must be defined there. `local-forward` makes using a VPS as a remote development machine much easier. For example, it's very easy to test a website on `development-machine` remotely and privately on port 3000 by executing `local-forward 3000`. To add more ports, execute the function with ports as parameters. To replace old ports with new ones, add a `-r` flag and to remove all ports, use the `-r` without providing any ports as parameters or execute `local-forward-stop`. To use a different host, use `--host <host>`.

#### `ą__keygen <path to private key>`

Will generate a new private and public key pair. The private key will be located at the provided path and its public key right next to it with a ".key" suffix.

#### `ą__key-fingerprint <path to public key>`

Will return the md5 representation of a key which is used on sites such as GitHub.

#### `ą__dev-term`

Opens a [Eternal Terminal (et)](https://mistertea.github.io/EternalTerminal/) shell in the terminal and logs into `DEVELOPMENT_MACHINE_SSH_HOST` which is equal `development-machine` (defined inside `~/.ssh/config`).

Note: ET has one significant advantage over [Mosh](https://mosh.org/) - it's possible to still scroll the terminal in macOS and see previous commands when using it.

#### `ą__git-config-user`

Sets git user name and email for local git repository. Useful when managing multiple git repositories with multiple git users. For example, a private git user and a company git user. Git uses this configuration to author new commits.

#### Docker commands

- `d` is shorthand for docker
- `dc` is shorthand for docker-compose
- `dm` is shorthand for docker-machine
- `docker-clean-images` saves hard drive space by removing unused Docker images
- `docker-clean-containers` removes unused containers
- `dme <docker machine name>` sets the Docker Machine environment to manage a different host
- `dmu` unsets the Docker Machine environment so it manages the local host again

#### Stats

- `mem` shows memory usage
- `disk` shows disk usage

#### Process management

- `process-from-tcp-port <port number>` will find processes using the specified port
- `kill-process-hard <PID>` will forcefully kill a process identified by PID

#### Other shortcuts

- `c` clears the terminal
- `ni` is `npm install`
- `nu` is `npm uninstall`
- `..` does `cd ..`

## Adding convenience scripts

File with the following contents can be double clicked and will open a directory or file in VSCode (defined in `editor.py`):

```
#!/bin/bash --login
edit-directory "DIRECTORY_PATH"
```

File with the following contents can be double clicked and will add all ssh keys in the directory:

```
#!/bin/bash --login
add-all-keys "SSH_KEYS_PATH"
```

Such files can be grouped into a directory and placed in macOS's dock for quick access.

## Easier handling of multiple GitHub accounts

Inside ~/.ssh/config, hosts starting with github.com have a special meaning. They're used for cloning and for interacting with GitHub repos using different private keys. For example, `git clone git@github.com-key1:user1/somerepo.git`. Git clone will then save the custom host as upstream, `origin` remote, so this is the only modification required to use git normally while supporting multiple GitHub accounts.

```
Host github.com-key1
	HostName github.com
	User user1
	IdentityFile "/Users/user/.ssh/key1"

Host github.com-key2
	HostName github.com
	User user2
	IdentityFile "/Users/user/.ssh/key2"
```

To ensure that commit author and commiter are the same in GitHub:
`GIT_COMMITTER_NAME='user1' GIT_COMMITTER_EMAIL='user1email' git commit --author 'user1 <user1email>'`

## Basic ~/.ssh/config parameters

```
Host development-machine
	HostName someinstancename.eu-west-1.compute.amazonaws.com
	User ubuntu
	IdentityFile "/Users/user1/.ssh/key"
	ServerAliveInterval 60
```
