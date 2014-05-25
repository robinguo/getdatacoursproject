features <- read.table("features.txt")
features[, 2] <- gsub("[-,]", "\\.", features[, 2])
features[, 2] <- gsub("\\(\\)", "", features[, 2])
features[, 2] <- gsub("\\(", "\\.", features[, 2])
features[, 2] <- gsub("\\)", "", features[, 2])

label <- read.table("activity_labels.txt")

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

columns <- names(data)
meanstd <- grep("\\.mean\\.|\\.std\\.", columns)
tidydata <- cbind(data$subject, data[, meanstd], data$label)
names(tidydata)[1] <- "subject"
names(tidydata)[length(tidydata)] <- "label"
write.csv(tidydata, file="tidydata.csv", row.names=F)

