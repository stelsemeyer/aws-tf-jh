#!/bin/bash
sudo sudo apt-get update
sudo apt-get install s3fs
# sudo mkdir /mnt
sudo s3fs \
	-o iam_role=jh_role \
	-o url="https://s3-${aws_region}.amazonaws.com" \
	-o umask=000 \
	-o allow_other \
	${bucket_name} /mnt
curl https://raw.githubusercontent.com/jupyterhub/the-littlest-jupyterhub/master/bootstrap/bootstrap.py \
	| sudo python3 - \
	--admin admin \
	--user-requirements-txt-url https://raw.githubusercontent.com/stelsemeyer/aws-jh-tf/master/script/requirements.txt
