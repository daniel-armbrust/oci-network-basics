#!/bin/bash

source "../network.env"
source "../../lib/vcn.sh"
source "../../lib/route_table.sh"
source "../../lib/drg.sh"

drg_1_id="$(get_drg_id "$DRG_1_NAME")"
drg_2_id="$(get_drg_id "$DRG_2_NAME")"

#----------------# 
# DRG VCN Attach #
#----------------#

# DRG-1 / VCN
vcn_a_id="$(get_vcn_id "$VCN_A_NAME" "$VCN_A_CIDR")"
vcn_a_drg_attch_id="$(get_drg_attch_id "$VCN_A_DRGATTCH_NAME" "$drg_1_id" "$vcn_a_id")"

oci network drg-attachment delete \
    --drg-attachment-id "$vcn_a_drg_attch_id" \
    --force \
    --wait-for-state "DETACHED"

# DRG-2 / VCN
vcn_hub_id="$(get_vcn_id "$VCN_HUB_NAME" "$VCN_HUB_CIDR")"
vcn_hub_drg_attch_id="$(get_drg_attch_id "$VCN_HUB_DRGATTCH_NAME" "$drg_2_id" "$vcn_hub_id")"

oci network drg-attachment delete \
    --drg-attachment-id "$vcn_hub_drg_attch_id" \
    --force \
    --wait-for-state "DETACHED"

#----------------# 
# DRG RPC Attach #
#----------------#

drg_1_rpc_id="$(get_rpc_id "$DRG_RPC_NAME" "$drg_1_id")"

# DRG-1 / RPC
oci network remote-peering-connection delete \
    --remote-peering-connection-id "$drg_1_rpc_id" \
    --force \
    --wait-for-state "TERMINATED"

drg_2_rpc_id="$(get_rpc_id "$DRG_RPC_NAME" "$drg_2_id")"

# DRG-1 / RPC
oci network remote-peering-connection delete \
    --remote-peering-connection-id "$drg_2_rpc_id" \
    --force \
    --wait-for-state "TERMINATED"

#-----#
# DRG #
#-----#

# DRG-1
oci network drg delete \
    --drg-id "$drg_1_id" \
    --force \
    --wait-for-state "TERMINATED"

# DRG-2
oci network drg delete \
    --drg-id "$drg_2_id" \
    --force \
    --wait-for-state "TERMINATED"