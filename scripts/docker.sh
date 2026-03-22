#!/usr/bin/env bash
set -euo pipefail

WSL_CONF="/etc/wsl.conf"

if grep -q "systemd = true" "$WSL_CONF" 2>/dev/null; then
  echo "› $MSG_DOCKER_SYSTEMD_ENABLED $WSL_CONF"
else
  echo "› $MSG_DOCKER_SYSTEMD_ENABLING $WSL_CONF..."
  sudo tee "$WSL_CONF" > /dev/null << 'EOF'
[boot]
systemd = true

[interop]
appendWindowsPath = true
EOF
  echo "  $MSG_DOCKER_SYSTEMD_DONE"
fi

if ! pidof systemd &>/dev/null; then
  echo ""
  echo "  ⚠ $MSG_DOCKER_SYSTEMD_NOT_RUNNING"
  echo "  $MSG_DOCKER_SYSTEMD_RESTART_HINT"
  exit 1
fi

if command -v docker &>/dev/null; then
  echo "› $MSG_DOCKER_ALREADY_INSTALLED docker $(docker --version)"
else
  echo "› $MSG_DOCKER_INSTALLING"

  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y ca-certificates curl

  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -qq
  sudo apt-get install -y \
    docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin

  echo "  $(docker --version)"
fi

if groups "$USER" | grep -q docker; then
  echo "› $USER $MSG_DOCKER_GROUP_EXISTS"
else
  echo "› $MSG_DOCKER_GROUP_ADDING"
  sudo usermod -aG docker "$USER"
  echo "  $MSG_DOCKER_GROUP_DONE"
fi

echo "› $MSG_DOCKER_SERVICE_ENABLING"
sudo systemctl enable --now docker.service
echo "  $(sudo systemctl is-active docker.service)"

if [[ "${DOCKER_EXPOSE_TCP:-false}" == "true" ]]; then
  echo "› $MSG_DOCKER_TCP_CONFIGURING"

  sudo tee /etc/docker/daemon.json > /dev/null << 'EOF'
{
  "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]
}
EOF

  sudo mkdir -p /etc/systemd/system/docker.service.d
  sudo tee /etc/systemd/system/docker.service.d/override.conf > /dev/null << 'EOF'
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

  sudo systemctl daemon-reexec
  sudo systemctl restart docker
  echo "  $MSG_DOCKER_TCP_DONE"
fi

echo ""
echo "› $MSG_DOCKER_VERIFYING"
docker run --rm hello-world 2>&1 | grep "Hello from Docker" \
  && echo "  $MSG_DOCKER_VERIFY_OK" \
  || echo "  $MSG_DOCKER_VERIFY_FAIL"
