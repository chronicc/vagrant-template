# frozen_string_literal: true

require_relative 'vagrant_extensions/linux'
require_relative 'vagrant_extensions/windows'

Vagrant.require_version '>= 2.4.0'
Vagrant.configure('2') do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.ignore_private_ip = true
  config.hostmanager.include_offline = false

  config.vagrant.plugins = %w[
    vagrant-hostmanager
    vagrant-libvirt
  ]

  nodes = YAML.load_file('vagrant_extensions/nodes.yml')
  nodes.each do |node|
    config.vm.define node['name'].to_s, autostart: false do |n|
      configure_common n, node
      configure_linux n if node['guest'] == 'linux' || node['guest'].nil?
      configure_windows n, node if node['guest'] == 'windows'

      n.vm.provider :libvirt do |libvirt|
        libvirt.cpus = ENV['VAGRANT_VM_CPUS'] || '4'
        libvirt.memory = ENV['VAGRANT_VM_MEMORY'] || '4096'
      end
    end
  end
end

def configure_common(node_config, node)
  node_config.vm.box = node['box']
  node_config.vm.box_version = node['version']
  node_config.vm.hostname = (node['hostname'] || node['name'])
  if node.include? 'ip'
    node_config.vm.network 'private_network', ip: node['ip'], netmask: node['netmask']
  else
    node_config.vm.network 'private_network', type: 'dhcp'
  end
  node_config.hostmanager.aliases = node['aliases']
end

def configure_linux(node_config)
  Linux.root_ssh_key node_config, ENV['VAGRANT_SSH_KEY'] || '~/.ssh/id_rsa.pub'
end

def configure_windows(node_config, node)
  node_config.winrm.max_tries = 300
  node_config.winrm.retry_delay = 2
  node_config.vm.communicator = 'winrm'
  node_config.vm.guest = :windows
  node['provisioners'].each do |provisioner|
    Windows.send provisioner['name'], node_config, *provisioner['args']
  end
end
