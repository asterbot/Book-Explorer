import os
import re

input_path = os.path.join(os.pardir, os.pardir, 'data', 'books.sql')
output_path = os.path.join(os.pardir, 'books.sql')

with open(input_path, 'r') as f:
    lines = f.readlines()

new_lines = []

for line in lines:
    if line.strip().startswith('`authors`'):
        continue

    if line.strip().startswith('INSERT INTO'):
        line = line.replace('`authors`, ', '')
        line = re.sub(r"VALUES\s*\(\s*([^,]+,\s*'[^']+',\s*)'[^']*',\s*", r"VALUES(\1", line)

    new_lines.append(line)

with open(output_path, 'w') as f:
    f.writelines(new_lines)

print(f"Successfully removed authors column. Output saved to: {output_path}")
