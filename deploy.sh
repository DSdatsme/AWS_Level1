#aws cloudformation deploy --template-file myTemp.json --stack-name my --region "us-east-1"
aws cloudformation create-stack --stack-name darshitStack --template-body myTemp.json --region "us-east-1"

# --parameter-overrides Key1=Value1 Key2=Value2 --tags Key1=Value1 Key2=Value2