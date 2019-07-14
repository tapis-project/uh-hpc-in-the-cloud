# Running Classifier Image in Abaco

### Getting the Image Ready and Registering an Actor

#### Preparing our code for Abaco
To run our classifier image with Abaco, we will first need to create a script that will take the message sent to an actor and send it to our classifier script. This could be written in anything, including the original Python script; for simplicity, we'll write a short Bash script. 

Create a new file called `abaco.sh` and add the following content:

```bash
#!/bin/bash

# print the special MSG variable:
echo "Contents of MSG: "$MSG

python "/classify_image.py --image_file=$MSG
```

Once we register our actor and sent it a message, Abaco will pass the contents of the message in the `$MSG` environment variable. We can use a bash script to capture it, and then run our classifier script with it.
Because we have added this wrapper script, we will need to update our Dockerfile before we create an Abaco actor.

```
# image: taccsciapps/classify_image

# create a direcotory for our app:
RUN mkdir /app

# add our app
ADD classify_image.py /app/classify_image.py
RUN chmod +x /app/classify_image.py
ADD abaco.sh /app/abaco.sh
RUN chmod +x /app/abaco.sh

# by default, execute the abaco.sh script - 
CMD ["/app/abaco.sh"]
```


Notice that instead of our entrypoint being `classify_image.py` as it was before, it is now set to run our wrapper script, `abaco.sh`.

Another difference with running on Abaco is that Abaco will run our actor using the UID associated with our TACC account.
This ensures files created and modified by the actor are owned by the API user. 

In order for this to work, we need to ensure that our container can run properly as a non-root user. Running containers as 
a non-root user is good practice in general. To make it so that a non-root user can
write the downloaded file to the container's file system, we can `chmod 777` the `/app` directory:

```bash
RUN chmod -R 777 /app
```

The final Dockerfile is thus:

```bash

# image: taccsciapps/abaco_classifier

FROM tensorflow/tensorflow:1.5.0-py3

# install requirements
RUN pip install requests

# add our app
RUN mkdir /apps
ADD classify_image.py /app/classify_image.py
RUN chmod +x /app/classify_image.py
ADD abaco.sh /app/abaco.sh
RUN chmod +x /app/abaco.sh
RUN chmod -R 777 /app

CMD ["/app/abaco.sh"]

```

#### Creating an Abaco Actor

Once our new dockerfile is built and pushed to DockerHub, we can create our Abaco actor. 
```
$ curl -H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" \
-d '{"image": "taccsciapps/abaco_classifier", "name": "abaco_classifier", "description": "Using the image classifier with abaco."}' \
https://api.tacc.cloud/actors/v2
```

Take note of the actor ID that is returned, since you will need it to send the actor a message.

### Executing Classifier with `curl`

To execute our Actor with our image classifier, we will need to send our actor a raw string message:

```
$ curl -H "Authorization: Bearer $TOKEN" -d "message=https://path/to/an/image.jpg" https://api.tacc.cloud/actors/v2/$ACTOR_ID/messages
```

To see the results of the execution, we can check the logs:
```
$ curl -H "Authorization: Bearer $TOKEN" https://api.tacc.cloud/actors/v2/$ACTOR_ID/messages
```


### Executing Classifier on Abaco using a Jupyter Notebook & TapisPy

