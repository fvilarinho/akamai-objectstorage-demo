# Private key filename definition.
locals {
  privateKeyFilename = pathexpand(var.privateKeyFilename)
}

# Defines the default password for the instances.
resource "random_password" "default" {
  length = 15
}

# Creates the SSH private key.
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "linode_sshkey" "publicKey" {
  label   = local.settings.id
  ssh_key = chomp(tls_private_key.default.public_key_openssh)
}

# Saves the SSH private key file.
resource "local_sensitive_file" "privateKey" {
  filename        = local.privateKeyFilename
  content         = tls_private_key.default.private_key_openssh
  file_permission = "600"
  depends_on      = [ tls_private_key.default ]
}

# Definition of the object storage access key.
resource "linode_object_storage_key" "default" {
  label = local.settings.id

  bucket_access {
    cluster     = data.linode_object_storage_cluster.default.id
    bucket_name = linode_object_storage_bucket.default.label
    permissions = "read_write"
  }

  depends_on = [ linode_object_storage_bucket.default ]
}