
				           PROJECT-3-SECANT AND BISECTION METHODS

	The code contains the algorithm that finds the root of a given polynomial via using bisection method, secant method, 
   and a hybrid method that is composed of both secant and bisection method.

	The code takes its entries from the command line arguments of the code. The last 1st parameter is for the tolerance
   value that determines the exactness of the root. The last 2nd and 3rd parameter is for the initial guesses x0 and x1 (x1<x0).
   And the first n+1 parameters is for the the coefficients from an upto a0. The command line arguments should have at least
   4 parameters because the last 3 ones are for the tolerance value and the guessed points; only one element is left, and that
   describes a constant polynomial which doesn't have a root.

	Some information about how the code works:
	   Bisection Method -> This algorithm compares the sign of the value of the middle points of given points and one of
   given points. If they match, then it updates the point. The algorithm processes until the interval reaches the tolerance. 
	   Secant Method    -> This algorithm approximates the polynomial by secant line through the given points. And it 
   updates the large one as the secant line's root and the small one as the large one of the previous iteration's. The 
   algorithm processes until the interval reaches the tolerance.
	   Hybrid Method    -> This algorithm uses bisection method in first 2 iterations and then proceeds with secant method 
   until finds the root.

	Why do we need the hybrid method?
	   The need for this approach is to eliminate some defect of secant method. Secant method can disturp the interval
   that the user gives if the initial interval is so large to converge. So the hybrid method firstly operates bisection 
   method to shorten the interval, and then it proceeds with secant method.