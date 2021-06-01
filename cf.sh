#!/bin/bash

POSITIONAL=()
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
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -z $STACK ] || [ -z $ACTION ]
then
    echo "Stack and action are required options..."
    return
fi

if [ "$ACTION" = "create" ]
then
    CMD="aws cloudformation create-stack --stack-name $STACK --template-body file://template.yml"
    MSG="Creating stack: $STACK"

    if [ ! -z $PARAMETERS ]
    then
        CMD=$CMD" --parameter file://parameters.json"
        MSG=$MSG" with parameters"
    fi
    
    if [ ! -z $REGION ]
    then 
        CMD=$CMD" --region $REGION"
        MSG=$MSG" in $REGION"
    fi
    
    if [ ! -z $CAPABILITY ]
    then 
        CMD=$CMD" --capabilities $CAPABILITY"
        MSG=$MSG" with $CAPABILITY"
    fi
    
    echo $MSG
    eval $CMD
fi

if [ "$ACTION" = "update" ]
then
    CMD="aws cloudformation update-stack --stack-name $STACK --template-body file://template.yml"
    MSG="Updating stack: $STACK"

    if [ ! -z $PARAMETERS ]
    then
        CMD=$CMD" --parameter file://parameters.json"
        MSG=$MSG" with parameters"
    fi
    if [ ! -z $REGION ]
    then 
        CMD=$CMD" --region $REGION"
        MSG=$MSG" in $REGION"
    fi

    if [ ! -z $CAPABILITY ]
    then 
        CMD=$CMD" --capabilities $CAPABILITY"
        MSG=$MSG" with $CAPABILITY"
    fi

    eval $CMD
fi

if [ "$ACTION" = "delete" ]
then
    if  [ -z $REGION ]
    then
    echo "Deleting stack: $STACK"
        aws cloudformation delete-stack --stack-name $STACK
    else
    echo "Deleting stack: $STACK in $REGION"
        aws cloudformation delete-stack --stack-name $STACK --region $REGION
    fi
fi