import numpy as np

with open('input.txt') as file:
    nums = np.array([[int(num) for num in row.split('   ')] for row in file.readlines()])
list_1 = np.sort(nums[:,0])
list_2 = np.sort(nums[:,1])
print(np.sum(np.abs(list_1 - list_2)))
