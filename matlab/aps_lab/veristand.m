% APS Lab Extract, Transform, Load (mototune.m)
%
% This file contains Veristand specific routines.

function [] = veristand(directory)
    global veristandSheet;
    
%    init();
    
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if contents(ndx).isdir
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        testNo = extractBetween(contents(ndx).name, 1, strfind(contents(ndx).name, '.') - 1);   
        data = process(path, testNo{1});
        veristandSheet = [veristandSheet; [size(veristandSheet, 1) + 1, data]]; %#ok
    end
end

function [] = init()
    global veristandSheet;
    
    if isempty(veristandSheet)
        return
    end
    
end

function [results] = process(file, testNo)
    % Import the data
    data = importdata(file, ',');
    
    % Extract the relevent data
    results = {testNo, extractDate(file)};
    results = [results, extract('LFEAirmass', @averageTen, data)];
    results = [results, extract('AI2_34 Lambda 1', @averageTen, data)^-1];
    results = [results, extract('T2_15 Intake Plenum Below Throttle', @averageTen, data)];
    results = [results, extract('T2_16 EGT 1', @averageTen, data)];
    results = [results, extract('T2_17 EGT 2', @averageTen, data)];
    results = [results, extract('T2_18 EGT 3', @averageTen, data)];
    results = [results, extract('T2_19 EGT 4', @averageTen, data)];
    results = [results, extract('T2_20 EGT 5', @averageTen, data)];
    results = [results, extract('T2_21 EGT 6', @averageTen, data)];
    results = [results, extract('T1_00 Rt. Bank Turb. In', @averageTen, data)];
    results = [results, extract('T1_02 EGT Right Bank Turbine Out', @averageTen, data)];
    results = [results, extract('T2_00 Coolant In', @averageTen, data)];
    results = [results, extract('T2_01 Coolant Out', @averageTen, data)];
    results = [results, extract('T2_06 Oil Gallery', @averageTen, data)];
end