pb-owncloud
===========

A Vagrant config for deploying an ownCloud instance on ubuntu with nginx, php-fpm and mySql

Installation
----------------
please make sure that you have VirtualBox and Vagrant installed.


clone this repo with
 
    $ git clone https://github.com/koellcode/pb-owncloud

jump in the cloned folder

    $ cd pb-owncloud
    
init and update the submodules

    $ git pull && git submodule init && git submodule update && git submodule status

start vagrant

    $ vagrant up
    
At the first time, the script downloads the virtual machine image. After some logs later you should be able to reach
your fresh owncloud instance at

    http://localhost:8080
    
in your browser.
