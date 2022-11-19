.PHONY: help

LOCAL_IP = $(shell ifconfig \
		| grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' \
		| grep -Eo '([0-9]*\.){3}[0-9]*' \
		| grep -v '127.0.0.1' \
		| grep -v '172.*')

help:
	@echo 'Available Commands:'
	@grep -E '^[a-zA-Z%_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf " - \033[36m%-18s\033[0m %s\n", $$1, $$2}'

create: create-cluster update-tfvars ## Create a cluster

create-cluster:
	kind create cluster --name kind

ls: list
list: ## List all clusters
	kind get clusters

delete: ## Delete the cluster
	kind delete cluster --name kind

update-tfvars: ## Update terraform.tfvars file
	@kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.server}' | xargs -0 printf "kubernetes_host=\"%s\"\n" > terraform.tfvars
	@kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.certificate-authority-data}' | xargs -0 printf "kubernetes_cluster_ca_certificate=\"%s\"\n" >> terraform.tfvars
	@kubectl config view --raw --minify --flatten --output='jsonpath={.users[].user.client-key-data}' | xargs -0 printf "kubernetes_client_key=\"%s\"\n" >> terraform.tfvars
	@kubectl config view --raw --minify --flatten --output='jsonpath={.users[].user.client-certificate-data}' | xargs -0 printf "kubernetes_client_certificate=\"%s\"\n" >> terraform.tfvars
