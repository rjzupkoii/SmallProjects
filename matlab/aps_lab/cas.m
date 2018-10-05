% APS Lab Extract, Transform, Load (cas.m)
%
% This file contains CAS specific routines.

function [sheet] = cas(directory)
    sheet = [];

    % CAS files are in subdirectories organized by the test number
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if ~contents(ndx).isdir 
            continue
        end
        if any(strcmp(contents(ndx).name, {'.', '..'})) 
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        sheet = [sheet; process(path, contents(ndx).name)]; %#ok
    end
end

function [results] = process(directory, testNo)
    % Open the datasum.csv file to get the results from
    path = strcat(directory, '\', 'datasum.csv');
    data = readtable(path);
    
    % Extract the relevent results
    results = [];
    results = [results, str2double(testNo)];
    results = [results, extract('RPM', data)];  % RPM.Timer
    results = [results, extract('TorqueAverageRT', data)];
    results = [results, extract('CNG_FlowAverageRT', data)];
    results = [results, extract('Diesel_FlowAverageRT', data)];
    results = [results, extract('MAPAverageRT', data)];
    results = [results, extract('Cyl4IMEPRT', data)];
    results = [results, extract('Cyl5IMEPRT', data)];
    results = [results, extract('Cyl6IMEPRT', data)];
    results = [results, extract('Cyl4IMEPRT', data, 'COV')];
    results = [results, extract('Cyl5IMEPRT', data, 'COV')];
    results = [results, extract('Cyl6IMEPRT', data, 'COV')];
    results = [results, extract('Cyl4PeakRT', data)];
    results = [results, extract('Cyl5PeakRT', data)];
    results = [results, extract('Cyl6PeakRT', data)];
    results = [results, extract('Cyl4Peak LocRT', data)];
    results = [results, extract('Cyl5Peak LocRT', data)];
    results = [results, extract('Cyl6Peak LocRT', data)];
    results = [results, extract('Cyl4PMEPRT', data)];
    results = [results, extract('Cyl5PMEPRT', data)];
    results = [results, extract('Cyl6PMEPRT', data)];
end

function [result] = extract(parameter, table, column)
    % Default to the mean
    if ~exist('column', 'var')
        column = 'Mean';
    end

    ndx = find(not(cellfun('isempty', strfind(table.Parameter, parameter))));
    if isempty(ndx)
        disp(['WARNING: column ', parameter, ' not found']);
        result = -1;
    else        
        result = table.(column)(ndx);
    end
end