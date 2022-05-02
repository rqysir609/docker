#!/bin/bash

#卸载旧版本
sudo apt-get remove docker docker-engine docker.io containerd runc

#更新 apt 包索引
sudo apt-get update

#设置存储库
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
#添加 Docker 的官方 GPG 密钥:官方地址
#curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#设置稳定存储库:官方地址
#echo \                                                                     
#  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
#  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#添加 Docker 的官方 GPG 密钥:中科大地址
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

#设置稳定存储库:中科大地址
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.ustc.edu.cn/docker-ce/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#更新 apt 包索引
sudo apt-get update

#安装最新版本的 Docker Engine-Community 和 containerd
sudo apt-get install docker-ce docker-ce-cli containerd.io

#设置阿里云镜像加速器
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors":["https://2vel7s8h.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

#删除安装包
#sudo apt-get purge docker-ce

#删除镜像、容器、配置文件等内容
#sudo rm -rf /var/lib/docker