function output = Poly2XML(filnm4,polyVerts,polyStats)
%% For Generating Mat File
% czStart = 'czstart.txt';
% czRegion = 'czregion.txt';
% czEnd = 'czend.txt';
% 
% %% Open Template files
% %Document Start
% S=fopen(czStart);
% Stext = fread(S,'uint8');
% fclose(S);
% 
% %RegionItem Nodes (will need one for each region)
% R=fopen(czRegion);
% Rtext = fread(R,'uint8');
% fclose(R);
% 
% %Document Close
% E=fopen(czEnd);
% Etext = fread(E,'uint8');
% fclose(E);
% save('RegionParts.mat','Stext','Rtext','Etext')
%% Load the parts
load('RegionParts.mat')

%%
%Start new file
fid=fopen(filnm4,'w');

%Initialize XML
fwrite(fid,Stext(1:end,1),'uint8');
%Key Count Reset
KEYID = 100000000000;
%GraphicsProperties PolygonGraphics() Count Reset
GPPG = 58421199;
%GraphicsProperties Id Count Reset
GPID =10000;

%Write all regions
%Format of czregion.czexr 1-90; Height; 93-241; Index; 243-353; Width; 356-360; Xcenter; 362-366; Ycenter; 368-736; Vertices;757-881

for i = 1:size(polyVerts,1)
    fwrite(fid,Rtext(1:71,1),'uint8');
    fwrite(fid,num2str(GPPG),'uint8');
    GPPG = GPPG + 1;
    fwrite(fid,Rtext(80:90,1),'uint8');
    fwrite(fid,num2str(polyStats.Height(i)),'uint8');
    fwrite(fid,Rtext(93:241,1),'uint8');
    fwrite(fid,num2str(i),'uint8');
    fwrite(fid,Rtext(243:273,1),'uint8');
    fwrite(fid,num2str(KEYID),'uint8');
    KEYID = KEYID + 1;
    fwrite(fid,Rtext(286:353,1),'uint8');
    fwrite(fid,num2str(polyStats.Width(i)),'uint8');
    fwrite(fid,Rtext(356:360,1),'uint8');
    fwrite(fid,num2str(polyStats.Cen(i,1)),'uint8');
    fwrite(fid,Rtext(362:366,1),'uint8');
    fwrite(fid,num2str(polyStats.Cen(i,2)),'uint8');
    fwrite(fid,Rtext(368:400,1),'uint8');
    fwrite(fid,num2str(GPID),'uint8');
    GPID = GPID + 1;
    fwrite(fid,Rtext(404:736,1),'uint8');
    for j=1:size(polyVerts{i,1},1)
        fwrite(fid,num2str(polyVerts{i,1}(j,1)),'uint8');
        fwrite(fid,',','uint8');
        fwrite(fid,num2str(polyVerts{i,1}(j,2)),'uint8');
        fwrite(fid,32,'uint8');
    end
    fwrite(fid,num2str(polyVerts{i,1}(j,1)),'uint8');
    fwrite(fid,',','uint8');
    fwrite(fid,num2str(polyVerts{i,1}(j,2)),'uint8');
    fwrite(fid,Rtext(757:879,1),'uint8');
end

%End XML
fwrite(fid,Etext(1:end,1),'uint8');

%Save file
fclose(fid);