clear
data = readmatrix("Return Loss4.csv");

%%
ant_dim{1} = [0.6 0.7 0.8 0.9 1]; % port gap
ant_dim{2} = [2.7 2.8 2.9 3 3.1]; %torus rad
ant_dim{3} = [0.1]; % wire radius
ant_dim{4} = ["feedY [cm]", "patchY [cm]","wire rad"];

sel_dim = 1;


figure(1)

for i = 1:length(ant_dim{sel_dim})
    plot(data(data(:,1)==ant_dim{sel_dim}(i),end-1), data(data(:,1)==ant_dim{sel_dim}(i),end), 'LineWidth', 2)
    legends(i) = ant_dim{4}(sel_dim) + "=" + ant_dim{sel_dim}(i) + "cm";
    hold on;
end
%%
xlabel("Frequency (GHz)");
ylabel("St11 (dB)");
%legend(legends);

title("Return Loss");
grid on;
xticks(1.2:0.2:3.6);
xlim([1.2 3.6])