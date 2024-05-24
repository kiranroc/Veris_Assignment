#!/bin/bash



# Simulation parameters

SIMULATION_TIME=10000  # Reduced for testing

ARRIVAL_PROBABILITY=60    # 60%

SERVICE_COMPLETION_PROBABILITY=25 # 25%

LEAVE_PROBABILITY=5       # 5%



# Variables to track the state

current_time=0

customer_queue=()

clerk1_free=1

clerk2_free=1

current_customer1=-1

current_customer2=-1

service_time1=0

service_time2=0

customers_served=0

customers_left=0

total_time_in_post_office=0

idle_time=0



# Function to simulate probability (returns 1 if event occurs, else 0)

function event_occurs() {

    local probability=$1

    if [ $((RANDOM % 100)) -lt $probability ]; then

        echo 1

    else

        echo 0

    fi

}



# Debug function to print current state

function print_debug() {

    echo "Time: $current_time, Queue: ${#customer_queue[@]}, Clerk1: $clerk1_free, Clerk2: $clerk2_free, Served: $customers_served, Left: $customers_left, Idle: $idle_time"

}



# Main simulation loop

while [ $current_time -lt $SIMULATION_TIME ]; do

    # Print debug information at intervals

    if (( current_time % 1000 == 0 )); then

        print_debug

    fi



    # Check if a new customer arrives

    if [ $(event_occurs $ARRIVAL_PROBABILITY) -eq 1 ]; then

        customer_queue+=($current_time)

    fi



    # Process first clerk

    if [ $clerk1_free -eq 1 ]; then

        if [ ${#customer_queue[@]} -gt 0 ]; then

            current_customer1=${customer_queue[0]}

            customer_queue=("${customer_queue[@]:1}")

            clerk1_free=0

            service_time1=0

        fi

    else

        ((service_time1++))

        if [ $(event_occurs $SERVICE_COMPLETION_PROBABILITY) -eq 1 ]; then

            ((total_time_in_post_office += current_time - current_customer1))

            ((customers_served++))

            clerk1_free=1

        fi

    fi



    # Process second clerk

    if [ $clerk2_free -eq 1 ]; then

        if [ ${#customer_queue[@]} -gt 0 ]; then

            current_customer2=${customer_queue[0]}

            customer_queue=("${customer_queue[@]:1}")

            clerk2_free=0

            service_time2=0

        fi

    else

        ((service_time2++))

        if [ $(event_occurs $SERVICE_COMPLETION_PROBABILITY) -eq 1 ]; then

            ((total_time_in_post_office += current_time - current_customer2))

            ((customers_served++))

            clerk2_free=1

        fi

    fi



    # Check if any customer in line leaves

    new_queue=()

    for arrival_time in "${customer_queue[@]}"; do

        if [ $(event_occurs $LEAVE_PROBABILITY) -eq 1 ]; then

            ((total_time_in_post_office += current_time - arrival_time))

            ((customers_left++))

        else

            new_queue+=($arrival_time)

        fi

    done

    customer_queue=("${new_queue[@]}")



    # Count idle time

    if [ $clerk1_free -eq 1 ]; then

        ((idle_time++))

    fi

    if [ $clerk2_free -eq 1 ]; then

        ((idle_time++))

    fi



    ((current_time++))

done



# Remaining customers in queue leave without being served

for arrival_time in "${customer_queue[@]}"; do

    ((total_time_in_post_office += SIMULATION_TIME - arrival_time))

    ((customers_left++))

done



# Calculate statistics

total_customers=$((customers_served + customers_left))

if [ $total_customers -gt 0 ]; then

    avg_time_in_post_office=$(echo "scale=2; $total_time_in_post_office / $total_customers" | bc)

    percent_left_without_service=$(echo "scale=2; $customers_left * 100 / $total_customers" | bc)

else

    avg_time_in_post_office=0

    percent_left_without_service=0

fi



percent_idle_time=$(echo "scale=2; $idle_time * 100 / ($SIMULATION_TIME * 2)" | bc)  # 2 clerks



# Print results

echo "Average time in post office: $avg_time_in_post_office minutes"

echo "Percentage of customers left without being served: $percent_left_without_service%"

echo "Percentage of time clerks are idle: $percent_idle_time%"
