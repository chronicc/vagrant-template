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
