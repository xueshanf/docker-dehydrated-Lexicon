#!/bin/bash

IMAGE=xueshanf/docker-dehydrated-lexicon
AWS_PROFILE="${AWS_PROFILE?Need to export AWS_PROFILE}"
EMAIL="${EMAIL?Need to export EMAIL}"
DOMAINS="${DOMAINS?Need to export DOMAINS}"

if ! aws --profile ${AWS_PROFILE} sts get-caller-identity > /dev/null; then
  echo "Cannot find ${AWS_PROFILE} in ~/.aws/credentials."
  exit 1
fi

AUTH_ACCESS_KEY=$(aws configure get aws_access_key_id --profile ${AWS_PROFILE})
AUTH_ACCESS_SECRET=$(aws configure get aws_secret_access_key --profile ${AWS_PROFILE})
docker run -d --rm  --name dehydrated  \
    -e "EMAIL=$EMAIL"  \
    -e "PROVIDER=--delegated ${DOMAINS} route53" \
    -e LEXICON_ROUTE53_AUTH_ACCESS_KEY=${AUTH_ACCESS_KEY} \
    -e LEXICON_ROUTE53_AUTH_ACCESS_SECRET=${AUTH_ACCESS_SECRET} \
    -v $PWD/certs/letsencrypt:/letsencrypt/ \
    -v $PWD/config:/config \
    $IMAGE /run.sh
