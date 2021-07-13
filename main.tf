# Configure the Vultr Provider
terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.3.3"
    }
  }
}

data "vultr_plan" "cheap_plan" {
  filter {
    name   = "monthly_cost"
    values = ["5"]
  }
}

# Create outline server
resource "vultr_instance" "outline" {
  # cheapest plan $5/month
  plan = data.vultr_plan.cheap_plan.id
  region = var.region_code
  # ubuntu 20.10
  os_id = "413"
  label = var.server_name
  tag = var.server_name
  hostname = var.server_name
  enable_ipv6 = true
  backups = "disabled"
  activation_email = true
  ddos_protection = false
  script_id = vultr_startup_script.install_outline_server.id

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for client config ...'",
      "while [ ! -f /tmp/outline-install-details.txt ]; do sleep 5; done",
      "echo 'DONE!'",
      "cat /tmp/outline-install-details.txt",
    ]

    connection {
      host = vultr_instance.outline.main_ip
      type = "ssh"
      user = "root"
      password = vultr_instance.outline.default_password
      timeout = "10m"
      agent = "false"
    }
  }
}

# Add the install script
resource "vultr_startup_script" "install_outline_server" {
  name = "install_outline_server"
  script = base64encode(file("./install_outline_server.sh"))
}
