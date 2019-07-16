# Intro to Tapis(Aloe) Jobs

### Tapis(Aloe) Jobs service
The Tapis(Aloe) Jobs service is a basic execution service that allows you to run applications registered with the Apps service across multiple, distributed, heterogeneous systems through a common REST interface.The service manages all aspects of execution and job management from data staging, job submission, monitoring, output archiving, event logging, sharing, and notifications. 
The Agave jobs service is rearchitectured, to a new code-named Aloe, which provides improved reliability, scalability, performance and serviceability. More details on this new jobs service can be found in the [Jobs Tutorial](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/jobs/introduction.html)


### Jobs Parameters 
An example Job JSON defintion:
```
{
  "name":"UPDATEUSERNAME.app.imageclassify",
  "appId":"UPDATEAPPID",
  "archive":true,
  "archiveSystem":"UPDATESTORAGESYSTEM",
  "memoryPerNode":"1",
  "parameters": { 
    "imagefile": "https://texassports.com/images/2015/10/16/bevo_1000.jpg"
    } 
}
```
* **appId**	- The unique ID (name + version) of the application run by this job. This must be a valid application that the user has permission to run.
* **name**	-  The user selected name for the job.
* **archive**	-	Whether the job output should be archived. When true, all new file created during job execution will be moved to the archivePath.
* **memoryPerNode**	-	The memory requested for each node on which the job runs. Values are expressed as [num][units], where num can be a decimal number and units can be KB, MB, GB, TB (default = GB). Examples include 200MB, 1.5GB and 5.
* **archiveSystem**	-	The unique id of the storage system on which the job output will be archived.
**appId** and **name** are required parameters. 
All the job parameters are given in [Job Parameters](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/jobs/aloe-job-changes.html)


### Submitting a Job
Once you have at least one app registered, you can start running jobs.  To run a job, Tapis just needs to know what app you want to run and what inputs and parameters you want to use. There are number of other optional features, which are explained in detail in the [Job Management Tutorial](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/jobs/job-submission.html).
Note that you can specify which queue to use as well as runtime limits in your job.  If those are absent, Tapis falls back to whatever was listed in the app description (also optional).If that app doesn't specify, then it falls back to the defaults given for the execution system.

If you have direct access to the system where you are running the job, it is fun to watch it progress through on the system itself.  

* Step 1: Crafting **Job Definition**

Create [job.json](https://github.com/tapis-project/hpc-in-the-cloud/blob/master/block4/templates/job.json) in your home directory on local VM and update the values for fields **name** and **appID**. 
Using the command below, grab the id of the app that you just registered.

```
apps-list

```
In the job.json, you will see archive set as "True". With this setting, all new files created during job execution will go to the archiveSystem's home directory. 


* Step 2: Submit job
From your home directory, where job.json file is located run job submission command
```
jobs-submit -F job.json
```
Alternately, to get a detialed job response run with a -V option
```
jobs-submit -F job.json -V

```
You should see a message "Successfully submitted job <jobID>. This is the job uuid is unique, everytime you submit a job. You will use this uuid to get the Job Status, output listing and much more.



### Jobs List
Now, when you do a jobs-list you can see your job
```
jobs-list

```

### Jobs Status
Job status allows you to see the current state of the job. You can also set up email or webhook notification, when the job state changes

```
jobs-status <jobId>

```
Details about different job states are given here [JOB STATES](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/jobs/aloe-job-changes.html#job-states)


### Jobs Output
```
jobs-output-list -L <jobId>

```
With this command you see the current files in the output folder. When archive is true, all the new files will get copied to archive directory on your archive system. When it is false all the output files can be found on the execution system's scratch directory

To view the output, run the below curl command

First Grab your access token from current and store it in a variable
```
cat ~/.agave/current
export token =<acces_token>
```				
Run below curl command
```
curl -sk -H "Authorization: Bearer $token" 'https://api.tacc.utexas.edu/files/v2/media/system/UPDATESTORAGESYSTEM/UPDATEUSER/archive/jobs/job-UPDATEJOBID/predictions.txt'
```

You can also download, the output files using the command below
```
jobs-output-get -r <jobId>
```


### Jobs Notifications
You can monitor progress of your job by setting by email or webhook notifications
Add this to your job definition and try to submit the job again
```
"notifications":[
    {
      "url":"UPDATEEMAILADDRESS",
      "event":"*",
      "persistent":true
    }
    ]
```
You should see email notifications pop up in your inbox as the job changes state.

## What's next?

If you made it this far, you have successfully created a new app within a container and have deployed that tool on an HPC system, and now you can run that tool through the cloud from anywhere!  That is quite a lot in one workshop.

At this point, it would be a good idea to connect with other developers that are publishing apps and running workflows through Tapis by joining the Tapis API Slack channel: [tacc-cloud.slack.com](tacc-cloud.slack.com)



[Back](index.md)
