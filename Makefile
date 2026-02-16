SHELL := /bin/bash

.PHONY: validate-k8s validate-scripts validate-terraform deploy-platform deploy-workloads all-check

validate-k8s:
	kubectl kustomize kubernetes/base >/dev/null
	kubectl kustomize kubernetes/overlays/aws >/dev/null
	kubectl kustomize kubernetes/overlays/onprem >/dev/null
	@echo "Kubernetes manifests validated"

validate-scripts:
	bash -n cicd/scripts/container_scan.sh
	bash -n cicd/scripts/blue_green_deploy.sh
	bash -n cicd/scripts/terraform_plan_apply.sh
	bash -n cicd/scripts/dr_drill.sh
	bash -n cicd/scripts/bootstrap_platform.sh
	bash -n cicd/scripts/deploy_workloads.sh
	@echo "Shell scripts validated"

validate-terraform:
	@if command -v terraform >/dev/null 2>&1; then \
		terraform fmt -check -recursive terraform; \
		cd terraform/envs/prod-primary && terraform init -backend=false && terraform validate; \
		cd terraform/envs/prod-dr && terraform init -backend=false && terraform validate; \
		echo "Terraform validated"; \
	else \
		echo "terraform CLI not found; skipping terraform validate"; \
	fi

all-check: validate-k8s validate-scripts validate-terraform

# Requires kubectl + helm access to target cluster.
deploy-platform:
	bash cicd/scripts/bootstrap_platform.sh

# Requires app images and cluster access.
deploy-workloads:
	bash cicd/scripts/deploy_workloads.sh
