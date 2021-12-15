# About
The purpose of this project is to write a function that parses an url extracting positional parameters. It receives 2 parameters (both mandatory):
- **URL_FORMAT**: describes the format of a url. A url format string can contain constant parts and variable parts, in any order, where "parts" of 
a url are separated with "/". All variable parts begin with a colon. Here is an example of such a url format string:
```
'/api/v2/:user/:role'
```
- **URL_INSTANCE**: A particular url instance that is guaranteed to have the format given by the url format string. It may also contain url parameters. 
For example, given the example url format string above, the url instance might be:
```
'/api/v2/etolstanov/guest?is_private=true&has_email_confirmed=false'
```

## How to use it
```
docker run \
  -e "URL_FORMAT=/api/v2/:user/:role" \
  -e "URL_INSTANCE=/api/v2/etolstanov/guest?is_private=true&has_email_confirmed=false" \
  etolstanov/rtnd:1.1 

{
"user": "etolstanov",
"role": "guest",
"is_private": "true",
"has_email_confirmed": "false"
}
```

## Dockerhub repository
The docker image is available in [DockerHub](https://hub.docker.com/r/etolstanov/rtnd)
