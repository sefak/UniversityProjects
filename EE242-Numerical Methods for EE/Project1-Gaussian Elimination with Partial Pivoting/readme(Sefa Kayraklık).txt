
				 PROJE-1-GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING:

	The code contains the algorithm that solves the system of equations which is represented as matrix. The n-by-n
   matrix A corresponds the coefficients of the unknown variables, and the n-by-1 vector b corresponds the values of
   the right hand sides of the equations. So, the algorithm solves the system of equations, and gives the values of the
   unknown variables.

	The code takes the matrix A and the vector b as a txt file that is named as A.txt and b.txt, respectively. Each
   line of the txt files corresponds to the rows of them. And the files should not contain more than one blank line 
   because it will disrupt the working process of the code. After solving the system, the algorithm gives the solutions
   as both a file named x.txt and an output of the program. (If A is singular, the code output an error message.)

	The algorithm uses partial pivoting to improve the accuracy of the solution. If it doesn't use this method, in
   the floating point algorithm, some information might be lost due to the underflow level and overflow level restiriction.

	The code also computes the condition number of the 2-by-2 matrix A. It is crucial to have this criterion, because
   it reveals the singularity of the matrix A. The condition number is said to be inifinity if A is singular. Namely, The
   greater the condition number, the closer the matrix A to singular matrix. For example:
   A: 1.000 1.000   The condition number is 4004. So, even a small change in the vector b causes a huge difference in the
      1.000 1.001   results.
   For b1: [2.000 2.000]^T, solution is [2.000 0.000]^T. However, For b2: [2.000 2.000]^T, solution is [1.000 1.000]^T.