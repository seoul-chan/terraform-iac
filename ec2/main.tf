resource "aws_instance" "example" {
    ami = "ami-0c76973fbe0ee100c"
    instance_type = "t3.micro"
    key_name                    = "chan-test"          # 미리 생성한 키페어 이름
    # vpc_security_group_ids      = ["sg-xxxxxxxxxxxxxxx"]          # 보안 그룹 ID (사전에 생성 필요)
    vpc_security_group_ids      = aws_security_group.prod-web_sg-02.id
    subnet_id                   = var.subnet_id        # 서브넷 ID (사전에 생성 필요)
    associate_public_ip_address = false
    
}