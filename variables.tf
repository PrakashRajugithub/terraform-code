# Syntax of variables
# ====================
              #  *============================* 
              #  *  variable "logicalname" {  *
              #  *   default =                *
              #  *   type    =                *
              #  *  description =             *
              #  *  }                         *
              #  *============================* 

# Example-1       || Example-2                    || Example-3
# =============   || =============                || =============
# variable "a" {  || variable "a" {               || variable "a" {
#   default = 10  ||   default = ["10", "5", "9"] ||   default = Prakash
#   type = number ||   type = list                ||   type = string
# }               || }                            || }
# ==> In ex-1 we have given the variable value as "10" which is integer/number.
# ==> In ex-2 we have given the variable value as some list of munbers.
# ==> In ex-3 we have given the variable value as "Prakash" which is string.


# creating a variable and giving cidr blocks for Pub and Pvt

variable "pub_cidr" {
  default = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24"]
  type = list
}

variable "pvt_cidr" {
  default = ["10.2.3.0/24", "10.2.4.0/24", "10.2.5.0/24"]
  type = list
}

variable "data_pvt_cidr" {
  default = ["10.2.6.0/24", "10.2.7.0/24", "10.2.8.0/24"]
  type = list
}