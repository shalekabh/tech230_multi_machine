# Configure this so that 2 virtual machines are created . We need a new "do" block
Vagrant.configure("2") do |config|
  config.vm.define "app" do |app|
    # Chane all the configs to app if the fall under the define app scope
    app.vm.box = "ubuntu/bionic64" # changed from xenial64 
    app.vm.network "private_network", ip:"192.168.10.100"
  # Put the app folder from our local machine to the VM

    app.vm.synced_folder "app", "/home/vagrant/app"

    #provision the VM to have nginx
    #config.vm.provision "shell", inline: <<-SHELL
    #sudo apt-get update -y
    #sudo apt-get upgrade -y
    #sudo apt-get install -y nginx
    #sudo systemctl enable nginx
    #sudo systemctl start nginx
    #cd tech230_app_deployment
    #cd app
    #sudo apt-get install nodejs -y
    #sudo apt-get install python-software-properties
    #curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    #sudo apt-get install nodejs -y
    #sudo npm install pm2 -g
    #npm start

  #SHELL

    app.vm.provision "shell", path: "provisions.sh"
  end  

  config.vm.define "db" do |db|
    
    db.vm.box = "ubuntu/bionic64"
    db.vm.network "private_network", ip:"192.168.10.150" # Makes sure to change the IP address from the app section

    db.vm.synced_folder "environment", "/home/vagrant/environment"
    db.vm.provision "shell", path: "provisionsdb.sh"
  
  end  



end
