ARG TAG=latest
FROM alpine:${TAG}

COPY dist/prog.sh /usr/local/bin/

USER guest
ENTRYPOINT ["prog.sh"]
