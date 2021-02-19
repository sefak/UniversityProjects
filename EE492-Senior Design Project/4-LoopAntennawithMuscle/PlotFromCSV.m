clear
data = readmatrix("Return Loss.csv");


ant_dim{1} = [0.1 0.2 0.3 0.4 0.5]; % port gap
ant_dim{2} = [1.2 1.5 1.8 2.1 2.4];% 1.8 2.1 2.4]; %torus rad
ant_dim{3} = [0.2 0.3]; % wire radius
ant_dim{4} = ["port gap", "torus rad","wire rad"];

sel_dim = 2;

n = size(data,2);
%%
for i = 1:length(ant_dim{sel_dim})
    plot(data(data(:,sel_dim-1)==ant_dim{sel_dim}(i),n-1), data(data(:,sel_dim-1)==ant_dim{sel_dim}(i),n), 'LineWidth', 2)
    legends(i) = ant_dim{4}(sel_dim) + "=" + ant_dim{sel_dim}(i) + "cm";
    hold on;
end
xlabel("Frequency (GHz)");
ylabel("St11 (dB)");
legend(legends);
title("Return Loss");
grid on;
xticks(1:0.2:3);

%%
plot(data(:,1),data(:,2), 'LineWidth', 2)
xlabel("Frequency (GHz)");
ylabel("St11 (dB)");
legend("CircRad=1.2cm Width=0.2cm PortGap=0.1cm");

title("Return Loss");
grid on;
xticks(1.5:0.1:3);