# Fetch information from an object storage region.
data "linode_object_storage_cluster" "default" {
  id = "${local.settings.region}-1"
}

# Definition of the object storage bucket. This will be the origin hostname.
resource "linode_object_storage_bucket" "default" {
  cluster    = data.linode_object_storage_cluster.default.id
  label      = local.settings.id
  acl        = "public-read"
  depends_on = [ data.linode_object_storage_cluster.default ]
}

resource "linode_object_storage_object" "default" {
  access_key   = linode_object_storage_key.default.access_key
  secret_key   = linode_object_storage_key.default.secret_key
  cluster      = data.linode_object_storage_cluster.default.id
  bucket       = linode_object_storage_bucket.default.label
  key          = "index.html"
  content      = "Hello World!"
  content_type = "text/html"
  acl          = "public-read"
  depends_on   = [ linode_object_storage_bucket.default ]
}