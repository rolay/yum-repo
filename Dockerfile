FROM swr.cn-southwest-2.myhuaweicloud.com/wutong/kylin:v10-sp3 as kylinv10sp3

COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/kylinv10-sp3/ -p && \
    yum install createrepo dnf-plugins-core -y && \
    yumdownloader --resolve --archlist=x86_64,aarch64 --destdir=/rpms/kylinv10-sp3 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yumdownloader --resolve --archlist=x86_64,aarch64 --destdir=/rpms/kylinv10-sp3 podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yumdownloader --resolve --archlist=x86_64,aarch64 --destdir=/rpms/kylinv10-sp3 kubectl kubelet kubeadm

RUN createrepo /rpms/kylinv10-sp3

FROM nginx:alpine

COPY --from=kylinv10sp3 /rpms /usr/share/nginx/html/rpms
COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
