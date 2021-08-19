#!/bin/bash
environment_name=UdagramWebApp

create ()
{
    echo Creating ${stack_name} stack
    aws cloudformation create-stack \
		--stack-name ${stack_name} \
		--template-body file://${template_body} \
		--parameters file://${parameters} \
		--tags Key=Name,Value=${environment_name} \
		--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
		--region=us-east-1
}

update ()
{
    echo Updating ${stack_name} stack
    aws cloudformation update-stack \
		--stack-name ${stack_name} \
		--template-body file://${template_body} \
		--parameters file://${parameters} \
		--tags Key=Name,Value=${environment_name} \
		--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
		--region=us-east-1
}

delete ()
{
    echo Deleting ${stack_name} stack
	aws cloudformation delete-stack \
		--stack-name ${stack_name}    
}

main()
{
    if [ -z "$stack" ]; then
        echo "Please define the needed stack"
        echo "e.g. stack=network ./run.sh <function>"
        exit 1
    fi

    if [ "$stack" == "servers" ]; then
        echo "Capturing local IP..."
        myIp=$(curl -s ifconfig.co)/32
        echo "Updating ${stack}-params.json with local IP: ${myIp}"
        sed -i "4s|\"ParameterValue\":.*|\"ParameterValue\": \"${myIp}\"|g" ${parameters}
    fi

    if [[ $(type -t $1) == function ]]; then
        $1
    else
        echo "$1 isn't a supported function!"
        exit 1
    fi
}

stack_name=udagram-$stack
template_body=$stack.yml
parameters=$stack-params.json
main $*
