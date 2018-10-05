% APS Lab Extract, Transform, Load (cas.m)
%
% This file contains Horiba specific routines.

function [sheet] = horiba(directory)
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
    % Import the data, adjust the columns as needed
    data = importdata(file, ',');
    temp = strsplit(strrep(char(data.textdata(2)), '"', ''), ',');
    data.colheaders = temp(3:end);
                
    results = [];
    results = [results, testNo];
    results = [results, extract('Lambda', @averageTen, data)];
    results = [results, extract('NO/NOx', @averageTen, data)];
    results = [results, extract('THC', @averageTen, data)];
    results = [results, extract('CO-L', @averageTen, data)];
    results = [results, extract('CO2', @averageTen, data)];
    results = [results, extract('O2', @averageTen, data)];
end