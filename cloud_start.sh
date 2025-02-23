#!/usr/bin/env sh

echo "----- Debug: Environment Variables -----"
echo "POSTGRES_USER: $POSTGRES_USER"
echo "POSTGRES_PASSWORD: $POSTGRES_PASSWORD"
echo "POSTGRES_HOST: $POSTGRES_HOST"
echo "POSTGRES_PORT: $POSTGRES_PORT"
echo "POSTGRES_DATABASE: $POSTGRES_DATABASE"
echo "ZEP_SERVER_WEB_ENABLED: $ZEP_SERVER_WEB_ENABLED"
echo "ZEP_API_SECRET: $ZEP_API_SECRET"
echo "ZEP_OPENAI_API_KEY: $ZEP_OPENAI_API_KEY"
echo "------------------------------------------"

if [ -f /app/zep.yaml ]; then
    echo "Processing /app/zep.yaml with envsubst..."

#    # 1) Move the original zep.yaml to a temp file
#    mv /app/zep.yaml /app/zep.yaml.template

    # 2) Perform env substitution on the template
    envsubst '$ZEP_AUTH_SECRET $POSTGRES_USER $POSTGRES_PASSWORD $POSTGRES_HOST $POSTGRES_PORT $POSTGRES_DATABASE $ZEP_API_SECRET $ZEP_SERVER_WEB_ENABLED $ZEP_OPENAI_API_KEY' \
      < /app/zep.yaml > /app/zep.yaml.tmp
    mv /app/zep.yaml.tmp /app/zep.yaml

    rm /app/zep.yaml.template
else
    echo "zep.yaml template not found! Exiting."
    exit 1
fi

echo "----- Generated /app/zep.yaml -----"
cat /app/zep.yaml
echo "-----------------------------------"

exec /app/zep --config /app/zep.yaml
#sleep 99999
