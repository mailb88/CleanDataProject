Explanation of Variables
========================

Merged Data
---------------

The variable names concerning measured data remain unchanged. There is little that could be done to make them self-explanatory. The best explanation of the variables is therefore the original authors, located in the features_info.txt file the authors provided in the dataset. The Activity variable was originally coded from 1:6, these have been replaced with strings describing the activity. The individual variable is a factor with levels 1:30.

Extracted Data
--------------

Same as with the merged data but with most of the variables discarded. Only 'Individual', 'Activity', and measurement variables with the strings '-mean()-' or '-std()-' in them remain.

Tidy Data
---------

In this data set each row corresponds to one individual doing one activity. The variables in the dataset are calculated by taking the mean of all the measurements available where the individual is participating in the specific activity. The variable names remain unchanged, it is important to remember that they now represent the mean of all the times that variable has been measured while the individual was doing that activity.
