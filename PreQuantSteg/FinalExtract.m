mask = [0 0 0 0 0 1 1 1
0 0 0 0 1 1 1 1
0 0 0 1 1 1 1 1
0 0 1 1 1 1 1 1
0 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1];
add_mask = [9 9 9 9 9 0 0 0
            9 9 9 9 0 0 0 0
            9 9 9 0 0 0 0 0
            9 9 0 0 0 0 0 0
            9 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0];
mask = int16(mask);
add_mask = int16(add_mask);
clearvars B2 B3 B_1 B_2 B_3 Map T a b dct f i j mov mov_fin mov_mat nFrames vidHeight vidWidth
%Need to read individual block elements. 
B1 = blockproc(B1,[8 8],@(block_struct) (block_struct.data) .* mask);
B1 = blockproc(B1,[8 8],@(block_struct) (block_struct.data) + add_mask);
blockproc(B1,[8 8],@(block_struct) funcextract(block_struct.data));
% A = transpose(A);