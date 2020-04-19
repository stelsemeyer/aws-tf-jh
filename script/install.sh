#!/bin/bash
sudo sudo apt-get update

# install s3fs & mount bucket 
sudo apt-get install s3fs
sudo s3fs \
	-o iam_role="auto" \
	-o url="https://s3-${aws_region}.amazonaws.com" \
	-o umask=000 \
	-o allow_other \
	${bucket_name} /mnt

# install tljh
curl https://raw.githubusercontent.com/jupyterhub/the-littlest-jupyterhub/master/bootstrap/bootstrap.py \
	| sudo python3 - \
	--admin admin:${password} \
	--user-requirements-txt-url https://raw.githubusercontent.com/stelsemeyer/aws-tf-jh/master/script/requirements.txt
