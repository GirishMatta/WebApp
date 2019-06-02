VAGRANTFILE_API_VERSION = "2"
VAGRANT_BOX_NAME = "gusztavvargadr/windows-server"
VAGRANT_BOX_VERSION = "1809.0.1901-standard-core"
DBSERVERNAME = "DBServer01"
WEBSERVERNAME = "WebServer01"
MOFFOLDER = "C:\\TMP"
SERVICEACCOUNT = "DBServiceUser"
SERVICEPASS = "Pass!word1"
DATABASENAME = "CustomerDB"
DACPAC_PATH = "C:\\tmp\\**\\*.dacpac"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.network "private_network", type: "dhcp"
    
    config.vm.define "db" do |db|
        db.vm.box = VAGRANT_BOX_NAME
        db.vm.box_version = VAGRANT_BOX_VERSION
        db.vm.communicator = "winrm"
        db.vm.hostname = DBSERVERNAME

        # db.vm.provider :virtualbox do |v|
        #     v.memory = "1024"
        #     v.name = DBSERVERNAME
        # end

        # db.vm.provision "shell" do |s|
        #     p = File.expand_path("../", __FILE__)
        #     s.path = p + "\\Provisioning\\Scripts\\SqlDSCResources.ps1" 
        # end

        # db.vm.provision "shell" do |s|
        #     p = File.expand_path("../", __FILE__)
        #     s.path = p + "\\Provisioning\\Scripts\\InstallBuildTools.ps1"
        # end

        # db.vm.provision "shell" do |s|
        #     p = File.expand_path("../", __FILE__)
        #     s.path = p + "\\Provisioning\\DSC\\BuildApplications.ps1" 
        #     s.args = [MOFFOLDER]
        # end

        # db.vm.provision "shell" do |s|
        #     p = File.expand_path("../", __FILE__)
        #     s.path = p + "\\Provisioning\\DSC\\InstallConfigureSQLServer.ps1" 
        #     s.args = [MOFFOLDER, SERVICEACCOUNT, SERVICEPASS, DATABASENAME]
        # end

        # db.vm.provision "shell" do |s|
        #     p = File.expand_path("../", __FILE__)
        #     s.path = p + "\\Provisioning\\Scripts\\DeployDacPac.ps1" 
        #     s.args = [DACPAC_PATH, DATABASENAME]
        # end

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

        web.vm.provision "shell" do |s|
            p = File.expand_path("../", __FILE__)
            s.path = p + "\\Provisioning\\Scripts\\WebAdminDSCResources.ps1" 
        end
        
        web.vm.provision "shell" do |s|
            p = File.expand_path("../", __FILE__)
            s.path = p + "\\Provisioning\\DSC\\InstallConfigureWebServer.ps1"
            s.args = [MOFFOLDER, SERVICEACCOUNT, SERVICEPASS, DBSERVERNAME, DATABASENAME]
        end

        web.vm.provision "shell" do |s|
            p = File.expand_path("../", __FILE__)
            s.path = p + "\\Provisioning\\Scripts\\WebSiteWarmUp.ps1"
            s.args = [WEBSERVERNAME]
        end
                
    end
    
end
