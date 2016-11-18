% This code should extract just the YUV planes/RGB equivalent matrix on
% which 2D-DCT can be applied. The complete previous code extracts this and
% then proceeds to convert the values into an equivalent RGB form so as to
% make it easy to store the frame as an image

% function mov = loadYUVtest(fileName, width, height, idxFrame)

function [mov,imgYuv] = LoadYUVtest(fileName, width, height, idxFrame)
% load RGB movie [0, 255] from YUV 4:2:0 file

fileId = fopen(fileName, 'r');

subSampleMat = [1, 1; 1, 1];
nrFrame = length(idxFrame);

for f = 1 : 1 : nrFrame
    % search fileId position
    sizeFrame = 1.5 * width * height;
    fseek(fileId, (idxFrame(f) - 1) * sizeFrame, 'bof');
    
    % read Y component
    buf = fread(fileId, width * height, 'uchar');
    imgYuv(:, :, 1) = reshape(buf, width, height).'; % reshape
    
    % read U component
    buf = fread(fileId, width / 2 * height / 2, 'uchar');
    imgYuv(:, :, 2) = kron(reshape(buf, width / 2, height / 2).', subSampleMat); % reshape and upsample
    
    % read V component
    buf = fread(fileId, width / 2 * height / 2, 'uchar');
    imgYuv(:, :, 3) = kron(reshape(buf, width / 2, height / 2).', subSampleMat); % reshape and upsample
    
    mov{f} = imgYuv;
    
end
fclose(fileId);