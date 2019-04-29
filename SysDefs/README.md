script template_render.py converts template to system definition json, which is then used to register system on agave using agavepy

Run it as 
python template_render.py 'https://api.tacc.utexas.edu/' $tok 'templates/compute_system.json' 'compute_system_template.json'

Files listing works for both storage and compute system.

