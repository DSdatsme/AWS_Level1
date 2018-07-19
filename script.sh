vpcRegion="us-west-2" #Oregon
vpcCidrBlock="10.0.0.0/16"
vpcName="DarshitVPCcli"

availabilityZone1="us-west-2a"
availabilityZone2="us-west-2b"
availabilityZone3="us-west-2c"


internetGatewayName="DarshitIG"


#subnets
subnetRegion1Public="10.0.0.0/22"
subnetRegion1Private="10.0.8.0/22"




#################VPC
#create a /16 vpc
aws_response=$(aws ec2 create-vpc --cidr-block $vpcCidrBlock)
#extracting the vpcId
vpcId=$(echo -e "$aws_response" |  /usr/bin/jq '.Vpc.VpcId' | tr -d '"')
#give a name to vpc
aws ec2 create-tags --resources "$vpcId" --tags Key=Name,Value="$vpcName"



#########INTERNET GATEWAY
#create a custom Internet Gateway
gateway_response=$(aws ec2 create-internet-gateway)
gatewayId=$(echo -e "$gateway_response" |  /usr/bin/jq '.InternetGateway.InternetGatewayId' | tr -d '"')
aws ec2 create-tags --resources "$gatewayId" --tags Key=Name,Value="$internetGatewayName"






#create first subnet
echo "Creating First Public Subnet...."
aws_subnetRegion1Public_response=$(ec2 create-subnet --vpc-id $vpcId --cidr-block $subnetRegion1Public --availability-zone "$availabilityZone1")