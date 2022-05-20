// This file contains all of the optional inputs for this module
variable "application" {
  description = "Name of the application"
  type        = string
  default     = "Data Lake"

  validation {
    condition = (
    length(var.application) > 0 &&
    length(var.application) < 256 &&
    length(regexall("^[a-zA-Z0-9_]+", var.application)) == 1
    )
    error_message = "The value cannot be a blank string, and must contain only alphabet (a-z or A-Z), numeral (0-9) or underscore (_) characters."
  }
}

variable "custom_tags" {
  description = "Map of custom tags (merged and added to existing Tags). Must not overlap with any already defined tags."
  type        = map(string)
  default     = {}
}
