resource "aws_key_pair" "terraformkey" {
  key_name_prefix = "terraformkey"
  public_key = file(var.PUB_KEY_PATH)
}
