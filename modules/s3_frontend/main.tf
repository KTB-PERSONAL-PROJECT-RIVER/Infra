resource "aws_s3_bucket" "frontend" {
  bucket = "river-vite-app"
  force_destroy = false
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
