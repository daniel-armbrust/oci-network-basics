#!/bin/bash

source "../data.env"
source "../../lib/iam.sh"

dynagrp_id="$(get_dynagrp_id "$DYNGRP_NAME")"

oci iam dynamic-group delete \
    --dynamic-group-id "$dynagrp_id" \
    --force

iam_policy_id="$(get_iampolicy_id "$IAM_POLICY_NAME")"

oci iam policy delete \
    --policy-id "$iam_policy_id" \
    --force