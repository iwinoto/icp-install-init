# Please update the nodes info according to your laptop
nodes = [
  {:hostname => 'icp-worker1', :ip => '192.168.122.11', :box => 'ubuntu/xenial64', :cpu => 2, :memory => 4096},
  {:hostname => 'icp-worker2', :ip => '192.168.122.12', :box => 'ubuntu/xenial64', :cpu => 2, :memory => 4096},
  # Here, here, here, add more worker nodes here.
  # Provision script assumes Master node is the last node in the list.
  # In a minimal set up, this node is used for Master, Boot & Proxy
  {:hostname => 'icp-master', :ip => '192.168.122.10', :box => 'ubuntu/xenial64', :cpu => 2, :memory => 4096}
]

# Please update the icp_config according to your laptop network
icp_config = '
network_type: calico
network_cidr: 10.1.0.0/16
service_cluster_ip_range: 10.0.0.0/24
ingress_enabled: true
ansible_user: ubuntu
ansible_become: true
mesos_enabled: false
install_docker_py: true
'

# Please update if you want to use a specified version
icp_version = 'latest'

icp_hosts = "[master]\n#{nodes.last[:ip]}\n[proxy]\n#{nodes.last[:ip]}\n[worker]\n"
vagrant_hosts = "127.0.0.1 localhost\n"
nodes.each do |node|
  icp_hosts = icp_hosts + node[:ip] + "\n" unless (node == nodes.last && nodes.length != 1)
  vagrant_hosts = vagrant_hosts + "#{node[:ip]} #{node[:hostname]}\n"
end

Vagrant.configure(2) do |config|

  unless File.exists?('ssh_key')
    require "net/ssh"
    rsa_key = OpenSSL::PKey::RSA.new(2048)
    File.write('ssh_key', rsa_key.to_s)
    File.write('ssh_key.pub', "ssh-rsa #{[rsa_key.to_blob].pack("m0")}")
  end

  rsa_public_key = IO.read('ssh_key.pub')
  rsa_private_key = IO.read('ssh_key')

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell", inline: <<-SHELL
    echo "#{rsa_public_key}" >> /home/vagrant/.ssh/authorized_keys
    echo "#{vagrant_hosts}" > /etc/hosts
  SHELL

#  config.vm.provision "shell",
#    privileged: "true",
#    path: "provision-install_docker.sh"

  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.box_check_update = false
      nodeconfig.vm.network "private_network", ip: node[:ip]
      nodeconfig.vm.provider "virtualbox" do |virtualbox|
        virtualbox.gui = false
        virtualbox.cpus = node[:cpu]
        virtualbox.memory = node[:memory]
      end

      nodeconfig.vm.provision "shell",
        privileged: "true",
        path: "provision-configure_node.sh"

      if node == nodes.last
        nodeconfig.vm.provision "shell",
          privileged: "true",
          path: "provision-configure_master.sh"

        nodeconfig.vm.provision "shell", inline: <<-SHELL
          mkdir -p cluster
          echo "#{rsa_private_key}" > cluster/ssh_key
          echo "#{icp_hosts}" > cluster/hosts
          echo "#{icp_config}" > cluster/config.yaml
          #docker run -e LICENSE=accept -v "$(pwd)/cluster":/installer/cluster ibmcom/icp-installer:"#{icp_version}" install
        SHELL
      end
    end
  end

end
