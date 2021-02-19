function [candidate] = gen_candidate(muscle_per,precision,trainedModel_St11)
% [candidate] = gen_candidate(muscle_per,precision,trainedModel_St11)
% returns the all possible candidate combinations of inputs with specified 
% muscle permittivity and desired precision of the inputs.
%
% Since the St11 values are also an output of the simulation results, 
% a trained model should be provided for estimation of the St11 values.

match_per = 1:muscle_per;
circ_rad = 0.6:precision:1.1;
circ_wid = 0.1:precision:0.2;
match_wid = 0.5:0.1:1.0;

candidate = array2table(combvec(muscle_per,match_per,circ_rad,circ_wid,match_wid)');
candidate.Properties.VariableNames = [{'$muscle_per []'}    {'$match_per []'} ...
    {'circ_rad [cm]'}    {'circ_wid [cm]'}    {'match_wid [cm]'}  ];

candidate.('dB(St11) []') = trainedModel_St11.predictFcn(candidate);

end

