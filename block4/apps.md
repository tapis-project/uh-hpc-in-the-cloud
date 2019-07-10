#Intro to Tapis(Agave) Apps 
---

### What is a Tapis(Agave) app? 
A Tapis(Agave) App is versioned, containerized executable that runs on a specific execution system through Tapis(Agave) Jobs service.  
So, for example, if you have multiple versions of a software package on a system, you would register each version as its own app. Likewise, if a single application code needs to be run on multiple systems, each combination of app and system needs to be defined as a separate app.
Once you have storage and execution systems registered with Tapis(Agave), you are ready to build and use apps. 


### Tapis(Agave) Apps service
Apps service is a central registry for all Tapis(Agave) apps. With Apps service you can:  
* list or search apps
* register new apps
* manage or share app permissions
* revise existing apps
* view information about each app such as its version number, owner, revision number in addition to the usual discovery capability
 
The rest of this tutorial explains in detail about how to package your Tapis(Agave) app, register your app with the Apps service and some other useful apps CLI commands. 


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

package-name-version is a folder that you create on your local VM and transfer it to Tapis(Agave) cloud storage system in a designated location, we prefer creating a folder applications in the user's home directory (/home/{user}). We refer to this location as a deployment path in our app definition (more on this in the next section).  This folder contains binaries, support scripts, test data, etc. all in one package.


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



### Lets first check:

* Your Storage and execution systems that you registered with Tapis(Agave) can be listed 
```
systems-list
```


### Step 1: Creating the app bundle locally 
 *  From classifyApp-1.0 directory on your VM,  singularity pull the classifier docker image using the command below

```
cd ~/applications/classifyApp-1.0

singularity pull docker://tacc/pearc19-classifier

```

*  Inside classifyAp-1.0 directory create a wrapper script "wrapper.sh"
```
touch wrapper.sh

```
We have set this up to have a minimal wrapper script:

```
#!/bin/bash
module load tacc-singularity/2.6.0

singularity run pearc19-classifier.simg python /classify_image.py ${imagefile} ${predictions} > predictions.txt

```
Within a wrapper script, you can reference the ID of any Tapis(Agave) input or parameter from the app description.  Before executing a wrapper script, Tapis(Agave) will look for the these references and substitute in whatever was that value was.  This will make more sense once we start running jobs, but this is the way we connect what you tell the Tapis(Agave) API that you want to do and what actually runs on the execution system.  The other thing Tapis(Agave) will do with the wrapper script is prepend all the scheduler information necessary to run the script on the execution system.

* Test data
If you have a small set of test data, it can be useful to other developers if you include it in a `test` directory. Inside your classifyApp-1.0 directory make a directory called test and create a test script inside it.You can make sure your wrapper script runs fine using by running the test.sh on the local vm
 
```
cd ~/applications/classifyApp-1.0 && mkdir test && cd test && touch test.sh
```

Test script

It is always a good idea to include a test script that can run your app against test data.  Paste the below bash script in your test.sh file

```
#!/bin/bash
module load tacc-singularity/2.6.0

export imagefile="--image_file=https://s3.amazonaws.com/cdn-origin-etr.akc.org/wp-content/uploads/2017/11/12231410/Labrador-Retriever-On-White-01.jpg"
export predictions="--num_top_predictions 5"

cd ../ && bash wrapper.sh
```



### Step 2: Transfering your app bundle to the cloud storage system using Tapis(Agave) Files service. You should run below commands from your local VM classifyApp-1.0 folder
```
files-mkdir agave://UPDATESTORAGESYSTEMID/applications/

files-mkdir agave://UPDATESTORAGESYSTEMID/applications/classifyApp-1.0

files-mkdir agave://UPDATESTORAGESYSTEMID/applications/classifyApp-1.0/test

files-cp pearc19-classifier.simg agave://UPDATESTORAGESYSTEMID/applications/classifyApp-1.0/

files-cp wrapper.sh agave://UPDATESTORAGESYSTEMID/applications/classifyApp-1.0/

files-cp test/test.sh agave://UPDATESTORAGESYSTEMID/applications/classifyApp-1.0/test/


```

### Step 3: Crafting your app definition 
Your classifier app definiton [app.json](https://github.com/tapis-project/hpc-in-the-cloud/blob/master/block4/templates/app.json) is written in JSON, and conforms to an Tapis (Agave)-specific data model. With minimal changes such as making sure the storage and execution systems are yours and name contains your username, you should be able to register your very first Tapis(Agave) app.

Store this app.json in your home directory on local VM. 


### Step 4: Registering an app
Once you have an application bundle ready to go and app definition crafted, you can use use the following CLI command from your home directory on VM
```
apps-addupdate -F app.json
```


Tapis(Agave) will check the app description, look for the app bundle on the deploymentSystem, and if everything passes, make it available to run jobs with Tapis Jobs service.


### List apps 
Now if you list apps you should see the app you just registered. You should also see other public apps available in the tacc.prod tenant
```
apps-list 

```

To see details about a specific app 
```
apps-list -V {app_ID}

```

### Managing App Permissions

To view the permissions on the app for different users 

```
 apps-pems-list {app_ID}

 ```

 To grant permissions to a user
 ```
 apps-pems-update -u {uname} -p READ_WRITE  {app_id}
 ```

 Now that we have our very first app ready to use, we are ready to run it on Stampede2 using Tapis Jobs service. 

[NEXT-> JOBS](https://github.com/tapis-project/hpc-in-the-cloud/blob/master/block4/jobs.md)


## More Resources

Building Tapis applications can be very rewarding way to share your code with your colleagues and the world. This is a very simple example. If you are interested to learn more, please check out the [App Management Tutorial](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/apps/introduction.html).
