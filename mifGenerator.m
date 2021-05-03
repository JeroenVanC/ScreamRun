close all;
clear all;
clc;

%read the image
I = imread('ScreamRun_Run.png');	
imshow(I);
[m,n] = size( I ); %size od your picture

N = m*n; %your ram or rom depth。
		
%Extract RED, GREEN and BLUE components from the image
R = I(:,:,1);			
G = I(:,:,2);
B = I(:,:,3);

%make the numbers to be of double format for 
R = double(R);	
G = double(G);
B = double(B);

%Raise each member of the component by appropriate value. 
R0 = R.^(4/8); % 8 bits -> 4 bits
G0 = G.^(4/8); % 8 bits -> 4 bits
B0 = B.^(4/8); % 8 bits -> 4 bits

%tranlate to integer
R1 = uint16(R0); % float -> uint8
G1 = uint16(G0);
B1 = uint16(B0);

%minus one cause sometimes conversion to integers rounds up the numbers wrongly
R2 = R1-1; % 3 bits -> max value is 111 (bin) -> 7 (dec)(hex)
G2 = G1-1;
B2 = B1-1; % 11 (bin) -> 3 (dec)(hex)

%shift bits and construct one Byte from 3 + 3 + 2 bits
G3 = bitshift(G2, 4); % 3 << G (shift by 3 bits)
B3 = bitshift(B2, 8); % 6 << B (shift by 6 bits)
COLOR = R2+G3+B3;      % R + 3 << G + 6 << B

%save variable COLOR to a file in HEX format for the chip to read
fid = fopen ('ScreamRun_Run.mif', 'w');

%fprintf (fileID, '%x', COLOR(size(COLOR(:), 1))); % COLOR (dec) -> print to file (hex)
    fprintf(fid, 'DEPTH=%d;\n', N);
    fprintf(fid, 'WIDTH=%d;\n', 12);

    fprintf(fid, 'ADDRESS_RADIX = HEX;\n'); 
    fprintf(fid, 'DATA_RADIX = HEX;\n'); 
    fprintf(fid, 'CONTENT\t');
    fprintf(fid, 'BEGIN\n');
    for i = 1:size(COLOR(:), 1)-1
        hex = dec2hex(i);
        fprintf(fid, '\t%s\t:\t%x;\n',hex, COLOR(i));
    end
    fprintf(fid, 'END;\n'); % prinf the end
%save variable COLOR to a file in HEX format for the chip to read
%fileID = fopen ('Mickey.list', 'w');
%fprintf (fileID, '%x\n', COLOR); % COLOR (dec) -> print to file (hex)
fclose (fid);

%translate to hex to see how many lines
COLOR_HEX = dec2hex(COLOR);
