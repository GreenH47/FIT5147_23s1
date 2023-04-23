import pandas as pd
import pyperclip

# Load data for combined_attack
attack_data = pd.read_excel("data_clean/combined_attack.xlsx", sheet_name=0, header=0)

# Find Croatia's row
croatia_row = attack_data.loc[attack_data['Team'] == 'Croatia']
#print(croatia_row.len())
# Calculate average values
avg_values = attack_data.mean(axis=0)[1:]
#print(avg_values.len())
# # Find columns where Croatia's value is larger than the average
# larger_cols = croatia_row.iloc[0, 1:] > avg_values

# # Get the names of the columns where Croatia's value is larger than the average
# larger_cols_names = larger_cols[larger_cols == True].index.tolist()

# if larger_cols_names:
#     # Copy the column names to the clipboard
#     pyperclip.copy("\n".join(larger_cols_names))
#     print("The following column names have values larger than average:")
#     print(", ".join(larger_cols_names))
#     print("\nColumn names copied to clipboard.")
# else:
#     print("There are no columns where Croatia's values are larger than the average.")
