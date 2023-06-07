output "public_ip_jenkins" {
  value = aws_instance.ec2-jenkins.public_ip
}

output "public_ip_sonar_qube" {
  value = aws_instance.ec2-sonar.public_ip
}

output "db_hostname" {
  value = aws_db_instance.computer-db.address
}

output "db_port" {
  value = aws_db_instance.computer-db.port
}

output "public_ip_jenkins_node" {
  value = aws_instance.ec2-jenkins-node.public_ip
}
