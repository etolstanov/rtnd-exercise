# rtnd-exercise
This repository has been created with the purpose of solving the exercise provided by rtnd.

## how to use it
docker run --rm \
  -e "URL_FORMAT=/api/v2/:user/:role" \
  -e "URL_INSTANCE=/api/v2/etolstanov/guest?is_private=true&has_email_confirmed=false" \
  etolstanov/rtnd:1.1 \

{\
"user": "etolstanov",\
"role": "guest",\
"is_private": "true",\
"has_email_confirmed": "false"\
}

## dockerhub repository
https://hub.docker.com/r/etolstanov/rtnd
