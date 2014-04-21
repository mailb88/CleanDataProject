Getting and Cleaning Data Project
=================================

This data munging project attempts to clean and process data collected from accelerometers in Samsung Galaxy smartphones. The original data, as well as information about collection and processing, is available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

Once this data has been downloaded, the script run_Analysis.R can be used to process. run_Analysis.R can be run in two ways; as an Rscript via the command line, or by using source() in an interactive session.

If called from the command line run_Analysis.R will write output of the analysis to three files:
* mergedData.csv
	This file merges all the data about measurements, individuals, and activities from both the testing set as well as the training set.
* extractedData.txt
	This file processes the merged data and extracts data about individuals, activities, as well as measurement variables with the strings '-mean()-' or '-std()-' in the name.
* tidyData.txt
	This file contains the fully processed data. The extracted data is split by the variables individual and activity, and the mean for each other variable is calculated.

If "sourced" in during an interactive session run_Analysis.R will immediately generate the tidy data, as explained above, and store it in the variable 'tidyDataSet.' There are four functions available in the script:
* mergeData
	Whi
