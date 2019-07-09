#!/bin/bash

# print the special MSG variable:
echo "Contents of MSG: "$MSG
cd /
python classify_image.py --image_file=$MSG
