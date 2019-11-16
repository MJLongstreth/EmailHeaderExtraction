library(readtext)
library(stringr)
library(rebus)
library(htmlwidgets)
library(dplyr)
library(purrr)

filenames <- read.csv("filenames.csv") #Read CSV containing file locations in
filenames$file_locations <- as.character(filenames$file_locations) #Convert locations to character string
filenames$file_locations <- gsub("([\\])","/", filenames$file_locations) #Change \ to /

#Create data frame with doc_id and text for all files in filenames
for (file in filenames) {
  emails <- readtext(file)
}

pattern_1 <- capture(one_or_more(char_class(ASCII_ALNUM %R% "._%+-"))) %R%
              capture("@") %R%
              capture(one_or_more(char_class(ASCII_ALNUM %R% ".-"))) %R%
              capture(DOT) %R%
              capture(ascii_alpha(2, 4))

emails_meta_1 <- str_match_all(emails$text,
                         pattern=pattern_1)

emails_meta_1_df <- data.frame()

#for (l in emails_meta_1) {
#  emails_meta_1_df <- sapply(l[,1], rbind)
#}

x <- as.data.frame(emails_meta_1[1])
y <- as.data.frame(emails_meta_1[2])
z <- rbind(x, y)

zz <- map(emails_meta_1, as.data.frame)

#emails_meta_1 <- as.data.frame(emails_meta_1)
#emails_meta_1$control_number <- str_replace(emails$doc_id, ".txt", "")