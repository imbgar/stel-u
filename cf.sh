#!/bin/bash

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--stack)
    STACK="$2"
    shift # past argument
    shift # past value
    ;;
    -a|--action)
    ACTION="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--parameter)
    PARAMETERS="true"
    shift # past argument
    shift # past value
    ;;
    -r|--region)
    REGION="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--capabilities)
    CAPABILITY="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "Unkown arg $1"
    shift # past argument
    ;;
esac
done

if [ -z $STACK ] || [ -z $ACTION ]
then
    echo "Stack and action are required options..."
    return
fi

if [ "$ACTION" = "create" ]
then
    CMD="aws cloudformation create-stack --stack-name $STACK --template-body file://template.yml"
    WCMD="aws cloudformation wait stack-create-complete --stack-name $STACK"
    DCMD="aws cloudformation describe-stacks --stack-name $STACK --query \"Stacks[0].Outputs\" --output table"

    MSG="Creating stack: $STACK"
    WMSG="Waiting for creation to complete for stack: $STACK"

    if [ ! -z $PARAMETERS ]
    then
        CMD=$CMD" --parameter file://parameters.json"
        MSG=$MSG" with parameters"
    fi
    
    if [ ! -z $REGION ]
    then 
        CMD=$CMD" --region $REGION"
        WCMD=$WCMD" --region $REGION"
        DCMD=$DCMD" --region $REGION"
        MSG=$MSG" in $REGION"
        WMSG=$WMSG" in $REGION"
    fi
    
    if [ ! -z $CAPABILITY ]
    then 
        CMD=$CMD" --capabilities $CAPABILITY"
        MSG=$MSG" with $CAPABILITY"
    fi
    
    # create
    echo $MSG
    eval $CMD
    
    # wait
    echo $WMSG
    eval $WCMD
    echo "Creation of $STACK complete"

    # outputs
    echo "====================="
    echo "=== Outputs Below ==="
    echo "====================="
    eval $DCMD

fi

if [ "$ACTION" = "recreate" ]
then
    if  [ -z $REGION ]
    then
        echo "Deleting stack: $STACK"
        aws cloudformation delete-stack --stack-name $STACK
        echo "Waiting for deletion of stack: $STACK"
        aws cloudformation wait stack-delete-complete --stack-name $STACK
        echo "Deletion of $STACK complete"
    else
        echo "Deleting stack: $STACK in $REGION"
        aws cloudformation delete-stack --stack-name $STACK --region $REGION
        echo "Waiting for deletion of stack: $STACK in $REGION"
        aws cloudformation wait stack-delete-complete --stack-name $STACK --region $REGION
        echo "Deletion of $STACK complete"
    fi

    CMD="aws cloudformation create-stack --stack-name $STACK --template-body file://template.yml"
    WCMD="aws cloudformation wait stack-create-complete --stack-name $STACK"
    DCMD="aws cloudformation describe-stacks --stack-name $STACK --query \"Stacks[0].Outputs\" --output table"

    MSG="Creating stack: $STACK"
    WMSG="Waiting for creation to complete for stack: $STACK"

    if [ ! -z $PARAMETERS ]
    then
        CMD=$CMD" --parameter file://parameters.json"
        MSG=$MSG" with parameters"
    fi
    
    if [ ! -z $REGION ]
    then 
        CMD=$CMD" --region $REGION"
        WCMD=$WCMD" --region $REGION"
        DCMD=$DCMD" --region $REGION"
        MSG=$MSG" in $REGION"
        WMSG=$WMSG" in $REGION"
    fi
    
    if [ ! -z $CAPABILITY ]
    then 
        CMD=$CMD" --capabilities $CAPABILITY"
        MSG=$MSG" with $CAPABILITY"
    fi
    
    # create
    echo $MSG
    eval $CMD
    
    # wait
    echo $WMSG
    eval $WCMD
    echo "Creation of $STACK complete"

    # outputs
    echo "====================="
    echo "=== Outputs Below ==="
    echo "====================="
    eval $DCMD

fi
if [ "$ACTION" = "update" ]
then
    CMD="aws cloudformation update-stack --stack-name $STACK --template-body file://template.yml"
    WCMD="aws cloudformation wait stack-update-complete --stack-name $STACK"
    DCMD="aws cloudformation describe-stacks --stack-name $STACK --query \"Stacks[0].Outputs\" --output table"

    MSG="Updating stack: $STACK"
    WMSG="Waiting for update to complete for stack: $STACK"

    if [ ! -z $PARAMETERS ]
    then
        CMD=$CMD" --parameter file://parameters.json"
        MSG=$MSG" with parameters"
    fi
    if [ ! -z $REGION ]
    then 
        CMD=$CMD" --region $REGION"
        WCMD=$WCMD" --region $REGION"
        DCMD=$DCMD" --region $REGION"
        MSG=$MSG" in $REGION"
        WMSG=$WMSG" in $REGION"
    fi

    if [ ! -z $CAPABILITY ]
    then 
        CMD=$CMD" --capabilities $CAPABILITY"
        MSG=$MSG" with $CAPABILITY"
    fi

    # update
    echo $MSG
    eval $CMD
    
    # wait
    echo $WMSG
    eval $WCMD
    echo "Update of $STACK complete"

    # outputs
    echo "====================="
    echo "=== Outputs Below ==="
    echo "====================="
    eval $DCMD
fi

if [ "$ACTION" = "delete" ]
then
    if  [ -z $REGION ]
    then
        echo "Deleting stack: $STACK"
        aws cloudformation delete-stack --stack-name $STACK
        echo "Waiting for deletion of stack: $STACK"
        aws cloudformation wait stack-delete-complete --stack-name $STACK
        echo "Deletion of $STACK complete"
    else
        echo "Deleting stack: $STACK in $REGION"
        aws cloudformation delete-stack --stack-name $STACK --region $REGION
        echo "Waiting for deletion of stack: $STACK in $REGION"
        aws cloudformation wait stack-delete-complete --stack-name $STACK --region $REGION
        echo "Deletion of $STACK complete"
    fi
fi