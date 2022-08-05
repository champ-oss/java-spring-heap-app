# java-spring-heap-app

Summary: creates basic spring app that runs at endpoint /hello.  
Also includes function to simulate heap space issue by running out of memory.  
Finally, bash script created to post hprof in s3 bucket if AWS_S3_BUCKETNAME is defined.  
Assumptions include you have existing s3 bucket already created and iam auth key to access bucket

![ci](https://github.com/conventional-changelog/standard-version/workflows/ci/badge.svg)
[![version](https://img.shields.io/badge/version-1.x-yellow.svg)](https://semver.org)

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Usage](#usage)
* [Project Status](#project-status)

## General Information
- spring java app runs at 127.0.0.1:8080/hello
- function included to run out of memory
- gzip hprof file and publish to s3

## Technologies Used
- java spring
- docker
- aws s3

## Usage

* mvn package
* docker build -t cloud/test-hello-world:1.0.0 --build-arg JAR_FILE=target/HelloWorldController-0.0.1-SNAPSHOT.jar --no-cache .
* docker run -e AWS_ACCESS_KEY_ID='' -e AWS_SECRET_ACCESS_KEY='' -e AWS_S3_BUCKETNAME="java-spring-heap-app" -e JAVA_HEAP_OOM_ENABLED=true -d -p 8082:8080 <hash>
* local browser hit endpoint 127.0.0.1:8082/hello or curl 127.0.0.1:8082/hello
* validate hprof gz file is located in s3://$AWS_S3_BUCKETNAME/$APP_NAME/${date}/

## Project Status
Project is: _in_progress_ 