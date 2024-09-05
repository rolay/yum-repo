ENV RPM_DIR=/rmps
ENV RPMS="audit audit-libs-python3 bash-completion bind-utils curl chrony conntrack fuse \
    git graphviz ipset ipvsadm iscsi-initiator-utils jq kubernetes-cni nfs-utils nc net-tools sysstat tar tcpdump \
    python3 python3-chardet python3-docker python3-pip python3-requests python3-jsonpatch python3-pyyaml python3-kubernetes python3-policycoreutils python3-libsemanage \
    podman cri-o container-selinux policycoreutils-python-utils kubectl kubelet kubeadm \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

FROM swr.cn-southwest-2.myhuaweicloud.com/wutong/kylin:v10-sp2 as kylinv10sp2
COPY  *.repo /etc/yum.repos.d/
RUN mkdir ${RPM_DIR}/kylin-V10-sp2 -p && \
    yum install createrepo dnf-plugins-core -yq && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=${RPM_DIR}/kylin-V10-sp2 ${RPMS}
RUN createrepo ${RPM_DIR}/kylin-V10-sp2

FROM swr.cn-southwest-2.myhuaweicloud.com/wutong/kylin:v10-sp3 as kylinv10sp3
COPY  *.repo /etc/yum.repos.d/
RUN mkdir ${RPM_DIR}/kylin-V10 -p && \
    yum install createrepo dnf-plugins-core -yq && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=${RPM_DIR}/kylin-V10 ${RPMS}
RUN createrepo ${RPM_DIR}/kylin-V10

FROM openeuler/openeuler:22.03-lts-sp4 as openEuler22
COPY  *.repo /etc/yum.repos.d/
RUN mkdir ${RPM_DIR}/openEuler-22 -p && \
    yum install createrepo dnf-plugins-core -yq && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=${RPM_DIR}/openEuler-22 ${RPMS}
RUN createrepo ${RPM_DIR}/openEuler-22

FROM openeuler/openeuler:24.03-lts as openEuler24
COPY  *.repo /etc/yum.repos.d/
RUN mkdir ${RPM_DIR}/openEuler-24 -p && \
    yum install createrepo dnf-plugins-core -yq && \
    yumdownloader --resolve --archlist=noarch,aarch64 --destdir=${RPM_DIR}/openEuler-24 ${RPMS}
RUN createrepo ${RPM_DIR}/openEuler-24

FROM nginx:alpine

COPY --from=kylinv10sp2 ${RPM_DIR} /usr/share/nginx/html${RPM_DIR}
COPY --from=kylinv10sp3 ${RPM_DIR} /usr/share/nginx/html${RPM_DIR}
COPY --from=openEuler22 ${RPM_DIR} /usr/share/nginx/html${RPM_DIR}
COPY --from=openEuler24 ${RPM_DIR} /usr/share/nginx/html${RPM_DIR}

COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
