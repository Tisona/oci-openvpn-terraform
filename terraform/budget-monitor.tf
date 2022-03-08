resource "oci_budget_budget" "vpn_budget" {
    amount = var.budget_amount
    compartment_id = var.tenancy_ocid
    reset_period = "MONTHLY"
    description = "VPN Budget "
    display_name = "vpn_budget"
    target_type  = "COMPARTMENT"
    targets      = [var.tenancy_ocid]
}

resource "oci_budget_alert_rule" "vpn_alert_rule" {
    #Required
    budget_id = oci_budget_budget.vpn_budget.id
    threshold = 1
    threshold_type = "PERCENTAGE"
    type = "FORECAST"
    recipients = var.alert_rule_recipients
    message = "Budget for VPN resources in Oracle Cloud Infrastructure (OCI) has been exceeded."
}