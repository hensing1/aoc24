import numpy as np

with open('input.txt') as file:
    nums = np.array([[int(num) for num in row.split('   ')] for row in file.readlines()])

list_1 = nums[:,0]
list_2 = nums[:,1]
sim_score = np.vectorize(lambda x: x * len(np.where(list_2 == x)[0]))
print(np.sum(sim_score(list_1)))
