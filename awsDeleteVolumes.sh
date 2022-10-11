#!/bin/bash

function deleteAvailableVolumes()
{
    for volume in `aws ec2 describe-volumes --filter "Name=status,Values=available" --query "Volumes[*].{ID:VolumeId}" --output text`
    do                                                                                
    aws ec2 delete-volume --volume-id $volume
    done   
}

deleteAvailableVolumes
