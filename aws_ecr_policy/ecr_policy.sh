#!/bin/bash

#find all your repositories names using "aws ecr describe-repositories" and save them to a variable named repositories
repositories=($(aws ecr describe-repositories --profile=$profile --output text --query "repositories[*].repositoryName"))

#for all repo in repositories this will add lifecycle policy
for repository in "${repositories[@]}";
do
aws ecr put-lifecycle-policy --profile=$profile --repository-name $repository --lifecycle-policy-text "file://ECR-Preserve-last-10.json"
done;