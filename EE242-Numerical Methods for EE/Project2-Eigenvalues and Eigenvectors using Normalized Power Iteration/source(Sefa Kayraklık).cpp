#include <iostream>
#include <fstream>
#include <stdlib.h>	// strtod
#include <math.h> 	// sqrt

using namespace std;

double abs (double x){
	if(x>=0)
		return x;
	else
		return -x;
}

class matrix{
	int s, i, j, k; // s-> the size of the matrix; the others-> the loop indecies.
	public:
		double **A, *b; // A->matrix A; b-> result of A*vector
		
		matrix(int y) : s(y){} // constructor of the class matrix
		
		void form(){ // forming the matrix sized s-by-s, and forming the vector sized s, with dynamic memory allocation
			A = new (nothrow) double *[s];
			for(i=0; i<s; i++)
				A[i] = new (nothrow) double [s];
			b = new (nothrow) double [s];
		
			if(A==NULL || b==NULL)
				cout << "Error: memory could not be allocated.";
			for(i=0; i<s; i++)
				b[i]=0;
		}
		
		double inf_norm_b(){ // determining the infinity norm of the vector b
			double max;
			max=abs(b[0]);
			for(i=1; i<s; i++){
				if(abs(b[i])>max)
					max=abs(b[i]);
			}
			return max;
		}
		void normalize_b(double norm){ // normalization of the vector b
			for(i=0; i<s; i++)
				b[i]/=norm;
		}
		void operator * (double vector[]){ // matrix multiplication of the matrix A and any vector sized s => b=A*vector

			for(i=0; i<s; i++){
				b[i]=A[i][0]*vector[0];
				for(j=1; j<s; j++){
					b[i]+=A[i][j]*vector[j];
				}
			}	
		}
		
		matrix operator * (matrix mat){ // matrix multiplication of the matrix A and any matrix sized s-by-s => M.A=A*mat.A
			matrix M(s);
			M.form();
			for(i=0; i<s; i++){
				for(j=0; j<s; j++){
					M.A[i][j]=A[i][0]*mat.A[0][j];
					for(k=1; k<s; k++)
						M.A[i][j]+=A[i][k]*mat.A[k][j];
				}
			}
			return M;
		}
		
};

int size_A(char* name){// determining the size of matrix A.
	int s=0;
	string dummy;
	ifstream file_dummy (name);
	if(file_dummy.is_open()){ 
		while(getline(file_dummy, dummy)){
			s++;
		}
		file_dummy.close();
	}else
		cout<<"enable to open the "<<name;
	
	return s;
}
// computes the scalar product of the 2 given vectors
double scalar_product(double x[], double y[], int s){ // s-> size of the multipied vectors.
	int i;
	double result;
	
	result=x[0]*y[0];
	for(i=1; i<s; i++){
		result+=x[i]*y[i];
	}
	return result;
}
// computes the distance square of the given 2 vectors.
double distance_square(double x[], double y[], int s){ // s-> size of the multipied vectors.
	int i;
	double result;
	result=(x[0]-y[0])*(x[0]-y[0]);
	for(i=1; i<s; i++){
		result+=(x[i]-y[i])*(x[i]-y[i]);
	}
	return result;
}


int main(int argc, char** argv) {
	int i, j, s; // s->size of the matrix A; the others-> loop indicies
	double *x, *pre, tolerans, eigen1=0, eigen2=0, pre_eigen; 

	s=size_A(argv[1]);// determining the size of the matrix
	matrix mat_A(s), mat_H(s), mat_Dummy(s), mat_B(s-1);

	x = new (nothrow) double [s];// for the starting point
	pre = new (nothrow) double [s]; // for the 2-previous eigenvector ( it is previous of the previous eigenvector)

	if(x==NULL || pre==NULL){
		cout << "Error: memory could not be allocated.";
		return 0;
	}
	if(argv[3]==NULL){// If the user enters less than 3 parameters, it gives error
		cout<<"Error: insufficient parameters are given.";
		return 0;
	}
		
	tolerans=strtod(argv[2], NULL);
	mat_Dummy.form();
	mat_B.form();
	mat_H.form();
	mat_A.form();

	ifstream file (argv[1]); // reading the matrix from asked file and writing it to the matrix A in mat_A.A
	if(file.is_open()){
		for(i=0; i<s; i++){
			for(j=0; j<s; j++)
				file>>mat_A.A[i][j];
		}
		file.close();
	}else{
		cout<<"Error: enable to open the file "<<argv[1];
		return 0;
	}

//	determining the 1st eigenvalue and its corresponding eigenvector
	for(i=0; i<s; i++)// selection of an arbitrary starting vector x.
		x[i]=1;
	do{	
		mat_A*x; // the b vector(in the class) is the resultant vector of this matrix multiplication 
		
		pre_eigen=eigen1; // storing the previously calculated eigenvalue in the pre_eigen
		eigen1=mat_A.inf_norm_b(); // infinite norm of b is the calculated eigenvalue
	
		mat_A.normalize_b(eigen1);// normalization of the b vector
		for(i=0; i<s; i++){
			pre[i]=mat_Dummy.b[i];// stores the every other eigenvectors, it is done because the sign of eigenvectors' elements can alternate after one iteration
			mat_Dummy.b[i]=x[i];// stores the previous eigenvectors
			x[i]=mat_A.b[i];  // new x vector is the normalized b vector (in the class)
		}
	 // repeat this process until it reaches the tolerance level that is given by 2nd parameter
	}while(abs(eigen1-pre_eigen)/eigen1>tolerans || sqrt(distance_square(pre, x, s))>tolerans);
 	mat_A*x;
	eigen1=scalar_product(x, mat_A.b, s)/scalar_product(x, x, s); // Rayleigh Quotient is used to find the eigenvalue for the approximate eigenvector
	if(abs(abs(eigen1)-pre_eigen)>tolerans*1e3) // If the matrix A has 2 eigenvalues that have the same absolute value, but with different sign,
		eigen1=pre_eigen; // then the corr. eigenvector is the linear combination of these. therefore Rayleigh Quotient is not valid for this case. 
	mat_A.normalize_b(eigen1);// So the eigenvalue found from Rayleigh Qutient is wrong. If the diff. of eigen1 and pre_eigen is so big then it is checked 

// Forming the v vector to construct the H matrix	v = a - (-sign_of_a(1))(2nd norm of a) * e1 ; v is the b vector in the mat_H class
	if(mat_A.b[0]>0)
		mat_H.b[0]=mat_A.b[0]+sqrt(scalar_product(mat_A.b, mat_A.b, s));
	else
		mat_H.b[0]=mat_A.b[0]-sqrt(scalar_product(mat_A.b, mat_A.b, s));
	for(i=1; i<s; i++)
		mat_H.b[i]=mat_A.b[i];
	
	
// forming the matrix H=>     H = I - 2/(scalar_product_v*v)*(v*transpose_v)
	for(i=0; i<s; i++){ 
		for(j=0; j<s; j++){
			if(i==j)
				mat_H.A[i][j]=1-2/scalar_product(mat_H.b, mat_H.b, s)*mat_H.b[i]*mat_H.b[j];
			else
				mat_H.A[i][j]=0-2/scalar_product(mat_H.b, mat_H.b, s)*mat_H.b[i]*mat_H.b[j];
		}
	}


//forming the matrix B=>      Dummy=H*A*(inverse_H)=H*A*H due to the property of the householder matrix. orthogonality and symmetry
	mat_Dummy=mat_H*mat_A*mat_H;
		
	for(i=0; i<s-1; i++){// B is the some part of the dummy matrix calculated above, 1-to-s by 1-to-s. 
		for(j=0; j<s-1; j++)
			mat_B.A[i][j]=mat_Dummy.A[i+1][j+1];
	}

	
// determining the 2nd eigenvalue	
	for(i=0; i<s-1; i++)// selection of an arbitrary starting vector x.
		x[i]=1;

	do{	
		mat_B*x; // the b vector(in the class) is the resultant vector of this matrix multiplication 
		
		pre_eigen=eigen2; // storing the previously calculated eigen value in the pre_eigen
		eigen2=mat_B.inf_norm_b(); // infinite norm of b is the calculated eigen value
		
		mat_B.normalize_b(eigen2);// normalization of the b vector
		for(i=0; i<s-1; i++){
			pre[i]=mat_Dummy.b[i];// stores the every other eigenvectors, it is done because the sign of eigenvectors' elements can alternate after one iteration
			mat_Dummy.b[i]=x[i];// stores the previous eigenvectors
			x[i]=mat_B.b[i];  // new x vector is the normalized b vector (in the class)
		}
    // repeat this process until it reaches the tolerance level that is given by 2nd parameter
	}while(abs(eigen2-pre_eigen)/eigen2>tolerans || sqrt(distance_square(pre, x, s-1))>tolerans);
	mat_B*x;
	eigen2=scalar_product(x, mat_B.b, s-1)/scalar_product(x, x, s-1);// Rayleigh Quotient is used to find the eigenvalue for the approximate eigenvector
	if(abs(abs(eigen2)-pre_eigen)>tolerans*1e3)// If the matrix A has 2 eigenvalues that have the same absolute value, but with different sign,
		eigen2=pre_eigen; // then the corr. eigenvector is the linear combination of these. therefore Rayleigh Quotient is not valid for this case.
	mat_B.normalize_b(eigen2);// So the eigenvalue found from Rayleigh Qutient is wrong. If the diff. of eigen2 and pre_eigen is so big then it is checked 

// determining the 2nd eigenvector; This algorithm is adopted from the lecture	
	for(i=0; i<s-1; i++)	
		mat_Dummy.b[i]=mat_Dummy.A[0][i+1];// the b vector in the formulation from the lecture
	x[0]=scalar_product(mat_Dummy.b, mat_B.b, s-1)/(eigen2-eigen1);
	for(i=0; i<s-1; i++)
		x[i+1]=mat_B.b[i];
	mat_H*x; // H^-1*x
	
	
// writing the results on the asked form
	ofstream file_result (argv[3]);
	if(file_result.is_open()){
		file_result<<"Eigenvalue#1: "<<eigen1<<"\n";
		for(i=0; i<s; i++)
			file_result<<mat_A.b[i]<<"\n";
		file_result<<"Eigenvalue#2: "<<eigen2<<"\n";
//		for(i=0; i<s; i++)// If the 2nd eigenvector corresponding to 2nd eigenvalues is wanted, erase comment marks at the beginning of the lines
//			file_result<<mat_H.b[i]<<"\n";
		file_result.close();
	}else
		cout<<"Error: enable to write the file "<<argv[3];


	return 0;
}
