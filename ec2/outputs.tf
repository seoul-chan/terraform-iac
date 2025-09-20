output "instance_id" {
  description = "EC2 인스턴스 ID"
  value       = aws_instance.example.id
}

output "public_ip" {
  description = "EC2 퍼블릭 IP"
  value       = aws_instance.example.public_ip
}

output "private_ip" {
  description = "EC2 프라이빗 IP"
  value       = aws_instance.example.private_ip
}

output "az" {
  description = "가용 영역"
  value       = aws_instance.example.availability_zone
}
