# image: taccsciapps/abaco_classifier

FROM tensorflow/tensorflow:1.5.0-py3

# install requirements
RUN pip install requests

# add our app
ADD classify_image.py /classify_image.py
RUN chmod +x /classify_image.py
ADD abaco.sh /abaco.sh
RUN chmod +x /abaco.sh

CMD ["/abaco.sh"]
