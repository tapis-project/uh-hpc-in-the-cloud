#!/bin/bash
module load tacc-singularity/2.6.0

export imagefile="--image_file https://s3.amazonaws.com/cdn-origin-etr.akc.org/wp-content/uploads/2017/11/12231410/Labrador-Retriever-On-White-01.jpg"
export predictions="--num_top_predictions 5"

cd ../ && bash wrapper.sh
