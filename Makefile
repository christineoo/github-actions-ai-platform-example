.PHONY: help env

.DEFAULT_GOAL := help

include .env

JOB_ID=christineoo_test
JOB_NAME=${JOB_ID}_$(shell date +%Y%m%d%H%M%S)

submit_job: ## submit job
	gcloud ai-platform jobs submit training ${JOB_NAME} \
    --job-dir gs://$(gcs_bucket_name)/${JOB_NAME} \
    --runtime-version 2.1 \
    --python-version 3.7 \
    --module-name ${MAIN_TRAINER_MODULE} \
    --package-path ${TRAINER_PACKAGE_PATH} \
    --region ${REGION}

get_token: ## job status
	gcloud auth print-access-token

curl_status:
	curl -X GET \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $(shell gcloud auth print-access-token)" \
	https://content-ml.googleapis.com/v1/projects/devs-sandbox/jobs/${JOB_NAME} | jq '.state'
