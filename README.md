# Our Publicly Available Dockerfiles

These Dockerfiles are built using Docker Hub's autobuilds. 
The convention is that each docker image repository be configured to use a single Dockerfile, located in its own subdirectory. The docker repository name should be reflected by the directory structure, so that it that knowing the docker image name should be deduced from looking at this repository structure. 
Likewise, docker builds should be triggered by tags with the repo's name as a prefix, and the rest of the tag as the image tag.

Putting these two conditions together, a Dockerfile under `./jenkins/maven` should build to `marfeel/jenkins-maven`, and a tag `jenkins-maven-v0.1.0` applied to this repository should trigger a build in the `marfeel/jenkins-maven` hub repository with tag `v0.1.0` (and only trigger in this single docker repository).
If more versions of a docker image are required using different dockerfiles, as long as dockerfiles live under the same directory structure, they should only trigger builds in a single hub repository. Conversaly, a docker image should only build from dockerfiles located under the same directory.

Changes in master in this Dockerfiles repository will trigger builds for all linked docker repositories and the resulting images tagged with `latest`.
