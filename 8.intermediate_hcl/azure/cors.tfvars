cors_rules = [
  {
    allowed_headers    = ["header1", "header2"]
    allowed_methods    = ["GET", "HEAD"]
    allowed_origins    = ["madeup.natilik.com", "alsofake.natilik.com"]
    exposed_headers    = ["header1", "header2"]
    max_age_in_seconds = 60
  },
  {
    allowed_headers    = ["header1", "header2"]
    allowed_methods    = ["GET", "HEAD", "POST", "PUT", "DELETE"]
    allowed_origins    = ["notreal.natilik.com", "stuff.natilik.com"]
    exposed_headers    = ["header1", "header2"]
    max_age_in_seconds = 120
  }
]
