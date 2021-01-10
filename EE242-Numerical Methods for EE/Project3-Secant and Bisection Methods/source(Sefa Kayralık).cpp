#include <iostream>
#include <stdlib.h>	// strtod

using namespace std;

double abs(double x){// returns the absolute value of the given double valued number
	if(x<0)
		return -x;
	else 
		return x;
}

int sign(double x){// indicates the sign of the given double valued number
	if(x>0)
		return 0;
	else
		return 1;
}

class poly{// the class represents the polynomial and functions on itthe polynomials
	int i, j, tracker, n;// n-> # of coffecient in the polynomial
	public:
		double *coff;// it contains the info about coffecients of poly.
		
		poly(int x) : n(x){};
		
		void form(char **c_line){
			coff = new (nothrow) double [n];
			if(coff==NULL)
				cout<<"Error: memory could not be allocated.";
				
			for(i=0; i<n; i++)
				coff[i]=strtod(c_line[n-i], NULL);// coff[0]->a0, coff[1]->a1, ... , coff[n]->an
			
			tracker=0;// setting 0 value to the tracker.
		}
		
		double calc_value(double x){// calculates the value of the poly. at the given point x
			double temp, result=coff[0];
			
			for(i=1; i<n; i++){
				temp=coff[i];// temp=an
				for(j=0; j<i; j++)
					temp*=x;// temp=an*x^n
				result+=temp;// result is equal to summation of all temp
			}
			return result;
		}
		// in saying a, it is meant to interval[0]; in saying b, it is meant to interval[1] 
		void bisection(double interval[2]){// the algorithm was adopted from lecture notes. m=(a+b)/2
			double m=interval[0]+(interval[1]-interval[0])/2;
			if(sign(calc_value(interval[0]))==sign(calc_value(m)))
				interval[0]=m;// if m and a have the same sign then a becomes m
			else
				interval[1]=m;// if m and b have the same sign then b becomes m
		}
		
		void secant(double interval[2]){// the algorithm was also adopted from lecture notes. m is the (k+1)th x in the formulation
			double m=interval[0]-calc_value(interval[0])*(interval[0]-interval[1])/(calc_value(interval[0])-calc_value(interval[1]));
			interval[1]=interval[0];// after finding m, b becomes a 
			interval[0]=m;// a becomes m
		}
		
		void hybrid(double interval[2]){// it is a hybrid algorithm, at first 2 iterations bisection, then continues with secant 
			if(tracker<2)
				bisection(interval);
			else
				secant(interval);
			tracker++;
		}
};


int main(int argc, char** argv) {
	int ite_b=0, ite_s=0, ite_h=0;// they keeps the info about the number of iterations; ite_b->bisection, ite_s->secant, ite_h->hybrid
	double interval[2], tol, soln_b, soln_s, soln_h;
	poly p1(argc-4);// the last 3 of agrv are about interval and tol. 
	

	tol=strtod(argv[argc-1], NULL); // setting the tolerance value
	p1.form(argv);

	interval[0]=strtod(argv[argc-3], NULL); // setting the starting points
	interval[1]=strtod(argv[argc-2], NULL);
	while(abs(interval[1]-interval[0])>tol){// it iterates until the tolerance value is reached
		p1.bisection(interval);
		ite_b++;
		soln_b=interval[0]+(interval[1]-interval[0])/2;// solution is equal to mean of a and b
	}

	
	interval[0]=strtod(argv[argc-3], NULL); // setting again the starting points
	interval[1]=strtod(argv[argc-2], NULL);
	while(abs(interval[1]-interval[0])>tol){// it iterates until the tolerance value is reached
		p1.secant(interval);
		ite_s++;
		soln_s=interval[0]+(interval[1]-interval[0])/2;// solution is equal to mean of a and b
	}


	interval[0]=strtod(argv[argc-3], NULL); // setting again the starting points
	interval[1]=strtod(argv[argc-2], NULL);
	while(abs(interval[1]-interval[0])>tol){// it iterates until the tolerance value is reached
		p1.hybrid(interval);
		ite_h++;
		soln_h=interval[0]+(interval[1]-interval[0])/2;// solution is equal to mean of a and b
	}	
	// These roots that are found by the algorithms are the approximate value of the exact root. And these roots' exactness are equal to tolerance value
	cout<<"The root that is found in bisection is "<<soln_b<<"+-"<<tol/2<<", and the number of iteration is "<<ite_b<<".\n";
	cout<<"The root that is found in secant is "<<soln_s<<"+-"<<tol/2<<", and the number of iteration is "<<ite_s<<".\n";
	cout<<"The root that is found in hybrid is "<<soln_h<<"+-"<<tol/2<<", and the number of iteration is "<<ite_h<<".\n";	


	return 0;
}
