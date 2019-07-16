
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

For this workshop, we have installed TACC training accounts on your VM.

#### Checking Access to the TACC APIs
To use any TACC API, including Abaco, you will need an access token. Once generated, tokens are valid
for 4 hours. As we saw in the previous section, you can refresh your access token using the CLI:

```bash
> auth-tokens-refresh -v
```

We recommend saving your access token into a variable for ease of use:

```bash
> export TOKEN=<your_access_token>
> curl -H "Authorization: Bearer $TOKEN" https://api.tacc.utexas.edu/actors/v2
```

The API should return a JSON object and a success message if all went well.

### Registering an Actor

As Abaco is an HTTP API. To work with the service, any HTTP client can be used.
In this workshop we will focus on two clients: `curl`, which can be run from the command line in most Unix-like
environments; and the `tapispy` Python library.

#### Initial Registration

Once you have a Docker image built and pushed to the Docker Hub, you can register
an actor from it by making a POST request to the Abaco API.

The only required POST parameter is the docker image to use, but there are several other optional arguments.

#### Complete List of Registration Parameters
The following parameters can be passed when registering a new actor.

Required parameters:
* image - The Docker image to associate with the actor. This should be a fully qualified image available on the public
Docker Hub.

Optional parameters:
* name - A user defined name for the actor.
* description - A user defined description for the actor.
* default_environment - The default environment is a set of key/value pairs to be injected into every execution of the
actor. The values can also be overridden when passing a message to the actor in the query parameters.
* stateless (True/False) - Whether the actor stores private state as part of its execution. If True, the state API will
not be available. The default value is False.
* privileged (True/False) - Whether the actor runs in privileged mode and has access to the Docker daemon. *Note:
Setting this parameter to True requires elevated permissions.*


Here is an example using curl:

```
$ curl -k -H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" \
-d '{"image": "abacosamples/test", "name": "test", "description": "My test actor using the abacosamples image.", "default_environment":{"key1": "value1", "key2": "value2"} }' \
https://api.tacc.cloud/actors/v2
```

To register an actor using the `tapispy` library, we use the `actors.add()` method and pass the same arguments through
the `body` parameter. For example,

```
>>> from tapispy.tapis import Tapis
>>> tp = Tapis(api_server='https://api.tacc.utexas.edu', token='<access_token>')
>>> actor = {"image": "abacosamples/test", "name": "test", "description": "My test actor using the abacosamples image registered using agavepy.", "default_environment":{"key1": "value1", "key2": "value2"} }
>>> tp.actors.add(body=actor)
```

### Executing an Actor

To execute a Docker container associated with an actor, we send the actor a message by making a POST request to the
actor's inbox URI which is of the form:
```
https://api.tacc.cloud/actors/v2/<actor_id>/messages
```

Currently, three types of messages are supported: "raw" text strings, JSON messages, and "binary" messages.

### Executing Actors with Raw Strings ###

To execute an actor passing a raw string, make a POST request with a single argument in the message body of `message`.
Here is an example using curl:

```
$ curl -k -H "Authorization: Bearer $TOKEN" -d "message=some test message" https://api.tacc.cloud/actors/v2/$ACTOR_ID/messages
```

When this request is successful, the abaco will put a single message on the actor's message queue which will ultimately result in one container execution with the `$MSG` environment variable having the value `some test message`.

```
$ curl -k -H "Authorization: Bearer $TOKEN" - https://api.tacc.cloud/actors/v2/$ACTOR_ID/executions/$EXECUTION_ID/logs
```
=======
When this request is successful, Abaco will put a single message on the actor's message queue which will ultimately
result in one container execution with the `$MSG` environment variable having the value `some test message`.


The same execution could be made using the tapispy Python library like so:

```
>>> tp.actors.sendMessage(actorId='NolBaJ5y6714M', body={'message': 'test'})
```

### Executing Actors by Passing JSON ###

You can also send pure JSON as the actor message. To do so, specify a Content-Type of "application/json". Here is an
example using curl:

```
$ curl -k -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"username": "jdoe", "application_id": "print-env-cli-DggdGbK-0.1.0" }' https://api.tacc.cloud/actors/v2/$ACTOR_ID/messages
```

For actors written in Python, Abaco provides a set of helper Python functions for tasks such as parsing the message
data and returning "results". One advantage to passing JSON  is that this library will automatically attempt to
deserialize the JSON into a pure Python object. This shows up in the `context` object under the `message_dict` key. For example, for the example above,
the corresponding actor (if written in Python) could retrieve the application_id from the message with the following
code:

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

One can also retrieve data about an actor's executions and the logs generated by the execution.
Logs are anything written to standard out during the container execution. Note that logs are purged from the database on a regular interval (usually 24 hours) so be sure to retrieve important log data in a timely fashion.

To get details about an execution, make a GET request to the actor's executions collection with the execution id:

```
$ curl -k -H "Authorization: Bearer $TOKEN" https://api.tacc.cloud/actors/v2/$ACTOR_ID/executions/$EXECUTION_ID
```
Here is an example response:
```
{
  "message": "Actor execution retrieved successfully.",
  "result": {
    "_links": {
      "logs": "https://api.sd2e.org/actors/v2/SD2E_NolBaJ5y6714M/executions/ZgeLeGGQDaZjj/logs",
      "owner": "https://api.sd2e.org/profiles/v2/jstubbs",
      "self": "https://api.sd2e.org/actors/v2/SD2E_NolBaJ5y6714M/executions/ZgeLeGGQDaZjj"
    },
    "actorId": "NolBaJ5y6714M",
    "apiServer": "https://api.sd2e.org",
    "cpu": 271632236,
    "executor": "jstubbs",
    "exitCode": 0,
    "finalState": {
      "Dead": false,
      "Error": "",
      "ExitCode": 0,
      "FinishedAt": "2017-10-06T15:54:00.019411149Z",
      "OOMKilled": false,
      "Paused": false,
      "Pid": 0,
      "Restarting": false,
      "Running": false,
      "StartedAt": "2017-10-06T15:53:57.845747189Z",
      "Status": "exited"
    },
    "id": "ZgeLeGGQDaZjj",
    "io": 766,
    "messageReceivedTime": "2017-10-06 15:53:55.615958",
    "runtime": 2,
    "startTime": "2017-10-06 15:53:57.088129",
    "status": "COMPLETE",
    "workerId": "lzD51vqrYaL8g"
  },
  "status": "success",
  "version": ":dev"
}
```
The equivalent request in Python looks like:

```
>>> tp.actors.getExecution(actorId=aid, executionId=exid)
```

Finally, to retrieve an execution's logs, make a GET request to the logs collection for the execution. For example:

```
$ curl -k -H "Authorization: Bearer $TOKEN" https://api.tacc.cloud/actors/v2/$ACTOR_ID/executions/$EXECUTION_ID/logs
```
Here is an example response:
```
{
  "message": "Logs retrieved successfully.",
  "result": {
    "_links": {
      "execution": "https://api.sd2e.org/actors/v2/NolBaJ5y6714M/executions/ZgeLeGGQDaZjj",
      "owner": "https://api.sd2e.org/profiles/v2/jstubbs",
      "self": "https://api.sd2e.org/actors/v2/NolBaJ5y6714M/executions/ZgeLeGGQDaZjj/logs"
    },
    "logs": "Contents of MSG: {'application_id': 'print-env-cli-DggdGbK-0.1.0', 'username': 'jdoe'}\nEnvironment:\nHOSTNAME=ba45cf7c68d5\nSHLVL=1\nHOME=/root\n_abaco_actor_id=NolBaJ5y6714M\n_abaco_access_token=9562ff7763cb6a21a0851f5e19bea67\n_abaco_api_server=https://api.sd2e.org\n_abaco_actor_dbid=SD2E_NolBaJ5y6714M\nMSG={'application_id': 'print-env-cli-DggdGbK-0.1.0', 'username': 'jdoe'}\n_abaco_execution_id=ZgeLeGGQDaZjj\nPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\nkey1=value1\n_abaco_Content_Type=application/json\nkey2=value2\nPWD=/\n_abaco_jwt_header_name=X-Jwt-Assertion-Sd2E\n_abaco_username=jstubbs\n_abaco_actor_state={}\nContents of root file system: \nbin\ndev\netc\nhome\nproc\nroot\nsys\ntest.sh\ntmp\nusr\nvar\nChecking for contents of mounts:\nMount does not exist\n"
  },
  "status": "success",
  "version": ":dev"
}
```

The equivalent request in Python looks like:
```
>>> ag.actors.getExecutionLogs(actorId=aid, executionId=exid)
```
