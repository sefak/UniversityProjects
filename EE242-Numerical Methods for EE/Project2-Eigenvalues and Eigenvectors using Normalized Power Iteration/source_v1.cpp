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
			if(A==NULL)
				cout << "Error: memory could not be allocated.";
			
			b = new (nothrow) double [s];
			if(b==NULL)
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
	}else{
		cout<<"enable to open the "<<name;
		return 0;
	}
	return s;
}

double scalar_product(double x[], double y[], int s){ // s-> size of the multipied vectors.
	int i;
	double result;
	
	result=x[0]*y[0];
	for(i=1; i<s; i++){
		result+=x[i]*y[i];
	}
	return result;
}

int main(int argc, char** argv) {
	int i, j, s; // s->size of the matrix A; the others-> loop indicies
	double *x, *v, tolerans, eigen1=0, eigen2=0, pre_eigen; // x->starting point; v->householder vector

	s=size_A(argv[1]);
	matrix mat_A(s), mat_H(s), mat_Dummy(s), mat_B(s-1);

	x = new (nothrow) double [s];
	if(x==NULL){
		cout << "Error: memory could not be allocated.";
		return 0;
	}
	v = new (nothrow) double [s]; // for the householder vector
	if(v==NULL){
		cout << "Error: memory could not be allocated.";
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
		x[i]=1.00;
	
	do{	
		mat_A*x; // the b vector(in the class) is the resultant vector of this matrix multiplication 
		
		pre_eigen=eigen1; // storing the previously calculated eigen value in the pre_eigen
		eigen1=mat_A.inf_norm_b(); // infinite norm of b is the calculated eigen value
		
		mat_A.normalize_b(eigen1);// normalization of the b vector
		for(i=0; i<s; i++)
			x[i]=mat_A.b[i];	// new x vector is the normalized b vector (in the class)
	}while(abs(eigen1-pre_eigen)>tolerans);// repeat this process until it reaches the tolerans value that given by 2nd parameter


// Forming the v vector to construct the H matrix	v = a - (-sign_of_a(1))(2nd norm of a) * e1
	if(mat_A.b[0]>0)
		v[0]=mat_A.b[0]+sqrt(scalar_product(mat_A.b, mat_A.b, s));
	else
		v[0]=mat_A.b[0]-sqrt(scalar_product(mat_A.b, mat_A.b, s));
	for(i=1; i<s; i++)
		v[i]=mat_A.b[i];

// forming the matrix H. H = I - 2/(scalar_product_v*v)*(v*transpose_v)
	for(i=0; i<s; i++){ 
		for(j=0; j<s; j++){
			if(i==j)
				mat_H.A[i][j]=1-2/scalar_product(v, v, s)*v[i]*v[j];
			else
				mat_H.A[i][j]=0-2/scalar_product(v, v, s)*v[i]*v[j];
		}
	}


//forming the matrix B. H=H*A*(inverse_H)=H*A*H due to the property of the householder matrix. 
	mat_Dummy=mat_H*mat_A*mat_H;
	
	for(i=0; i<s-1; i++){// B is the part of calculated H above, 1-to-s by 1-to-s. 
		for(j=0; j<s-1; j++)
			mat_B.A[i][j]=mat_Dummy.A[i+1][j+1];
	}

// determining the 2nd eigenvalue	
	for(i=0; i<s-1; i++)// selection of an arbitrary starting vector x.
		x[i]=1.00;
	
	do{	
		mat_B*x; // the b vector(in the class) is the resultant vector of this multiplication 
		
		pre_eigen=eigen2; // storing the previously calculated eigen value in the pre_eigen
		eigen2=mat_B.inf_norm_b(); // infinite norm of b is the calculated eigen value

		mat_B.normalize_b(eigen2);// normalization of the b vector.
		for(i=0; i<s-1; i++)
			x[i]=mat_B.b[i];	// new x vector is the normalized b vector in the class.
	}while(abs(eigen2-pre_eigen)>tolerans);
//	eigen2=-eigen2;
	
	for(i=0; i<s-1; i++)	
		v[i]=mat_Dummy.A[0][i+1];
	x[0]=scalar_product(v,mat_B.b, s-1)/(eigen2-eigen1);
	for(i=0; i<s-1; i++)
		x[i+1]=mat_B.b[i];
	mat_H*x;
	
	
// writing the results on the asked form
	ofstream file_result (argv[3]);
	if(file_result.is_open()){
		file_result<<"Eigenvalue#1: "<<eigen1<<"\n";
		for(i=0; i<s; i++)
			file_result<<mat_A.b[i]<<"\n";
		file_result<<"Eigenvalue#2: "<<eigen2<<"\n";
		for(i=0; i<s; i++)
			file_result<<mat_H.b[i]<<"\n";
		file_result.close();
	}else
		cout<<"Error: enable to write the file "<<argv[3];
	
	return 0;
}
