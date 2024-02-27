# Creates the instance.
resource "linode_instance" "default" {
  label           = local.settings.id
  tags            = [ local.settings.tag ]
  type            = local.settings.type
  image           = local.settings.image
  region          = local.settings.region
  private_ip      = true
  root_pass       = random_password.default.result
  authorized_keys = [ linode_sshkey.publicKey.ssh_key ]

  provisioner "remote-exec" {
    # Remote connection attributes.
    connection {
      host        = self.ip_address
      user        = "root"
      password    = random_password.default.result
      private_key = chomp(tls_private_key.default.private_key_openssh)
    }

    # Installs the required software and initialize the swarm.
    inline = [
      "hostnamectl set-hostname ${self.label}",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update",
      "apt -y upgrade",
      "apt -y install bash ca-certificates curl wget htop dnsutils net-tools vim s3fs"
    ]
  }

  depends_on = [ random_password.default ]
}

# Mount the object storage as volume in the instance.
resource "null_resource" "mountVolume" {
  provisioner "remote-exec" {
    # Remote connection attributes.
    connection {
      host        = linode_instance.default.ip_address
      user        = "root"
      password    = random_password.default.result
      private_key = chomp(tls_private_key.default.private_key_openssh)
    }

    # Installs the required software and initialize the swarm.
    inline = [
      "mkdir -p ${local.settings.volumeMountPoint}",
      "echo \"${linode_object_storage_key.default.access_key}:${linode_object_storage_key.default.secret_key}\" > /root/.passwd-s3fs",
      "chmod og-rwx /root/.passwd-s3fs",
      "echo \"#!/bin/bash\" > /root/mountVolume.sh",
      "echo >> /root/mountVolume.sh",
      "echo \"umount ${local.settings.volumeMountPoint}\" >> /root/mountVolume.sh",
      "echo \"s3fs ${local.settings.id} ${local.settings.volumeMountPoint} -o passwd_file=/root/.passwd-s3fs -o url=https://${local.settings.region}-1.linodeobjects.com -o use_path_request_style\" >> /root/mountVolume.sh",
      "chmod +x /root/mountVolume.sh",
      "/root/mountVolume.sh"
    ]
  }

  depends_on = [
    linode_instance.default,
    linode_object_storage_bucket.default,
    linode_object_storage_key.default,
    linode_object_storage_object.default
  ]
}