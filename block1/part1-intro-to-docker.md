## NOTES/TODO
- Should we use jupyter as a docker example? 
- or will jupyter just be run locally? (not in docker)
- make a docker image that is a jupyter notebook (that has docker cli installed, sing, etc)
    - running jupyter as a docker image on their own vm, can mount to that container 
    - then they could do everything from terminal in notebook 
- create a class client for all test accounts


# Intro to Docker

slides: https://docs.google.com/presentation/d/1XQCNFcAu80QRliOa8DdwgcBNQdiKcV7tiRMcw_fEJKo/pub?start=false&loop=false&delayms=3000&slide=id.p

*TODO: Do we still want these slides? or put all relevant info in md?*

### Pulling Images
Authentication is the process of proving to a third-party (in our case, an API) you are who you say you are. At the DMV, this amounts to producing your driver's license. There are multiple ways of authenticating to APIs. We'll look at two of them.

### Building Images From a DockerFile
We can build images from a text file called a Dockerfile. This is a 

#### The FROM instruction
We can use the `FROM` instruction to start our new image from a known image. This should be the first line of our Dockerfile. We will start our image from an official Ubuntu 16.04 image:

```
FROM ubuntu:16.04 
```

#### The RUN instruction
We can add files to our image by running commands with the `RUN` instruction. We will use that to install `wget` via `apt`. Keep in mind that the the docker build cannot handle interactive prompts, so we use the `-y` flag in `apt`. We also need to be sure to update our apt packages.

The Dockerfile will look like this now:
```
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y wget
```
 
#### The ADD instruction
We can also add local files to our image using the `ADD` instruction. We can add a file `test.txt` in our local directory to the `/root` directory in our container with the following instruction:

```
ADD test.txt /root/text.txt
```

A complete Dockerfile for the class Anaconda/Jupyter Notebook server is availble in the class repository:
https://github.com/TACC/CSC2017Institute/blob/master/docker/Dockerfile

*TODO: This will need to be changed*

#### Building the Image
To build an image from a docker file we use the `docker build` command. We use the `-t` flag to tag the image: that is, give our image a name. We also need to specify the working directory for the buid. We specify the current working directory using a dot (.) character:
```
docker build -t csc_test .
```

### Running a Docker Container
We use the `docker run` command to run containers from an image. We pass a command to run in the container.

#### Running and Attaching to a Container
To run a container and attach to it in one command, use the `-it` flags. Here we run `bash` in a container from the ubuntu image:
```
docker run -it ubuntu bash
```

#### Running a Container in Daemon mode
We can also run a container in the background. We do so using the `-d` flag:
```
docker run -d ubuntu sleep infinity
```
Keep in mind that the command given to the `docker run` statement will be given PID 1 in the container, and as soon as this process exits the container will stop.

#### Running Additional Commands in a Running Container
Finally, we can execute commands in a running container using the `docker exec` command. First, we need to know the container id, which we can get through the `docker ps` command:

```
~ $ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
a2f968b8443f        ubuntu:16.04        "sleep infinity"    9 seconds ago       Up 8 seconds                            awesome_goldwasser
```
Here we see the container id is `a2f968b8443f`. To execute `bash` in this container we do:
```
docker exec -it a2f968b8443f bash
```
At this point we are attached to the running container. If our bash session exits, the container will keep running because the `sleep infinity` command is still running.

### Running the Jupyter Container
We need to map the 8887 port so that Jupyter is available from outside the VM. We might also want to mount the currect working directory on the host to a data directory to save our files after the container is destroyed.

```
docker run -d -it -p 8887:8887 -v $(pwd):/data tacc/csc_jupyter
```

*TODO: Will we be using the same jupyter image? or will we create a new one?*

