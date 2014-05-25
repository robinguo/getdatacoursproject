## Feature Names

Read in feature.txt file, which has two columns. The second one is feature names. To clean the feature names, do the following,
1. Replace the '-' character in feature names.
2. Remove '()' characters in feature names.
3. Replace '(' with '.' in feature names.
4. Remove ')' characters in feature nmaes.

```r
features <- read.table("features.txt")
features[, 2] <- gsub("[-,]", "\\.", features[, 2])
features[, 2] <- gsub("\\(\\)", "", features[, 2])
features[, 2] <- gsub("\\(", "\\.", features[, 2])
features[, 2] <- gsub("\\)", "", features[, 2])
```

## Activity Labels

The second column of activity_labels.txt is Activity labels.

```r
label <- read.table("activity_labels.txt")
```
## Train and Test Data

The folder structure and file names for train data and test data are similar, so we can apply the same logic to them. 

1. Read the subject data, set appropriate column name, and convert it to factor
2. Read the test/train data, set appropriate column name (using the feature names)
3. Read the label data, set appropriate column name, and convert it to factor (also set level names)
4. Combine the 3 piece of data by column
5. Combine train and test data by row

```r
data <- data.frame()
df <- data.frame()
type <- c("test", "train")
for (t in type) {
    subject <- read.table(paste0(t, "/subject_", t, ".txt"))
    names(subject) <- "subject"
    subject$subject <- as.factor(subject$subject)
    
    x <- read.table(paste0(t, "/X_", t, ".txt"))
    names(x) <- features[, 2]
    
    y <- read.table(paste0(t, "/y_", t, ".txt"))
    names(y) <- "label"
    y$label <- as.factor(y$label)
    levels(y$label) <- label[, 2]
    
    df <- cbind(subject, x, y)
    data <- rbind(data, df)
}
```
## Subset Data

1. Get the column names for the combined data
2. Grep for 'mean' or 'std'
3. Subsetting Data using the Grep result
4. Cbind subject, the result from the previous step and label
5. Set appropriate column name

```r
columns <- names(data)
meanstd <- grep("\\.mean\\.|\\.std\\.", columns)
tidydata <- cbind(data$subject, data[, meanstd], data$label)
names(tidydata)[1] <- "subject"
names(tidydata)[length(tidydata)] <- "label"
```

## Write Data

Finally, write the tidy data to file

```r
write.csv(tidydata, file="tidydata.csv", row.names=F)
```