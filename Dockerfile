FROM swr.cn-southwest-2.myhuaweicloud.com/wutong/kylin:v10-sp2 as kylinv10sp2
COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/kylinv10-sp2/ -p && \
    yum install createrepo -y && \
    yum -y install --downloadonly --downloaddir=/rpms/kylinv10-sp2 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yum -y install --downloadonly --downloaddir=/rpms/kylinv10-sp2 podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yum -y install --downloadonly --downloaddir=/rpms/kylinv10-sp2 kubectl kubelet kubeadm
RUN createrepo /rpms/kylinv10-sp2

FROM swr.cn-southwest-2.myhuaweicloud.com/wutong/kylin:v10-sp3 as kylinv10sp3
COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/kylinv10-sp3/ -p && \
    yum install createrepo -y && \
    yum -y install --downloadonly --downloaddir=/rpms/kylinv10-sp3 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yum -y install --downloadonly --downloaddir=/rpms/kylinv10-sp3 podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yum -y install --downloadonly --downloaddir=/rpms/kylinv10-sp3 kubectl kubelet kubeadm
RUN createrepo /rpms/kylinv10-sp3

FROM openeuler/openeuler:22.03-lts-sp4 as openEuler22.03-LTS-SP4
COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/openEuler22.03-LTS-SP4/ -p && \
    yum install createrepo -y && \
    yum -y install --downloadonly --downloaddir=/rpms/openEuler22.03-LTS-SP4 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yum -y install --downloadonly --downloaddir=/rpms/openEuler22.03-LTS-SP4 podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yum -y install --downloadonly --downloaddir=/rpms/openEuler22.03-LTS-SP4 kubectl kubelet kubeadm
RUN createrepo /rpms/openEuler22.03-LTS-SP4

FROM openeuler/openeuler:24.03-lts as openEuler24.03-LTS
COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/openEuler24.03-LTS/ -p && \
    yum install createrepo -y && \
    yum -y install --downloadonly --downloaddir=/rpms/openEuler24.03-LTS audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yum -y install --downloadonly --downloaddir=/rpms/openEuler24.03-LTS podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yum -y install --downloadonly --downloaddir=/rpms/openEuler24.03-LTS kubectl kubelet kubeadm
RUN createrepo /rpms/openEuler24.03-LTS

FROM nginx:alpine

COPY --from=kylinv10sp2 /rpms /usr/share/nginx/html/rpms
COPY --from=kylinv10sp3 /rpms /usr/share/nginx/html/rpms
COPY --from=openEuler22.03-LTS-SP4 /rpms /usr/share/nginx/html/rpms
COPY --from=openEuler24.03-LTS /rpms /usr/share/nginx/html/rpms

COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
