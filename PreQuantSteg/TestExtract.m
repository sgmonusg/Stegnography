nFrames = 1;
vidHeight = 288;    
vidWidth = 352;
T = dctmtx(8);

mask_bit = [9 9 9 9 9 1 1 1
        9 9 9 9 1 1 1 1
        9 9 9 1 1 1 1 1
        9 9 1 1 1 1 1 1
        9 1 1 1 1 1 1 1
        1 1 1 1 1 1 1 1
        1 1 1 1 1 1 1 1
        1 1 1 1 1 1 1 1];
b = 7;
b = int16(b);

Map = zeros(352);
del_rows = [1:(352-288)];
Map(del_rows,:) = [];
Map = blockproc(Map,[8 8],@(block_struct)(block_struct.data)+mask_bit);
clearvars del_rows mask_bit

% T' refers to the complex conjugate transpose
dct = @(block_struct) dct2(block_struct.data);
% invdct = @(block_struct) T' * block_struct.data * T;
mov = LoadYUVtest('test_embed_save.yuv',vidWidth,vidHeight,1:nFrames);
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
  B1 = int16(B_1);
  B2 = int16(B_2);
  B3 = int16(B_3);
  
  for i = 1 : 1 : 288
      for j = 1 : 1 : 352
          if Map(i,j)~= 9
              if B1(i,j)<0
                  a = abs(B1(i,j));
                  a = bitand(a,b);
                  B1(i,j)= a;
              else
                  a = B1(i,j);
                  a = bitand(a,b);
                  B1(i,j)= a;
              end
          end
      end
  end
%   comb_frame = cat(3,B_1,B_2,B_3);
%   mov_fin{f} = comb_frame;
end
   