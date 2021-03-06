#!/bin/sh

#	To run this script you need to have jq installed
#	use this command to install--> sudo you install jq


destinationCidr="0.0.0.0/0" 		#Internet

echo "Enter a name for VPC"
read vpcName
#vpcName="DarshitVPCcliZ"

echo "Enter a VPC region code"
read vpcRegion		#should be in region code and not name			
#vpcRegion="us-west-2" #Oregon

echo "Enter CIDR block "
read vpcCidrBlock 				#user need to just specify CIDR block number
vpcCidrBlock="10.0.0.0/${vpcCIDR}"

#creating values for availability zones (for now only three zones)
availabilityZone1=${vpcRegion}a
availabilityZone2=${vpcRegion}b
availabilityZone3=${vpcRegion}c

#....... INTERNET GATEWAY..................
#This is the name variable for internet gateway which will be connected to 
# VPC, for now its hardcoded but you can ask user for the name.
internetGatewayName="DarshitIG"

#.............ROUTE TABLES.................
#This are the name variables for route tables which will be connected to 
# each subnets, for now its hardcoded but you can ask user for the name.
#public route tables
publicRouteTableName1="myPublicRT1"
publicRouteTableName2="myPublicRT2" 
publicRouteTableName3="myPublicRT3"
#private route tables
privateRouteTableName1="myPrivateRT1"
privateRouteTableName2="myPrivateRT2"
privateRouteTableName3="myPrivateRT3"

#..........SUBNETS CONFIGURATION............
#for now hardcoding the names and CIDR blocks for subnet
# but its possible t ask for user's choice
echo "Enter a block for Subnets"
read subnetBlock 			#User can enter CIDR block for subnets [22-28]
#Zone 1
subnetRegion1Public="10.0.0.0/${subnetBlock}"
subnetRegion1PublicName="subnetRegion1Public"
subnetRegion1Private="10.0.4.0/${subnetBlock}"
subnetRegion1PrivateName="subnetRegion1Private"
#Zone 2
subnetRegion2Public="10.0.8.0/${subnetBlock}"
subnetRegion2PublicName="subnetRegion2Public"
subnetRegion2Private="10.0.12.0/${subnetBlock}"
subnetRegion2PrivateName="subnetRegion2Private"
#Zone 3
subnetRegion3Public="10.0.16.0/${subnetBlock}"
subnetRegion3PublicName="subnetRegion3Public"
subnetRegion3Private="10.0.20.0/${subnetBlock}"
subnetRegion3PrivateName="subnetRegion3Private"


#...............VPC................
echo "Creating a VPC....."
#create a vpc
aws_response=$(aws ec2 create-vpc --cidr-block $vpcCidrBlock --region "$vpcRegion")
#extracting the vpcId
vpcId=$(echo -e "$aws_response" |  /usr/bin/jq '.Vpc.VpcId' | tr -d '"')
#give a name to vpc
aws ec2 create-tags --resources "$vpcId" --tags Key=Name,Value="$vpcName" --region "$vpcRegion"

#............INTERNET GATEWAY............
echo "Creating internet gateway....."
#create a custom Internet Gateway
gateway_response=$(aws ec2 create-internet-gateway --region "$vpcRegion" --region "$vpcRegion")
#extracting the internet gatewayId
gatewayId=$(echo -e "$gateway_response" |  /usr/bin/jq '.InternetGateway.InternetGatewayId' | tr -d '"')
#give a name to internet gateway
aws ec2 create-tags --resources "$gatewayId" --tags Key=Name,Value="$internetGatewayName" --region "$vpcRegion"
#attaching internet gateway to VPC
aws ec2 attach-internet-gateway --internet-gateway-id "$gatewayId" --vpc-id "$vpcId" --region "$vpcRegion"

#create first zone
echo "Creating First Public Subnet....."
aws_subnetRegion1Public_response=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetRegion1Public --region "$vpcRegion" --availability-zone "$availabilityZone1")
subnet1PublicId=$(echo -e "$aws_subnetRegion1Public_response" |  /usr/bin/jq '.Subnet.SubnetId' | tr -d '""')
aws ec2 create-tags --resources "$subnet1PublicId" --tags Key=Name,Value="$subnetRegion1PublicName" --region "$vpcRegion"
echo "Creating First Private Subnet....."
aws_subnetRegion1Private_response=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetRegion1Private --region "$vpcRegion" --availability-zone "$availabilityZone1")
subnet1PrivateId=$(echo -e "$aws_subnetRegion1Private_response" |  /usr/bin/jq '.Subnet.SubnetId' | tr -d '""')
aws ec2 create-tags --resources "$subnet1PrivateId" --tags Key=Name,Value="$subnetRegion1PrivateName" --region "$vpcRegion"
#create second zone
echo "Creating Second Public Subnet....."
aws_subnetRegion2Public_response=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetRegion2Public --region "$vpcRegion" --availability-zone "$availabilityZone2")
subnet2PublicId=$(echo -e "$aws_subnetRegion2Public_response" |  /usr/bin/jq '.Subnet.SubnetId' | tr -d '""')
aws ec2 create-tags --resources "$subnet2PublicId" --tags Key=Name,Value="$subnetRegion2PublicName" --region "$vpcRegion"
echo "Creating Second Private Subnet....."
aws_subnetRegion2Private_response=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetRegion2Private --region "$vpcRegion" --availability-zone "$availabilityZone2")
subnet2PrivateId=$(echo -e "$aws_subnetRegion2Private_response" |  /usr/bin/jq '.Subnet.SubnetId' | tr -d '""')
aws ec2 create-tags --resources "$subnet2PrivateId" --tags Key=Name,Value="$subnetRegion2PrivateName" --region "$vpcRegion"
#create third zone
echo "Creating Third Public Subnet....."
aws_subnetRegion3Public_response=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetRegion3Public --region "$vpcRegion" --availability-zone "$availabilityZone3")
subnet3PublicId=$(echo -e "$aws_subnetRegion3Public_response" |  /usr/bin/jq '.Subnet.SubnetId' | tr -d '""')
aws ec2 create-tags --resources "$subnet3PublicId" --tags Key=Name,Value="$subnetRegion3PublicName" --region "$vpcRegion"
echo "Creating Third Private Subnet....."
aws_subnetRegion3Private_response=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetRegion3Private --region "$vpcRegion" --availability-zone "$availabilityZone3")
subnet3PrivateId=$(echo -e "$aws_subnetRegion3Private_response" |  /usr/bin/jq '.Subnet.SubnetId' | tr -d '""')
aws ec2 create-tags --resources "$subnet3PrivateId" --tags Key=Name,Value="$subnetRegion3PrivateName" --region "$vpcRegion"

#create public route table
#This is the route table which is attached to Internet gateway and all the three public subnets are associated with it.
echo "Creating Public route table..... "
aws_publicRouteTable1Response=$(aws ec2 create-route-table --vpc-id "$vpcId" --region "$vpcRegion")
publicRouteTable1Id=$(echo -e "$aws_publicRouteTable1Response" |  /usr/bin/jq '.RouteTable.RouteTableId' | tr -d '"')
aws ec2 create-tags --resources "$publicRouteTable1Id" --tags Key=Name,Value="$publicRouteTableName1" --region "$vpcRegion"
#connect public route table to internet gateway
echo "Creating route for public route table and internet gateway....."
aws ec2 create-route --route-table-id "$publicRouteTable1Id" --destination-cidr-block "$destinationCidr" --gateway-id "$gatewayId" --region "$vpcRegion"
#associate public route table to public subnet
echo "Associating public subnets to a route table....."
aws_associationResponse=$(aws ec2 associate-route-table --route-table-id "$publicRouteTable1Id" --subnet-id "$subnet1PublicId" --region "$vpcRegion")
subnet1PublicAssociationId=$(echo -e "$aws_associationResponse" |  /usr/bin/jq '.AssociationId' | tr -d '""')
aws_associationResponse=$(aws ec2 associate-route-table --route-table-id "$publicRouteTable1Id" --subnet-id "$subnet2PublicId" --region "$vpcRegion")
subnet2PublicAssociationId=$(echo -e "$aws_associationResponse" |  /usr/bin/jq '.AssociationId' | tr -d '""')
aws_associationResponse=$(aws ec2 associate-route-table --route-table-id "$publicRouteTable1Id" --subnet-id "$subnet3PublicId" --region "$vpcRegion")
subnet3PublicAssociationId=$(echo -e "$aws_associationResponse" |  /usr/bin/jq '.AssociationId' | tr -d '""')


#route tables for isolated subnets
#########This is for future use(if needed)
#echo "Associating private subnets to a route table each....."
aws_privateRouteTable1Response=$(aws ec2 create-route-table --vpc-id "$vpcId" --region "$vpcRegion")
privateRouteTable1Id=$(echo -e "$aws_privateRouteTable1Response" |  /usr/bin/jq '.RouteTable.RouteTableId' | tr -d '"')
aws ec2 create-tags --resources "$privateRouteTable1Id" --tags Key=Name,Value="$privateRouteTableName1" --region "$vpcRegion"

aws_privateRouteTable2Response=$(aws ec2 create-route-table --vpc-id "$vpcId" --region "$vpcRegion")
privateRouteTable2Id=$(echo -e "$aws_privateRouteTable2Response" |  /usr/bin/jq '.RouteTable.RouteTableId' | tr -d '"')
aws ec2 create-tags --resources "$privateRouteTable2Id" --tags Key=Name,Value="$privateRouteTableName2" --region "$vpcRegion"

aws_privateRouteTable3Response=$(aws ec2 create-route-table --vpc-id "$vpcId" --region "$vpcRegion")
privateRouteTable3Id=$(echo -e "$aws_privateRouteTable3Response" |  /usr/bin/jq '.RouteTable.RouteTableId' | tr -d '"')
aws ec2 create-tags --resources "$privateRouteTable3Id" --tags Key=Name,Value="$privateRouteTableName3" --region "$vpcRegion"

#associate private route tables to private subnets
#########This is for future use(if needed)
#echo "Associating private subnets to their respective route table......"
aws_associationResponse=$(aws ec2 associate-route-table --route-table-id "$privateRouteTable1Id" --subnet-id "$subnet1PrivateId" --region "$vpcRegion")
subnet1PrivateAssociationId=$(echo -e "$aws_associationResponse" |  /usr/bin/jq '.AssociationId' | tr -d '""')
aws_associationResponse=$(aws ec2 associate-route-table --route-table-id "$privateRouteTable2Id" --subnet-id "$subnet2PrivateId" --region "$vpcRegion")
subnet2PrivateAssociationId=$(echo -e "$aws_associationResponse" |  /usr/bin/jq '.AssociationId' | tr -d '""')
aws_associationResponse=$(aws ec2 associate-route-table --route-table-id "$privateRouteTable3Id" --subnet-id "$subnet3PrivateId" --region "$vpcRegion")
subnet3PrivateAssociationId=$(echo -e "$aws_associationResponse" |  /usr/bin/jq '.AssociationId' | tr -d '""')

#creating a txt file to store IDs which can be used later on to delete the VPC
touch do_not_delete.txt
echo "$vpcId $vpcRegion $subnet1PublicId $subnet1PublicAssociationId $subnet1PrivateId $subnet1PrivateAssociationId $subnet2PublicId $subnet2PublicAssociationId $subnet2PrivateId $subnet2PrivateAssociationId $subnet3PublicId $subnet3PublicAssociationId $subnet3PrivateId $subnet3PrivateAssociationId $gatewayId $publicRouteTable1Id $privateRouteTable1Id $privateRouteTable2Id $privateRouteTable3Id" > do_not_delete.txt

echo "Done creating....."