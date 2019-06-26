function [polygons2,polyFull,polygons] = Mask2Regions(raw,outputName,TarDir,finalRes,options)
%Converts a binary image into a .Regions file and a .ovl file to be read by
%the Zen application.


%Set variables based on input arguments
temp=size(raw);
ysize=temp(1);
xsize=temp(2);
% save('raw.mat','raw')
%%
if size(raw,3)>1
    for i = 1:size(raw,3)
        clear raw3
        raw3(:,:) = raw(:,:,i);
        %Make sure there are no features within 'EDGE' pixels of border
        EDGE = 1; %round(4000/(xsize*LSS));
        raw2 = zeros(size(raw3,1)+2*EDGE,size(raw3,2)+2*EDGE);
        raw2(2:end-1,2:end-1) = raw3;
        clear raw3
        raw3 = raw2;
        [polyFull,polygonsOld,polygons] = Mask2Polyv3(raw3(:,:),options);
        if i == 1
            poly2 = polygons;
        else
            poly2 = cat(1,poly2,polygons);
        end
        clear polygons
        polygons = poly2;
    end
else
    %Make sure there are no features within 'EDGE' pixels of border
    EDGE = 1; %round(4000/(xsize*LSS));
    raw2 = zeros(size(raw,1)+2*EDGE,size(raw,2)+2*EDGE);
    raw2(2:end-1,2:end-1) = raw;
    clear raw
    raw = raw2;
    [polyFull,polygonsOld,polygons] = Mask2Polyv3(raw(:,:),options);
end

if iscell(polygons) ==1
%% Dilate polygon vertices to the ZEN coordinate space
%Convert pixel coordinates into real coordinates in units of micrometers by
%scaling with pixlength
polygons2 = polygons;
for i = 1:size(polygons2,1)
    polygons2{i,1}(:,1) = (finalRes(1,1)/xsize).*polygons2{i,1}(:,1);
    polygons2{i,1}(:,2) = (finalRes(1,2)/ysize).*polygons2{i,1}(:,2);
end

%Convert into the coordinate system used by the microscope. Coordinate
%system is in units of meters, with the origin at the center of the field
%of view.

for i = 1:size(polygons2,1)
    polygons2{i,1}(:,1) = ((polygons2{i,1}(:,1)-(finalRes(1,1)/2))*(10^-6));
    polygons2{i,1}(:,2) = ((polygons2{i,1}(:,2)-(finalRes(1,2)/2))*(10^-6));
end
%% Option to convert single pixels to triangles or squares
if options(2,1) == 1
    %to triangles
    for i = 1:size(polygons2,1)
        if size(polygons2{i,1},1) == 1
            polygons2{i,1}(1,2) = polygons2{i,1}(1,2)+((.25*(10^-6))/2);
            polygons2{i,1}(2,1) = polygons2{i,1}(1,1)+((.25*(10^-6))/2);
            polygons2{i,1}(3,1) = polygons2{i,1}(1,1)-((.25*(10^-6))/2);
            polygons2{i,1}(2,2) = polygons2{i,1}(1,2)-((.25*(10^-6)));
            polygons2{i,1}(3,2) = polygons2{i,1}(1,2)-((.25*(10^-6)));
            
        end
    end
    %to squares
elseif options(5,1) == 1
    for i = 1:size(polygons2,1)
        if size(polygons2{i,1},1) == 1
            polygons2{i,1}(1,2) = polygons2{i,1}(1,2)+((.25*(10^-6))/2);
            polygons2{i,1}(2,1) = polygons2{i,1}(1,1)+((.25*(10^-6))/2);
            polygons2{i,1}(3,1) = polygons2{i,1}(1,1)-((.25*(10^-6))/2);
            polygons2{i,1}(2,2) = polygons2{i,1}(1,2)-((.25*(10^-6)));
            polygons2{i,1}(3,2) = polygons2{i,1}(1,2)-((.25*(10^-6)));
            polygons2{i,1}(1,1) = polygons2{i,1}(1,1)+((.25*(10^-6))/2);
            polygons2{i,1}(4,1) = polygons2{i,1}(1,1)-((.25*(10^-6)));
            polygons2{i,1}(4,2) = polygons2{i,1}(1,2);
            
        end
    end
end

%% Deal with single pixel lines (thin rectangles)
for i = 1:size(polygons2,1)
    if size(unique(polygons2{i,1}(:,1)),1)==1
        clear tempPoly
        tempPoly(1) = min(polygons2{i,1}(:,2));
        tempPoly(2) = max(polygons2{i,1}(:,2));
        tempPoly(3) = polygons2{i,1}(1,1);
        polygons2{i,1}(1,1) = tempPoly(3)+((.25*(10^-6))/2);
        polygons2{i,1}(2,1) = tempPoly(3)+((.25*(10^-6))/2);
        polygons2{i,1}(3,1) = tempPoly(3)-((.25*(10^-6))/2);
        polygons2{i,1}(4,1) = tempPoly(3)-((.25*(10^-6))/2);
        polygons2{i,1}(1,2) = tempPoly(1)-((.25*(10^-6))/2);
        polygons2{i,1}(2,2) = tempPoly(2)+((.25*(10^-6))/2);
        polygons2{i,1}(3,2) = tempPoly(2)+((.25*(10^-6))/2);
        polygons2{i,1}(4,2) = tempPoly(1)-((.25*(10^-6))/2);
    end
    if size(unique(polygons2{i,1}(:,2)),1)==1
                clear tempPoly
        tempPoly(1) = min(polygons2{i,1}(:,1));
        tempPoly(2) = max(polygons2{i,1}(:,1));
        tempPoly(3) = polygons2{i,1}(1,2);
        polygons2{i,1}(1,2) = tempPoly(3)+((.25*(10^-6))/2);
        polygons2{i,1}(2,2) = tempPoly(3)+((.25*(10^-6))/2);
        polygons2{i,1}(3,2) = tempPoly(3)-((.25*(10^-6))/2);
        polygons2{i,1}(4,2) = tempPoly(3)-((.25*(10^-6))/2);
        polygons2{i,1}(1,1) = tempPoly(1)-((.25*(10^-6))/2);
        polygons2{i,1}(2,1) = tempPoly(2)+((.25*(10^-6))/2);
        polygons2{i,1}(3,1) = tempPoly(2)+((.25*(10^-6))/2);
        polygons2{i,1}(4,1) = tempPoly(1)-((.25*(10^-6))/2);
    end
end


if (options(7,1) == 0) || (options(7,1) == 1 && mod(options(8,1),10)==1)
%% View all polylines as Raw Image Overlay
hFig = figure;
set(hFig, 'Position', [50 50 1200 600]);
subplot(1,2,1);
rawImage = max(raw,[],3);
imshow(rawImage);
hold on
for i = 1:size(polygons,1)
    try
        plot([polygons{i,1}(:,1);polygons{i,1}(1,1)],[polygons{i,1}(:,2);polygons{i,1}(1,2)])
        scatter([polygons{i,1}(:,1);polygons{i,1}(1,1)],[polygons{i,1}(:,2);polygons{i,1}(1,2)])
    end
end

%% View all polylines in Zen Frame of Reference
hFigS = subplot(1,2,2);
set(hFigS,'Position',[.55 .1 .4 .8]);
axis([-finalRes(1,1)/2, finalRes(1,1)/2, -finalRes(1,1)/2, finalRes(1,1)/2]);
xlabel('Microns')
ylabel('Microns')
hold on
for i = 1:size(polygons2,1)
    try
        plot([polygons2{i,1}(:,1);polygons2{i,1}(1,1)]/(10^-6),[polygons2{i,1}(:,2);polygons2{i,1}(1,2)]/(-1*10^-6))
        scatter([polygons2{i,1}(:,1);polygons2{i,1}(1,1)]/(10^-6),[polygons2{i,1}(:,2);polygons2{i,1}(1,2)]/(-1*10^-6))
    end
end
for i = 1:size(polygons2,1)
    xmin(i,1) = min(polygons2{i,1}(:,1));
    xmax(i,1) = max(polygons2{i,1}(:,1));
    ymin(i,1) = min(polygons2{i,1}(:,2));
    ymax(i,1) = max(polygons2{i,1}(:,2));
end
xMin = min(xmin);
xMax = max(xmax);
yMin = min(ymin);
yMax = max(ymax);
xwidth = (xMax-xMin) *10^6;
ywidth = (yMax-yMin) *10^6;

text(-finalRes(1,1)/2+5,-finalRes(1,2)/2+25,['Width: ',num2str(xwidth)])
text(-finalRes(1,1)/2+5,-finalRes(1,2)/2+10,['Height: ',num2str(ywidth)])
end
else
   polygons2{1,1}(1:4,1:2) = 0; 
end

%% Create the .Regions file for ZEN
%Define path and file name for .rls file
filnm2=strcat(TarDir,'\',outputName,'.Regions');
filnm3=strcat(TarDir,'\',outputName,'.ovl');
filnm4=strcat(TarDir,'\',outputName,'.czexr');

%Pass the coordinates for the vertices of each ROI to the subroutine
%Poly2Regions or Poly2Overlay which will write the information about the
%list of ROIs to a file written in a format that is readable by Zeiss AIM
%or Zen software
polygons4 = polygons2;
%% Update 05/2019. Adding support for newer Zen versions (Blue/Black combo)
for i = 1:size(polygons4,1)
    polygons4{i,1} = polygons4{i,1}*1000000;
    poly4.MaxX(i,1) = max(polygons4{i,1}(:,1));
    poly4.MinX(i,1) = min(polygons4{i,1}(:,1));
    poly4.Width(i,1) = poly4.MaxX(i,1)-poly4.MinX(i,1); 
    poly4.Cen(i,1) = poly4.MinX(i,1) + (poly4.Width(i,1)/2);
    
    poly4.MaxY(i,1) = max(polygons4{i,1}(:,2));
    poly4.MinY(i,1) = min(polygons4{i,1}(:,2));        
    poly4.Height(i,1) = poly4.MaxY(i,1)-poly4.MinY(i,1);
    poly4.Cen(i,2) = poly4.MinY(i,1) + (poly4.Height(i,1)/2);
    
    %Zero all vertices to (MinX,MinY), and normalize to Width/Height
    polygons4{i,1}(:,1) = (polygons4{i,1}(:,1) - poly4.MinX(i,1));             
    polygons4{i,1}(:,2) = (polygons4{i,1}(:,2) - poly4.MinY(i,1));                     
end
%% Update 05/2019. Testing support for newer Zen versions (Blue/Black combo)
%Draw regions to verify accuracy. Diagnostic.

% figure
% hold on
% for i = 1:size(polygons4,1)
%     plot((polygons4{i,1}(:,1)) + poly4.MinX(i,1) - poly4.Width(i,1)/2,(polygons4{i,1}(:,2))*-1-poly4.MinY(i,1)+ poly4.Height(i,1)/2)
% end

%%
Poly2Regions(filnm2,polygons2);
Poly2OVL(filnm3,polygons2);
Poly2XML(filnm4,polygons4,poly4); % Update 05/2019. Adding support for newer Zen versions (Blue/Black combo)

%%
disp(['Regions file #' num2str(options(8,1)) ' has ',num2str(size(polygons,1)),' Regions and took ' num2str(toc) ' seconds!'])
%End of program


end