FROM python:3.8-slim

RUN apt-get update && apt-get install -y jq zip git
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
