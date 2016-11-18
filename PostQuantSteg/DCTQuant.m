nFrames = 5;
vidHeight = 288;    
vidWidth = 352;
T = dctmtx(8);
mask = [1 1 1 1 1 1 0 0
        1 1 1 1 1 0 0 0
        1 1 1 1 0 0 0 0
        1 1 1 0 0 0 0 0
        1 1 0 0 0 0 0 0
        1 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0];
;
% T' refers to the complex conjugate transpose
dct = @(block_struct) T * block_struct.data * T';
invdct = @(block_struct) T' * block_struct.data * T;
mov = LoadYUVtest('akiyo_cif.yuv',vidWidth,vidHeight,1:nFrames);
mov_fin = cell(size(mov));
for f = 1 : 1 : nFrames
  %Have to pass Y,U and V separately since blockproc only accepts 2-D
  %matrices
  mov_mat = cell2mat(mov(f));
  B_1 = blockproc(mov_mat(:,:,1),[8 8],dct);
  B_2 = blockproc(mov_mat(:,:,2),[8 8],dct);
  B_3 = blockproc(mov_mat(:,:,3),[8 8],dct);
  % .* operation denotes element wise multiplication
  %Masking the DCT values
  B1 = blockproc(B_1,[8 8],@(block_struct) mask .* block_struct.data);
  B2 = blockproc(B_2,[8 8],@(block_struct) mask .* block_struct.data);
  B3 = blockproc(B_3,[8 8],@(block_struct) mask .* block_struct.data);
  %Applying inverse DCT and recombining to check the compressed video
  b1 = blockproc(B1,[8 8],invdct);
  b2 = blockproc(B2,[8 8],invdct);
  b3 = blockproc(B3,[8 8],invdct);
  comb_frame = cat(3,b1,b2,b3);
  mov_fin{f} = comb_frame;
end
saveYUVtest(mov_fin,'compress_save.yuv','w');   