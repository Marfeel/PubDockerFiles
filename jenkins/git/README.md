# Jenkins git

A git client jenkins image very similar to marfeel/jenkins-openssh but

- based on alpine 3:11
- adds yq from an alpine-based build (and so to be safe, best executed inside alpine)
- has a few less tools (no pssh and no rsync or make)

Eventually this image could be used to replace marfeel/jenkins-openssh if the missing tools are not used
