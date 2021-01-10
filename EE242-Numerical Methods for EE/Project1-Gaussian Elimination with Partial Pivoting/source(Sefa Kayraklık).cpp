#include <iostream>
#include <fstream>

using namespace std;

double epsilon =0.000000001;

double abs(double a){ // The function that calculates the number's absolute value.
	if(a>=0)
		return a;
	else
		return -a;
}

double findmax(double a, double b){  // The function that determines which parameter is the maximum value. 
	if(a>b)
		return a;
	else
		return b;
}


int main() {
	
	int c, r, i, j, s=0, nth, isSingular=0;

	double **mat_A, *vec_b, *vec_x, *temp_r, temp, div, max, det, cond_1, cond_inf;

	string dummy;


//reading the files
	
	ifstream file_dummy ("b.txt");
	ifstream file_b ("b.txt");
	ifstream file_A ("A.txt");
	ofstream file_x ("x.txt");
	
	if(file_dummy.is_open()){ // getting the row and columns numbers.
		while(getline(file_dummy, dummy)){
			s++;
		}
		file_dummy.close();
	}else{
		cout<<"enable to open the b.txt.";
		return 0;
	}

		
//forming the matrix and vectors	

	mat_A = new (nothrow) double *[s];
	for(i=0; i<s; i++)
		mat_A[i] = new (nothrow) double [s];
	vec_b = new (nothrow) double [s];
	vec_x = new (nothrow) double [s];
	temp_r = new (nothrow) double [s];
	if(mat_A==NULL||vec_b==NULL||vec_x==NULL||temp_r==NULL){
		cout << "Error: memory could not be allocated.";	
		return 0;
	}

	if(file_b.is_open()){ 
		for(i=0; i<s; i++){
			file_b>>vec_b[i];
		}
		file_b.close();
	}else{
		cout<<"Error: enable to open the b.txt.";
		return 0;
	}	

	if(file_A.is_open()){
		for(i=0; i<s; i++){
			for(j=0; j<s; j++){
				file_A>>mat_A[i][j];
			}
		}
		file_A.close();
	}else{
		cout<<"Error: enable to open the A.txt.";
		return 0;
	}


// computing the condition number of 2-by-2 matrix A={a, b; c, d} ; A^-1=1/det*{d, -b; -c, a}
// for cond1: 1-norm of A is max(|a|+|c|,|b|+|d|) and 1-norm of A^-1 is max(|d|+|-c|,|a|+|-b|)/|det| then cond1=||A^-1||*||A||
// for condinf: inf-norm of A is max(|a|+|b|,|c|+|d|) and inf-norm of A^-1 is max(|d|+|-b|,|a|+|-c|)/|det| then condinf=||A^-1||*||A||

	if(s==2){   
		det=mat_A[0][0]*mat_A[1][1]-mat_A[0][1]*mat_A[1][0];
		
		cond_1=(findmax(abs(mat_A[1][1])+abs(-mat_A[1][0]) , abs(mat_A[0][0])+abs(-mat_A[0][1]))/abs(det))*
		(findmax(abs(mat_A[0][0])+abs(mat_A[1][0]) , abs(mat_A[0][1])+abs(mat_A[1][1])));
		
		cond_inf=(findmax(abs(mat_A[1][1])+abs(-mat_A[0][1]) , abs(mat_A[0][0])+abs(-mat_A[1][0]))/abs(det))*
		(findmax(abs(mat_A[0][0])+abs(mat_A[0][1]) , abs(mat_A[1][0])+abs(mat_A[1][1])));
		
		cout<<"The condition number of A is "<<cond_1<<" at order-1, and "<<cond_inf<<" at order-infinity.\n";		
	}	
	
	
//gaussian elimination with partial pivoting
	for(c=0; c<s; c++){
		max=abs(mat_A[c][c]); // reseting the max value for each pivot.
		nth=c;  // keeps the info about ordering the rows of A.
		
		for(r=c+1; r<s; r++){   //partial pivoting; determining the maximum value on the corresponding column.
			if(max<abs(mat_A[r][c])){
				max=abs(mat_A[r][c]);
				nth=r;
			}
		}
		
		for(i=0; i<s; i++){    // sweeping the max pivot to where it should be
			temp_r[i]=mat_A[c][i];
			mat_A[c][i]=mat_A[nth][i];
			mat_A[nth][i]=temp_r[i];
		}
		temp=vec_b[c];		// the b vector should also be sweept.
		vec_b[c]=vec_b[nth];
		vec_b[nth]=temp;
				
		for(r=c+1; r<s; r++){  // zeroing out the below of the pivot.
			div=mat_A[r][c]/mat_A[c][c];
			for(i=0; i<s; i++){
				mat_A[r][i]-=div*mat_A[c][i];
			}
			vec_b[r]-=div*vec_b[c];
		}
		if(abs(mat_A[c][c])<=epsilon)
			isSingular=1;
	}
	
	if(isSingular==0){  // if the matrix A isn't singular then it solve the system. "backward substitution"
		for(i=s-1; i>=0; i--){
			vec_x[i]=vec_b[i];
			for(j=i+1; j<s; j++){
				vec_x[i]-=mat_A[i][j]*vec_x[j];
			}	
			vec_x[i]/=mat_A[i][i];
		}
	}else{
		cout<<"Error: A is singular.\n";
		return 0;	
	}
	
	for(i=0; i<s; i++){  // printing out the elements of the solution x and writing them in a text file.
		file_x<<vec_x[i]<<"\n";
		cout<<"x"<<i+1<<" "<<vec_x[i]<<"\n";
	}file_x.close();
		

	for(i=0; i<s; i++)
		delete[] mat_A[i];
	delete[] mat_A;
	delete[] vec_x;
	delete[] vec_b;
	delete[] temp_r;					

	return 0;
}
