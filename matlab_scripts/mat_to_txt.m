function mat_to_txt(filepath)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    close all
    struct = load(filepath);
    [pathstr name ext] = fileparts(filepath);
    destination = strcat(fullfile(pathstr, name), '.txt');
    
    dlmwrite(destination, struct.feat, '\t')
end

