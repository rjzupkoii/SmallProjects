function [directoryNames] = getSubDirectories(directory)
    contents = dir(directory);
    directoryNames = {contents([contents.isdir]).name};
    directoryNames = setxor(directoryNames, {'.', '..'});
end