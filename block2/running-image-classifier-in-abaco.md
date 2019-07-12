# Running Classifier Image in Abaco

### Getting the Image Ready and Registering an Actor

#### Preparing our code for Abaco
To run our classifier image with Abaco, we will first need to create a script that will take the message sent to an actor and send it to our classifier script. 

```bash
#!/bin/bash

# print the special MSG variable:
echo "Contents of MSG: "$MSG

python "/classify_image.py --image_file="$MSG
```

The message sent to abaco will be saved in the `$MSG` environment variable. We can use a bash script to capture it, and then run our classifier script with it.
Because we have added this wrapper script, we will need to update our Dockerfile before we create an Abaco actor.

```
# image: taccsciapps/classify_image

FROM tensorflow/tensorflow:1.5.0-py3

# install requirements
RUN pip install requests

# add our app
ADD classify_image.py /classify_image.py
ADD abaco.sh /abaco.sh


ENTRYPOINT ["/abaco.sh"]
```


Notice that instead of our entrypoint being `classify_image.py` as it was before, it is now set to run our wrapper script, `abaco.sh`.

#### Creating an Abaco Actor

Once our new dockerfile is built and pushed to DockerHub, we can create our Abaco actor. 
```
$ curl -k -H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" \
-d '{"image": "taccsciapps/abaco_classifier", "name": "abaco_classifier", "description": "Using the image classifier with abaco."}' \
https://api.tacc.cloud/actors/v2
```

Take note of the actor ID that is returned, since you will need it to send the actor a message.

### Executing Classifier with `curl`

To execute our Actor with our image classifier, we will need to send our actor a raw string message:

```
$ curl -k -H "Authorization: Bearer $TOKEN" -d "message=https://path/to/an/image.jpg" https://api.tacc.cloud/actors/v2/$ACTOR_ID/messages
```

To see the results of the execution, we can check the logs:
```
$ curl -k -H "Authorization: Bearer $TOKEN" https://api.tacc.cloud/actors/v2/$ACTOR_ID/executions/$EXECUTION_ID
```


### Executing Classifier on Abaco using a Jupyter Notebook & TapisPy

