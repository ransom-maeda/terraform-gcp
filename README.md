# terraform-gcp

## Prerequisites
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/downloads.html)
3. Install [Docker](https://www.docker.com/products/docker-desktop)

### Set up GCP account
[GCP Resource](https://cloud.google.com/functions/docs/quickstart)

## Directory layout
```
├── terraform-gcp
│ ├── README.md
│ ├── Vagrantfile
│ ├── Dockerfile
│ ├── workspace
│ │ ├── modules
│ │ ├── tfvars
│ │ ├── project.tf
│ │ ├── variables.tf
│ │ ├── outputs.tf
│ ├── bin
│ │ ├── setup.sh
│ │ ├── init.sh
