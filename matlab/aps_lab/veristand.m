% APS Lab Extract, Transform, Load (mototune.m)
%
% This file contains Veristand specific routines.

function [] = veristand(directory)
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if contents(ndx).isdir
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        testNo = extractBetween(contents(ndx).name, 1, strfind(contents(ndx).name, '.') - 1);   
        results = process(path, testNo);
    end
end

function [results] = process(file, testNo)
    data = importdata(file, ',');
    results = [];
    results = [results, testNo];
    results = [results, extract('LFEAirmass', @averageTen, data)];
    results = [results, extract('AI2_34 Lambda 1', @averageTen, data)];
    results = [results, extract('CNG_FlowAverageRT', @averageTen, data)];
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