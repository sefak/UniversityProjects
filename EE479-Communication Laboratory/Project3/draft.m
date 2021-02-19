for lfreq=[730 810 890]
    if sum(abs(lowpass(low_Freq, lfreq, Fs, 'Steepness', 0.95)))>3e3
        temp_h = temp_l(temp_lf==lfreq,:);
        break
    else
        temp_h = temp_l(4,:);
    end
end
for hfreq=[1270 1400 1550 1700]
    if sum(abs(lowpass(high_Freq, hfreq, Fs, 'Steepness', 0.95)))>1e2
        output = temp_h(temp_hf==hfreq);
        break
    else
        output = nan;
    end
end