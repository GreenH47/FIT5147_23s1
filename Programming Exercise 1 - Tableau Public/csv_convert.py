import pandas as pd
from datetime import datetime

# load the CSV file into a pandas dataframe
df = pd.read_csv('PE1_frog_data.csv')

# convert the text in Time_Start column to datetime format
df['Time_Start'] = pd.to_datetime(df['Time_Start'])

# extract the time portion of the datetime and convert to hh:mm:ss format
df['Time_Start'] = df['Time_Start'].apply(lambda x: datetime.strftime(x, '%H:%M:%S'))

# Convert the 'Date' column to datetime format
df['Date'] = pd.to_datetime(df['Date'], format='%Y/%m/%d %H:%M:%S+00')

# Extract the date info and overwrite the 'Date' column
df['Date'] = df['Date'].dt.date

# Use the replace() method to replace the incorrect character sequence with the correct one
df['Common_name'] = df['Common_name'].replace("PeronÃ¢â‚¬â„¢s Tree Frog", "Peron's Tree Frog")

# save the modified dataframe to a new CSV file
df.to_csv('modified_file.csv', index=False)
