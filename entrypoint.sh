#!/bin/sh

set -e

echo "$INPUT_SERVICE_KEY" | base64 --decode > "$HOME"/gcloud.json

if [ "$INPUT_ENV" ]
then
    ENVS=$(cat "/github/workspace/$INPUT_ENV" | xargs | sed 's/ /,/g')
fi


if [ "$ENVS" ]
then
    ENV_FLAG="--set-env-vars $ENVS"
else
    ENV_FLAG="--clear-env-vars"
fi


if [ "$INPUT_CLOUD_SQL" ]
then
    ENV_FLAG="--add-cloudsql-instances $INPUT_CLOUD_SQL --set-env-vars INSTANCE_CONNECTION_NAME=$INPUT_CLOUD_SQL $ENV_FLAG"
fi

if [ "$INPUT_VPC_CONNECTOR" ]
then
    ENV_FLAG="--vpc-connector $INPUT_VPC_CONNECTOR $ENV_FLAG"
fi

gcloud auth activate-service-account --key-file="$HOME"/gcloud.json --project "$INPUT_PROJECT"
gcloud auth configure-docker

docker push "$INPUT_IMAGE"

gcloud run deploy "$INPUT_SERVICE" \
  --image "$INPUT_IMAGE" \
  --platform managed \
  --region "$INPUT_REGION" \
  ${ENV_FLAG}

gcloud run services update-traffic "$INPUT_SERVICE" --to-latest \
  --platform managed \
  --region "$INPUT_REGION"
