init:
	@go run scripts/init.go

terraform-init:
	@(cd terraform && terraform init \
		-backend-config="bucket=${TF_BACKEND_S3_BUCKET}" \
		-backend-config="key=${TF_BACKEND_S3_KEY}" \
		-backend-config="region=${AWS_REGION}")

stop:
	echo "stop service ... not implemented yet"

.PHONY: init terraform-init stop
