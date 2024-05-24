def split_array(arr):
    total_sum = sum(arr)
    if total_sum % 2 != 0:
        return False
    
    target = total_sum // 2
    current_sum = 0
    
    for i in range(len(arr)):
        current_sum += arr[i]
        if current_sum == target:
            return arr[:i+1], arr[i+1:]
    
    return False

# Example usage:
array = [5, 2, 1, 3, 1, 2]
print(split_array(array))  

array = [1, 2, 3, 4]
print(split_array(array))  
