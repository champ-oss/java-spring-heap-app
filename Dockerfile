FROM openjdk:17-jdk-slim as builder

ARG JAR_FILE

COPY entrypoint.sh /usr/local/bin
RUN mkdir -p /srv/app/ && \
    chmod 0555 /usr/local/bin/entrypoint.sh

COPY ${JAR_FILE} /srv/app/test-hello-world.jar

FROM openjdk:17-jdk-slim


## install aws cli if not installed by app
RUN apt-get update && apt-get install -y \
    curl unzip procps

RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
        && unzip awscliv2.zip \
        && aws/install \
        && rm -rf \
            awscliv2.zip \
            aws \
            /usr/local/aws-cli/v2/*/dist/aws_completer \
            /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
            /usr/local/aws-cli/v2/*/dist/awscli/examples \

RUN aws --version

EXPOSE 8080

COPY --from=builder /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=builder /srv/app/test-hello-world.jar /srv/app/test-hello-world.jar

WORKDIR /srv/app

CMD ["-jar","/srv/app/test-hello-world.jar",""]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
