FROM tailscale/tailscale:v1.82.5 AS tailscale
FROM phusion/baseimage:noble-1.0.2

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update && \ 
    apt-get install -y --no-install-recommends \
        gcc \
        jq \
        j2cli \
        nodejs  \
        nvidia-cuda-toolkit \
        pipx \
        python3-dev \
        python3-pip \
        python3.12-venv && \
    npm install -g yarn

RUN apt-get clean && \ 
    rm -rf /root/.npm \
        /usr/share/doc/* \
        /usr/share/man/* \
        /var/lib/apt/lists/*

RUN pipx ensurepath && \
    pipx install nvitop-exporter

RUN mkdir /etc/jinja
COPY jinja /etc/jinja

COPY utils/ /opt/utils
COPY build/rl-swarm /opt/swarm

COPY env /etc/container_environment
COPY /runit/startup.sh /etc/rc.local
RUN chmod +x /etc/rc.local

COPY runit/services/ /etc/service/
RUN find -L /etc/service \
    -type f \
    \( -name run -o -name down \) \
    -exec chmod +x {} +;

COPY --from=tailscale /usr/local/bin/tailscaled /bin/
COPY --from=tailscale /usr/local/bin/tailscale /bin/
COPY --from=tailscale /usr/local/bin/containerboot /bin/tailscaleup

CMD ["/sbin/my_init"]
