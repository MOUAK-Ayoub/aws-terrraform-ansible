data "aws_ssm_parameter" "ami-linux-master" {
  provider = aws.region-master
  name="/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "ami-linux-worker" {
  provider = aws.region-worker
  name="/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "key-master" {
  provider = aws.region-master
  key_name = "jenkins"
  public_key = file("$HOME/.ssh/id_rsa.pub")
}

resource "aws_key_pair" "key-worker" {
  provider = aws.region-worker
  key_name = "jenkins"
  public_key = file("$HOME/.ssh/id_rsa.pub")
}

resource "aws_instance" "jenkins-master" {

  provider = aws.region-master
  ami=data.aws_ssm_parameter.ami-linux-master.value
  instance_type = var.instance-type

  key_name =  aws_key_pair.key-master

  vpc_security_group_ids = [aws_security_group.sg-jenkins-master.id]
  subnet_id = aws_subnet.subnet_master_1

  associate_public_ip_address = true

  tags = {
    Name= "Jenkins master instance"
  }
  
  depends_on=[aws_main_route_table_association.vpc_route_asso_master]

}



resource "aws_instance" "jenkins-workers" {

  provider = aws.region-worker
  
  count= var.num-workers

  ami=data.aws_ssm_parameter.ami-linux-worker.value
  instance_type = var.instance-type
  
  key_name =  aws_key_pair.key-worker

  vpc_security_group_ids = [aws_security_group.sg-jenkins-worker.id]
  subnet_id = aws_subnet.subnet_worker_1

  associate_public_ip_address = true
  
  tags = { 
    Name= join("-", ["jenkins-worker", count.index+1])
  }

  depends_on=[aws_main_route_table_association.vpc_route_asso_worker,aws_main_route_table_association.vpc_route_asso_master]

}


