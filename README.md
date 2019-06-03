# Techinical assessment

# Web App

## Tools and technologies used

### Application development
- ASP.NET MVC Web Application, SSDT
- Build tools- Visual Studio 2017 Build tools with Web and Data workload
- Deployment tools - DAC Framework 17.1

### Infrastructure automation
- Vagrant 2.2.4
- Vagrant box
    - VM box - gusztavvargadr/windows-server
    - Vm box version - 1809.0.1901-standard-core

### Configuration management
- PowerShell
- PowerShell DSC
- Chocolatey package manager

### IDE
- Visual Studio 2017
- Visual Studio Code 1.3

### Source control
- Git

### SQL Server
- Microsoft SQL Server 2017 Express

### Web Server
- IIS 

### Virtual infrastructure
- Hypervisor - Oracle VirtualBox 6.0
- Virtual Machines - Windows Server 2019 Server Core

## Usage
- Add Vagrant box gusztavvargadr/windows-server version 1809.0.1901-standard-core 
    *PS> vagrant box add gusztavvargadr/windows-server --box-version 1809.0.1901-standard-core*
(https://app.vagrantup.com/gusztavvargadr/boxes/windows-server/versions/1809.0.1901-standard-core)
- Clone the repo https://github.com/GirishMatta/WebApp.git
    *PS> git clone https://github.com/GirishMatta/WebApp.git*
- Navigate to the WebApp folder and run vagrant up
    *PS> vagrant up*
- Browse the URL output at the end of the *vagrant up* command to access the application

The *vagrant up* command takes approximately 35-40 mins to complete, mostly for the VS 2017 Build tools installation. 
