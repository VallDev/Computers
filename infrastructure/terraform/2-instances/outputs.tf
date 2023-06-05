output "public_ip_jenkins" {
    value = "${aws_instance.ec2-jenkins.public_ip}"
}

output "public_ip_sonar_qube" {
    value = "${aws_instance.ec2-sonar.public_ip}"
}