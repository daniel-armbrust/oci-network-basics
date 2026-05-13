#!/bin/bash

source "../data.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/drg.sh"

#-------#
# DRG-1 #
#-------#

oci network drg create \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$DRG_1_NAME" \
    --wait-for-state "AVAILABLE"

drg_1_id="$(get_drg_id "$DRG_1_NAME")"

#-------#
# DRG-2 #
#-------#

oci network drg create \
    --compartment-id "$COMPARTMENT_ID" \
    --display-name "$DRG_2_NAME" \
    --wait-for-state "AVAILABLE"

drg_2_id="$(get_drg_id "$DRG_2_NAME")"

#----------------------------# 
# Import Route Distribution  #
#----------------------------#

# DRG-1 / VCN
oci network drg-route-distribution create \
    --drg-id "$drg_1_id" \
    --distribution-type "IMPORT" \
    --display-name "$DRG_IMPRT_VCN_NAME" \
    --wait-for-state "AVAILABLE"

drg_1_imprt_vcn_id="$(get_drg_imprtdst_id "$DRG_IMPRT_VCN_NAME" "$drg_1_id")"

oci network drg-route-distribution-statement add \
    --route-distribution-id "$drg_1_imprt_vcn_id" \
    --statements '[{
        "action": "ACCEPT",
        "priority": 10,
        "matchCriteria": [{
        "matchType": "DRG_ATTACHMENT_TYPE",
        "attachmentType": "REMOTE_PEERING_CONNECTION"
        }]
    }]'

# DRG-1 / RPC
oci network drg-route-distribution create \
    --drg-id "$drg_1_id" \
    --distribution-type "IMPORT" \
    --display-name "$DRG_IMPRT_RPC_NAME" \
    --wait-for-state "AVAILABLE"

drg_1_imprt_rpc_id="$(get_drg_imprtdst_id "$DRG_IMPRT_RPC_NAME" "$drg_1_id")"

# ** MATCH_ALL **
oci network drg-route-distribution-statement add \
    --route-distribution-id "$drg_1_imprt_rpc_id" \
    --statements '[{
         "action": "ACCEPT",
         "priority": 1,
         "matchCriteria": []
    }]'

# DRG-2 / VCN
oci network drg-route-distribution create \
    --drg-id "$drg_2_id" \
    --distribution-type "IMPORT" \
    --display-name "$DRG_IMPRT_VCN_NAME" \
    --wait-for-state "AVAILABLE"

drg_2_imprt_vcn_id="$(get_drg_imprtdst_id "$DRG_IMPRT_VCN_NAME" "$drg_2_id")"

oci network drg-route-distribution-statement add \
    --route-distribution-id "$drg_2_imprt_vcn_id" \
    --statements '[{
        "action": "ACCEPT",
        "priority": 10,
        "matchCriteria": [{
        "matchType": "DRG_ATTACHMENT_TYPE",
        "attachmentType": "REMOTE_PEERING_CONNECTION"
        }]
    }]'

# DRG-1 / RPC
oci network drg-route-distribution create \
    --drg-id "$drg_2_id" \
    --distribution-type "IMPORT" \
    --display-name "$DRG_IMPRT_RPC_NAME" \
    --wait-for-state "AVAILABLE"

drg_2_imprt_rpc_id="$(get_drg_imprtdst_id "$DRG_IMPRT_RPC_NAME" "$drg_2_id")"

# ** MATCH_ALL **
oci network drg-route-distribution-statement add \
    --route-distribution-id "$drg_2_imprt_rpc_id" \
    --statements '[{
         "action": "ACCEPT",
         "priority": 1,
         "matchCriteria": []
    }]'

#------------------# 
# DRG Route Table  #
#------------------#

# DRG-1 / VCN
oci network drg-route-table create \
    --drg-id "$drg_1_id" \
    --display-name "$DRG_RT_VCN_NAME" \
    --import-route-distribution-id "$drg_1_imprt_vcn_id" \
    --is-ecmp-enabled "false" \
    --wait-for-state "AVAILABLE"

# DRG-1 / RPC
oci network drg-route-table create \
    --drg-id "$drg_1_id" \
    --display-name "$DRG_RT_RPC_NAME" \
    --import-route-distribution-id "$drg_1_imprt_rpc_id" \
    --is-ecmp-enabled "false" \
    --wait-for-state "AVAILABLE"

# DRG-2 / VCN
oci network drg-route-table create \
    --drg-id "$drg_2_id" \
    --display-name "$DRG_RT_VCN_NAME" \
    --import-route-distribution-id "$drg_2_imprt_vcn_id" \
    --is-ecmp-enabled "false" \
    --wait-for-state "AVAILABLE"

# DRG-2 / RPC
oci network drg-route-table create \
    --drg-id "$drg_2_id" \
    --display-name "$DRG_RT_RPC_NAME" \
    --import-route-distribution-id "$drg_2_imprt_rpc_id" \
    --is-ecmp-enabled "false" \
    --wait-for-state "AVAILABLE"

#----------------# 
# DRG VCN Attach #
#----------------#

# DRG-1 / VCN-A
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
drg_1_rt_vcn_id="$(get_drg_rt_id "$DRG_RT_VCN_NAME" "$drg_1_id" "$drg_1_imprt_vcn_id")"

oci network drg-attachment create \
    --display-name "$VCN_A_DRGATTCH_NAME" \
    --drg-id "$drg_1_id" \
    --drg-route-table-id "$drg_1_rt_vcn_id" \
    --vcn-id "$vcn_a_id" \
    --wait-for-state "ATTACHED"

# DRG-2 / VCN-HUB
vcn_hub_id="$(get_vcn_id "$VCN_HUB_NAME" "$VCN_HUB_CIDR")"
drg_2_rt_vcn_id="$(get_drg_rt_id "$DRG_RT_VCN_NAME" "$drg_2_id" "$drg_2_imprt_vcn_id")"
vcn_hub_rt_id="$(get_route_table_id "$VCN_HUB_RT_DRG_NAME" "$vcn_hub_id")"

oci network drg-attachment create \
    --display-name "$VCN_HUB_DRGATTCH_NAME" \
    --drg-id "$drg_2_id" \
    --drg-route-table-id "$drg_2_rt_vcn_id" \
    --route-table-id "$vcn_hub_rt_id" \
    --vcn-id "$vcn_hub_id" \
    --wait-for-state "ATTACHED"

#----------------# 
# DRG RPC Attach #
#----------------#

# DRG-1 / RPC
oci network remote-peering-connection create \
  --compartment-id "$COMPARTMENT_ID" \
  --drg-id "$drg_1_id" \
  --display-name "$DRG_RPC_NAME" \
  --wait-for-state "AVAILABLE"

drg_1_rpc_id="$(get_rpc_id "$DRG_RPC_NAME" "$drg_1_id")"

# DRG-2 / RPC
oci network remote-peering-connection create \
  --compartment-id "$COMPARTMENT_ID" \
  --drg-id "$drg_2_id" \
  --display-name "$DRG_RPC_NAME" \
  --wait-for-state "AVAILABLE"

drg_2_rpc_id="$(get_rpc_id "$DRG_RPC_NAME" "$drg_2_id")"

# REMOTE PEERING CONNECTION
oci network remote-peering-connection connect \
    --remote-peering-connection-id "$drg_1_rpc_id" \
    --peer-id "$drg_2_rpc_id" \
    --peer-region-name "sa-saopaulo-1"

# DRG-1 / RPC ROUTE TABLE
drg_1_rpc_attch_id="$(get_drg_rpc_attch_id "$drg_1_id")"
drg_1_rpc_rt_id="$(get_drg_rt_id "$DRG_RT_RPC_NAME" "$drg_1_id" "$drg_1_imprt_rpc_id")"

oci network drg-attachment update \
    --display-name "$DRG_RPC_NAME" \
    --drg-attachment-id "$drg_1_rpc_attch_id" \
    --drg-route-table-id "$drg_1_rpc_rt_id" \
    --wait-for-state "ATTACHED"

# DRG-2 / RPC ROUTE TABLE
drg_2_rpc_attch_id=""

while true; do
    drg_2_rpc_attch_id="$(get_drg_rpc_attch_id "$drg_2_id")"

    if [ -z "$drg_2_rpc_attch_id" ]; then
        echo "Slepping..."
        sleep 3s
        continue
    else
        break
    fi
done

drg_2_rpc_rt_id=""

while true; do
    drg_2_rpc_rt_id="$(get_drg_rt_id "$DRG_RT_RPC_NAME" "$drg_2_id" "$drg_2_imprt_rpc_id")"

    if [ -z "$drg_2_rpc_rt_id" ]; then
        echo "Slepping..."
        sleep 3s
        continue
    else
        break
    fi
done

oci network drg-attachment update \
    --display-name "$DRG_RPC_NAME" \
    --drg-attachment-id "$drg_2_rpc_attch_id" \
    --drg-route-table-id "$drg_2_rpc_rt_id" \
    --wait-for-state "ATTACHED"