# Badges

| fair-software.nl recommendations | Badge |
|:-|:-:|
| [1. Code Repository](https://fair-software.nl/recommendations/repository) | [![GitHub](https://img.shields.io/github/last-commit/nlesc/lokum)](https://img.shields.io/github/last-commit/nlesc/lokum) |
| [2. License](https://fair-software.nl/recommendations/license) | [![License](https://img.shields.io/github/license/nlesc/lokum)]((https://img.shields.io/github/license/nlesc/lokum)) |
| [3. Community Registry](https://fair-software.nl/recommendations/registry) | [![Research Software Directory](https://img.shields.io/badge/rsd-lokum-00a3e3.svg)](https://www.research-software.nl/software/lokum) |
| [4. Enable Citation](https://fair-software.nl/recommendations/citation) | [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3482939.svg)](https://doi.org/10.5281/zenodo.3482939) |
| [5. Code Quality Checklist](https://fair-software.nl/recommendations/checklist) | [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3754/badge)](https://bestpractices.coreinfrastructure.org/projects/3754)  |


# Lokum

This repository includes scripts to deploy a cluster with GlusterFS, Docker, Spark and JupyterHub services on bare-metal. Currently, it only supports Opennebula platform.

Lokum uses [emma](https://github.com/nlesc-sherlock/emma) ansible playbooks to deploy services.

In this `eecolidar-lokum` branch we have adapted and expanded the scripts and playbooks to set-up a cluster specific to the needs of the eEcoLiDAR project. Specific instructions to this end can be found below, after the general Lokum instructions.

## Technologies & Tools

- [Terraform Client](https://www.terraform.io)
- [Runtastic Terraform Opennebula provider](https://github.com/runtastic/terraform-provider-opennebula)
- [Ansible](https://www.ansible.com/)
- [emma](https://github.com/nlesc-sherlock/emma)

## Usage

### 1-Pull the Docker image from Docker Hub

```bash
docker pull nlesc/lokum:latest
```

### 2-Settings

#### 2.1 VM configuration (template)

Edit **config/opennebula_k8s.tpl** to adjust the following VM settings:

    CPU = "2.0"
    VCPU = "2"
    IMAGE_ID = "YOUR_IMAGE_ID"
    MEMORY = "4096"
    NIC = [
      NETWORK = "INTERNAL_NETWORK_NAME",
      NETWORK_UNAME = "NETWORK_USERNAME" ]

There are two **SIZE** variables. The first one is for the cluster itselft and the second one is for the persistent storage. The default values are about 15G and 30G.

#### 2.2 Credentials

Edit **config/variables.tf** and set user credentials.

### 3-Deploy the cluster

```bash
docker run --rm --net=host -it \
  -v $(pwd)/config:/lokum/config \
  -v $(pwd)/deployment:/lokum/deployment \
  nlesc/lokum:latest
```

Confirm the planned changes by typing **yes**

Configuration and the ssh-keys of each deployed cluster will be stored under **deployment/clusterX** folder.

## Connecting to the nodes

### ssh to nodes

You can connect to the nodes using generated ssh keys. For example:

```bash
ssh -i ./deployment/cluster0/id_rsa_lokum_root.key root@SERVER_IP
or
ssh -i ./deployment/cluster0/id_rsa_lokum_ubuntu.key ubuntu@SERVER_IP
```

## Starting the services manually

Run the following command in main lokum directory.

```bash
docker run --rm --net=host -it \
  -v $(pwd)/config:/lokum/config \
  -v $(pwd)/deployment:/lokum/deployment \
  nlesc/lokum:latest
```

```bash
DEPLOYMENT_DIR=/lokum/deployment/cluster0; ANSIBLE_HOST_KEY_CHECKING=False; export CLUSTER_NAME=lokum; cd /lokum/emma/vars; sh ./create_vars_files.sh; cd /lokum/emma; ansible-playbook -i ${DEPLOYMENT_DIR}/hosts.yaml --extra-vars 'CLUSTER_NAME=lokum' start_platform.yml --skip-tags 'jupyterhub,cassandra' --private-key=${DEPLOYMENT_DIR}/id_rsa_lokum_ubuntu.key -v
```

To check Apache Spark open the link below in a browser:
http://NODE_1_IP:8080/

# eEcoLiDAR-lokum

Lokum, as described above, uses `emma` ansible playbooks to deploy software stacks and services to the cluster VMs. To meet the needs of the eEcoLiDAR project we have also forked and expanded the `emma` repository. In the following we make use of the fork located here [emma](https://github.com/meiertgrootes/lokum).

In order to build the eEcolidar cluster please proceed as follows. This includes preparatory steps to be taken on the [SURFsara OpenNebula UI](https://ui.hpccloud.surfsara.nl)(TODO!) (a user account is required). In the following we assume the user to be a member of the eecolidar group.

## Preparatory steps
TODO

## Build Docker image
(Install Docker on your system)
Clone the repository to your local system and `cd` to the cloned repository. The run the following command
```bash
cd Docker && ./buildeeco.sh
```
this will build the `nlesc/lokumeeco` image. This image is based off the `nlesc/lokum` image, but replaces the [emma](https://github.com/meiertgrootes/lokum) repository with the required fork.

## Edit variables (and template)
Next `cd` back to the `config` folder of the cloned repository.
``` bash
cd ../config/
```

There, edit the `variables.tf.example` file, filling in your user credentials and the number of nodes, and save this file as `variables.tf`.

If desired you can edit the VM template. However, the `eecolidargen2-opennebula_k8s.tpl` should be suitable for the eEcolidar cluster. The `main.tf` file contains the instructions `Terraform` uses to initialize the VMs and provision them using the emma ansible playbooks. In contrast to the `lokum/master` branch, we make use of the `install_platform_eecolidar.yml` playbook, which installs common requirements, GDAL and PDAL (with associated python bindings) and the lcMacroPipeline stack.

## Deploy cluster
`cd` back to the main repository folder.
There run
```bash
./deployCluster.sh
```
which will create and run the Docker container and set up and provision the cluster. An initial confirmation query will be issued which must be confirmed by entering `yes`. Simply follow the instructions. Total set up requires ca. 25 minutes. On completion the IPs of the VMs will be returned. These can also be inspected using the OpenNebula UI.
The machines can then be accessed as described in the general instructions above.

Please be aware that the set-up sometimes fails as the VMs can't be found. They are, in most cases, however, up and running. They should then be terminated in the Opennebula UI and the `lokum-template` which was created should be deleted. optionally the `deployment` folder which was created can be deleted. If not, subsequent deployment attempts will increment the cluster counter.
