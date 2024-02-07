Please read this file before running the matlab functions
---------------
Adam Nafie
CSE Seminar 07.02.2024
Application of Swarm Intelligence to the Set Covering Problem
---------------

There are two SCP algorithms implemented in this folder as matlab functions:
- Artifical Bee Colony: abc.m
- Firefly Algorithm: firefly.m

All the other files are supporter functions, except
- algorithm_test.m
which is a test script intended to test SCP benchmark instances from the OR-Library (http://people.brunel.ac.uk/~mastjjb/jeb/orlib/scpinfo.html).

You can use the algorithms yourself by either running any of the above mentioned functions by passing two inputs:
- A: Incidence Matrix with dimensions m x n defining the Set Covering Problem instance to be solved
- c: A column vector of length n defining the cost for each respective column in A

If you wish to test an instance from the OR-Library linked above, then please note that the .txt file provided by the OR-Library for an SCP instance 
can be converted into the input variables A and c using the following function:
- import_scp_data.m

Or you can just directly use the algorithm_test.m script to solve the problem. You just need to
1- Download the <dataset-name>.txt file from the OR-Library and save in the folder ../scp-data
2- In algorithm_test.m set the dataset string array to include the string <dataset-name>
3- Set the runs_per_dataset variable to 1
4- Run the script
5- Your solution vector will be saved in the workspace in the variable 'sol'