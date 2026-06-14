#!/bin/bash

source "../data.env"

oci iam dynamic-group create \
    --name "$DYNGRP_NAME" \
    --compartment-id "$TENANCY_ID" \
    --description "Instancias do ArmFirewall" \
    --matching-rule "ALL {instance.compartment.id = '$COMPARTMENT_ID'}"

oci iam policy create \
  --name "$IAM_POLICY_NAME" \
  --compartment-id "$TENANCY_ID" \
  --description "Permite download do bucket" \
  --statements "[
        \"Allow dynamic-group ${DYNGRP_NAME} to read objects in compartment id ${COMPARTMENT_ID} where target.bucket.name = '${BUCKET_NAME}'\"
  ]"