clear
data = readmatrix("Return Loss.csv");


ant_dim{1} = [0.1 0.2 0.3 0.4 0.5]; % port gap
ant_dim{2} = [2.15]; %torus rad
ant_dim{3} = [0.1]; % wire radius
ant_dim{4} = ["port gap", "torus rad","wire rad"];

sel_dim = 1;


figure(1)

for i = 1:length(ant_dim{sel_dim})
    plot(data(data(:,sel_dim)==ant_dim{sel_dim}(i),4), data(data(:,sel_dim)==ant_dim{sel_dim}(i),5), 'LineWidth', 2)
    legends(i) = ant_dim{4}(sel_dim) + "=" + ant_dim{sel_dim}(i) + "cm";
    hold on;
end
xlabel("Frequency (GHz)");
ylabel("St11 (dB)");
legend(legends);


title("Return Loss");
grid on;
xticks(1.5:0.1:3);