clear all;
close all;

folderpath_input = 'D:\EthanLin\CoreFiles\ProjectsFile\Study\PostGraduate\Projects\ImageSegementation\ACM+GMM\data\segmentations\�Ƚ�ͬһ����\ACMGMMnew\bw data\';
% folderpath_input = 'D:\EthanLin\CoreFiles\ProjectsFile\Study\PostGraduate\Projects\ImageSegementation\ACM+GMM\data\exportForPaper\�Ƚ�ͬһ����\bwͼͼ';

filename_input = '2_68_68825_contour_iter11_ACMGMMnew_bwData.mat';
filepath_input = fullfile(folderpath_input, filename_input);
load(filepath_input);
% imread(filepath_input);

inbwdata=(reshape(bwData,294,400));


folderpath_output = 'D:\EthanLin\CoreFiles\ProjectsFile\Study\PostGraduate\Projects\ImageSegementation\ACM+GMM\data\exportForPaper\�Ƚ�ͬһ����\bwͼͼ';
filename_output = '2_68_68825_contour_iter11_ACMGMMnew_bwImage.bmp';
filepath_output=fullfile(folderpath_output, filename_output);
imwrite(inbwdata, filepath_output);
