# Managing systems
---

The Tapis API provides a way to access and manage the data storage and compute resources you already use (or maybe the systems you want to use), but first you have to tell Tapis where they are, how to login, and how to communicate with that system.  That is done by giving Tapis a short JSON description for each system.  

### Tapis Storage Systems

Storage systems tell Tapis where data resides.  You can store files for running compute jobs, archive results, share files with collaborators, and maintain copies of your Tapis apps on storage systems.  Tapis supports many of the communication protocols and  permissions models that go along with them, so you can work privately, collaborate with individuals, or provide an open community resource.  It's up to you.  Here is an example of a simple data storage system template accessed via SFTP for the TACC Corral cloud storage system:
```json
{
  "id": "UPDATEUSERNAME.tacc.corral.storage",
  "name": "Storage system for TACC cloud storage on corral",
  "status": "UP",
  "type": "STORAGE",
  "description": "Storage system for TACC cloud storage on corral",
  "site": "www.tacc.utexas.edu",
  "public": false,
  "default": true,
  "storage": {
    "host": "cloud.corral.tacc.utexas.edu",
    "port": 22,
    "protocol": "SFTP",
    "rootDir": "/",
    "homeDir": "/home/UPDATEUSERNAME/",
    "auth": {
      "username": "UPDATEUSERNAME",
      "password": "UPDATEPASSWORD",
      "type": "PASSWORD"
    }
  }
}
```

* **id** -This needs to be a unqiue identifier amongst all systems in Tapis - so using your username helps ensure this.
* **name** - This can be whatever you like, but should be descriptive for you.
* **status** - This is used when querying systems and can give other users an idea if the system is UP or DOWN- only sytems that are UP can be accessed.
* **type** - A system can be STORAGE or EXECUTION.
* **site** - A url typically with information about the system.
* **host** -  This is the ip or domain of the server we need to connect to
* **port** -  This is the port we need to use when connecting, this is usally tied to the proctocal (SFTP is usually port 22)
* **protocol** - This is the communication protocol most systems use SFTP but others are supported.
* **rootDir** - This is the lowest directory any Tapis user accessing this system can navigate.
* **homeDir** - This is the directory that a Tapis user will access by default.
* **auth** - The Authenication type to use when accessing the system - in this tutorial we are using a PASSWORD Auth but SSH-KEYS is usually recommended.
* **public** - Is this a shared resource available to all users - only Administrators can set this to TRUE.
* **default** - TRUE or FALSE if this is the default system for Tapis to use when not explicitly passed a system.

More details on the possible parameters for storage systems can be found in the [Tapis Storage System documentation](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/systems/systems-storage.html).
### Hands-on

As a hands on exercise, using the Tapis CLI, register a data storage system using PASSWORD authentication with the above template for the TACC Corral Cloud store. Don't forget to replace *UPDATEUSERNAME* and *UPDATE PASSWORD*.  Call the JSON file "corral_cloud.json"

Then the CLI command to use is:
```
systems-addupdate -F cloud_corral.json
```

The above command will submit the JSON file "cloud_corral.json" to Tapis and create a new system with the attributes specified in the JSON file.

You can now see the you new system by running the following Tapis CLI command:
```
systems-list
```

---
### Tapis Execution Systems

Execution systems in Tapis are very similar to storage systems.  They just have additional information for how to launch jobs.  In this example, we are using the Stampede2 HPC system, so we have to give scheduler and queue information.  This system description is longer than the storage definition due to logins, queues, scratch systems definitions.

```json
{
  "id": "UPDATEUSERNAME.stampede2.execution",
  "name": "Execution system for Stampede2",
  "status": "UP",
  "type": "EXECUTION",
  "description": "Execution system for Stampede2 ",
  "site": "www.tacc.utexas.edu",
  "executionType": "HPC",
  "scratchDir": "/home1/0003/UPDATEUSERNAME/scratch",
  "workDir": "/home1/0003/UPDATEUSERNAME/work",
  "login": {
    "host": "login1.stampede2.tacc.utexas.edu",
    "port": 22,
    "protocol": "SSH",
    "scratchDir": "/home1/0003/UPDATEUSERNAME/scratch",
    "workDir": "/home1/0003/UPDATEUSERNAME/work",
    "auth": {
      "username": "UPDATEUSERNAME",
      "password": "UPDATEPASSWORD",
      "type": "PASSWORD"
    }
  },
  "storage": {
    "host": "login1.stampede2.tacc.utexas.edu",
    "port": 22,
    "protocol": "SFTP",
    "rootDir": "/",
    "homeDir": "/home1/0003/UPDATEUSERNAME",
    "auth": {
     "username": "UPDATEUSERNAME",
      "password": "UPDATEPASSWORD",
      "type": "PASSWORD"
    }
  },
  "maxSystemJobs": 100,
  "maxSystemJobsPerUser": 10,
  "scheduler": "SLURM",
  "queues": [
    {
      "name": "normal",
      "maxJobs": 100,
      "maxUserJobs": 10,
      "maxNodes": 128,
      "maxMemoryPerNode": "2GB",
      "maxProcessorsPerNode": 128,
      "maxRequestedTime": "24:00:00",
      "customDirectives":"-A UPDATEPROJECT -r UPDATERESERVATION",
      "default": true
    }
  ],
  "environment": "",
  "startupScript": null
}
```

We covered what some of these keywords are in the storage systems section.  Below is some commentary on the new fields:

* **executionType** - Either HPC, Condor, or CLI.  Specifies how jobs should go into the system. HPC and Condor will leverage a batch scheduler. CLI will fork processes.
* **scheduler** - For HPC or CONDOR systems, Agave is "scheduler aware" and can use most popular schedulers to launch jobs on the system.  This field can be LSF, LOADLEVELER, PBS, SGE, CONDOR, FORK, COBALT, TORQUE, MOAB, SLURM, UNKNOWN. The type of batch scheduler available on the system.
* **environment** - List of key-value pairs that will be added to the Linux shell environment prior to execution of any command.
* **scratchDir** - Whenever Agave runs a job, it uses a temporary directory to cache any app assets or job data it needs to run the job.  This job directory will exist under the "scratchDir" that you set.  The path in this field will be resolved relative to the rootDir value in the storage config if it begins with a "/", and relative to the system homeDir otherwise.
* **workDir** - Path to use for a job working directory. This value will be used if no scratchDir is given. The path will be resolved relative to the rootDir value in the storage config if it begins with a "/", and relative to the system homeDir otherwise.
* **queue** - An array of batch queue definitions providing descriptive and quota information about the queues you want to expose on your system. If not specified, no other system queues will be available to jobs submitted using this system.
* **startupScript** - Path to a script that will be run prior to execution of any command on this system. The path will be a standard path on the remote system. A limited set of system macros are supported in this field. They are rootDir, homeDir, systemId, workDir, and homeDir. The standard set of runtime job attributes are also supported. Between the two set of macros, you should be able to construct distinct paths per job, user, and app. Any environment variables defined in the system description will be added after this script is sourced. If this script fails, output will be logged to the .agave.log file in your job directory. Job submission will still continue regardless of the exit code of the script.

Complete reference information is located here:
https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/systems/introduction.html

### Hands-on
As a hands on exercise, register the Stampede2 HPC as a execution system using the Tapis-CLI using the above JSON template. - Don't forget to change *UPDATEUSERNAME* and *UPDATEPASSWORD* to your tutorial or TACC username and *UPDATEPROJECT* and *UPDATERESERVATION* for this workshops Stampede2 provided project and reservation (or your personal ones if doing this on your own).  

In your CLI you can now get a list of your systems using:
```
systems-list
```

If you want to view just the storage systems you can use -S. For execution systems use -E.

We can also set a default storage system that Tapis can default to:

```
systems-setdefault USERNAME.tacc.corral.storage
```

Default systems are the systems that are used when the user does not specify a system to use when performing a remote action in Tapis. For example, specifying an archivePath in a job request, but no archiveSystem, or specifying a deploymentPath in an app description, but no deploymentSystem. In these situations, Tapis will use the user’s default storage system.
