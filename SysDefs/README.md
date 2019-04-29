 template_render.py renders Jinja2 template for system definition and registers system on TACC-PROD tenant

Run template_render.py as below to render and register a compute system 
python template_render.py 'https://api.tacc.utexas.edu/' $tok 'templates/compute_system.json' 'compute_system_template.json'
Arg. 1 is the tenant base url
Arg. 2 is the Auth token 
Arg. 3 is the file path of rendered template for system definition 
Arg.4 is the template to be rendered

Files listing works for both storage and compute system.Systems have been registered with password authentication with the cic service account.

