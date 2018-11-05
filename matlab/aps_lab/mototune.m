% APS Lab Extract, Transform, Load (mototune.m)
%
% This file contains Mototune specific routines.

function [] = mototune(directory)
    global mototuneSheet;

    % Set the column headers if this is a new sheet
    if ~size(mototuneSheet, 1)
        mototuneSheet = {'Number', 'TestNo', 'Date'};
        for row = getColumns.'
            mototuneSheet = [mototuneSheet, row{1}];    %#ok
        end
    end
    
    % Process the data in the directory
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if contents(ndx).isdir || ~endsWith(contents(ndx).name, '.log')
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        testNo = extractBetween(contents(ndx).name, 1, strfind(contents(ndx).name, '.') - 1);   
        data = process(path, testNo{1});
        mototuneSheet = [mototuneSheet; [size(mototuneSheet, 1), data]]; %#ok
    end 
end

function [columns] = getColumns() 
    columns = {'D_NOx_exhaust', @averageTen;
               'D_O2_exhaust', @averageTen;
               'D_VGT_position48', @averageTen;
               'D_ETC_PWM_Out', @averageTen;
               'D_EGR_position_commanded', @averageTen;
               'D_SOI_dbtdc', @averageTen;
               'D_Rp_Bar', @averageTen;
               'O_main_inj_dur_us_new', @averageTen};
end

function [results] = process(file, testNo)
    % Import the data
    data = importdata(file, '\t');
    
    % Extract the relevent data
    results = {testNo, extractDate(file)};
    for row = getColumns.'
        results = [results, extract(row{1}, row{2}, data)]; %#ok
    end
end
