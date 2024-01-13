class Windows
  def self.change_admin_pass(config, password)
    config.vm.provision "change_admin_pass",
      inline: %Q(
        net user Administrator #{password}
      ),
      privileged: true,
      run: "once",
      type: "shell"
  end

  def self.create_admin_user(config, username, password)
    config.vm.provision "create_admin_user",
      inline: %Q(
        net user #{username} #{password} /add /expires:never
        net localgroup administrators #{username} /add
      ),
      privileged: true,
      run: "once",
      type: "shell"
  end

  def self.install_chocolatey(config)
    config.vm.provision "install_chocolatey",
      path: "https://chocolatey.org/install.ps1",
      privileged: true,
      run: "once",
      type: "shell"
  end

  def self.install_netframework(config, version)
    config.vm.provision "install_netframework",
      args: "-version #{version}",
      path: "./vagrant_extensions/install_netframework.ps1",
      privileged: true,
      reboot: true,
      run: "once",
      type: "shell"
  end

  def self.install_python(config)
    config.vm.provision "install_python",
      inline: "choco install -y python3",
      privileged: true,
      run: "once",
      type: "shell"

    config.vm.provision "create_symlink_for_python",
      inline: %Q(
        New-Item -ItemType SymbolicLink \
          -Path C:\\ProgramData\\chocolatey\\bin\\python.exe \
          -Target C:\\ProgramData\\chocolatey\\bin\\python3.12.exe
      ),
      privileged: true,
      run: "once",
      type: "shell"

    config.vm.provision "display_python_version",
      inline: "python --version",
      run: "always",
      type: "shell"
  end

  def self.reboot(config)
    config.vm.provision "reboot",
      inline: "",
      privileged: true,
      run: "once",
      reboot: true,
      type: "shell"
  end
end
