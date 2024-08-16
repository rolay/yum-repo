FROM swr.cn-southwest-2.myhuaweicloud.com/wutong/kylin:v10-sp3 as build

COPY  *.repo /etc/yum.repos.d/
RUN mkdir -p /rpms/k8s/centos9 && \
    yum -y install --downloadonly --downloaddir=/rpms/k8s/kylinv10-sp3 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump createrepo && \
    yum -y install --downloadonly --downloaddir=/rpms/k8s/kylinv10-sp3 podman cri-o crun flatpak-selinux container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yum -y install --downloadonly --downloaddir=/rpms/k8s/kylinv10-sp3 kubectl kubelet kubeadm

RUN createrepo /rpms/kylinv10-sp3

FROM nginx:alpine

COPY --from=build /rpms /usr/share/nginx/html/rpms
COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
