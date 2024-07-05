
% split multipage tiff into each image
% and save both image and matrix files
filename = input('file name \n','s')
nofiles = input('number of images \n')
outputname = input('file name \n','s')
t = Tiff(filename,'r');
for k = 1:nofiles
    subimages(:,:,k) = t.read();
    
    fileNO = sprintf('%03i', k);
    imgname = [outputname fileNO '.tif']
    %matname = [outputname 'mat' fileNO '.txt']
    imwrite(subimages(:,:,k),imgname)
    %A = double(subimages(:,:,k)); % convert from integer to double precision
    %dlmwrite(matname,A,'delimiter','\t','precision',16)
    %clear('A')
    if t.lastDirectory()
        disp('end of directory')
    else
        t.nextDirectory();
    end
end

% if you want to create an image from a matrix A of float/double values
% first convert it to 16-bit integer matrix, then use IMWRITE
% B = cast(A,'uint16');
% imwrite(B,'myImage.tif')