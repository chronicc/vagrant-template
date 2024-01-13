class Linux
  def self.root_ssh_key(config, *key_paths)
    [*key_paths, nil].each do |key_path|
      if key_path.nil?
        fail "Public key not found at following paths: #{key_paths.join(", ")}"
      end

      full_key_path = File.expand_path(key_path)

      if File.exists?(full_key_path)
        config.vm.provision "file",
          destination: "/home/vagrant/root_pubkey",
          run: "once",
          source: full_key_path

        config.vm.provision "shell",
          inline: %Q(
            echo 'Creating /root/.ssh/authorized_keys with #{key_path}' \
            && mkdir -p /root/.ssh/ \
            && rm -f /root/.ssh/authorized_keys \
            && mv /home/vagrant/root_pubkey /root/.ssh/authorized_keys \
            && chown root:root /root/.ssh/authorized_keys \
            && chmod 600 /root/.ssh/authorized_keys \
            && rm -f /home/vagrant/root_pubkey \
            && echo 'Done'
          ),
          privileged: true,
          run: "once"
        break
      end
    end
  end
end
