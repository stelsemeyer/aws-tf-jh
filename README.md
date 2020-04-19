### How to setup [the littlest jupyterhub](http://tljh.jupyter.org/en/latest/) on AWS using [terraform](https://www.terraform.io/).

#### Requirements:

1. AWS account and credentials
2. terraform v0.12.x (here: v0.12.24 + provider.aws v2.58.0)

#### Run:

1. Add AWS credentials and password for jupyterhub as `terraform.tfvars` file:

    ```
    aws_access_key = "..."
    aws_secret_key = "..."
    aws_region     = "eu-central-1"
    jh_password    = "..."
    ```

1. Optionally: adjust variabes in `variables.tf`.

1. Run `terraform init` to initialize the required plugins (for our provider AWS).
After a few moments you should see something like 
`Terraform has been successfully initialized!`

1. Use `terraform plan` to check out the plan.
It should plan something along `Plan: 6 to add, 0 to change, 0 to destroy.`

1. You can apply the plan now by running `terraform apply` and confirming with `yes`. 
This will take around a minute and you should see something like 
`Apply complete! Resources: 6 added, 0 changed, 0 destroyed.` and the public DNS entry: 
`public_dns = ec2-aa-bb-cc-dd.eu-central-1.compute.amazonaws.com`.

1. After 10 to 15 minutes you can visit your jupyterhub instance at the above shown URL.

1. You can destroy the setup via `terraform destroy`. 
As of now (2020-04-19) non-empty s3 buckets will not be deleted and raise an error message on destroy. 
You can also prevent the s3 bucket from destruction by adding `prevent_destroy`.
If you call `destroy` and the bucket has a `prevent_destroy` it will also raise an error. 
To get around this you can destroy the setup using the `target` feature (which currently works via explicit listing).
You can list your infrastructure using `terraform state list` and then target all but the bucket in the destruction:

    ```
    terraform destroy \
		-target=data.aws_iam_policy_document.s3 \
		-target=data.aws_iam_policy_document.sts \
		-target=aws_iam_instance_profile.jh \
		-target=aws_iam_role.jh \
		-target=aws_iam_role_policy.jh \
		-target=aws_instance.jh \
		-target=aws_security_group.instance 
    ```
	**Warning:** This will delete all data on the instance apart from the files stored in `/mnt`, which are synced to s3.


#### Improvements:

- Run terraform within docker.
- Use script to restart `s3fs` and remount s3 after restart/resize of instance, for ex. cloud init.
- Use `s3fs` to persist user's home folder.
- Add `HTTPS`, for ex. by using route 53 plus elastic ips ([TLJH docs](http://tljh.jupyter.org/en/latest/howto/admin/https.html)).
- Limit AWS credentials to minimum amount of needed services.
- Improve the destruction process.
- Add some health check for s3 connection.