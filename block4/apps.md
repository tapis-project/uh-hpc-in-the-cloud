#Intro to Tapis(Agave) Apps 
---
Once you have storage and execution systems registered with Tapis(Agave), you are ready to build and use apps. 

### What is a Tapis(Agave) app? 
A Tapis(Agave) App is versioned, containerized executable that runs on a specific execution system through Tapis(Agave)' Job service.  
So, for example, if you have multiple versions of a software package on a system, you would register each version as its own app. Likewise, if a single code needs to be run on multiple systems, each combination of app and system needs to be defined as an individual app.


### What does Tapis(Agave) Apps service provide?
Apps service is a central registry for all Tapis(Agave) apps. With Apps service you can:  
* list or search 
* register 
* manage or share 
* revise 
* view information about each app as version number, owner, revision number in addition to the usual discovery capability
 
The rest of this tutorial explains in detail about how to package your app, register an app to the Apps service and how to manage and share apps. 


### App Packaging 
Tapis(Agave) apps are bundled into a directory and organized in a way that Tapis(Agave) jobs can properly invoke it. Though there is plenty of opportunity to establish your own conventions, at the very least, your application folder should have the following in it:

* An execution script that creates and executes an instance of the application. We refer to this as the <em>wrapper template</em> throughout the documentation. For the sake of maintainability, it should be named something simple and intuitive like `wrapper.sh`. More on this in the next section.
* A library subdirectory: This contains all scripts, non-standard dependencies, binaries needed to execute an instance of the application.  
* A test directory containing a script named something simple and intuitive like `test.sh`, along with any sample data needed to evaluating whether the application can be executed in a current command-line environment. It should exit with a status of 0 on success when executed on the command line. A simple way to create your test script is to create a script that sets some sensible default values for your app's inputs and parameters and then call your wrapper template.

The resulting minimal app bundle would look something like the following:

```always
package-name-version
|- app.json
|+ bin
 |- script.R
|+ test
 |- test.sh
|- wrapper.sh
```

package-name-version is a folder that you create on your Tapis(Agave) cloud storage system in a designated location, we prefer (/home/{user}/applications/). We refer to this location as a deployment path in our app definition (more on this in the next section).  This folder contains binaries, support scripts, test data, etc. all in one package.


### Application metadata
* **name** - Apps are given an ID by combining the "name" and "version". That combination must be unique across the entire Tapis(Agave) tenant, so unless you are an admin creating public system, you should probably put your username somewhere in there, and it's often useful to have the system name somehow referenced there too. You shouldn't use spaces in the name.
* **version** - This should be the version of the software package that you are wrapping.  If you end up updating your app description later on, Tapis(Agave) will keep track of the app revision separately, so there is no need to reflect that here.
* **deploymentSystem** - The data storage system where you keep the app assets, such as the wrapper script, test script, etc.  App assets are not stored on the execution system where they run.  For provenance and reproducibility, Tapis(Agave) requires that you keep them on a cloud storage system.
* **deploymentPath** - the directory on the deploymentSystem where the app bundle is located
* **templatePath** - This template is what Tapis(Agave) uses to run your app.  The path you specify here is relative to the deploymentPath
* **testPath** - The intention here is that you include a testcase inside of your app bundle.
* **argument** - In combination with "showArgument", the "argument" keyword is a convenience that lets you build up commandline arguments in your wrapper script.
* **Cardinality** - Sets the min and max number of files you can give for inputs and outputs.  A "maxCardinality" of -1 will accept an unlimited number of files.
Some of the above fields are manadatory to register the app. A complete list of application metadata(mandatory/non-mandatory) can be found at [Application Metadata](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/apps/app-wrapper-templates.html#application-metadata)


### Registering an app  
Registering an app with the Apps service is conceptually simple. Just describe your app as a JSON document and POST it to the Apps service. 



### To register your very first app with Tapis(Agave) these are some of the prequisites
* Must have successfully registered your storage and execution systems in the block 3 of this tutorial.
* With the training accounts credentials you should be able to ssh to cloud.corral.tacc.utexas.edu 
 ```
 ssh trainXXX@cloud.corral.tacc.utexas.edu 

 ``` 
 In your /home/{user}/ you should see an 'applications' directory

###Step 1: Creating the app bundle locally 
 * Create a directory classifyApp-1.0 in your /home/{user}/applications directory on your local VM 

 * cd into classifyApp-1.0 directory and pull the singularity image. 
 If you successfully made a Docker or Singularity image, use that as the basis for your app.  Depending on your implementation, you may have to modify some things in the wrapper script to match.  If you do not have an image to use, you are welcome to use below.

```
singularity pull docker://tacc/pearc19-classifier
```

* Create a wrapper script wrapper.sh inside classifyAp-1.0 directory
We have set this up to have a minimal wrapper script:
```
singularity run pearc19-classifier.simg python /classify_image.py ${imagefile} ${predictions} > predictions.txt
```
Within a wrapper script, you can reference the ID of any Tapis(Agave) input or parameter from the app description.  Before executing a wrapper script, Tapis(Agave) will look for the these references and substitute in whatever was that value was.  This will make more sense once we start running jobs, but this is the way we connect what you tell the Tapis(Agave) API that you want to do and what actually runs on the execution system.  The other thing Tapis(Agave) will do with the wrapper script is prepend all the scheduler information necessary to run the script on the execution system.

* Test data
If you have a small set of test data, it can be useful to other developers if you include it in a `test` directory. Inside your classifyApp-1.0 directory make a directory called test and create a test script inside it

```
mkdir test && cd test && vi test.sh
```

### Test script

It is always a good idea to include a test script that can run your app against test data.  Paste the below bash script in your test.sh file

```
#!/bin/bash
module load tacc-singularity/2.6.0

export imagefile="--image_file test/bevo_1000.jpg"
export predictions="--num_top_predictions 5"

cd ../ && bash wrapper.sh
```

###Step 2: Transfering your app bundle to the cloud storage system using Tapis(Agave) Files service





###Step 3: Crafting your app definition 
Your classifier app definiton [app.json](https://github.com/tapis-project/hpc-in-the-cloud/blob/master/block4/templates/app.json) is written in JSON, and conforms to an Tapis (Agave)-specific data model. With minimal changes such as making sure the storage and execution systems are yours and name contains your username, you should be able to register your very first Tapis(Agave) app.

You can store this app.json in your home directory. 

```


### Step 4: Registering an app
Once you have an application bundle ready to go, you can use use the following CLI command from your local VM home directory:
```
apps-addupdate -F app.json
```
or execute below curl command in terminal
```
curl -X POST -H "Content-Type:multipart/form-data" -H "Authorization: Bearer $token" -F "fileToUpload=@app.json" https://api.tacc.utexas.edu/apps/v2?pretty=true
```

Tapis(Agave) will check the app description, look for the app bundle on the deploymentSystem, and if everything passes, make it available to run jobs with Tapis Jobs service.


