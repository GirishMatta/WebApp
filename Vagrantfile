VAGRANTFILE_API_VERSION = "2"
VAGRANT_BOX_NAME = "gusztavvargadr/windows-server"
VAGRANT_BOX_VERSION = "1809.0.1901-standard-core"
DBSERVERNAME = "DBServer01"
WEBSERVERNAME = "WebServer01"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.network "private_network", type: "dhcp"
    
    config.vm.define "db" do |db|
        db.vm.box = VAGRANT_BOX_NAME
        db.vm.box_version = VAGRANT_BOX_VERSION
        db.vm.communicator = "winrm"
        db.vm.hostname = DBSERVERNAME

        db.vm.provider :virtualbox do |v|
            v.memory = "1024"
            v.name = DBSERVERNAME
        end

    end

    config.vm.define "web" do |web|
        web.vm.box = VAGRANT_BOX_NAME
        web.vm.box_version = VAGRANT_BOX_VERSION
        web.vm.communicator = "winrm"
        web.vm.hostname = WEBSERVERNAME

        web.vm.provider :virtualbox do |v|
            v.memory = "512"
            v.name = WEBSERVERNAME
        end

    end



end
