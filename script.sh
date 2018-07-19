destinationCidr="0.0.0.0/0"

echo "Enter a name for VPC"
read vpcName
#vpcName="DarshitVPCcliZ"

echo "Enter a VPC region code"
read vpcRegion
#vpcRegion="us-west-2" #Oregon

echo "Enter CIDR block "
read vpcCIDR
vpcCidrBlock="10.0.0.0/${vpcCIDR}"


availabilityZone1=${vpcRegion}a
availabilityZone2=${vpcRegion}b
availabilityZone3=${vpcRegion}c
internetGatewayName="DarshitIG"
publicRouteTableName="myPublicRT"

#subnets
echo "Enter a block for Subnets"
read subnetBlock
subnetRegion1Public="10.0.0.0/${subnetBlock}"
subnetRegion1Private="10.0.8.0/${subnetBlock}"
subnetRegion1PublicName="subnetRegion1Public"
#################VPC
#create a /16 vpc
aws_response=$(aws ec2 create-vpc --cidr-block $vpcCidrBlock --region "$vpcRegion")
#extracting the vpcId
vpcId=$(echo -e "$aws_response" |  /usr/bin/jq '.Vpc.VpcId' | tr -d '"')
#give a name to vpc
aws ec2 create-tags --resources "$vpcId" --tags Key=Name,Value="$vpcName"
#########INTERNET GATEWAY
#create a custom Internet Gateway
gateway_response=$(aws ec2 create-internet-gateway --region "$vpcRegion")
gatewayId=$(echo -e "$gateway_response" |  /usr/bin/jq '.InternetGateway.InternetGatewayId' | tr -d '"')
aws ec2 create-tags --resources "$gatewayId" --tags Key=Name,Value="$internetGatewayName"
aws ec2 attach-internet-gateway --internet-gateway-id "$gatewayId" --vpc-id "$vpcId"
#create first subnet
echo "Creating First Public Subnet...."
aws_subnetRegion1Public_response=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetRegion1Public --availability-zone "$availabilityZone1")
subnet1PublicId=$(echo -e "$aws_subnetRegion1Public_response" |  /usr/bin/jq '.Subnet.SubnetId' | tr -d '""')
aws ec2 create-tags --resources "$subnet1PublicId" --tags Key=Name,Value="$subnetRegion1PublicName"
#create public route table
aws_publicRouteTableResponse=$(aws ec2 create-route-table --vpc-id "$vpcId")
publicRouteTableId=$(echo -e "$aws_publicRouteTableResponse" |  /usr/bin/jq '.RouteTable.RouteTableId' | tr -d '"')
aws ec2 create-tags --resources "$publicRouteTableId" --tags Key=Name,Value="$publicRouteTableName"
#connect public route table to internet gateway
aws ec2 create-route --route-table-id "$publicRouteTableId" --destination-cidr-block "$destinationCidr" --gateway-id "$gatewayId"
#associate public route table to public subnet
aws_associationResponse=$(aws ec2 associate-route-table --route-table-id "$publicRouteTableId" --subnet-id "$subnet1PublicId")
subnet1AssociationId=$(echo -e "$aws_associationResponse" |  /usr/bin/jq '.AssociationId' | tr -d '""')