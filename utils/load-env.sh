#!/bin/sh

load_env() {
    env_file="$1"

    if [ -f "$env_file" ]; then
        while IFS='=' read -r key value || [ -n "$key" ]; do
            [ -z "$key" ] && continue
            echo "$key" | grep -q '^#' && continue

            value=$(echo "$value" | sed 's/^["'"'"']\(.*\)["'"'"']$/\1/')
            eval "current=\$$key"
            if [ -z "$current" ]; then
                export "$key=$value"
            fi
        done < "$env_file"
    fi
}
