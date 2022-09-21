# To replace all occurrences of "day" with "night" and write to stdout:
sed 's/day/night/g' <file>

# To replace all occurrences of "day" with "night" within <file>:
sed -i 's/day/night/g' <file>

# To replace all occurrences of "day" with "night" on stdin:
echo 'It is daytime' | sed 's/day/night/g'

# To remove leading spaces:
sed -i -r 's/^\s+//g' <file>

# To remove empty lines and print results to stdout:
sed '/^$/d' <file>

# To replace newlines in multiple lines:
sed ':a;N;$!ba;s/\n//g' <file>

# To insert a line before a matching pattern:
sed '/Once upon a time/i\Chapter 1'

# To add a line after a matching pattern:
sed '/happily ever after/a\The end.'

# To remove the line and print the output to standard out:
sed '/pattern to match/d' ./infile

# To directly modify the file – does not work with BSD sed:
sed -i '/pattern to match/d' ./infile

# Same, but for BSD sed (Mac OS X and FreeBSD) – does not work with GNU sed:
sed -i '' '/pattern to match/d' ./infile

# To directly modify the file (and create a backup) – works with BSD and GNU sed:
sed -i.bak '/pattern to match/d' ./infile
