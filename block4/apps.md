#Tapis Apps 
---

Once you have storage and execution systems registered with Tapis, you are ready to build and use apps.  
A Tapis App is versioned, containerized executable that runs on a specific execution system.  So, for example, if you have multiple versions of a software package on a system, you would register each version as its own app. Likewise, for a software package available on multiple execution systems, each system would use a different Tapis app to use that software.

Tapis keeps a registry of apps that you can list and search.  The Apps service provides permissions, validation, archiving, and revision information about each app in addition to the usual discovery capability.

## Registering an app  

Registering an app with the Apps service is conceptually simple. Just describe your app as a JSON document and POST it to the Apps service. 


## Packaging your app  

Tapis apps are bundled into a directory and organized in a way that Tapis can properly invoke it. Though there is plenty of opportunity to establish your own conventions, at the very least, your application folder should have the following in it:

* An execution script that creates and executes an instance of the application. We refer to this as the <em>wrapper template</em> throughout the documentation. For the sake of maintainability, it should be named something simple and intuitive like `wrapper.sh`. More on this in the next section.
* A library subdirectory: This contains all scripts, non-standard dependencies, binaries needed to execute an instance of the application.  
* A test directory containing a script named something simple and intuitive like `test.sh`, along with any sample data needed to evaluating whether the application can be executed in a current command-line environment. It should exit with a status of 0 on success when executed on the command line. A simple way to create your test script is to create a script that sets some sensible default values for your app's inputs and parameters and then call your wrapper template.

The resulting minimal app bundle would look something like the following:

```always
jfonner-ggplot-1.0
|- app.json
|+ bin
 |- script.R
|+ test
 |- test.sh
|- wrapper.sh
```

## An example app

If you successfully made a Docker or Singularity image, use that as the basis for your app.  Depending on your implementation, you may have to modify some things in the wrapper script to match.  If you do not have an image to use, you are welcome to use below.

```
singularity pull docker://johnfonner/image_classifier:0.2
```

### Wrapper script

We have set this up to have a minimal wrapper script:

```sh
singularity exec image_classifier-0.2.simg python /classify_image.py ${imagefile} ${predictions} > predictions.txt
```

Within a wrapper script, you can reference the ID of any Tapis input or parameter from the app description.  Before executing a wrapper script, Tapis will look for the these references and substitute in whatever was that value was.  This will make more sense once we start running jobs, but this is the way we connect what you tell the Tapis API that you want to do and what actually runs on the execution system.  The other thing Tapis will do with the wrapper script is prepend all the scheduler information necessary to run the script on the execution system.

### Test data

If you have a small set of test data, it can be useful to other developers if you include it in a `test` directory.

```
mkdir test && cd test
wget --no-check-certificate https://texassports.com/images/2015/10/16/bevo_1000.jpg
```

### Test script

In the `test` directory, it is always a good idea to include a test script that can run your app against test data.  In a file called `test.sh` put the following:

```
#!/bin/bash
module load singularity

export imagefile="--image_file test/bevo_1000.jpg"
export predictions="--num_top_predictions 5"

cd ../ && bash wrapper.sh
```

### The app description

Below is an app description that takes a single file and one parameter as input and classifies an image.  The app description we give to Tapis can be simpler than what is below, but a number of optional fields were included to demonstrate their use.

```json
{
  "name": "USERNAME-imageclassify-uhhpc",
  "version": "1.0",
  "label": "Image Classifier",
  "shortDescription": "Classify an image using a small ImageNet model",
  "longDescription": "",
  "tags": [
    "tensorflow",
    "ImageNet"
  ],
  "deploymentSystem": "USERNAME-workshop-uhhpc-lustre",
  "deploymentPath": "/usr/USERNAME/USERNAME-imageclassify-1.0",
  "templatePath": "wrapper.sh",
  "testPath": "test/test.sh",
  "executionSystem": "USERNAME-uhhpc-exec",
  "executionType": "HPC",
  "helpURI": "https://uh-ci.github.io/agave-container-workshop-20180806/",
  "parallelism": "SERIAL",
  "modules": ["load singularity"],
  "inputs": [{
    "id": "imagefile",
    "details": {
      "label": "Image to classify",
      "description": "",
      "argument": "--image_file ",
      "showArgument": true
    },
    "semantics": {
      "minCardinality": 1,
      "ontology": [
        "http://edamontology.org/format_3547"
      ],
      "maxCardinality": 1
    },
    "value": {
      "default": "https://texassports.com/images/2015/10/16/bevo_1000.jpg",
      "order": 0,
      "required": true,
      "validator": "",
      "visible": true
    }
  }],
  "parameters": [{
    "id": "predictions",
    "details": {
      "label": "Number of predictions to return",
      "argument": "--num_top_predictions ",
      "showArgument": true
    },
    "semantics": {
      "maxCardinality": 1,
      "ontology": [],
      "minCardinality": 1
    },
    "value": {
      "visible": true,
      "required": true,
      "type": "number",
      "default": 5
    }
  }],
  "outputs": [],
  "defaultQueue": "uhagave.q",
  "checkpointable": false
}
```

Looking at some of the important keywords:
* **name** - Apps are given an ID by combining the "name" and "version". That combination must be unique across the entire Agave tenant, so unless you are an admin creating public system, you should probably put your username somewhere in there, and it's often useful to have the system name somehow referenced there too. You shouldn't use spaces in the name.
* **version** - This should be the version of the software package that you are wrapping.  If you end up updating your app description later on, Agave will keep track of the app revision separately, so there is no need to reflect that here.
* **deploymentSystem** - The data storage system where you keep the app assets, such as the wrapper script, test script, etc.  App assets are not stored on the execution system where they run.  For provenance and reproducibility, Agave requires that you keep them on a storage system.
* **deploymentPath** - the directory on the deploymentSystem where the app bundle is located
* **templatePath** - This template is what Agave uses to run your app.  The path you specify here is relative to the deploymentPath
* **testPath** - The intention here is that you include a testcase inside of your app bundle.
* **argument** - In combination with "showArgument", the "argument" keyword is a convenience that lets you build up commandline arguments in your wrapper script.
* **Cardinality** - Sets the min and max number of files you can give for inputs and outputs.  A "maxCardinality" of -1 will accept an unlimited number of files.

## Registering an app

Once you have an application bundle ready to go, you can use use the following CLI command:

```
apps-addupdate -F app.json
```
or execute below curl command in terminal
```
curl -X POST -H "Content-Type:multipart/form-data" -H "Authorization: Bearer $token" -F "fileToUpload=@app.json" https://api.tacc.utexas.edu/apps/v2?pretty=true
```

Tapis will check the app description, look for the app bundle on the deploymentSystem, and if everything passes, make it available to run jobs against


## Running a job

Once you have at least one app registered, you can start running jobs.  To run a job, Tapis just needs to know what app you want to run and what inputs and parameters you want to use.  There are number of other optional features, which are explained in detail in the [Job Management Tutorial](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/jobs/job-submission.html)


Note that you can specify which queue to use as well as runtime limits in your job.  If those are absent, Tapis falls back to whatever was listed in the app description (also optional).  If that app doesn't specify, then it falls back to the defaults given for the execution system.

If you have direct access to the system where you are running the job, it is fun to watch it progress through on the system itself.  

## What's next?

If you made it this far, you have successfully created a new app within a container and have deployed that tool on an HPC system, and now you can run that tool through the cloud from anywhere!  That is quite a lot in one workshop.

At this point, it would be a good idea to connect with other developers that are publishing apps and running workflows through Tapis by joining the Tapis API Slack channel: [tacc-cloud.slack.com](tacc-cloud.slack.com)

## More Resources

Building Tapis applications can be very rewarding way to share your code with your colleagues and the world. This is a very simple example. If you are interested to learn more, please check out the [App Management Tutorial](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/apps/introduction.html).


[Back](index.md)
