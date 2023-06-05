output "public_ip_jenkins" {
    value = "${aws_instance.ec2-jenkins.public_ip}"
}