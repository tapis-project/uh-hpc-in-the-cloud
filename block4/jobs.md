#Intro to Tapis(Agave) Jobs

### What is a Tapis(Agave) Jobs? 

### Tapis(Agave) Jos service

### Running Job
Once you have at least one app registered, you can start running jobs.  To run a job, Tapis just needs to know what app you want to run and what inputs and parameters you want to use.  There are number of other optional features, which are explained in detail in the [Job Management Tutorial](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/jobs/job-submission.html)


Note that you can specify which queue to use as well as runtime limits in your job.  If those are absent, Tapis falls back to whatever was listed in the app description (also optional).  If that app doesn't specify, then it falls back to the defaults given for the execution system.

If you have direct access to the system where you are running the job, it is fun to watch it progress through on the system itself.  



###Jobs Metadata

###Jobs List

###Jobs Status

###Jobs Output

###Jobs Notifications




## What's next?

If you made it this far, you have successfully created a new app within a container and have deployed that tool on an HPC system, and now you can run that tool through the cloud from anywhere!  That is quite a lot in one workshop.

At this point, it would be a good idea to connect with other developers that are publishing apps and running workflows through Tapis by joining the Tapis API Slack channel: [tacc-cloud.slack.com](tacc-cloud.slack.com)

## More Resources

Building Tapis applications can be very rewarding way to share your code with your colleagues and the world. This is a very simple example. If you are interested to learn more, please check out the [App Management Tutorial](https://tacc-cloud.readthedocs.io/projects/agave/en/latest/agave/guides/apps/introduction.html).


[Back](index.md)
