#disassociate route table from subnet
aws ec2 disassociate-route-table --association-id "$subnet1AssociationId"

#for internet gateway
aws ec2 detach-internet-gateway --internet-gateway-id "$gatewayId" --vpc-id "$vpcId"
aws ec2 delete-internet-gateway --internet-gateway-id "$gatewayId"


#delete route table
aws ec2  delete-route-table --route-table-id "$publicRouteTableId"



#delete a subnet
aws ec2 delete-subnet --subnet-id $mySubnetId


echo "Deleting your VPC....."
#delete a vpc
aws ec2 delete-vpc --vpc-id $vpcId





