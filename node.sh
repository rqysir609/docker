#!/bin/bash

apt-get update

echo "��װDocker"
# curl -sSL https://get.docker.com/ | sh

mkdir -p /etc/nginx
mkdir -p /etc/nginx/conf.d
mkdir -p /usr/share/nginx/html

CF_Token="AAA"
CF_Zone_ID="AAA"
CF_Account_ID="AAA"

# ��������
docker run --name nginx -p 9001:80 -d nginx
# ������nginx.conf�ļ����Ƶ�������
docker cp nginx:/etc/nginx/nginx.conf /etc/nginx/nginx.conf
# ������conf.d�ļ��������ݸ��Ƶ�������
docker cp nginx:/etc/nginx/conf.d /etc/nginx/conf.d
# �������е�html�ļ��и��Ƶ�������
docker cp nginx:/usr/share/nginx/html /usr/share/nginx/html
# ɾ���������е�nginx����
docker rm -f nginx

# ����Docker-Compose
cat > $PWD/docker-compose.yml << EOF
version: "3"
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    restart: unless-stopped
    network_mode: host
    environment:
      - PGID=1000
      - PUID=1000
    volumes:
      - /etc/nginx/nginx.conf:/etc/nginx/nginx.conf
      - /etc/nginx/conf.d:/etc/nginx/conf.d
      - /var/www/html:/var/www/html
      - /var/log/nginx:/var/log/nginx
      - /root/certs:/root/certs
 
  acme:
    image: neilpang/acme.sh
    container_name: acme.sh
    restart: unless-stopped
    network_mode: host
    environment:
      - PGID=1000
      - PUID=1000
      - CF_Token=${CF_Token}
      - CF_Zone_ID=${CF_Zone_ID}
      - CF_Account_ID=${CF_Account_ID}
    volumes:
      - /root/acme.sh:/acme.sh
      - /root/certs:/root/certs
EOF

# �״������Ƚ�����������֤��
# acme.sh --issue --dns dns_dp -d sleele.com -d *.sleele.com
# ��һ����Ҫ���Լ�������ע�� docker exec -i acme-ecc acme.sh --register-account -m my@example.com
# docker exec -i acme-ecc acme.sh --issue --dns dns_dp -d sleele.com -d *.sleele.com --keylength ec-256
# Ȼ����֤�鵽ָ���ļ���
# acme.sh --deploy -d sleele.com --deploy-hook docker
# docker exec -i acme-ecc acme.sh --deploy -d sleele.com --ecc --deploy-hook docker
