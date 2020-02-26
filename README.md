# Barrique API

[![Build Status](https://tgwconsulting.visualstudio.com/barrique/_apis/build/status/tgw-auth-build-master?branchName=master)](https://tgwconsulting.visualstudio.com/barrique/_build/latest?definitionId=35&branchName=master)

This document provides an overview of the Barrique REST API for
web, mobile, and native applications accessing TGW services.  You
will also find instructions for setting up development and test environments.

**Requirements:** Ruby ~> v2.5.4, Rails ~> v5.2.2, MySQL Server ~> 5.7, Docker Desktop ~> 2.2.0.0

## Development Prerequisites

The following prerequisites should be installed on your workstation before working on the
Barrique API project:

* Ruby Version Manager (http://www.rvm.io/)
* MySQL Server CE (https://dev.mysql.com/downloads/)
* MySQL Workbench (optional)
* Docker CE (https://www.docker.com/)
* Kompose (https://github.com/kubernetes/kompose)
* Editor or IDE (suggest RubyMine from JetBrains)

### Setting Up Ruby Environment

These instructions assume you have installed the Ruby Version Manager on your workstation.  To install
Ruby:

    $ rvm install 2.6.3

RVM will install the Ruby interpreter.  It's good practice to use gemsets to keep various projects 
separated to reduce the likelihood of Ruby gem version conflicts between your projects.  The following
snippet can be used to create your environment:

    $ rvm use 2.6.3
    $ rvm gemset create tgw
    $ rvm use 2.6.3@barrique
    $ gem install bundler
    
You can set your gemset to be the default by using the command:

    $ rvm use 2.6.3@barrique --default
    
### Setting Up Docker Environment

After you install Docker Desktop for Mac, be sure to enable Kubernetes.  You will need to install 
a tool for deploying your application.

    $ brew install kompose
    
### Setting Up Development Project

Once you have your Ruby environment set up, it's time to download the source code and finish setting
things up. From the work directory where you plan to save the source code:

    $ git clone git@github.com:arktos65/barrique-api.git
    $ cd barrique-api
    $ bundle install
    $ brew install yarn
    
The previous commands clone a copy of the `barrique-api` repository from Github to your local work
directory.  Then you change directory into the source code root directory and run `bundler` to 
install all the required Ruby gems for the project.  The `Gemfile` provides the list of gems and
version constraints to be installed.

You also should install the git hooks for the project.  From the root source code directory:

    $ ./install-hooks.sh
    
This script will install the git hooks in their correct location.

### Network local hosts

Edit your /etc/hosts file and add the following line:

    127.0.0.1 barrique-db barrique-server barrique-cache

This host file entry will allow you to run a development instance of your Barrique services in Docker.

### Initialize Database Environment

These instructions assume you're running MySQL as a containerized service defined in the project's
`docker-compose.yml` file..  Take a look at the `config/database.yml` file to see what you should 
set your database credentials to.

From the root source code directory:

    $ rvm use 2.6.3@barrique
    $ docker-compose up barrique-db
    
Open a new terminal window and then:

    $ rvm use 2.6.3@barrique
    $ rails db:create db:migrate
    $ rails db:seed
    
You should see some messages starting with:

    Created database 'tgw-auth_development'
    Created database 'tgw-auth_test'
    Task seed:
     * [  ] User (seed)
     * [OK] User (seed)
     * [  ] Admin (seed)
     * [OK] Admin (seed)

This means your database environment has been successfully initialized.

### Test Barrique Service

The final step is to verify everything works properly.  From the root source code directory:

    $ rails server

You should see:

    => Booting Puma
    => Rails 5.2.2.1 application starting in development
    => Run `rails server -h` for more startup options
    Puma starting in single mode...
    * Version 3.12.1 (ruby 2.5.1-p57), codename: Llamas in Pajamas
    * Min threads: 5, max threads: 5
    * Environment: development
    * Listening on tcp://localhost:3000
    Use Ctrl-C to stop
    
Now open your web browser and type in `http://localhost:3000/api/v1/ping`.  If the API server is healthy,
you should receive a JSON response that looks something like:

    {
      "service":"Barrique OAuth Service::API",
      "version":"0.1.0",
      "rails_version":"5.2.0",
      "ruby_version":"2.5.1",
      "database_connection":"OK",
      "timestamp":"2018-08-01T14:09:34.018-07:00"
    }
    
The JSON may be formatted to display as a single line -- that is ok.  You can stop the API server
by pressing CTRL-C in the terminal window where it is running.

### User Login

The OAuth development environment is seeded with a user for testing purposes. You can login by
pointing your web browser at `http://localhost:3000/users/sign_in`.

**Development Credentials**

    Username: user@tgwconsulting.co
    Password: password123
    
These credentials are only available on your development instance.

### Admin Login

The OAuth development environment is seeded with an admin user for testing purposes.  You can
login by pointing your web browser at `http://localhost:3000/admins/sign_in`.

**Development Credentials**

    Username: admin@tgwconsulting.co
    Password: password123
    
These credentials are only available on your development instance.

### OAuth Applications

Admin users can manage OAuth applications registered with this provider by pointing your web
browser at `http://localhost:3000/oauth/applications`.

## Generating API Documentation

This project using `rswagger` for generating API developer documentation.  To update the documentation:

    rake rswag:specs:swaggerize
    
The documentation is accessible at `http://localhost:3000/api-docs`.

## Building a Docker Image

By design, when Github code is merged to the `master` branch, a build job is triggered on Azure DevOps to build
a Docker image from that branch and is pushed up to Docker Hub.  Code merged to the `stage` branch will automatically
produce a stage environment Docker image.  

If you wish to manually build an image, use the following command from the project root directory:

    $ docker-compose build
    
The resulting image will be stored in your local Docker image repository.  The image will be titled
`tgwconsulting/tgw-oauth:latest`.

## Running Your Development Environment

This project uses Docker Compose making it very simple to start your development environment with all the 
associated services in various containers.

Starting the Barrique Auth service:

    $ kompose up
    
    INFO Build key detected. Attempting to build and push image 'tgwconsulting/barrique-auth:latest' 
    INFO Building image 'tgwconsulting/barrique-auth:latest' from directory 'barrique-auth' 
    INFO Image 'tgwconsulting/barrique-auth:latest' from directory 'barrique-auth' built successfully 
    INFO Pushing image 'tgwconsulting/barrique-auth:latest' to registry 'docker.io' 
    INFO Attempting authentication credentials 'https://index.docker.io/v1/ 
    INFO Successfully pushed image 'tgwconsulting/barrique-auth:latest' to registry 'docker.io' 
    INFO We are going to create Kubernetes Deployments, Services and PersistentVolumeClaims for your Dockerized application. If you need different kind of resources, use the 'kompose convert' and 'kubectl create -f' commands instead. 
     
    INFO Deploying application in "barrique-dev" namespace 
    INFO Successfully created Service: barrique-cache     
    INFO Successfully created Service: barrique-db        
    INFO Successfully created Service: barrique-server    
    INFO Successfully created Deployment: barrique-cache  
    INFO Successfully created Deployment: barrique-db     
    INFO Successfully created PersistentVolumeClaim: barrique-data of size 100Mi. If your cluster has dynamic storage provisioning, you don't have to do anything. Otherwise you have to create PersistentVolume to make PVC work 
    INFO Successfully created Deployment: barrique-server 
    
    Your application has been deployed to Kubernetes. You can run 'kubectl get deployment,svc,pods,pvc' for details.
    
To perform a graceful shutdown of your development environment:

    $ kompose down
    
    INFO Deleting application in "barrique-dev" namespace 
    INFO Successfully deleted Service: barrique-cache     
    INFO Successfully deleted Service: barrique-db        
    INFO Successfully deleted Service: barrique-server    
    INFO Successfully deleted Deployment: barrique-cache  
    INFO Successfully deleted Deployment: barrique-db     
    INFO Successfully deleted PersistentVolumeClaim: barrique-data 
    INFO Successfully deleted Deployment: barrique-server 

### Testing OAuth Server

Once you have deployed the Rails application to your local Kubernetes cluster, you'll need to forward the port
to the `barrique-server` service.  This can be done with the command:

    $ kubectl port-forward deployment/auth-server 3000
    
Direct your web browser to `http://localhost:3000` to access the service.

### Examining a Docker Image

If you need to explore the contents of the Docker image, you may do so with the following command:

    $ docker run --rm -it --entrypoint=/bin/bash tgwconsulting/tgw-oauth
    
Docker will start a container with a `bash` shell.  This command is useful for checking service source code.


# License & Authors

- Author:: Sean M. Sullivan (<sean@tgwconsulting.co>)

```text
Copyright:: 2020 TGW Consulting, LLC.  All rights reserved.

This source code is proprietary, confidential information of TGW Consulting, LLC.
It contains TGW Consulting intellectual property, including trade secrets and
copyright-protected authorship, and may include patentable inventions. You may
not distribute this source code outside of TGW Consulting without express written
permission from management. TGW Consulting does not claim ownership of included
open source software components, which are subject to their own licenses.
```