
# Intro to Abaco

### What is Abaco?

Abaco is an NSF-funded web service and distributed computing platform providing functions-as-a-service (FaaS) 
to the research computing community. Abaco implements functions using the Actor Model of concurrent computation. 
In Abaco, each actor is associated with a Docker image, and actor containers are executed in response to messages 
posted to their inbox which itself is given by a URI exposed over HTTP.

Full documentation is available on ReadTheDocs: https://abaco.readthedocs.io

### Using Abaco

The primary Abaco instance is hosted at the Texas Advanced Computing Center. It requires a TACC account and access
to the TACC Cloud APIs. Full details on getting the required accounts can be found on the Getting Started Guide here
https://abaco.readthedocs.io/en/latest/getting-started/index.html#account-creation-and-software-installation

For this workshop, we have installed TACC training accounts on your VM. If you wish to use your own TACC account
you will also need TACC Cloud API keys (see the Working With TACC OAuth section, 
https://abaco.readthedocs.io/en/latest/getting-started/index.html#working-with-tacc-oauth)

### Registering an Actor

The hosted TACC reactors service sits on top of a RESTful HTTP API called Abaco. To work with the service, any HTTP client can be used. 
In this workshop we will focus on two clients: curl, which can be run from the command line in most Unix like environments; and the tapispy Python library.


#### Initial Registration 

Once you have your Docker image build and pushed to the Docker Hub, you can register an actor from it by making a POST request to the API. 
The only required POST parameter is the image to use, but there are several other optional arguments.

#### Complete List of Registration Parameters 
The following parameters can be passed when registering a new reactor.

Required parameters:
* image - The Docker image to associate with the actor. This should be a fully qualified image available on the public Docker Hub.

Optional parameters:
* name - A user defined name for the actor.
* description - A user defined description for the actor.
* default_environment - The default environment is a set of key/value pairs to be injected into every execution of the actor. The values can also be overridden when passing a message to the actor in the query parameters.
* stateless (True/False) - Whether the actor stores private state as part of its execution. If True, the state API will not be available. The default value is False.
* privileged (True/False) - Whether the reactor runs in privileged mode and has access to the Docker daemon. *Note: Setting this parameter to True requires elevated permissions.*

## TODO: talk about aliases? 

Here is an example using curl:

```
$ curl -H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" \
-d '{"image": "abacosamples/test", "name": "test", "description": "My test actor using the abacosamples image.", "default_environment":{"key1": "value1", "key2": "value2"} }' \
https://api.tacc.cloud/actors/v2
```

To register an actor using the tapispy library, we use the `actors.add()` method and pass the same arguments through the `body` parameter. For example,

```
>>> from tapispy.tapis import Tapis
>>> tp = Tapis(api_server='https://api.tacc.utexas.edu', token='<access_token>')
>>> actor = {"image": "abacosamples/test", "name": "test", "description": "My test actor using the abacosamples image registered using agavepy.", "default_environment":{"key1": "value1", "key2": "value2"} }
>>> tp.actors.add(body=actor)
```


### Executing an Actor

To execute a Docker container associated with an actor, we send the actor a message by making a POST request to the actor's inbox URI which is of the form:
```
https://api.tacc.cloud/reactors/v2/<reactor_id>/messages
```

Currently, two types of messages are supported: "raw" strings and JSON messages.

### Executing Reactors with Raw Strings ###

To execute a reactor passing a raw string, make a POST request with a single argument in the message body of `message`. Here is an example using curl:

```
$ curl -H "Authorization: Bearer $TOKEN" -d "message=some test message" https://api.tacc.cloud/actors/v2/$REACTOR_ID/messages
```

When this request is successful, the abaco will put a single message on the actor's message queue which will ultimately result in one container execution with the `$MSG` environment variable having the value `some test message`.

The same execution could be made using the Python library like so:

```
>>> tp.actors.sendMessage(actorId='NolBaJ5y6714M', body={'message': 'test'})
```

### Executing Actors by Passing JSON ###

You can also send pure JSON as the reactor message. To do so, specify a Content-Type of "application/json". Here is an example using curl:

```
$ curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"username": "jdoe", "application_id": "print-env-cli-DggdGbK-0.1.0" }' https://api.tacc.cloud/actors/v2/$REACTOR_ID/messages
```

One advantage to passing JSON is that the python library will automatically attempt to deserialize it into a pure Python object. This shows up in the `context` object under the `message_dict` key. For example, for the example above, the corresponding rector (if written in Python) could retrieve the application_id from the message with the following code:

```
from tapispy.actors import get_context
context = get_context()
application_id = context['message_dict']['application_id']
```

The same actor execution could be made using the Python library like so:

```
>>> message_dict = {"username": "jdoe", "application_id": "print-env-cli-DggdGbK-0.1.0" }
>>> tp.actors.sendMessage(actorId='NolBaJ5y6714M', body=message_dict)
```


### Retrieving the Logs

