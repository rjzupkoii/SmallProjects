% APS Lab Extract, Transform, Load (mototune.m)
%
% This file contains Veristand specific routines.

function [] = veristand(directory)
    global veristandSheet;
     
    % Set the column headers if this is a new sheet
    if ~size(veristandSheet, 1)
        veristandSheet = {'Number', 'TestNo', 'Date'};
        for row = getColumns.'
            veristandSheet = [veristandSheet, row{1}];    %#ok
        end
    end
    
    % Process the data in the directory    
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if contents(ndx).isdir || ~endsWith(contents(ndx).name, '.csv')
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        testNo = extractBetween(contents(ndx).name, 1, strfind(contents(ndx).name, '.') - 1);   
        data = process(path, testNo{1});
        veristandSheet = [veristandSheet; [size(veristandSheet, 1) + 1, data]]; %#ok
    end
end

function [columns] = getColumns() 
    columns = {'LFEAirmass', @averageTen;
               'AI2_34 Lambda 1', @lambda;
               'T2_15 Intake Plenum Below Throttle', @averageTen;
               'T2_16 EGT 1', @averageTen;
               'T2_17 EGT 2', @averageTen;
               'T2_18 EGT 3', @averageTen;
               'T2_19 EGT 4', @averageTen;
               'T2_20 EGT 5', @averageTen;
               'T2_21 EGT 6', @averageTen;
               'T1_00 Rt. Bank Turb. In', @averageTen;
               'T1_02 EGT Right Bank Turbine Out', @averageTen;
               'T2_00 Coolant In', @averageTen;
               'T2_01 Coolant Out', @averageTen;
               'T2_06 Oil Gallery', @averageTen};
end

function [results] = process(file, testNo)
    % Import the data
    data = importdata(file, ',');
    
    % Extract the relevent data
    results = {testNo, extractDate(file)};
    for row = getColumns.'
        results = [results, extract(row{1}, row{2}, data)]; %#ok 
    end
end

function [result] = lambda(colNo, data)
    result = averageTen(colNo, data)^-1;
end