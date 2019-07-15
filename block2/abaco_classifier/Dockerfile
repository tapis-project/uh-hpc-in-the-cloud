# image: taccsciapps/abaco_classifier

FROM tensorflow/tensorflow:1.5.0-py3

# install requirements
RUN pip install requests

# add our app
RUN mkdir /apps
ADD classify_image.py /app/classify_image.py
RUN chmod +x /app/classify_image.py
ADD abaco.sh /app/abaco.sh
RUN chmod +x /app/abaco.sh
RUN chmod -R 777 /app

CMD ["/app/abaco.sh"]