function [] = print_output(temp_output, output)
%print_output Summary of this function goes here
%   Detailed explanation goes here

if ~isnan(output)
    if ~isequal(temp_output,output)
        fprintf('%c', output)
    end
end

end

