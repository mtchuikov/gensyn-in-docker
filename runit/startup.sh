#!/bin/sh
exec 2>&1

setup_swarm_data() {
    cd /opt/swarm/modal-login/temp-data/

    echo "$SWARM_API_KEY" | base64 -d > userApiKey.json
    echo "$SWARM_USER_DATA" | base64 -d > userData.json
}

setup_ssh_keys() {
    cd /root/.ssh
    echo "$SSHD_AUTHORIZED_KEYS" | base64 -d > authorized_keys
}

render_config_templates() {
    cd /etc/jinja/

    j2 sshd_config.j2 -o /etc/ssh/sshd_config
    j2 swarm.yaml.j2 -o /opt/swarm/swarm.yaml
}

setup_swarm_data
setup_ssh_keys
render_config_templates
