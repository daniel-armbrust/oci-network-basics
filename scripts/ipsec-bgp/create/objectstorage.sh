#!/bin/bash

source "../data.env"

oci os bucket create \
  --name "$BUCKET_NAME" \
  --compartment-id "$COMPARTMENT_ID"