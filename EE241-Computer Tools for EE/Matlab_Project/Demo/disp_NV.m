function disp_NV( soln, name )
%It displays the given node voltages as a matrix as a kind of the users can
%understand, and the name of the text file.
%   
for i=1:4
    name(end)=[];
end
fprintf('The name of the file which is executed is %s.\n', name);
N=length(soln);
for i=1:N
    fprintf("The node%d's value is %.3f. \n", i, soln(i));
end
end

