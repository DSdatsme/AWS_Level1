
aws ec2 delete-internet-gateway --internet-gateway-id "$gatewayId"
echo "Deleting your VPC....."
#delete a vpc
aws ec2 delete-vpc --vpc-id $vpcId

#delete a subnet
aws ec2 delete-subnet --subnet-id $mySubnetId

