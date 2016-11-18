function [] = funcextract(input)

fileID = fopen('final_stegdata.dat','a+');
for a = 1:1:8
    for b = 1:1:8
        if input(a,b) ~= 9
            fprintf(fileID,'%2d,',input(a,b));
        end
    end
end
fclose(fileID);
end