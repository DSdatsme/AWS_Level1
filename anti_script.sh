#!/bin/sh
#extracting data
readFile=`cat do_not_delete.txt`
ids=($readFile)
#
vpcId=${ids[0]}
vpcRegion=${ids[1]}
#
subnet1PublicId=${ids[2]}
subnet1PublicAssociationId=${ids[3]}
subnet1PrivateId=${ids[4]}
subnet1PrivateAssociationId=${ids[5]}
#
subnet2PublicId=${ids[6]}
subnet2PublicAssociationId=${ids[7]}
subnet2PrivateId=${ids[8]}
subnet2PrivateAssociationId=${ids[9]}
#
subnet3PublicId=${ids[10]}
subnet3PublicAssociationId=${ids[11]}
subnet3PrivateId=${ids[12]}
subnet3PrivateAssociationId=${ids[13]}
#
gatewayId=${ids[14]}
#
publicRouteTable1Id=${ids[15]}
privateRouteTable1Id=${ids[16]}
privateRouteTable2Id=${ids[17]}
privateRouteTable3Id=${ids[18]}
#
#disassociate route table from subnet
echo "disassociating your public subnet from route table....."
aws ec2 disassociate-route-table --association-id "$subnet1PublicAssociationId" --region "$vpcRegion"
aws ec2 disassociate-route-table --association-id "$subnet2PublicAssociationId" --region "$vpcRegion"
aws ec2 disassociate-route-table --association-id "$subnet3PublicAssociationId" --region "$vpcRegion"
#
echo "disassociating your private subnet from route table....."
aws ec2 disassociate-route-table --association-id "$subnet1PrivateAssociationId" --region "$vpcRegion"
aws ec2 disassociate-route-table --association-id "$subnet2PrivateAssociationId" --region "$vpcRegion"
aws ec2 disassociate-route-table --association-id "$subnet3PrivateAssociationId" --region "$vpcRegion"
#
#
#for internet gateway removal
echo "detaching your IG....."
aws ec2 detach-internet-gateway --internet-gateway-id "$gatewayId" --vpc-id "$vpcId" --region "$vpcRegion"
#
echo "Deleting your IG....."
aws ec2 delete-internet-gateway --internet-gateway-id "$gatewayId" --region "$vpcRegion"
#
#
#delete route table
echo "Deleting your routetables....."
#
aws ec2  delete-route-table --route-table-id "$publicRouteTable1Id" --region "$vpcRegion"		#public Rt
aws ec2  delete-route-table --route-table-id "$privateRouteTable1Id" --region "$vpcRegion"		#private Rt1
aws ec2  delete-route-table --route-table-id "$privateRouteTable2Id" --region "$vpcRegion"		#private Rt2
aws ec2  delete-route-table --route-table-id "$privateRouteTable3Id" --region "$vpcRegion"		#private Rt3
#
#delete subnets
echo "Deleting your public subnets....."
aws ec2 delete-subnet --subnet-id "$subnet1PublicId" --region "$vpcRegion"
aws ec2 delete-subnet --subnet-id "$subnet2PublicId" --region "$vpcRegion"
aws ec2 delete-subnet --subnet-id "$subnet3PublicId" --region "$vpcRegion"
#
echo "Deleting your private subnets....."
aws ec2 delete-subnet --subnet-id "$subnet1PrivateId" --region "$vpcRegion"
aws ec2 delete-subnet --subnet-id "$subnet2PrivateId" --region "$vpcRegion"
aws ec2 delete-subnet --subnet-id "$subnet3PrivateId" --region "$vpcRegion"
#
#
#delete a vpc

echo "Deleting your VPC....."
aws ec2 delete-vpc --vpc-id "$vpcId" --region "$vpcRegion"
#
echo "done deleting"