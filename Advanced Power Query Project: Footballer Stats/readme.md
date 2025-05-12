# Power Query Dynamic Football Stats Transformation

## Overview
This repository contains a solution for transforming unstructured football player statistics data into a clean, analysis-ready format using advanced Power Query techniques. The solution demonstrates dynamic filtering, custom function creation, and automated data processing without hard-coded values.

## 🔍 Problem Statement
The source data consists of football player statistics with a challenging structure:
- Multiple players' data (5 players in the sample file)
- Each player's data follows the same pattern but starts at different row positions
- Empty/null rows separate each player's section
- Multiple columns with mixed information (goals home/away, yellow/red cards)
- Non-normalized data that needs restructuring for proper analysis

## 🎯 Solution
The solution implements a fully automated approach that:
1. Dynamically identifies player data sections without hard-coded row numbers
2. Creates a template that can transform any single player's data
3. Converts the template into a reusable custom function
4. Uses a helper table to iterate through each player and apply the function
5. Combines all transformed player data into a single, clean dataset

## 🛠️ Technical Implementation

### Dynamic Top Row Filtering
```m
= Table.SelectRows(Source, each [players] <> P_Name)
```
This code dynamically removes all rows until it finds the first player name (stored in P_Name).

### Helper Table Structure
| Index | Player Name       |
|-------|-------------------|
| 1     | Nicolas Anelka    |
| 2     | Thierry Henry     |
| 3     | Ronaldo Nazario   |
| 4     | Kaka              |
| 5     | Hernan Crespo     |

### Parameter Configuration
A parameter named `player_index` is created to enable the dynamic selection of players.

### Dynamic Bottom Row Filtering
```m
= if cutoff_index > 0 then
      Table.FirstN(rename_columns2, cutoff_index)
  else
      rename_columns2
```
This code dynamically determines where each player's data ends by finding the position of the next player.

### Error Handling
```m
= try player_table_import{[Index = player_index + 1]}[Player Name]
  otherwise P_Name
```
This code handles the edge case of the last player where there is no "next player."

### Function Creation
The template is converted into a function that takes a player index as a parameter, enabling automated processing of all players.

## 🔄 Data Transformation Steps
1. **Source Data Loading**: Import the original Excel file
2. **Dynamic Top Row Filtering**: Remove rows until finding the player name
3. **Fill Down Player Names**: Fill empty cells in the player column
4. **Promote Headers**: Use the first row as column headers
5. **Rename Columns**: Standardize column names
6. **Remove Unnecessary Columns**: Filter out empty/irrelevant columns
7. **Unpivot Goal Columns**: Transform goals home/away into goal type and value columns
8. **Dynamic Bottom Row Filtering**: Limit data to the current player only
9. **Apply Function**: Use the custom function to process all players
10. **Combine Results**: Expand and merge all player data into a final dataset

## 📊 Final Data Structure
The final dataset has the following structure:
- Player: Player name
- Year: Year of the statistic
- Season: Season identifier
- Matches: Matches played
- Goal Type: Home or Away
- Goals: Number of goals (by type)
- Yellow Cards: Number of yellow cards received
- Red Cards: Number of red cards received

## 🔍 Key Technical Concepts Demonstrated
- Dynamic row filtering (both top and bottom)
- Parameter-driven transformations
- Custom function creation and application
- Table expansion and combination
- Error handling for edge cases
- Helper table design for iteration control

## 🎓 Advanced Power Query Techniques Used
- List.PositionOf() for finding data boundaries
- Table.SelectRows() with dynamic conditions
- Table.FirstN() for dynamic row limiting
- Try/otherwise for error handling
- Table.ExpandTableColumn() for combining results
- Custom parameter usage
- Function invocation via column operations

## 📝 Notes on Customization
The solution is designed to be flexible and can be adapted to similar data structures:
- The player helper table can be modified to include any number of players
- The transformation steps can be adjusted for different column structures
- The unpivot operation can be extended to other column pairs (like the cards)
- Additional transformation steps can be added as needed

---

⭐ If you find this project useful, please star it on GitHub! ⭐
