.PHONY: test plan deploy destroy

TFVARS_FILE := dev.tfvars

test:
	rm .terraform.lock.hcl plan.out plan.out.json 2> /dev/null || true
    # should not require any aws credentials to test against, should be safe to run as github checks on pull requests
	terraform init -backend-config=backend-configs/dev.config -input=false || ( echo 'FAILED: terraform init failed'; exit 1 )
	terraform validate || ( echo 'FAILED: terraform validate failed'; exit 1 )
	terraform fmt -check -recursive ./ || ( echo 'FAILED: all tf files should be formatted using "terraform fmt -recursive ./"'; exit 1 )
	tflint --init && tflint --var='region=us-west-1' --var='profile=default' ./ || ( echo 'FAILED: tflint found issues'; exit 1 )
	checkov --directory . || ( echo 'FAILED: checkov found issues'; exit 1 )

plan:
	terraform init -backend-config=backend-configs/dev.config
	terraform plan -var-file=environments/$(TFVARS_FILE) -out plan.out

deploy:
	terraform apply plan.out

destroy:
	terraform destroy -var-file=environments/$(TFVARS_FILE)