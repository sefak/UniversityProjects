file_path = fullfile(pwd(),'data.csv');
data_table = readtable(file_path,'PreserveVariableNames', true);

[trainedModel_St11, validationRMSE_St11] = trainRegressionModelSt11(data_table);

[trainedModel_AP, validationRMSE_AP] = trainRegressionModelAP(data_table);

%%
muscle_per = 30;
percision = 0.01;

candidate_combinations = gen_candidate(muscle_per,percision,trainedModel_St11);

estimate_AP = trainedModel_AP.predictFcn(candidate_combinations);

best = candidate_combinations(estimate_AP==max(estimate_AP),:);

fprintf("The maximum delivered average power for the muscle permittivity" ...
  + " of %i is estimated as %f with the following combination of inputs: \n",...
  muscle_per, max(estimate_AP));
disp(best);