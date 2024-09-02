FROM swr.cn-southwest-2.myhuaweicloud.com/wutong/kylin:v10-sp2 as kylinv10sp2
COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/kylin-V10-sp2 -p && \
    yum install createrepo dnf-plugins-core -yq && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/kylin-V10-sp2 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/kylin-V10-sp2 podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/kylin-V10-sp2 kubectl kubelet kubeadm && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/kylin-V10-sp2 docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN createrepo /rpms/kylin-V10-sp2

FROM swr.cn-southwest-2.myhuaweicloud.com/wutong/kylin:v10-sp3 as kylinv10sp3
COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/kylin-V10 -p && \
    yum install createrepo dnf-plugins-core -yq && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/kylin-V10 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/kylin-V10 podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/kylin-V10 kubectl kubelet kubeadm && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/kylin-V10 docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN createrepo /rpms/kylin-V10

FROM openeuler/openeuler:22.03-lts-sp4 as openEuler22
COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/openEuler-22 -p && \
    yum install createrepo dnf-plugins-core -yq && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/openEuler-22 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/openEuler-22 podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/openEuler-22 kubectl kubelet kubeadm && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/openEuler-22 docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN createrepo /rpms/openEuler-22

FROM openeuler/openeuler:24.03-lts as openEuler24
COPY  *.repo /etc/yum.repos.d/
RUN mkdir /rpms/openEuler-24 -p && \
    yum install createrepo dnf-plugins-core -yq && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/openEuler-24 audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools python3 python3-chardet python3-docker python3-pip python3-requests sysstat tar tcpdump && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/openEuler-24 podman cri-o container-selinux policycoreutils-python-utils python3-policycoreutils python3-libsemanage && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/openEuler-24 kubectl kubelet kubeadm && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=/rpms/openEuler-24 docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN createrepo /rpms/openEuler-24

FROM nginx:alpine

COPY --from=kylinv10sp2 /rpms /usr/share/nginx/html/rpms
COPY --from=kylinv10sp3 /rpms /usr/share/nginx/html/rpms
COPY --from=openEuler22 /rpms /usr/share/nginx/html/rpms
COPY --from=openEuler24 /rpms /usr/share/nginx/html/rpms

COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
