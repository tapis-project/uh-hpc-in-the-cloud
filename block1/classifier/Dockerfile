# image: taccsciapps/classify_image

FROM tensorflow/tensorflow:1.5.0-py3

# pre-reqs
# RUN apt-get update && apt-get install -y wget

# our app
ADD classify_image.py /classify_image.py
RUN pip install requests
# ADD entry.sh /entry.sh
# RUN chmod +x /entry.sh

ENTRYPOINT ["python", "/classify_image.py"]
# ENTRYPOINT ["/entry.sh"]