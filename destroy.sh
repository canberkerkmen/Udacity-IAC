#!/bin/bash

STACK_NAME=$1

echo "Checking if stack exists ..."

STACK_ARRAY=$(aws cloudformation list-stacks --stack-status-filter CREATE_IN_PROGRESS CREATE_COMPLETE ROLLBACK_IN_PROGRESS ROLLBACK_FAILED ROLLBACK_COMPLETE DELETE_IN_PROGRESS DELETE_FAILED UPDATE_IN_PROGRESS UPDATE_COMPLETE_CLEANUP_IN_PROGRESS UPDATE_COMPLETE UPDATE_ROLLBACK_IN_PROGRESS UPDATE_ROLLBACK_FAILED UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS UPDATE_ROLLBACK_COMPLETE REVIEW_IN_PROGRESS --query "StackSummaries[*].StackName")

if [[ ${STACK_ARRAY} == *${STACK_NAME}* ]]; then 
    echo -e "\nStack exists, attempting delete ..."
    aws cloudformation delete-stack \
        --stack-name ${STACK_NAME} \

    aws cloudformation wait stack-delete-complete --stack-name ${STACK_NAME}
else
    echo "Stack does not exist"
fi;

echo "Finished delete successfully!"
