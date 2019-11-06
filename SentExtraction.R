library(readtext)
library(stringr)
library(rebus)
library(htmlwidgets)
library(dplyr)

filenames <- read.csv("filenames.csv") #Read CSV containing file locations in
filenames$file_locations <- as.character(filenames$file_locations) #Convert locations to character string
filenames$file_locations <- gsub("([\\])","/", filenames$file_locations) #Change \ to /

#Create data frame with doc_id and text for all files in filenames
for (file in filenames) {
  emails <- readtext(file)
}

#Use for single file
#email <- readtext("CTRL0000001.txt") #Read in text file
#email_text <- email$text #Extract text column from text file

#Pattern to match date "Sent: MM/DD/YYYY HH:MM:SS AM/PM"
pattern <- capture("Sent:") %R%
            " " %R% capture(one_or_more(DGT %R% DGT)) %R% 
            "/" %R% capture(one_or_more(DGT %R% DGT)) %R% 
            "/" %R% capture(one_or_more(DGT %R% DGT %R% DGT %R% DGT)) %R%
            " " %R% capture(one_or_more(DGT %R% DGT)) %R%
            ":" %R% capture(one_or_more(DGT %R% DGT)) %R%
            ":" %R% capture(one_or_more(DGT %R% DGT)) %R%
            " " %R% capture(or("AM", "PM"))

#Use this if you want to see the pattern being matched in the actual text file
#str_view(email_text,
#         pattern = pattern)

#Use match to extract date/time elements to a list
emails_meta <- str_match(emails$text,
          pattern=pattern)

emails_meta <- as.data.frame(emails_meta) #Convert list to data frame

emails_meta$control_number <- str_replace(emails$doc_id, ".txt", "") #Append file names from CSV file and remove ".txt"

#Replace column names in advance of export
names(emails_meta) <- c("extracted_date",
                       "action",
                       "month",
                       "day",
                       "year",
                       "hour",
                       "minute",
                       "second",
                       "AM_PM",
                       "control_number")

#Create additional columns to store formatted data in preparation for loading
emails_meta <- emails_meta %>%
                mutate(sent_date=paste(month, day, year, sep="/")) %>%
                mutate(sent_time=paste(hour, minute, second, sep=":")) %>%
                mutate(sent_date_time=paste(sent_date, sent_time, AM_PM, sep=" "))

write.csv(emails_meta,
          "C:/Temp/emails_meta.csv")
