import json
import sys
from jinja2 import Environment, FileSystemLoader
from agavepy import Agave

# base url of the tenant you want to use
url = sys.argv[1]
# valid access token for the tenant above 
tok = sys.argv[2]
# system.json rendered file location
system_rendered_json = sys.argv[3] 
# system.json template file location
system_template_json = sys.argv[4]
#directory for templates
file_loader = FileSystemLoader('templates')
env = Environment(loader=file_loader)
template = env.get_template(system_template_json)
output = template.render(user='****',confName='PEARC19',password='****',allocation='****')
# write rendered output to a file
sysfile = open(system_rendered_json, 'w') 
sysfile.write(output)
sysfile.close()

with open(system_rendered_json, 'r') as f:
    data = f.read()
    s = json.loads(data)

# register system with agave
ag = Agave(api_server=url, token=tok)
ag.systems.add(body=s)


