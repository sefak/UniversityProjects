%% Forming the dataset point for simulation in HFSS

dataset=cell(218,12);
dataset{1,1}="*";
dataset{1,2}="$muscle_per";
dataset{1,3}="$match_per";
dataset{1,4}="circ_rad";
dataset{1,5}="circ_wid";
dataset{1,6}="port_gap";
dataset{1,7}="turn_deg";
dataset{1,8}="turn_z";
dataset{1,9}="muscle_dim";
dataset{1,10}="match_dim";
dataset{1,11}="match_wid";
dataset{1,12}="surface_dim";
dataset{2,2}="";
dataset{2,3}="";
dataset(2,4:end)={"cm"};
dataset{2,7}="rad";
dataset{2,8}="deg";

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
                dataset(ind,1)={mod(ind-3,12)+1};
                dataset(ind,2)={num2str(mu_p(k))};
                dataset(ind,3)={num2str(ma_p(k,l))};
                dataset(ind,4)={num2str(circ_rad(i))+"cm"};
                dataset(ind,5)={num2str(circ_wid(i))+"cm"};
                dataset(ind,6)={num2str(port_gap)+"cm"};
                dataset(ind,7)={num2str(turn_deg(i),12)+"rad"};
                dataset(ind,8)={num2str(turn_z)+"deg"};
                dataset(ind,9)={num2str(muscle_dim)+"cm"};
                dataset(ind,10)={num2str(match_dim)+"cm"};
                dataset(ind,11)={num2str(match_wid(j))+"cm"};
                dataset(ind,12)={num2str(surface_dim)+"cm"};
                ind=ind+1;
            end
        end 
    end
end
dataset(:,7)=[];
dataset(2,:)=[];
%%
% for i=0:12:12*17
%     writecell([dataset(1,:); dataset([2:13]+i,:)],sprintf("sweep%i.csv",i./12+1))
% end