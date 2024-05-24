def find_second_maximum(arr):
    if len(arr) < 2:
        raise ValueError("List must contain at least two elements.")
    
    first_max = float('-inf')
    second_max = float('-inf')
    
    for num in arr:
        if num > first_max:
            first_max = num
    
    for num in arr:
        if num > second_max and num < first_max:
            second_max = num
    
    return second_max

# Example usage:
list1 = [5, 1, 5, 4, 2]
list2 = [7, 1, 5, 4, 2]

print(find_second_maximum(list1))  
print(find_second_maximum(list2))  
