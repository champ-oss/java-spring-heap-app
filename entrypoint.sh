#!/usr/bin/env bash

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ] ; then
	set -- "$@"
fi

## check to see if AWS_S3_BUCKETNAME is defined and JAVA_HEAP_OOM_ENABLED is set to true
if [ -n "${AWS_S3_BUCKETNAME}" ] && [ "${JAVA_HEAP_OOM_ENABLED}" = true ] ; then

# creating directory just in case app is running at different path
mkdir -p /srv/app/
# create bash script to run if app runs out of memory
cat <<EOF > /srv/app/upload_java_heap_dump_s3.sh
#!/bin/bash
for hprof_file in *.hprof
do
  echo "gzip hprof file"
  gzip \$hprof_file
  echo "aws cp file to s3 bucket"
  aws s3 cp *.gz s3://\$AWS_S3_BUCKETNAME/java_heap_dump/\$APP_NAME/\$(date +%Y-%m-%dT%H:%M:%S)/
  echo "aws cp file complete"
  echo "killing java process"
  killalljobs() { for pid in $( jobs -p ); do kill -9 $pid ; done ; }
done
EOF

  chmod 775 /srv/app/upload_java_heap_dump_s3.sh

  # used in bash script for s3 directory
  export APP_NAME=java-spring-heap-app
  # pass heap out of memory variable to java startup
  HEAP_OOM="-XX:+HeapDumpOnOutOfMemoryError -XX:OnOutOfMemoryError=/srv/app/upload_java_heap_dump_s3.sh"

else
  echo "AWS_S3_BUCKETNAME not set, run as normal"
  HEAP_OOM=""
fi

printf 'Starting Java Application\n'

java -Djava.security.egd=file:/dev/./urandom $HEAP_OOM $JAVA_OPTS "$@"
