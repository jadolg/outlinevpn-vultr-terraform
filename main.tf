# Configure the Vultr Provider
provider "vultr" {
  rate_limit = 700
  retry_limit = 3
}

# Create outline server
resource "vultr_server" "outline" {
  # cheapest plan $5/month
  plan_id = "201"
  region_id = "${var.region_id}"
  # ubuntu 20.10
  os_id = "413"
  label = "${var.server_name}"
  tag = "${var.server_name}"
  hostname = "${var.server_name}"
  enable_ipv6 = true
  auto_backup = false
  ddos_protection = false
  notify_activate = true
  script_id = "${vultr_startup_script.install_outline_server.id}"

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for client config ...'",
      "while [ ! -f /tmp/outline-install-details.txt ]; do sleep 5; done",
      "echo 'DONE!'",
      "cat /tmp/outline-install-details.txt",
    ]

    connection {
      host = "${vultr_server.outline.main_ip}"
      type = "ssh"
      user = "root"
      password = "${vultr_server.outline.default_password}"
      timeout = "10m"
      agent = "false"
    }
  }
}

# Add the install script
resource "vultr_startup_script" "install_outline_server" {
  name = "install_outline_server"
  script = "${file("./install_outline_server.sh")}"
}

