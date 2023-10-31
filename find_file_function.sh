find_files() {
  # Get the current day of the week (0=Sunday, 1=Monday, 2=Tuesday, etc.)
  day_of_week=$(date +'%u')
  
  if [ "$day_of_week" -eq 1 ]; then
    # If today is Monday, calculate the date of the previous Friday (current_date - 3 days)
    previous_friday=$(date -d "3 days ago" +'%Y%m%d')
    
    # Replace "pattern" with the actual file pattern you want to search for on the previous Friday
    file_pattern="your_pattern_here_for_previous_friday"
    
    # Search for files with the specified pattern modified on the previous Friday
    find /path/to/search -type f -name "$file_pattern" -newermt "$previous_friday" ! -newermt "$previous_friday+1 day"
  else
    # If today is not Monday, calculate the date of yesterday (current_date - 1 day)
    yesterday=$(date -d "1 day ago" +'%Y%m%d')
    
    # Replace "pattern" with the actual file pattern you want to search for on yesterday
    file_pattern="your_pattern_here_for_yesterday"
    
    # Search for files with the specified pattern modified on yesterday
    find /path/to/search -type f -name "$file_pattern" -newermt "$yesterday" ! -newermt "$yesterday+1 day"
  fi
}

# Call the function to find files based on the current day of the week
find_files
