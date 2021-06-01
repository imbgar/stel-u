#!/bin/bash
# Take lab directory name as parameter
# If it doesn't exist, exit with error message
# cd into lab, run ../../cf.sh with desired action hard-coded
# Allow overrides for parameter and template file

#!/bin/bash
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -l|--lab)
    if [ ! -d "$2" ]
    then
        echo "Directory for $2 doesn't exist! Exiting..."
        exit 1
    fi
    cd $2
    ../../cf.sh -s bgar-stelu-$2 -a create -p yes -c CAPABILITY_NAMED_IAM
    exit 0
    ;;
    *)    # unknown option
    echo "Invalid option $1"
    exit 1
    shift # past argument
    ;;
esac
done

echo "Invalid usage. Run with ./up.sh -l <LAB_DIRECTORY>"