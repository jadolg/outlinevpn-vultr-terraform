# Terraform script to quickly install outline in a vultr server

Provision an [outline](https://getoutline.org/) server on [Vultr](https://www.vultr.com/)

It will use the cheapest plan. You need to set `VULTR_API_KEY` in your environment before trying to apply. Edit `vars.tf` to setup the correct region for you.

After provisioning, the API URL will be part of the output.

### Base

I used this great project to get all the basic things right https://github.com/gudlyf/TerraformOutlineVPN
