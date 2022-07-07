output "jenkins-master-public-ip" {
  value     = aws_instance.jenkins-master
  sensitive = true
}

output "jenkins-workers-public-ip" {
  value = {
    for instance in aws_instance.jenkins-workers :
    instance.id => instance.public_ip
  }
  sensitive = true
}
