A = [3
11
10
1
0
12
5
6
3
14
11
14
10
8
10
5
6
2
3
10
12
9
10
0
15
];
A = int8(A);
A
clc
A = dec2bin(A,4);
A
A = int8(A);
A
A - 48
pre_error = gf(A);
pre_error = gf(ans);
pre_error
post_corr = bchenc(pre_error,7,4);
post_corr
post_reshape = reshape(post_corr,[],3);
post_reshape
% red_arr = post_reshape([63-49],:) = [];
% red_arr = post_reshape((50,51,52,53,54,55,56,57,58,59,60,61,62,63),:) = [];
% red_arr = post_reshape([50,51,52,53,54,55,56,57,58,59,60,61,62,63],:) = [];
red_arr = post_reshape(1:49,:);
red_arr = (int8)red_arr
embed_data = bi2de(red_arr);
num_arr = zeroes(49);
num_arr = zeros(49);
num_arr = int8(num_arr);
num_arr = num_arr(:,1:3);
GF2Bin
num_arr
red_arr
clc
embed_data = bi2de(num_arr);
embed_data