import os
import pandas as pd

# Set the file path for the Attack.xlsx file
xlsx_file_path = os.path.join('raw_data', 'Defend.xlsx')

# Load all sheets of the xlsx file into a dictionary of dataframes
dfs = pd.read_excel(xlsx_file_path, sheet_name=None)

# Format and sort the team column for each sheet
for sheet_name, df in dfs.items():
    df['Team'] = df['Team'].astype(str).apply(lambda x: x.split('.')[-1].strip())
    df = df.sort_values('Team')
    dfs[sheet_name] = df

# Combine all sheets into a single dataframe
combined_df = pd.concat([df.set_index('Team') for df in dfs.values()], axis=1)

# Save the combined dataframe to a new xlsx file
combined_xlsx_file_path = os.path.join('data_clean', 'combined_Defend.xlsx')
combined_df.to_excel(combined_xlsx_file_path)
