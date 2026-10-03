

variable "domain_name" {
  type        = string
  description = "The domain name for the ACM certificate."
}


variable "cloudflare_zone_id" {
  type        = string
  description = "The cloudflare zone ID for the domain."
}