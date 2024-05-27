from time import time_ns

list = [1] * 10_000   # a Python list
# print(list) # for 10 elements: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
tik = time_ns()
for i in range(1, len(list)):
    list[i] += list[i - 1]
tok = time_ns()
# print(list) # for 10 elements: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
print(f"Time spent per element: {(tok - tik) / len(list)} ns")
# => Time spent per element: 67.5547 ns