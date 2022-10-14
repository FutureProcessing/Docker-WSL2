# Docker Engine on WSL2

## Windows 10 Configuration

All commands should be run in shell with __administrator privileges__.
PowerShell was used to run the commands

## Install WSL2 + Ubuntu

Microsoft simplified installation of WSL2 starting with Windows 10 version 2004 (see [documentation](https://docs.microsoft.com/en-us/windows/wsl/install) for details).

1. Open PowerShell terminal
1. Install **Ubuntu 20.04 LTS** distribution
   ```
   wsl --install --distribution Ubuntu-20.04
   ```
1. Reboot
1. Enter new UNIX username and password (new user will be created in Linux)
1. Enjoy new Linux instance

## Docker Engine

**Important: To start the Docker service automatically follow the "Run Docker
when a WSL instance launches" section after successful installation**

Choose and execute one of the available installation methods: scripted or
manually.

### Scripted installation (preferred)

1. Open PowerShell terminal
1. Download **[setup.sh](./setup.sh)** script
   ```
   Invoke-WebRequest -uri https://git.future-processing.com/docker-training/wsl2/-/raw/master/setup.sh -OutFile setup.sh
   ```
1. Execute the script
   ```
   wsl -- ./setup.sh
   ```
   Expected output:
   ```
   Docker Server version is xx.xx.xx
   ```
1. Stop WSL session
   ```
   logout
   ```
1. Start WSL session
   ```
   wsl
   ```
1. Enjoy Docker Engine

### Manual installation

1. Start WSL session
   ```
   wsl
   ```
1. Download PGP Public Key
   ```
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --quiet --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
   ```
1. Add APT source list
   ```
   echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
   ```
1. Update APT package information
   ```
   sudo apt update --yes
   ```
1. Install Docker Community Edition
   ```
   sudo apt install --yes docker-ce
   ```
1. Add current user do the `docker` group
   ```
   sudo usermod -aG docker $(whoami)
   ```
   Note: For the new group to be used by your system, it is necessary to log out
1. Stop WSL session
   ```
   logout
   ```
1. Start WSL session
   ```
   wsl
   ```
1. Start Docker service
   ```
   sudo service docker start
   ```
1. Check server version
   ```
   docker info  --format "Docker Server version is {{.ServerVersion}}"
   ```
   Expected output:
   ```
   Docker Server version: xx.xx.xx
   ```

### Run Docker when a WSL instance launches (the right way)

By default operating system running in WSL does not start services
automatically so Docker service is not running after reboot. One could execute
`sudo service docker start` command each time or automate that action using
following instruction.

#### Windows 11
If you have installed Windows 11, you can start docker using the Boot setting ([link](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#boot-settings)).
In WSL instance edit file `/etc/wsl.conf` and add the following content (file is
also accessible via `\\wsl$\<distro-name>\etc\wsl.conf`)

```ini
[boot]
command = service docker start
```

More information available [here](https://docs.microsoft.com/en-us/windows/wsl/wsl-config).

#### Windows 10
In previous versions of Windows you can use `.profile` file to automatically start the service if it's not running.
Add the following line to `~/.profile` file (`\\wsl$\<distro-name>\home\<username>\.profile`) or any shell configuration file you're using (i.e. `.bash_profile`).
```
(sudo service docker status || sudo service docker start) > /dev/null
```


### Ubuntu 20.10+ nftables issue

In ubuntu 20.10* due to incompatibility of Docker Engine with nftables, legacy
iptables should be used. To switch default iptables execute the following command and choose **iptables-legacy**
```
sudo update-alternatives --config iptables
```

## Visual Studio Code

Download, install and run Visual Studio Code\
https://code.visualstudio.com/Download

### Remote - WSL

1. Install [Remote WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extension.\
   (Press `ctrl+p` and execute `ext install ms-vscode-remote.remote-wsl`)
1. In the bottom left corner, press the green button\
   ![](images/vscode-remote-select.png)
1. Select `Remote WSL: New Window`\
   ![](images/vscode-remote-wsl2.png)

### Windows terminal

1. Download and install Windows Terminal\
   https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701
1. Open Windows Terminal and select Ubuntu
   ![](images/windows-terminal-ubuntu.png)

### Recomended plugins

- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)

## First Container

1. In Ubuntu execute following command
   ```
   docker run -d -p 80:80 docker/getting-started
   ```

   Expected output example
   ```
   Unable to find image 'docker/getting-started:latest' locally
   latest: Pulling from docker/getting-started
   aad63a933944: Pull complete
   b14da7a62044: Pull complete
   343784d40d66: Pull complete
   6f617e610986: Pull complete
   Digest: sha256:d2c4fb0641519ea208f20ab03dc40ec2a5a53fdfbccca90bef14f870158ed577
   Status: Downloaded newer image for docker/getting-started:latest
   ad77e95c178b1bdd3c752b45223e40b2f9a964a99cd6ee611043805518631d42
   ```
1.  Visit http://localhost/tutorial

## Docker Compose

1. Create CLI plugins directory:
   ```
   mkdir -p ~/.docker/cli-plugins
   ```
1. Download docker-compose executable:
   ```
   curl -L https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
   ```
1. Make docker-compose file executable:
   ```
   chmod +x ~/.docker/cli-plugins/docker-compose
   ```
1. Check installation correctness by viewing compose's version:
   ```
   docker compose version
   ```

   Expected example output:
   ```
   Docker Compose version v2.2.3
   ```
