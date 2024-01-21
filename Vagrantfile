require_relative "vagrant_extensions/linux"
require_relative "vagrant_extensions/windows"

Vagrant.require_version ">= 2.4.0"
Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  config.vagrant.plugins = [
    "vagrant-hostmanager",
    "vagrant-libvirt",
  ]

  nodes = YAML.load_file("vagrant_extensions/nodes.yml")
  nodes.each do |node|
    config.vm.define "#{node["name"]}", autostart: false do |n|
      n.vm.box = node["box"]
      n.vm.box_version = node["version"] if node["version"]
      n.vm.network "private_network", ip: node['ip'] if node["ip"]

      if node["hostname"]
        n.vm.hostname = node["hostname"]
      else
        n.vm.hostname = node["name"]
      end

      if node["aliases"]
        n.hostmanager.aliases = node["aliases"]
      end

      if node["guest"] == "linux" || node["guest"] == nil
        Linux.root_ssh_key n, ENV["VAGRANT_SSH_KEY"] || "~/.ssh/id_rsa.pub"
      end

      if node["guest"] == "windows"
        n.winrm.max_tries = 300
        n.winrm.retry_delay = 2
        n.vm.communicator = "winrm"
        n.vm.guest = :windows
        for provisioner in node["provisioners"] do
          Windows.send provisioner["name"], n, *provisioner["args"]
        end
      end

      n.vm.provider :libvirt do |libvirt|
        libvirt.cpus = ENV["VAGRANT_VM_CPUS"] || "4"
        libvirt.memory = ENV["VAGRANT_VM_MEMORY"] || "4096"
      end
    end
  end
end
