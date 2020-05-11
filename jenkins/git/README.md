# Jenkins git

A git client jenkins image similar to marfeel/jenkins-openssh but

- based on alpine 3:11
- adds yq from an alpine-based build (and so to be safe, best executed inside alpine)
- replaces some  pipeline tools not used with docker builds (no pssh and no rsync or make for instance) with those that do:
  - docker-cli
  - aws-cli
  - hub (a Github cli)
