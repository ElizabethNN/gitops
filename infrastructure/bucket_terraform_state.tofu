resource "minio_s3_bucket" "terraform-state" {
  bucket = "terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}