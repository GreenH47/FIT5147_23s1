import os
import json
import pandas as pd

# Set the file paths for the team_data.csv and team_tips.json files
data_file_path = os.path.join('raw_data', 'team_data.csv')
tips_file_path = os.path.join('raw_data', 'team_tips.json')

# Load the team_tips.json file
with open(tips_file_path) as f:
    team_tips = json.load(f)

# Load the team_data.csv file into a pandas dataframe
team_data = pd.read_csv(data_file_path)

# Create a new xlsx file with two sheets
xlsx_file_path = os.path.join('data_clean', 'team_data.xlsx')
writer = pd.ExcelWriter(xlsx_file_path, engine='xlsxwriter')

# Write the team_data dataframe to the first sheet
team_data.to_excel(writer, sheet_name='Data', index=False)

# Create a new dataframe with column names and descriptions
cols = pd.DataFrame({'Columns': team_data.columns,
                     'Description': [team_tips.get(c, '') for c in team_data.columns]})

# Write the cols dataframe to the second sheet
cols.to_excel(writer, sheet_name='Column Descriptions', index=False)

# Save the xlsx file
writer.save()
