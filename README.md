#  Yum Repo for Docker/K8S etc installation
 Yum Repo for Docker/K8S etc installation

使用方法

YUM Repo服务器安装好docker，直接运行命令：
```
docker run -d -p 8090:8090 --name=yum-repo yum-repo:v1.28
```

在需要安装docker/k8s的其它主机上, 创建一个repo文件至 /etc/yum.repos.d/
```
cat > /etc/yum.repos.d/rpms.repo <<EOF
[custom-pkgs]
name=custom-pkgs
baseurl=http://$ip:8090/rpms/kylinv10-sp3
enabled=1
gpgcheck=0
EOF
```

上面的`$ip`请写为上述服务器的真实IP地址，然后就可以直接用yum install命令命令安装相关软件了。例如：
```
yum --disablerepo=* --enablerepo=-k8s install rsync python-chardet jq nfs-utils
yum --disablerepo=* --enablerepo=-k8s install kubernetes-cni kubectl kubelet kubeadm
yum --disablerepo=* --enablerepo=-k8s install cri-o podman crun
yum --disablerepo=* --enablerepo=-docker install docker-ce docker-ce-cli
yum --disablerepo=* --enablerepo=-ceph install ceph-deploy ceph ceph-radosgw rbd-nbd rbd-mirror
```