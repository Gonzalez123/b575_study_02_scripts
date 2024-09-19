cat file*txt > concat_seq.txt
#=============================================================================
#=============================================================================

# Using the vcf file of the TNBC sample:
# - Count all variants that have the reference T and Alternative C or G
# - Show the top 3 most common variations on chromosome 10

# from the following sample in the TNBC GEO dataset:
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM1261016
# The description of the format for the vcf file version 4.1 
# is available in the following document:
# https://samtools.github.io/hts-specs/VCFv4.1.pdf

# download the sample vcf file
curl -o TNBC_sample.vcf.gz https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1261nnn/GSM1261016/suppl/GSM1261016%5FIP2%2D50%5Fvar%2Eflt%2Evcf%2Egz

# uncompress the file
gzip -d TNBC_sample.vcf.gz

# take only the lines that contain data - ignore the ones that start with # using grep 
# use awk to separate the file into columns and select lines where specific columns 
# have specific values && means AND in a condition, || means OR in a condition use cut to
# select only columns 1,2,4,5 and 6 (chromosome, position, reference, alternative and 
# quality) from the result 
# the default separator for cut is tab to se up a different separator use the -d option
# for comma it would be -d,


# Count all variants that have the reference T and Alternative C or G
# Count the lines that have the reference T and Alternative C or G
grep -v "^#"  TNBC_sample.vcf | awk '$4=="T" && ($5=="C" || $5=="G")' | cut -f1,2,4-6 | wc -l 

# - Show the top 3 most common variations on chromosome 10
# use grep, awk, and cut to remove comments, get chromosome 10 data only and select the columns 
# you need (chromosome, ref, alt)
# sort the data and use uniq to count (-c) how many of each unique element we have
# sort numeric and descendig/reverse (-nr) the results and take top 3 (head -n3)
grep -v "^#"  TNBC_sample.vcf | awk '$1==10' | cut -f1,4,5 | sort | uniq -c | sort -rn | head -n3


# What does the following code do?

# you can use a simple example to rest the regular expression match:
echo "1|22|3" | grep -o "|.*|"
echo "12|(33)|567" | sed  's/(33)/xx/'
echo "12|(33)|567" |sed  's/33/xx/'
echo "12|(33)|567" |sed  's/\(33\)/xx/'
echo "12|(333333)|567" |sed  's/\(33\)/xx/'
echo "12|(333333)|567" |sed  's/\(3*3\)/xx/'

# The following code uses the echo command to display the text 
# 'Here we are! We are finishing this exercise!'
# The text will then be sent as the input to the sed command
# which will look for the string are and it will replace it with were
# s/<what_you_want_to_substitute>/<what_to_substitite_with>/<flag = how many times>  
# s/ - means the action is substitute
# the flag g means globally - replace all occurences
# https://man7.org/linux/man-pages/man1/sed.1p.html
# https://linux.die.net/man/1/sed
# https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html
# https://www.grymoire.com/Unix/Sed.html#uh-0

 echo 'Here we are! We are finishing this exercise!' | sed 's/are/were/g'

## result:
## Here we were! We were finishing this exercise!


# On the following code, we use sed to capture what is between two separators 
# - in this case the separators are the words "are " and "ing"
# Using parantheses will allow us to capture a pattern
# .* tells us that you want to match anything (see the cheatsheet I showed in class. for regular expressions)
# see https://www.maketecheasier.com/cheatsheet/regex/
# the () allows us to group the elements matching the expression between parantheses
# we need \ before parantheses to be interpreted as parantheses
# \1 is the matched pattern - what matches the expression between parantheses
# We add an 'e' after the matched pattern
# So, we find something like TEXT_BEFOREare TEXT_BETWEENingTEXT_AFTER and substitute it with text_between

echo 'We are decoding instructions\n that are intriguing' | sed 's/.*are \(.*\)ing.*/\1e/1'

## result:
## decode
## intrigue

# Also try:

echo 'we are decodeing instructions \n that are confusing' | grep  -o 'are\(.*\)ing'

## result - matches on each line text that starts with "are" and ends with "ing"
## are decodeing
## are confusing

# WORK WITH MULTI SEQUENCE FILE

#=============================================================================
#=============================================================================

# PROBLEM What does the following code do?
head -n 4 multi_seq.fa > seq1.fa
head -n 8 multi_seq.fa | tail -n 4 > seq2.fa 
head -n 12 multi_seq.fa | tail -n 4 > seq3.fa 
head -n 16 multi_seq.fa | tail -n 4 > seq4.fa

#### ------------------------------------------------------------------------
# SOLUTION to the PROBLEM: 
#### ------------------------------------------------------------------------

# The code separates the 4 sequences in the multi_seq.fa file in 4 files seq1-4.fa
# Each sequence is written on 4 lines.

# Line one takes the first 4 lines (head -n 4) of the file multi_seq.fa and saves them in the  seq1.fa
# Line two takes the first 8 lines (head -n 8) and then the last 4 lines of the result (tail -n 4) of the file multi_seq.fa (practically lines 5-8) and saves them in the  seq2.fa
# Line three takes the first 12 lines (head -n 12) and then the last 4 lines of the result (tail -n 4) of the file multi_seq.fa (practically lines 9-12) and saves them in the  seq3.fa
# Line four takes the first 16 lines (head -n 16) and then the last 4 lines of the result (tail -n 4) of the file multi_seq.fa (practically lines 13-16) and saves them in the  seq4.fa

#=============================================================================
#=============================================================================




# Select the sequence id from the multi sequence fasta file: multi_seq.fa

# The line that marks a new sequence and has the sequence ID starts with > 
# so we select those lines using grep
# We use sed to capture what is between two separators - in this case the separator is |
# Using parantheses will allow us to capture a pattern
# .* tells us that you want to match anything (see the cheatsheet I showed in class. for regular expressions)
# see https://www.maketecheasier.com/cheatsheet/regex/
# the () allows us to group the elements matching the expression between parantheses
# we need \ before parantheses to be interpreted as parantheses
# \1 is the matched pattern - what matches the expression between parantheses
# So, we find something like text_before|text_between|text_after and substitute it with text_between

grep "^>" multi_seq.fa | sed  's/.*|\(.*\)|.*/\1/'

grep "^>" multi_seq.fa | sed  's/.*|\(.*\)|.*/\1/' > seq_ids.txt


# Alternative (less general) solution
# Remove (substitute with nothing) the specific text you have before and after | in the file

grep "^>" multi_seq.fa | sed 's/>ref|//' | sed '/s/|Homo Sapiens/'


# Remove the first and third sequence from the file seq_ids.txt and save the result on seq_ids_selected.txt 

# In the follwong command we use sed to look for a pattern 
# - in this case is the line number (1 or 3) and then apply the delete action (d)
# we can only provide a single number or a range to one delete actions, 
# so we have 2 actions separated by ;
# then we reditect the output to the seq_ids_selected.txt file

sed '1d;3d' seq_ids.txt > seq_ids_selected.txt


# Write a bash script that does the two steps, 
# add echo commands to separate the steps 
# and describe the output.
# See what a gen AI tool does if you ask it.

# https://www.perplexity.ai/search/write-a-bash-script-that-does-DsxD_c7jQKGmnCSkecOXOA

# ------- the script for perplexity AI: we save it as multi_seq_processing.sh

#!/bin/bash

# Step 1: Extract sequence IDs
echo "Step 1: Extracting sequence IDs from multi_seq.fa"
grep "^>" multi_seq.fa | sed 's/^>//' > seq_ids_AI.txt
echo "Sequence IDs saved to seq_ids_AI.txt"

# Step 2: Remove first and third sequences
echo -e "\nStep 2: Removing first and third sequences from seq_ids_AI.txt"
sed '1d;3d' seq_ids_AI.txt > seq_ids_selected_AI.txt
echo "Selected sequence IDs saved to seq_ids_selected_AI.txt"

# Display results
echo -e "\nContents of seq_ids_AI.txt:"
cat seq_ids_AI.txt
echo -e "\nContents of seq_ids_selected_AI.txt:"
cat seq_ids_selected_AI.txt


# ---------


#  Write a bash script that separates the sequences in a multiseq fasta file. 

# https://www.perplexity.ai/search/write-a-bash-script-that-separ-wjXM3PVrRNK3055B2qCh.A


# ---- the scipt from perplexity AI: we save it as multi_seq_split.sh

#!/bin/bash

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_fasta_file>"
    exit 1
fi

input_file=$1

# Create output directory
output_dir="split_sequences"
mkdir -p "$output_dir"

# Split the multi-sequence FASTA file
awk '/^>/ {close(outfile); outfile="'$output_dir'/"++count".fasta"} {print > outfile}' "$input_file"

echo "Sequences have been separated into individual files in the '$output_dir' directory."

# --------




# What does the following code do?

echo "Hello Cristina" | awk '{$2="X"; print $0}'

# The echo command displays the text after it to the standard output
# The pipe takes the output of echo and gives it as input to awk
# awk breaks the input by whitespace and
# sets/assigns (=) the text "X" to the second element 
# replacing the existing second element "Cristina" with "X"
# then it displays the line ($0) to the standard output


## result:
## Hello X


# Create a folder b575_study02_scripts and move the scripts 
# from the exercises above to the repository through the UI

mkdir b575_study02_scripts
mv multi_seq_processing.sh b575_study02_scripts/multi_seq_processing.sh
mv multi_seq_split.sh b575_study02_scripts/multi_seq_split.sh

# Initialize a git repo in the folder b575_study02_scripts
cd b575_study02_scripts
git init

# Add the scripts to be tracked using git and commit the change 
git add multi_seq_processing.sh
git add multi_seq_split.sh

# Create a GitHub repo b575_study02_scripts (no readme gitignore or license) 
# this is done on GitHub

# Slised 32 and 33 at
# https://umich.instructure.com/courses/701737/files/folder/class_sessions/session_03_git_github?preview=36802126


# Connect the GitHub and local repo following the instruction in the tutorial at the following link:
# https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github#adding-a-local-repository-to-github-using-git

git remote add origin https://github.com/mitreacristina/b575_study02_scripts.git

git remote -v

git push -u origin main

# Write a bash command that concatenates the sequences in the multi_seq.fa
#  and saves them as concat_seq.txt 

grep -v "^>" multi_seq.fa| tr -d "\n" > concat_seq.txt 

# Write a bash command that concatenates the sequences in the 
# multi_seq.fa and saves them in a file named concat_seq.txt 



# As a change on a new branch, add this command as a third step to the script with two steps

# create branch 

git branch -b multi_seq_concat

# use nano to edit the file 
nano multi_seq_processing.sh
# add the line
# grep -v "^>" multi_seq.fa| tr -d "\n" > concat_seq.txt 



# Commit the change on the new branch
git add multi_seq_processing.sh
git commit -m "Added command to conacatenate sequences to the script"


# merge the branch into main
# go to the main branch
git checkout main

# merge
git merge multi_seq_concat



# push the change to the remote repository
git push



