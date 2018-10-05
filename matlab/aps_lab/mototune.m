% APS Lab Extract, Transform, Load (mototune.m)
%
% This file contains Mototune specific routines.

function [] = mototune(directory)
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if contents(ndx).isdir
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        process(path);
    end
end

function [] = process(file)
    disp(file)
end