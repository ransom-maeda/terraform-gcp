# terraform-gcp

## Prerequisites
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/downloads.html)
3. Install [Docker](https://www.docker.com/products/docker-desktop)

### Set up GCP account
[GCP Resource](https://cloud.google.com/functions/docs/quickstart)
1. Install gcloud
2. Run `gcloud init` and follow steps to authenticate and create
   a new root project
3. Create admin service account
    ```
    gcloud iam service-accounts create [SA NAME] \
        --description "[SA DESCRIPTION]" \
        --display-name "[SA-DISPLAY-NAME]"
    ```   
4. Generate service account key
    ```
    gcloud iam service-accounts keys create OUTPUTFILE \
        --iam-account=[IAM_ACCOUNT]
    ```
5. Move service account key to terraform-gcp/access directory
6. Create gcp.env file in terraform-gcp/configs directory
    ```
    cp terraform-gcp/gcp.env.template terrafrom-gcp/gcp.env
    ```
7. Update values in terraform-gcp/gcp.env with the appropriate values
8. Build Docker image and run
9. Run init.sh to setup environment
    ```
    ./root/terraform-gcp/bin/init.sh
    ```

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
│ ├── access
│ │ ├── <GCP-access-key>.json
│ ├── configs
│ │ ├── gcp.env.template
│ ├── bin
│ │ ├── setup.sh
│ │ ├── init.sh
