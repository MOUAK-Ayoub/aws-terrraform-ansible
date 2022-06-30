sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum install -y unzip

wget -O /tmp/terraform.zip   https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip
unzip -d /home/ansible/terraform /tmp/terraform.zip
terraform version

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
aws --version
aws configure

Create  a policy from the json file
Create a user terraform and affect the policy to it (no need for aws management cosnole access)

save access keys
AKIAYATXH6Z6VTUOXSF6
BPX/mJCqbhKd/aDdzjbmbc1QLTOVEVEF9UWxfflP


aws s3api create-bucket --bucket terraformstatefile2022