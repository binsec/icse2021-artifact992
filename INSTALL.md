***RUSTInA*** is supplied as an self-contained [AppImage](bin/rustina-x86_64.AppImage) (**Linux** equivalent of `.exe` on **Windows**).
It should be run in a `x86_64` **Ubuntu** *18.04* environment to work properly.

In addition to the *AppImage* itself, we released a [**docker** container](https://github.com/binsec/icse2021-artifact992/releases/download/1.0/icse2021-artifact992.tar.gz) and a [**VirtualBox** image](https://github.com/binsec/icse2021-artifact992/releases/download/1.0/icse2021-artifact992.ova) "ready-to-use".
*Container and Appliance only wrap the content of the repository with the dependencies resolved.*

The setup will depend on the choosen method:

# Ubuntu 18.04 user

*AppImage* is working off-the-shelf.
Surrounding scripts require:
- **make**
- **python** (either 2 or 3) with **pandas** and **tabulate**

Running the following will make sure dependencies are installed:
```shell
sudo apt-get install make python python-pandas python-tabulate
```

# Docker user

The container is available in the [release panel](https://github.com/binsec/icse2021-artifact992/releases/tag/1.0) ([download](https://github.com/binsec/icse2021-artifact992/releases/download/1.0/icse2021-artifact992.tar.gz)).

In a terminal, use the following to install the container:
```shell
docker load < icse2021-artifact992.tar.gz
```
Run the following to start an ephemeral (`--rm`) container:
```shell
docker run --rm -ti icse2021-artifact992
```
The content of the repository is ready in the home directory.

#### Shared directory

It may be usefull to share files with the host system.
The additional argument `--mount` ([documentation](https://docs.docker.com/storage/bind-mounts/)) can help.
The following command will bind the current host directory (`$(pwd)`) to the docker `/shared` directory:
```shell
docker run --rm --mount type=bind,source="$(pwd)",target=/shared -ti icse2021-artifact992
```



# VirtualBox user

The image is available in the [release panel](https://github.com/binsec/icse2021-artifact992/releases/tag/1.0) ([download](https://github.com/binsec/icse2021-artifact992/releases/download/1.0/icse2021-artifact992.ova)).

In **VirtualBox**, select **File**, **Import Appliance...** and then browse to the `icse2021-artifact992.ova`. Select **Next** and finaly **Import**.
Alternatively, double-click on the file `icse2021-artifact992.ova` and select **Import**.

Starting the virtual machine will auto-log as an admin user `devs`. The password `admin` should never be required.
The content of the repository is ready in the home directory.

#### Shared directory

It may be usefull to share files with the host system.
To mount a shared directory, go **Devices**, **Shared Folders**, **Shared Folders Settings**. Click on **Add a new shared folder** and browse to the desired location. Give it a name (*e.g.* `name1`). Do not tick **Read-only** nor **Auto-mount**.
In the virtual machine, create a directory, for instance:
```shell
mkdir name2
```
Then use the following to mount the directory:
```shell
sudo mount -t vboxsf name1 name2
```
