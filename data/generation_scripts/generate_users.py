import os

file_path = os.path.join(os.pardir, os.pardir, 'data', 'users.sql')

with open(os.path.join(os.pardir,'users.sql'),'a') as f:
    for i in range(150):
        f.write(f"('{i+5}', 'User{i+5}', 'user{i+5}@example.com'),\n")

