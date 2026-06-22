#!/bin/bash

source "../data.env"

oci os bucket delete \
    --bucket-name "$BUCKET_NAME" \
    --empty \
    --force