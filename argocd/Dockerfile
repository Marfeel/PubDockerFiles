ARG ARGOCD_SRC_IMAGE_TAG="v2.0.1"

FROM golang:1.15.2 as builder

ARG HEL_SOPS_GO_VER=20201003-1

RUN git clone -b ${HEL_SOPS_GO_VER} --depth=1 https://github.com/camptocamp/helm-sops \
  && cd helm-sops \
  && go build

FROM argoproj/argocd:${ARGOCD_SRC_IMAGE_TAG}

# Switch to root for the ability to perform install
USER root

COPY --from=builder /go/helm-sops/helm-sops /usr/local/bin/

RUN cd /usr/local/bin \
  &&  mv helm _helm \
  &&  mv helm2 _helm2 \
  &&  mv helm-sops helm \
  &&  ln helm helm2

# Switch back to non-root user
USER argocd
