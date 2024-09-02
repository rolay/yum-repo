#  Yum Repo for Docker/K8S installation
 Yum Repo for Docker/K8S installation

使用方法

YUM Repo服务器安装好docker，直接运行命令：
```
docker run -d -p 80:80 --name=yum-repo yum-repo:v1.28
```

在需要安装docker/k8s的其它主机上, 创建一个repo文件至 /etc/yum.repos.d/
```
cat > /etc/yum.repos.d/rpms.repo <<EOF
[pkgs]
name=pkgs
baseurl=http://$ip/rpms/kylin-v10
enabled=1
gpgcheck=0
EOF
```

上面的`$ip`请写为上述服务器的真实IP地址，然后就可以直接用yum install命令命令安装相关软件了。例如：
```
yum --disablerepo=* --enablerepo=-pkgs install rsync python-chardet jq nfs-utils
yum --disablerepo=* --enablerepo=-pkgs install kubernetes-cni kubectl kubelet kubeadm
yum --disablerepo=* --enablerepo=-pkgs install cri-o podman crun
yum --disablerepo=* --enablerepo=-pkgs install docker-ce docker-ce-cli
```