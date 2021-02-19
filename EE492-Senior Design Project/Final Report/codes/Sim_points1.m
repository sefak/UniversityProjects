%% Forming the dataset point for simulation in HFSS

dataset=cell(218,11);
dataset{1,1}="$muscle_per";
dataset{1,2}="$match_per";
dataset{1,3}="circ_rad";
dataset{1,4}="circ_wid";
dataset{1,5}="port_gap";
dataset{1,6}="turn_deg";
dataset{1,7}="turn_z";
dataset{1,8}="muscle_dim";
dataset{1,9}="match_dim";
dataset{1,10}="match_wid";
dataset{1,11}="surface_dim";
dataset{2,1}="";
dataset{2,2}="";
dataset(2,3:end)={"cm"};
dataset{2,6}="rad";
dataset{2,7}="deg";

circ_rad = [0.6 0.7 0.8 0.9 1 1.1];
circ_wid = [0.1 0.1 0.1 0.2 0.2 0.2];
port_gap = 0.1;
turn_deg = (2*pi*circ_rad)./(2*pi*circ_rad+port_gap)*2*pi;
turn_z = 0;
muscle_dim = 4;
match_dim = 5;
match_wid = [0.5 1];
surface_dim = 1;

mu_p = [20 30 40 50];
ma_p = [1 7 14 0 0 0 ; 1 8 16 23 0 0 ; 1 9 17 24 32 0; 1 9 17 26 34 42];

ind=3;
for i=1:6
    for j=1:2
        for k=1:4
            for l = 1:6
                if ma_p(k,l)==0
                    break;
                end
                dataset(ind,1)={mu_p(k)};
                dataset(ind,2)={ma_p(k,l)};
                dataset(ind,3)={circ_rad(i)};
                dataset(ind,4)={circ_wid(i)};
                dataset(ind,5)={port_gap};
                dataset(ind,6)={turn_deg(i)};
                dataset(ind,7)={turn_z};
                dataset(ind,8)={muscle_dim};
                dataset(ind,9)={match_dim};
                dataset(ind,10)={match_wid(j)};
                dataset(ind,11)={surface_dim};
                ind=ind+1;
            end
        end 
    end
end

%% Arranging the dataset for further processing

dataset(:,[5 6 7 8 9 11])=[];
dataset(2,:)=[];
dataset{1,1}="$muscle_per []";
dataset{1,2}="$match_per []";
dataset{1,3}="circ_rad [cm]";
dataset{1,4}="circ_wid [cm]";
dataset{1,5}="match_wid [cm]";

% Adding corresponding average power calculation values
dataset{1,6}="average_power [W/m2]";
dataset(2:end,6)=num2cell(load("AveragePower.txt"));
%%
% Adding corresponing S11 values at 2.4GHz in dB

dataset{1,7}="dB(St11) []";
returnLoss = readmatrix("Return Loss.csv");
ind=2;
for i=1:6
    for j=1:2
        for k=1:4
            for l = 1:6
                if ma_p(k,l)==0
                    break;
                end
                indx=find(ismember(returnLoss(:,1:5), [ma_p(k,l) ...
                    mu_p(k) circ_rad(i) circ_wid(i) match_wid(j)],'rows'));
                dataset{ind,7}=returnLoss(indx,7);
                ind=ind+1;
            end
        end 
    end
end

%writecell(dataset,'data.csv');
%save("data.mat", "dataset");