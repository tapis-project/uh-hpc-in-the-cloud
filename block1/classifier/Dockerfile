# image: taccsciapps/classify_image

FROM tensorflow/tensorflow:1.5.0-py3

# install requirements
RUN pip install requests

# add our app
ADD classify_image.py /classify_image.py

ENTRYPOINT ["python", "/classify_image.py"]