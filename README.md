# aws-ecr-gitlab

A full "docker-in-docker" dind image of the base `docker:stable-dind` with the
[docker-credentials-helpers](https://github.com/awslabs/amazon-ecr-credential-helper) implementation of AWS to push
images to the AWS Docker registry ECR

## How it works

The property in the [config.json](config.json) let Docker search for the `amazon-ecr-credential-helper` in specific paths. In this image it lays in /usr/bin.
Docker will automatically execute `amazon-ecr-credential-helper` with the environment variables 'AWS_ACCESS_KEY_ID' & 'AWS_SECRET_ACCESS_KEY'
to get a token and will authorize using this token while pushing/pulling an image.

## Setup and usage

The built image is pushed to the [Docker hub](https://hub.docker.com/r/bausparkadse/aws-ecr-gitlab)

You can use it or build your own image with the [Dockerfile](Dockerfile)

### Create a new AWS account for GitLab

You need rights to create a new AWS user.

1. Go to https://console.aws.amazon.com/iam/
2. Add user
  1. Name it "gitlabci"
  2. Activate "Programmatic access"
  3. Next
  4. Attach existing policies directly
  5. Search vor "AmazonEC2ContainerRegistryPowerUser" and activate it
  6. Create user
  7. IMPORTANT! Remember the "Access Key ID" and "Secret Access Key". You will need them.

### Configure credentials for access in GitLab to AWS ECR

As said before, environment variables have to been configured:

1. Go to your GitLab project
2. Settings
3. CI / CD
4. Variables
5. Add a new variable with the key "AWS_ACCESS_KEY_ID" and the value of the "Access Key ID", which you've got while creating a new AWS user
6. Add another variable with the key "AWS_SECRET_ACCESS_KEY" and the value of the "Secret Access Key", which you've also got while creating a new AWS user
7. Optional: Add a variable for the URI to the Docker image repository in ECR: As key for example: CI_REGISTRY_IMAGE_AWS and the value of the ECR URI: `<account_id>.dkr.ecr.<region>.amazonaws.com/<service_name>`

### .gitlab-ci.yml

This is an example of a ready to go Docker build entry in the .gitlab-ci.yml for building a Docker image and pushing it to the ECR:

```yaml
docker-build-master:
  image: bausparkadse/aws-ecr-gitlab:3
  stage: docker
  services:
    - docker:dind
  script:
    - docker build --pull -t "$CI_REGISTRY_IMAGE_AWS:$CI_COMMIT_SHORT_SHA" .
    - docker push "$CI_REGISTRY_IMAGE_AWS:$CI_COMMIT_SHORT_SHA"
  only:
    - master
```
