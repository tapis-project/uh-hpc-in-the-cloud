#!/bin/bash
module load tacc-singularity/2.6.0

singularity run pearc19-classifier.simg python /classify_image.py ${imagefile} ${predictions} > predictions.txt
