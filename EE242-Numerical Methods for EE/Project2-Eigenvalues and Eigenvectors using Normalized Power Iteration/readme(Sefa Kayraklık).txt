
				 PROJE-2-COMPUTING EIGENVALUES AND EIGENVECTORS USING NORMALIZED
					      POWER ITERATON TOGETHER WITH DEFLATION

	The code contains the algorithm that computes the dominant eigenvalue, its corresponding eigenvector, and the
   next eigenvalue (if wanted, its corresponding eigenvector) by using the normalized power iteration together with 
   deflation.
   
	The code takes the matrix from the file whose name is given by the first parameter of the code.(it should contain 
   the extension of it.) Each line of the file corresponds to the rows of the matrix. The matrix in the file should be
   real valued and it should have the first 2 dominant eigenvalues as real numbers. And the file should not contain more
   than one blank line at the end because it will disrupt the working process of the code. Through the computation, the 
   code should have a tolerance level to estimate the eigenvalues and their corresponding eigenvector. This tolerance 
   level should be given by the second parameter of the code. And after calculations to find the results, the code writes 
   the results into a file whose name is given by the third parameter of the code(it should contain the extension of it.)

	Some information about how the code works: The algorithm tries to find the dominant eigenvalue by converging to it
   by the tolerance level. Furthermore, the algorithm tries to converge to the corresponding eigenvectors by the tolerance
   level. The second approach is compulsory; because even if the eigenvalue converges to a number, the corresponding eigen
   vector may not converge a vector. So, these conditions should be cosidered independetly.

	If the matrix has the same dominant eigenvalue more than one times, then the code works as following:
		1)if all dominant eigenvalues have the same sign, the 1st dominant and the next eigenvalue are the same
		2)if they have different sign, the 1st dominant eigenvalue is positive of them, and the next eigenvalue is
		whatever it is.
		***In both cases, the eigenvector is the linear combination of the true eigenvectors.***
			For example: -4 0 0 0 0    result:                     -4 0 0 0 0     result:
				     0 1 0 0 0 	     1st:-4                    0 1 0 0 0	1st:4
				     0 0 2 0 0       2nd:-4                    0 0 2 0 0	2nd:-3
				     0 0 0 -3 0 			       0 0 0 -3 0
				     0 0 0 0 -4 			       0 0 0 0 4
