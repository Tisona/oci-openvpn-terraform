# Setup for OpenVPN in OCI always free tier

## Requirements

  * terraform 1.0.6
  * ansible 2.11.6
  * ssh agent

## How to run

1. Sign up to Oracle Cloud https://signup.cloud.oracle.com

   You will need valid credit card to complete this step

2. Generate new RSA key pair for signing API requests

    `openssl genrsa -out $HOME/.oci/api.pem 2048`

    `chmod 600 $HOME/.oci/api.pem`

    `openssl rsa -pubout -in $HOME/.oci/api.pem -out $HOME/.oci/api_public.pem`

3. OCI web interface - API keys - Add API key

   Paste public API key

4. Create vpn.tfvars config based on vpn.tfvars.example

   Get valid image id here: https://docs.oracle.com/en-us/iaas/images/image/8681332e-cc39-452c-bd0b-ecd19da96ebd/

5. Init terraform

    `terraform init`

    `terraform plan -var-file=vpn.tfvars`

6. Apply

    `terraform apply -var-file=vpn.tfvars`

7. Repeat last step if OCI is out of capacity at the moment

   Hint: one can look in OCI web interface and manually set availability domain advised by Oracle in instance.tf

8. Get config files from ansible/configs folder and use it with your favorite OpenVPN client
