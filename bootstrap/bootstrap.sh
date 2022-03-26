#!/bin/bash
set -e

# Validate the world
echo "Validating script pre-requisites..."
if ! aws sts get-caller-identity > /dev/null; then 
  echo "ERROR: AWS default credentials not configured."
  exit 1
fi

if [ ! -f "bootstrap.yml" ]; then 
  echo "ERROR: Please ensure bootstrap.yml exists within the working directory before running this script."
  exit 1
fi

if ! command -v qrencode > /dev/null ; then 
  echo "WARNING: 'qrencode' utility not found on PATH."
  echo "This script will prompt you to configure a virtual MFA device."
  echo "If you plan to use a mobile app as your virtual MFA device this process will be easier if you have the 'qrencode' utility installed on your PATH."
  echo "Press ENTER to continue or Control-C to cancel."
  read
fi

echo "This script will guide you through deploying the bootstrap cloudformation template and configuring your organization owner user with access keys and MFA. You will be prompted for input at various points. This script will use your default AWS credentials and region configuration."
echo "Press ENTER to continue."
read

read -p 'Choose a name for your organization owner user: ' ORG_OWNER_USER_NAME

STACK_NAME="organization-bootstrap"
echo "Deploying cloudformation stack '$STACK_NAME'..."
# Create bootstrap stack
aws cloudformation create-stack \
  --template-body file://bootstrap.yml \
  --stack-name $STACK_NAME \
  --parameters "ParameterKey=OrganizationOwnerUserName,ParameterValue=$ORG_OWNER_USER_NAME" \
  --capabilities CAPABILITY_NAMED_IAM \
  --disable-rollback \
  > /dev/null

# Wait for stack to finish creating
echo "Waiting for '$STACK_NAME' stack deployment to complete..."
while sleep 1 ; do
  STACK_STATUS=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query "Stacks[0].StackStatus" \
    --output text
  )
  if [ $STACK_STATUS == 'CREATE_COMPLETE' ] ; then 
    break
  fi 
  if [ $STACK_STATUS == 'CREATE_FAILED' ] ; then 
    echo "ERROR: Failed to create bootstrap stack!"
    exit 1
  fi
done

# Create an access key pair for the new user
echo "Creating access credentials for user '$ORG_OWNER_USER_NAME'..."
aws iam create-access-key --user-name $ORG_OWNER_USER_NAME
echo "Save the above access keys to a safe place. (e.g. aws-vault)"
echo "Press ENTER to continue."
read 

# Create an MFA device for the new user
echo "Creating new virtual MFA device for user '$ORG_OWNER_USER_NAME'..."
MFA_SERIAL=$(aws iam create-virtual-mfa-device \
  --virtual-mfa-device-name $ORG_OWNER_USER_NAME \
  --bootstrap-method Base32StringSeed \
  --outfile privatekey \
  --query "VirtualMFADevice.SerialNumber" \
  --output text
)

# Show MFA private key to user
command -v qrencode > /dev/null && qrencode "$(cat privatekey)" -t UT8
echo "Private Key: $(cat privatekey)"
echo "Use the above private key to set up a new virtual MFA device. After continuing you will be prompted to enter two consecutive validation TOTP codes from your new device. This private key will not be shown again."
echo "Press ENTER to continue."
read
rm privatekey

# Enable the mfa device 
read -p 'Validation TOTP Code 1: ' TOTP_1
read -p 'Validation TOTP Code 2: ' TOTP_2

aws iam enable-mfa-device --user-name $ORG_OWNER_USER_NAME --serial-number $MFA_SERIAL --authentication-code1 $TOTP_1 --authentication-code2 $TOTP_2
echo "MFA configured!"

$S3_BUCKET=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs[?OutputKey==`OrganizationStateBucketName`].OutputValue' \
  --output text
)
echo ""
echo "When configuring your terraform backend use bucket '$S3_BUCKET'."
echo ""
echo "Finished successfully!"