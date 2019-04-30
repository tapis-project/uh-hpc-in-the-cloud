Script template_render.py renders Jinja2 system templates and registers them on the TACC-PROD tenant using agavepy system calls

Run template_render.py as below 
python template_render.py 'https://api.tacc.utexas.edu/' $tok 'templates/compute_system.json' 'compute_system_template.json'


Arg. 1 is the tenant base url.
Arg. 2 is the Auth token. 
Arg. 3 is the destination for the rendered system definition 
Arg.4 is the template to be rendered

We can test by doing a Files listing on both storage and compute. System definitions use password authentication for cic service account.

