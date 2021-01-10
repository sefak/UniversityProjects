function [ solution ] = CalculateVoltages( textName )
%The function takes the name of text file with its extention that consists
%of 4 columns. The 1st column includes the type of components(V, I, or R).
%Remining two ones descripe the nodes between which the corresponding
%component is connected.(1st is negative, 2nd is positive node) And the
%last column is the values of the components in the unit of volt, ampere,
%and ohm. Then it returns the correspondin node voltages, respectively.
%  
fid=fopen(textName, 'r');
r=0; v=0; i=0;
while feof(fid)==0%determines # of R, V, and I.
    aline=fgetl(fid);%reads the txt file line by line.
    [txt, num]=strtok(aline);%1st entry is the type.
    if txt(1)=='R'%determines the type
        r=r+1;%increases the # of R.
    end
    if txt(1)=='V'%determines the type
        v=v+1;%increases the # of V.
    end
    if txt(1)=='I'%determines the type
        i=i+1;%increases the # of I.
    end
end
fclose(fid);
fid=fopen(textName, 'r');%to be able to use fgetl in while loop, again opens the text file.

resistors={zeros(r,1), zeros(r,2)};%1st field of cell array is the value of R, and 2nd field is the nodes of R.
vsources={zeros(v,1), zeros(v,2)};%1st field of cell array is the value of V, and 2nd field is the nodes of V.
isources={zeros(i,1), zeros(i,2)};%1st field of cell array is the value of I, and 2nd field is the nodes of I.

r=0; v=0; i=0; %resets the indexs of R, V, and I.
while feof(fid)==0
    aline=fgetl(fid);%reads the txt file line by line.
    [txt, num]=strtok(aline);%1st entry is the type, 2nd is the nodes and the values. 
    num=str2num(num);%converts string 'num' matrix to a integer 'num' matrix.
    if txt(1)=='R'%determines the type
        r=r+1;%increases the # of R.
        resistors{1}(r)=num(3);%value of rth R.
        resistors{2}(r,:)=[num(1) num(2)];%nodes of rth R.
    end
    if txt(1)=='V'%determines the type
        v=v+1;%increases the # of V.
        vsources{1}(v)=num(3);%value of vth V.
        vsources{2}(v,:)=[num(1) num(2)];%nodes of vth V.
    end
    if txt(1)=='I'%determines the type
        i=i+1;%increases the # of I.
        isources{1}(i)=num(3);%value of ith I.
        isources{2}(i,:)=[num(1) num(2)];%nodes of ith I.
    end
end
fclose(fid);
%The procedure of the MNA from 'http://www.swarthmore.edu/NatSci/echeeve1/Ref/mna/MNA3.html'
m=v;%# of independent voltage sources.
max_r=max(max(resistors{2}));
max_v=max(max(vsources{2}));
max_i=max(max(isources{2}));
n=max([max_r max_v max_i]);% determines # of nodes

G=zeros(n);
for a = 1:n
    for b = 1:n
        if a==b%at diagonal of G, the value is sum of the conductance in the corresponding node. 
            for c=1:r
                if any(resistors{2}(c,:)==a)%searchs each R whether it is connected to the node a, or not.
                G(a,a)=G(a,a)+1/resistors{1}(c);%if true it adds conductances.
                end
            end
        else%at off-diagonal, the value is the -1 times conductances.
            for c=1:r
                if resistors{2}(c,1)==a && resistors{2}(c,2)==b%Rs that connected node a to b.G(a,b)
                    G(a,b)=G(a,b)-1/resistors{1}(c);
                end
                if resistors{2}(c,1)==b && resistors{2}(c,2)==a%Rs that connected node b to a.G(b,a)
                    G(a,b)=G(a,b)-1/resistors{1}(c);
                end
            end
        end
    end
end

B=zeros(n,m);
for a=1:m%columns of B correspond each V, the one has positive polarity is 1, negative polarity is -1, otherwise 0.
     if vsources{2}(a,2)>0%checks nonzero of the indexing.
         B(vsources{2}(a,2),a)=1;%positive polarity corresponds 1.
     end
     if vsources{2}(a,1)>0%checks nonzero of the indexing.
         B(vsources{2}(a,1),a)=-1;%negative polarity corresponds -1.
     end
end
C=transpose(B);%If there is no dependent source(in the project thereis no), C equals to B^T. 
        
D=zeros(m,m);%If there is no dependent source(in the project thereis no), D eqauls m-by-m zero matrix.

A=zeros(n+m,n+m);%construct the A matrix.

for a=1:n
    for b=1:n
        A(a,b)=G(a,b);%first n by n submatrix of A equals to G.
    end
end
for a=1:n
    for b=1+n:n+m
        A(a,b)=B(a,b-n);%the right top of A equals to B.
    end
end
for a=1+n:n+m
    for b=1:n
        A(a,b)=C(a-n,b);%the left buttom of A equals to C.
    end
end
    
z=zeros(n+m,1);%first n elements reveal the sum of I at the node, last m elements reveal the value of V.

for a=1:i
    if isources{2}(a,2)>0%checks nonzero of the indexing.
        z(isources{2}(a,2))=z(isources{2}(a,2))+isources{1}(a,1);%positive polarity corresponds adding the Is' values.
    end
    if isources{2}(a,1)>0%checks nonzero of the indexing.
        z(isources{2}(a,1))=z(isources{2}(a,1))-isources{1}(a,1);%negative polarity corresponds adding the -Is' values.
    end
end
for a=1+n:n+m
    z(a)=vsources{1}(a-n);
end

x=(A^-1)*z;%computes the unknowns variables.

solution=zeros(n,1);
for i=1:n%first n elements correspond the node voltages.
    solution(i)=x(i);
end

end

