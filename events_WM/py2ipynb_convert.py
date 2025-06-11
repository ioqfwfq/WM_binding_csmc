import nbformat
import re
from pathlib import Path

py_file = 'neural_delay_distractor_cleaned.py'
nb_file = 'neural_delay_distractor_cleaned.ipynb'

# Read the Python script
py = Path(py_file).read_text(encoding='utf-8')

cells = []
for block in re.split(r'(?m)^# %%+', py):
    block = block.strip()
    if not block:
        continue
    # Find all docstrings (triple double quotes)
    md = re.findall(r'"""(.*?)"""', block, re.DOTALL)
    # Remove all docstrings from code
    code = re.sub(r'""".*?"""', '', block, flags=re.DOTALL).strip()
    # Add markdown cells for each docstring
    for m in md:
        m = m.strip().replace('\r\n', '\n').replace('\r', '\n')
        cells.append(nbformat.v4.new_markdown_cell(m))
    # Add code cell if any code remains
    if code:
        cells.append(nbformat.v4.new_code_cell(code))

nb = nbformat.v4.new_notebook()
nb['cells'] = cells

nbformat.write(nb, nb_file)
print(f'Notebook created: {nb_file}') 