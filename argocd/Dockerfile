ARG ARGOCD_SRC_IMAGE_TAG="v1.5.1"

FROM argoproj/argocd:${ARGOCD_SRC_IMAGE_TAG}

ARG SOPS_VERSION="v3.5.0"

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests 
# (e.g. curl, awscli, gpg, sops)
RUN apt-get update \
  && apt-get install -y \
    curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux \
  && chmod +x /usr/local/bin/sops 

# Switch back to non-root user
USER argocd

RUN helm plugin install https://github.com/zendesk/helm-secrets
