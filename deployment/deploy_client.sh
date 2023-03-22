#!/bin/sh

### Check Argument
if [ $# -ne 1 ]; then
	echo 'No argument'
	exit -1
fi

### Download tar.gz From S3
aws s3 cp s3://seolmyeongtang-cicd/client/$1.tar.gz $1.tar.gz

BUILD_PATH=docker/data/nginx/build

rm -rf ${BUILD_PATH}/*

### Extract tar.gz
tar -zxf $1.tar.gz -C ${BUILD_PATH} --strip 1

### Cleanup
rm $1.tar.gz
