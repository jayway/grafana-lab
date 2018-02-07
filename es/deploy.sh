#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

die() { echo "$*"; exit 111; }

unset ES_DOMAIN
while getopts ":d:" opt; do
  case $opt in
    d )
      ES_DOMAIN=$OPTARG
      ;;
    \? )
      die "Error: invalid option: -$OPTARG"
      ;;
    : )
      die "Error: option -$OPTARG requires an argument."
      ;;
  esac
done

[ -z $ES_DOMAIN ] && ES_DOMAIN=es-grafana-$RANDOM

echo "Creating/updating ES domain $ES_DOMAIN"
aws cloudformation deploy \
    --template-file $DIR/es.yaml \
    --stack-name $ES_DOMAIN \
    --parameter-overrides DomainName=$ES_DOMAIN \
    --capabilities CAPABILITY_IAM

echo $(aws cloudformation describe-stacks --stack-name $ES_DOMAIN --query 'Stacks[0].Outputs[?OutputKey==`DomainEndpoint`].OutputValue' --output text)