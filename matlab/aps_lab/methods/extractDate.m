function [result] = extractDate(directory) 
    start = regexpi(directory, '\d{4}\.\d{2}\.\d{2}');
    date = extractBetween(directory, start, start + 9);
    result = date{1};
end