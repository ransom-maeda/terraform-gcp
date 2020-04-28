# terraform-gcp

## Prerequisites
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/downloads.html)
3. Install [Docker](https://www.docker.com/products/docker-desktop)

### Set up GCP admin project, admin service account, and project
1. Create gcp.env file in terraform-gcp/configs directory
    ```
    cp terraform-gcp/gcp.env.template terrafrom-gcp/gcp.env
    ```
2. Update values in terraform-gcp/gcp.env with the appropriate values
3. Create tfvars file in terraform-gcp/workspace/tfvars
   ```
   cp terraform-gcp/workspace/tfvars/project.tfvars.template terraform/tfvars/${PROJECT_NAME}.tfvars
   ```
   Note: Be sure ${PROJECT_NAME} is same value as one set in terraform-gcp/gcp.env
4. Build Docker image and run
5. When prompted, authenticate seesion and provide access token

## Directory layout
```
├── terraform-gcp
│ ├── README.md
│ ├── Vagrantfile
│ ├── Dockerfile
│ ├── workspace
│ │ ├── modules
│ │ ├── tfvars
│ │ |  ├── project.tfvars.template
│ │ ├── project.tf
│ │ ├── variables.tf
│ │ ├── outputs.tf
│ ├── configs
│ │ ├── gcp.env.template
│ ├── bin 
│ │ ├── entrypoint.sh
```
