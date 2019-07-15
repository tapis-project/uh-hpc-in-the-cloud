#!/bin/bash
#
# Entrypoint script for the Abaco-ready version of the classifer image.
# This script expects an environment variable, MSG, to be set to a string
# containing a URL to an image to classify.
#
# Example invocation:
# docker run -e MSG=https://s3.amazonaws.com/cdn-origin-etr.akc.org/wp-content/uploads/2017/11/12231410/Labrador-Retriever-On-White-01.jpg taccsciapps/abaco_classifier
#
#
# print the special MSG variable:
echo "Contents of MSG: "$MSG
cd /app
python classify_image.py --image_file=$MSG
