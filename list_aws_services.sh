#!/bin/bash

# Function to get all AWS regions
get_all_regions() {
    aws ec2 describe-regions --query "Regions[].RegionName" --output text
}

# Function to list services in each region
list_services_in_region() {
    local region=$1
    echo "Listing services in region: $region"
    
    # Create a list of services that we want to check
    services=("ec2" "rds" "s3" "lambda")

    for service in "${services[@]}"; do
        echo "Service: $service"
        case $service in
            ec2)
                aws ec2 describe-instances --region $region
                ;;
            rds)
                aws rds describe-db-instances --region $region
                ;;
            s3)
                aws s3api list-buckets --query "Buckets[].Name" --region $region
                ;;
            lambda)
                aws lambda list-functions --region $region
                ;;
            *)
                echo "No description command available for $service"
                ;;
        esac
        echo ""
    done
}

# Main script execution
regions=$(get_all_regions)
for region in $regions; do
    echo "Region: $region"
    list_services_in_region $region
done

