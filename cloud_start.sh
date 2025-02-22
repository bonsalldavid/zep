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
    envsubst '$POSTGRES_USER $POSTGRES_PASSWORD $POSTGRES_HOST $POSTGRES_PORT $POSTGRES_DATABASE $ZEP_API_SECRET $ZEP_SERVER_WEB_ENABLED $ZEP_OPENAI_API_KEY' < /app/zep.yaml > /app/config.yaml
else
    echo "zep.yaml template not found! Exiting."
    exit 1
fi

echo "----- Generated config.yaml -----"
cat /app/config.yaml
echo "---------------------------------"

# Unset any legacy DSN variable to ensure only explicit fields are used.
unset ZEP_STORE_POSTGRES_DSN

exec /app/zep --config /app/config.yaml
