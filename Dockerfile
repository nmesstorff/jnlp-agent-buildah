# Highly inspired by https://developers.redhat.com/blog/2019/08/14/best-practices-for-running-buildah-in-a-container/

FROM jenkins/inbound-agent:alpine as jnlp

FROM quay.io/buildah/stable:latest

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

RUN sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /etc/containers/storage.conf
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
