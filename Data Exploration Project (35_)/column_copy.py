import pyperclip
import pandas as pd

# Set the file path for the input xlsx or csv file
file_path = 'data_clean/combined_Pass.xlsx'  # or 'path/to/file.csv'

# Load the file into a pandas dataframe
df = pd.read_excel(file_path) if file_path.endswith('.xlsx') else pd.read_csv(file_path)

# Get the column names as a list
col_names = list(df.columns)

# Convert the list to a string with tab separators
col_names_str = '\t'.join(col_names)

# Copy the string to the clipboard
pyperclip.copy(col_names_str)

# Print a message to indicate that the column names have been copied to the clipboard
print('Column names have been copied to the clipboard!')
