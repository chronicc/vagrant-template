# vagrant-template

A template for creating playgrounds with vagrant.

## Setup

- Install vagrant
- Install plugins: `vagrant plugin install vagrant-hostmanager vagrant-libvirt`

## Usage

All hosts are configured not to autostart to prevent shredding your workstation when you try to run `vagrant up`.

- Overview of available hosts: `vagrant status`
- Start a host: `vagrant up HOST`
- Stop a host: `vagrant destroy -f HOST`

## Environment Variables

### SSH Key

For linux nodes vagrant searches for a ssh key in `~/.ssh/id_rsa`. If it finds one the key is enabled as authorized for connecting as root user via ssh. If you want to use a different key, you can set the environment variable `VAGRANT_SSH_KEY` to the path of your key.

### Resource Configuration

You can set a global amount of resources which is used for every node. Possible variables are:

- `VAGRANT_VM_CPUS`: The number of cpus. Defaults to 4.
- `VAGRANT_VM_MEMORY`: The amount of memory in MB. Defaults to 4096.

### Dissable Checkpoint

- `VAGRANT_CHECKPOINT_DISABLE`: If this is set to `true`, Vagrant will not check if there is a newer version of itself available.

## Nodes configuration

- `aliases`: A list of aliases for the node. These aliases can be used to connect to the node via ssh.
- `box`: A vagrant box. See [vagrant cloud](https://app.vagrantup.com/boxes/search) for available boxes.
- `guest`: The guest operating system of the node. See [vagrant documentation](https://www.vagrantup.com/docs/providers/) for available guests. Defaults to `linux`.
- `hostname`: Overwrite the hostname of the node here. If you don't set this variable the hostname is set to the name of the node.
- `ip`: A static ip address for the node. You need to ensure that there are no ip conflicts with other nodes.
- `name`: A generic name for the node used as identifier.
- `version`: The version of the vagrant box.
- `provisioners`: A list of provisioners to run on the node. These provisioners are provided by this repository and not by vagrant itself.

## Provisioners

Provisioner arguments must be provided as a list of strings in the order described here.

#### Windows

- `change_admin_pass`: Change the password of the Administrator user. Args: `password`
- `create_admin_user`: Create a new user with administrator privileges. Args: `username`, `password`
- `install_chocolatey`: Install [chocolatey](https://chocolatey.org/).
- `install_netframework`: Install .NET Framework. Args: `version`
- `install_python`: Install python 3.
- `reboot`: Reboot the node.

## License

MIT
