% APS Lab Extract, Transform, Load (cas.m)
%
% This file contains Horiba specific routines.

function [] = horiba(directory)
    global horibaSheet;
    
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if contents(ndx).isdir
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        testNo = extractBetween(contents(ndx).name, 1, strfind(contents(ndx).name, '.') - 1); 
        data = process(path, testNo{1});
        horibaSheet = {horibaSheet; [size(horibaSheet, 1) + 1, data]}; %#ok
    end
end

function [results] = process(file, testNo)

    % Import the data, adjust the columns as needed
    data = importdata(file, ',');
    temp = strsplit(strrep(char(data.textdata(2)), '"', ''), ',');
    data.colheaders = temp(3:end);
    
    % Extract the relevent data
    results = {testNo, extractDate(file)};
    results = [results, extractLambda(data)];
    results = [results, extract('NO/NOx', @averageTen, data)];
    results = [results, extract('THC', @averageTen, data)];
    results = [results, extract('CO-L', @averageTen, data)];
    results = [results, extract('CO2', @averageTen, data)/10000];
    results = [results, extract('O2', @averageTen, data)/10000];
end

function [result] = extractLambda(data)
    % Scan for the column name, but be sure to shift it by one for Horiba
    for ndx = 1 : length(data.colheaders)
        if strcmp('Lambda', data.colheaders(ndx))           
            result = averageTen(ndx + 1, data) ^ -1;
            return
        end
    end
    
    % Note a warning
    disp('WARNING: column Lambda not found');
    result = -1;
end