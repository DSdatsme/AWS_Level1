#disassociate route table from subnet
aws ec2 disassociate-route-table --association-id "$subnet1AssociationId"


aws ec2 delete-internet-gateway --internet-gateway-id "$gatewayId"

echo "Deleting your VPC....."
#delete a vpc
aws ec2 delete-vpc --vpc-id $vpcId

#delete a subnet
aws ec2 delete-subnet --subnet-id $mySubnetId




