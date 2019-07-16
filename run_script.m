%% RUN THIS SCRIPT TO MAKE REGIONS AND OVL FILES

% OmarABanda April 2018
% University of Delaware
%% Adds relevant functions to path
% Works as long as folders have not been moved around
funcName = length(mfilename);
funcPath = mfilename('fullpath');
funcPath = funcPath(1:end-funcName);
cd(funcPath)
addpath(genpath([funcPath 'Dependencies']));
%% Dialogue options for all inputs
% Open images
[ListName,ListPath] = uigetfile('*.tif','Choose an image or stack to convert');
images = getImages([ListPath,ListName]);

% Choose save location and filenames. Currently set to adopt the folder
% name as the name of the files.
[TarPath] = uigetdir(ListPath,'Choose a folder to save regions to. The resulting files will inherit the folder name.');
parts = strsplit(TarPath, '\');
prefix = parts{end}; %Sets the output name prefix

%%
% Zen Application frame parameters for scaling images and regions
% pixelsize = input('What is the pixel size in microns?');
% finalRes(1,1) = input('What is the final X resolution in pixels (desired frame size in ZEN)?');
% finalRes(1,2) = input('What is the final Y resolution in pixels (desired frame size in ZEN)?');
% tic


finalRes(1,1) = input('In microns, how WIDE (X-dimension) would you like your image to be printed?');
finalRes(1,2) = input('In microns, how TALL (Y-dimension) would you like your image to be printed?');
tic

%% Run the options selection window

options = ROIGenOpt();

%% Iterative .Regions and .ovl outputs
if options(6,1) == 0
    for i = 1:size(images,3)
        outputName = [prefix '_' num2str(i)];
        a=images(:,:,i);
        b=a>0;
        options(8,1) = i;
        [poly1,poly2,poly3] = Mask2Regions(b,outputName,TarPath,finalRes,options);
    end
else
    i=1;
    outputName = [prefix '_' num2str(i)];
    a=images;
    b=a>0;
    options(8,1) = i;
    if options(9,1) == 0
        [poly1,poly2,poly3] = Mask2Regions(b,outputName,TarPath,finalRes,options);
    else
        [poly1,poly3] = Mask2RegionsAlt(b,outputName,TarPath,finalRes,options);
    end
end
disp('Done!')


