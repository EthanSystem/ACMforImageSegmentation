 load('D:\EthanLin\CoreFiles\ProjectsFile\Study\PostGraduate\Projects\ImageSegementation\ACM+GMM\test\mat01.mat');
 mat01(:,35)=[];
 mat02=mat01.';
 mat03=mat01+mat02;
 
 mat04=mapminmax(mat03,0,1);
