#!/bin/bash

STACK_NAME=$1
TEMPLATE_BODY_FILE=$2
PARAMETERS_FILE=$3

echo "Checking if stack exists ..."

STACK_ARRAY=$(aws cloudformation list-stacks --stack-status-filter CREATE_IN_PROGRESS CREATE_COMPLETE ROLLBACK_IN_PROGRESS ROLLBACK_FAILED ROLLBACK_COMPLETE DELETE_IN_PROGRESS DELETE_FAILED UPDATE_IN_PROGRESS UPDATE_COMPLETE_CLEANUP_IN_PROGRESS UPDATE_COMPLETE UPDATE_ROLLBACK_IN_PROGRESS UPDATE_ROLLBACK_FAILED UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS UPDATE_ROLLBACK_COMPLETE REVIEW_IN_PROGRESS --query "StackSummaries[*].StackName")

if [[ ${STACK_ARRAY} == *${STACK_NAME}* ]]; then
    echo -e "\nStack exists, attempting update ..."
    aws cloudformation update-stack \
        --stack-name ${STACK_NAME} \
        --template-body file://${TEMPLATE_BODY_FILE}  \
        --parameters file://${PARAMETERS_FILE} \
        --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
#       --region=us-west-2

    echo "Waiting for stack update to complete ..."
    aws cloudformation wait stack-update-complete --stack-name ${STACK_NAME}

else
    echo -e "\nStack does not exist, creating ..."
    aws cloudformation create-stack \
        --stack-name ${STACK_NAME} \
        --template-body file://${TEMPLATE_BODY_FILE}  \
        --parameters file://${PARAMETERS_FILE} \
        --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
#       --region=us-west-2

    echo "Waiting for stack to be created ..."
    aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME}
fi;

echo "Finished create/update successfully!"
