# Welcome to our Tutorial!

## Portable, Reproducible High Performance Computing In the Cloud
To clone this repo to your vm, use the following command:
`git clone https://github.com/tapis-project/uh-hpc-in-the-cloud.git`

## Block 1: Intro to Docker
* [Introduction to Jupyter](./block1/intro-to-jupyter.md)
  * [Starting a Jupyter Notebook](./block1/intro-to-jupyter.md#starting-up-your-jupyter-notebook-environment)
  * [Creating a Notebook](./block1/intro-to-jupyter.md#creating-a-notebook)
  * [Starting a Terminal](./block1/intro-to-jupyter.md#starting-a-terminal)

* [Using Docker](./block1/intro-to-docker.md)
  * [What is a container?](./block1/intro-to-docker.md#what-is-a-container)
  * [Containers vs VMs](./block1/intro-to-docker.md#containers-vs-vms)
  * [The Docker Platform](./block1/intro-to-docker.md#the-docker-platform)
  * [Initial Setup](./block1/intro-to-docker.md#initial-setup)
  * [Docker Images and Tags, Docker Hub, and Pulling Images](./block1/intro-to-docker.md#docker-images-and-tags-docker-hub-and-pulling-images)
  * [Building Images from a Dockerfile](./block1/intro-to-docker.md#building-images-from-a-dockerfile)
  * [Running a Docker Container](./block1/intro-to-docker.md#running-a-docker-container)
  * [Removing Docker Containers](./block1/intro-to-docker.md#removing-docker-containers)
  

## Block 2: Using Abaco
* [Intro to Abaco](./block2/intro-to-abaco.md)
  * [What is Abaco?](./block2/intro-to-abaco.md#what-is-abaco)
  * [Using Abaco](./block2/intro-to-abaco.md#using-abaco)
  * [Registering an Actor](./block2/intro-to-abaco.md#registering-an-actor)
  * [Executing an Actor](./block2/intro-to-abaco.md#executing-an-actor)
  * [Executing Actors with Raw Strings](./block2/intro-to-abaco.md#executing-actors-with-raw-strings)
  * [Executing Actors with JSON](./block2/intro-to-abaco.md#executing-actors-by-passing-json)
  * [Retrieving the Logs](./block2/intro-to-abaco.md#retrieving-the-logs)

* [Running the Image classifier with Abaco](./block2/running-image-classifier-in-abaco.md)
  * [Preparing our Code for Abaco](./block2/running-image-classifier-in-abaco.md#preparing-our-code-for-abaco)
  * [Creating and Actor](./block2/running-image-classifier-in-abaco.md#creating-an-abaco-actor)
  * [Executing Actor with curl](./block2/running-image-classifier-in-abaco.md#executing-classifier-with-curl)
  * [Executing Actor with Python](./block2/running-image-classifier-in-abaco.md#executing-classifier-on-abaco-using-a-jupyter-notebook--tapispy)
## Block 3: Intro to Singularity and Tapis(Agave) CLI & Systems
* [Intro to Singularity](./block3/intro-singularity.md)
* [Intro to Tapis(Agave)](./block3/tapis-intro.md)
* [Intro to Tapis CLI](./block3/tapis-cli.md)
* [Intro to Tapis Systems](./block3/tapis-systems.md)

## Block 4: Intro to Tapis(Agave) Apps & Tapis(Aloe) Jobs
* [Intro to Apps](./block4/apps.md)
  * [What is a Tapis(Agave) app?](./block4/apps.md#what-is-a-tapisagave-app)
  * [Tapis(Agave) Apps service](./block4/apps.md#tapisagave-apps-service)
  * [App Packaging](./block4/apps.md#app-packaging)
  * [Application metadata](./block4/apps.md#application-metadata)
  * [Registering App](./block4/apps.md#registering-an-app)
  * [List Apps](./block4/apps.md#list-apps)
  * [Managing App Permissions](./block4/apps.md#apps-permissions)

* [Intro to Tapis(Aloe) Jobs](./block4/jobs.md)
  * [Tapis(Aloe) Jobs Service](./block4/jobs.md#tapisaloe-jobs-service)
  * [Jobs Parameters](./block4/jobs.md#jobs-parameters)
  * [Submitting a Job ](./block4/jobs.md#submitting-a-job)
  * [Jobs List](./block4/jobs.md#jobs-list)
  * [Jobs Status](./block4/jobs.md#jobs-status)
  * [Jobs Output](./block4/jobs.md#jobs-output)
  * [Jobs Notifications](./block4/jobs.md#jobs-notifications)
