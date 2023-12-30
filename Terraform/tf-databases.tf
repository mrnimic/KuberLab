# resource "aws_dynamodb_table" "bsb-dynamodb-table" {
#   name           = "bsb-dynamodb-table"
#   hash_key       = "PK"
#   billing_mode   = "PAY_PER_REQUEST"

#   attribute {
#     name = "PK"
#     type = "S"
#   }

#   tags = {
#     Name        = "bsb-dynamodb-table"
#   }
# }