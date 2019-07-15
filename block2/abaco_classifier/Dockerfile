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

<<<<<<< HEAD
CMD /abaco.sh
=======
CMD ["/app/abaco.sh"]
>>>>>>> f5ec9b89482e95b479cf59b7937210300c197d9d
