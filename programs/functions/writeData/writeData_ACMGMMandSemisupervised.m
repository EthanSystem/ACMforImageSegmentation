function [Pros] = writeData_ACMGMMandSemisupervised(Pros, image_original, image_processed,L_phi, phi,  bwData, Pix, Px, Pxi, P_x_and_i, Pi, mu, Sigma)
%writeData_ACMandGMM_new_fixedTime 保存在程序运行过程中产生的数据，并不是每一代都保存，而是保存给定迭代周期的数据
%   input:
% Pros：结构体
% image_original：要处理的图像对应的原始图像。单张图像。
% image_processed：要处理的图像。单张图像。
% phi：嵌入函数。图像像素数×1
% bwData：二值图数据。单张图像的尺寸。
% Pix：后验概率。图像像素数×分类数
% Px：高斯概率密度。图像像素数×1
% Pxi：条件概率。图像像素数×分类数
% Pi：先验概率。1×分类数
% Pi_vis：被分摊到每个像素点上的先验概率。图像像素数×分类数
% mu：均值。维数×维数
% Sigma：协方差。维数×维数×分类数
% output:
% Pros：更新后的结构体

if  ( ( (strcmp(Pros.isWriteData,'yes')==1) && (Pros.iteration_outer==1 || Pros.iteration_outer==Pros.numIteration_outer || mod(Pros.iteration_outer,Pros.periodOfVisual)==0) ) ...
        || (strcmp(Pros.isWriteData,'yes')==0 && Pros.iteration_outer==Pros.numIteration_outer ) )
    i = Pros.index_exportData;
    [numRow,numCol,numVar]=deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
    numState = Pros.numOfComponents;
    
    % 	ExportData.name = Pros.filename_writeData;
    % 	ExportData.originalImage = image_original;
    % 	ExportData.processedImage = image_processed;
    % 	ExportData.Args = Pros.Args;
    % 	ExportData.data(i).iteration = Pros.iteration_outer;
    % 	ExportData.data(i).Pros = Pros;
    % 	ExportData.data(i).phi = reshape(phi,numRow,numCol);
    %     ExportData.data(i).bwData = reshape(bwData,numRow,numCol);
    %     ExportData.data(i).L_phi = reshape(L_phi,numRow,numCol);
    % 	ExportData.data(i).Pix = reshape(Pix,numRow,numCol,numState);
    % 	ExportData.data(i).Px = reshape(Px,numRow,numCol);
    % 	ExportData.data(i).Pxi = reshape(Pxi,numRow,numCol,numState);
    % 	ExportData.data(i).P_x_and_i = reshape(P_x_and_i,numRow,numCol,numState);
    % 	ExportData.data(i).Pi_vis = reshape(Pi_vis,numRow,numCol,numState);
    % 	ExportData.data(i).Pi = Pi;
    % 	ExportData.data(i).mu = mu;
    % 	ExportData.data(i).Sigma = Sigma;
    
    
    i=i+1;
    Pros.index_exportData = i;
    
    Pros.filename_writeData =  [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_ExportData.mat'];
    Pros.filepath_writeData = fullfile(Pros.folderpath_writeData, Pros.filename_writeData);
    save(Pros.filepath_writeData,'ExportData');
    if Pros.iteration_outer~=Pros.numIteration_outer && exist(Pros.filepath_writeData,'file')
        disp(['已保存数据 ' Pros.filename_writeData]);
    end
    if Pros.iteration_outer==Pros.numIteration_outer && exist(Pros.filepath_writeData,'file')
        disp(['已保存最终数据 ' Pros.filename_writeData]);
    end
end

end

