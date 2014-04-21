# This script consists of three primary functions for each step of the 
# data processing, as well as one helper function that calls each of them
# and constructs the tidy data set. The script can be called from inside of R
# via source, or from the command line via Rscript. If called from inside of
# R the function to create the tidy data set is run immediately and stored in
# the variable 'tidyDataSet'. If called from the command line, the analyses
# will output the results to three files in the current working directory.
# The files will be labeled 'mergedData.txt', 'extractedData.txt', and 
# 'tidyData.txt.' One file for each of the steps in the analysis.
# In both cases, the 'UCI HAR Dataset' directory needs to be in the given
# directory if one is entered, or the working directory if one is not.

mergeData <- function(inDirectory = getwd()) {
    # Merge the training, testing, activity, and individual data files.
    # The directory containing the 'UCI HAR Dataset' can be specified. If
    # no path given, the function assumes it resides in the current working
    # directory.
    
    # Check for existence of data directory. 
    if (! file.exists(paste0(inDirectory, '/UCI HAR Dataset'))) {
        stop('UCI HAR Dataset not in the directory')
    }
    uciPath = paste(inDirectory, 'UCI HAR Dataset', sep='/') 
    
    
    # Load the required datasets.
    features <- read.table(paste(uciPath, 'features.txt', sep='/'), 
                           header=FALSE)
    featureNames <- features$V2
    trainFull <- read.table(paste(uciPath, 'train', 'X_train.txt',sep='/'),
                            header=FALSE)
    testFull <- read.table(paste(uciPath, 'test', 'X_test.txt', sep='/'),
                           header=FALSE)
    trainIndividual <-read.table(paste(uciPath, 'train', 'subject_train.txt',
                                       sep='/'), header=FALSE)
    testIndividual <- read.table(paste(uciPath, 'test', 'subject_test.txt',
                                       sep='/'), header=FALSE)
    trainActivity <- read.table(paste(uciPath, 'train', 'y_train.txt', 
                                      sep='/'), header=FALSE)
    testActivity <- read.table(paste(uciPath, 'test', 'y_test.txt',
                                     sep='/'), header=FALSE)
    activityNames <- read.table(paste(uciPath, 'activity_labels.txt', sep='/'),
                                stringsAsFactors=FALSE)
    
    # Combine datasets into merged dataframe.
    fullData <- rbind(trainFull, testFull)
    colnames(fullData) <- featureNames
    
    fullActivity <- c(trainActivity$V1, testActivity$V1)
    fullActivity <- as.factor(fullActivity)
    levels(fullActivity) <- activityNames$V2
    fullData$Activity <- fullActivity
    
    fullIndividual <- c(trainIndividual$V1, testIndividual$V1)
    fullData$Individual <- as.factor(fullIndividual)
    return(fullData)
}

extractMeanStd <- function(processedData) {
    # Takes the full merged dataset and extracts the data 
    # for all the wanted variables.
    
    # Extract all variable names.
    allNames <- names(processedData)
    
    # We are only taking variables containing the strings '-mean()-' or
    # the strings '-std()-' somewhere in the name. 
    meanIndex <- grep('\\-mean\\(\\)\\-', allNames)
    stdIndex <- grep('\\-std\\(\\)\\-', allNames)
    
    # Along with the 'Activity' and 'Individual' variables.
    activityIndex = which(allNames == 'Activity')
    individualIndex = which(allNames == 'Individual')
    
    # Keep the ordering of the variables the same as in the original.
    featureIndices <- sort(c(meanIndex, stdIndex))
    
    # Except for 'Individual' and 'Activity' which will be first.
    featureIndices <- c(individualIndex, activityIndex, featureIndices) 
    
    featureNames <- allNames[featureIndices]
    return(processedData[, featureNames])
}

createTidyData <- function(extractedData) {
    # Computes the mean for each variable by the factor variables
    # Activity and Individual.
    
    activities <- levels(extractedData$Activity)
    individuals <- levels(extractedData$Individual)
    
    # Initialize a dataframe of the appropriate size.
    tidyData <- as.data.frame(matrix(rep(NA, 180*48), nrow=180))
    activityIndividualIndex <- which(names(extractedData) %in% 
                                    c('Activity', 'Individual'))
    
    colnames(tidyData) <- names(extractedData)[-activityIndividualIndex]
    tidyName <- rep(NA, 180)
    index = 1
    # Loop over the data frame and calculate mean for all
    # combinations of individual and activity and entering them
    # into the tidyData dataframe.
    for (act in activities) {
        for (ind in individuals) {
            data <- subset(extractedData, 
                           Activity == act | Individual == ind)
            tidyData[index,] <- colMeans(data[, -activityIndividualIndex])
            tidyName[index] = paste(act, ind, sep='_')
            index = index + 1
            
            }
    }
    row.names(tidyData) <- tidyName
    return(tidyData)
}
    
run_analysis <- function(inDirectory = getwd()) { 
    # Runs the entire analysis returning a tidy data set. Specify the 
    # directory containing the 'UCI HAR Dataset' if it is not in the 
    # current working directory.
    merge <- mergeData(inDirectory)
    extracted <- extractMeanStd(merge)
    tidy <- createTidyData(extracted)
    return(tidy)
}

# Runs the analysis if the script is sourced into R. Creates an object
# tidyDataSet that contains the result of the full analysis. This
# may take a minute or two depending on the machine.
if (interactive()) {
    tidyDataSet <- run_analysis()
    invisible(tidyDataSet)
}
# Allow for the analysis to be called as a script from the command line via
# Rscript run_Analysis.R If called it will save each data set to the files:
# mergedData.txt
# extractedData.txt
# tidyData.txt
if (! interactive()) {
    args <- commandArgs(trailingOnly = TRUE)
    if (length(args) == 1) {
        mergedData <- mergeData(args[1])
    } else {
        mergedData <- mergeData()
    }
    extractedData <- extractMeanStd(mergedData)
    tidyData <- createTidyData(extractedData)
    write.table(mergedData, 'mergedData.txt', row.names=FALSE)
    write.table(extractedData, 'extractedData.txt', row.names=FALSE)
    write.table(tidyData, 'tidyData.txt', row.names=TRUE)
}
