nFrames = 5;
vidHeight = 288;    
vidWidth = 352;
% T = dctmtx(8);
mask = [9 9 9 9 9 1 1 1
        9 9 9 9 1 1 1 1
        9 9 9 1 1 1 1 1
        9 9 1 1 1 1 1 1
        9 1 1 1 1 1 1 1
        1 1 1 1 1 1 1 1
        1 1 1 1 1 1 1 1
        1 1 1 1 1 1 1 1];
% data_embed = [1 1 1 1 1 4 0 2
%               1 1 1 1 0 3 6 1
%               1 1 1 7 1 0 5 5
%               1 1 5 6 4 5 3 3
%               1 1 0 7 1 6 4 0
%               6 1 2 2 7 4 6 7
%               3 0 5 5 2 3 1 0
%               2 3 5 2 1 0 5 5];
data_embed = [1 1 1 1 1 6 7 7
              1 1 1 1 2 2 5 3
              1 1 1 0 6 2 3 7
              1 1 7 1 5 7 0 2
              1 2 2 0 3 5 1 5
              2 1 6 4 2 4 4 5
              5 3 5 4 1 6 5 0
              2 0 1 7 6 0 0 0];
b = 32720; 
b = int16(b);
Map = zeros(352);
del_rows = [1:(352-288)];
Map(del_rows,:) = [];
Map = blockproc(Map,[8 8],@(block_struct)(block_struct.data)+mask);
clearvars del_rows mask
Mask = Map;
Mask = blockproc(Mask,[8 8],@(block_struct) block_struct.data .* data_embed);

%T' refers to the complex conjugate transpose
dct = @(block_struct) dct2(block_struct.data);
invdct = @(block_struct) idct2(block_struct.data);
mov = LoadYUVtest('akiyo_cif.yuv',vidWidth,vidHeight,1:nFrames);
mov2 = LoadYUVtest('compress_save.yuv',vidWidth,vidHeight,1:nFrames);
mov_fin = cell(size(mov));
mov_fin2 = cell(size(mov));    
for f = 1 : 1 : nFrames
%    Have to pass Y,U and V separately since blockproc only accepts 2-D matrices
  mov_ref=mov{f};
  mov_mat = cell2mat(mov(f));
  mov_mat2 = cell2mat(mov2(f));
  C_1 = mov_mat2(:,:,1);
  B_1 = blockproc(mov_mat(:,:,1),[8 8],dct);
  B_2 = blockproc(mov_mat(:,:,2),[8 8],dct);
  B_3 = blockproc(mov_mat(:,:,3),[8 8],dct);
  B1 = int16(B_1);
%   B2 = int16(B_2);
%   B3 = int16(B_3);
  % .* operation denotes element wise multiplication
  for i = 1 : 1 : 288
      for j = 1 : 1 : 352
          if Mask(i,j)~= 9
              if B1(i,j)<0
                  a = abs(B1(i,j));
                  a = bitand(a,b);
                  a = bitor(a,Mask(i,j));
                  B1(i,j)= -a;
              else
                  a = B1(i,j);
                  a = bitand(a,b);
                  a = bitor(a,Mask(i,j));
                  B1(i,j)= a;
              end
          end
      end
  end
%   for i = 1 : 1 : 288
%       for j = 1 : 1 : 352
%           if Mask(i,j)~= 9
%               if B2(i,j)<0
%                   a = abs(B2(i,j));
%                   a = bitand(a,b);
%                   a = bitor(a,Mask(i,j));
%                   B2(i,j)= -a;
%               else
%                   a = B2(i,j);
%                   a = bitand(a,b);
%                   a = bitor(a,Mask(i,j));
%                   B2(i,j)= a;
%               end
%           end
%       end
%   end
%   for i = 1 : 1 : 288
%       for j = 1 : 1 : 352
%           if Mask(i,j)~= 9
%               if B3(i,j)<0
%                   a = abs(B3(i,j));
%                   a = bitand(a,b);
%                   a = bitor(a,Mask(i,j));
%                   B3(i,j)= -a;
%               else
%                   a = B3(i,j);
%                   a = bitand(a,b);
%                   a = bitor(a,Mask(i,j));
%                   B3(i,j)= a;
%               end
%           end
%       end
%   end
%   %Applying inverse DCT and recombining to check the compressed video
  B1 = double(B1);
%   B2 = double(B2);
%   B3 = double(B3);
  b1 = blockproc(B1,[8 8],invdct);
  b2 = blockproc(B_2,[8 8],invdct);
  b3 = blockproc(B_3,[8 8],invdct);
  comb_frame = cat(3,b1,b2,b3);
  mov_fin{f} = comb_frame;
%   peaksnr = psnr(B_1,B1);
  peaksnr = psnr(C_1,b1);
  fprintf('psnr for frame %d is %d\n',f,peaksnr);  
end
saveYUVtest(mov_fin,'test_embed_save.yuv','w');   
% % computing psnr values
% psnr=yuvpsnr('akiyo_cif.yuv','test_embed_save.yuv',352,288,'420','yuv');
% disp(sprintf('%f ''s results are: ',psnr)); 