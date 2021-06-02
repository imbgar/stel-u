#!/bin/bash 
# TODO: Allow overrides for parameter and template file

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -l|--lab)
    LAB_DIRECTORY=$2
    shift # past argument
    shift # past value
    ;;
    -t|--topic)
    TOPIC_DIRECTORY=$2
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "Invalid option $1"
    exit 1
    shift # past argument
    ;;
esac
done

if [ -z LAB_DIRECTORY ] || [ -z TOPIC_DIRECTORY ]
then
    echo "Invalid usage. Run with ./up.sh -t <TOPIC_DIRECTORY> -l <LAB_DIRECTORY>"
    exit 1
fi

if [ ! -d "$TOPIC_DIRECTORY/$LAB_DIRECTORY" ]
then
    echo "Directory for $TOPIC_DIRECTORY/$LAB_DIRECTORY doesn't exist! Exiting..."
    exit 1
fi

cd $TOPIC_DIRECTORY/$LAB_DIRECTORY
../../cf.sh -s bgar-stelu-$LAB_DIRECTORY -a update -p yes -c CAPABILITY_NAMED_IAM
exit 0