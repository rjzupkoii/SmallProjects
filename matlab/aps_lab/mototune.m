% APS Lab Extract, Transform, Load (mototune.m)
%
% This file contains Mototune specific routines.

function [sheet] = mototune(directory)
    sheet = [];
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if contents(ndx).isdir
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        testNo = extractBetween(contents(ndx).name, 1, strfind(contents(ndx).name, '.') - 1);   
        sheet = [sheet; process(path, testNo)]; %#ok
    end 
end

function [results] = process(file, testNo)
    data = importdata(file, '\t');
    results = [];
    results = [results, testNo];
    results = [results, extract('D_NOx_exhaust', @averageTen, data)];
    results = [results, extract('D_O2_exhaust', @averageTen, data)];
    results = [results, extract('D_VGT_position48', @averageTen, data)];
    results = [results, extract('D_ETC_PWM_Out', @averageTen, data)];
    results = [results, extract('D_EGR_position_commanded', @averageTen, data)];
    results = [results, extract('D_SOI_dbtdc', @averageTen, data)];
    results = [results, extract('D_Rp_Bar', @averageTen, data)];
    results = [results, extract('O_main_inj_dur_us_new', @averageTen, data)];
end
