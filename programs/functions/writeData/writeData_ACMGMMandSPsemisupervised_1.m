function [Pros] = writeData_ACMGMMandSPsemisupervised_1(Pros, image_original, image_processed, ...
    F_sp, L_phi, phi,  bwData, Pix, Px, Pxi, P_x_and_i, Pi, mu, Sigma ...
    )
%writeData_ACMGMMandSPsemisupervised_1 �����ڳ������й����в��������ݣ�������ÿһ�������棬���Ǳ�������������ڵ�����
%   input:
% Pros���ṹ��
% image_original��Ҫ�����ͼ���Ӧ��ԭʼͼ�񡣵���ͼ��
% image_processed��Ҫ�����ͼ�񡣵���ͼ��
% phi��Ƕ�뺯����ͼ����������1
% bwData����ֵͼ���ݡ�����ͼ��ĳߴ硣
% Pix��������ʡ�ͼ����������������
% Px����˹�����ܶȡ�ͼ����������1
% Pxi���������ʡ�ͼ����������������
% Pi��������ʡ�1��������
% Pi_vis������̯��ÿ�����ص��ϵ�������ʡ�ͼ����������������
% mu����ֵ��ά����ά��
% Sigma��Э���ά����ά����������
% F_sp������������
% output:
% Pros�����º�Ľṹ��

if  ( ( (strcmp(Pros.isWriteData,'yes')==1) && (Pros.iteration_outer==1 || Pros.iteration_outer==Pros.numIteration_outer || mod(Pros.iteration_outer,Pros.periodOfVisual)==0) ) ...
        || (strcmp(Pros.isWriteData,'yes')==0 && Pros.iteration_outer==Pros.numIteration_outer ) )
    
    %     i = Pros.index_exportData;
    [numRow,numCol,numVar]=deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
    %     numState = Pros.numStates;
    
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
    
    % ���泬����������
    Pros.filename_SPforceData = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_SPforceData.mat'];
    Pros.filepath_SPforceData = fullfile(Pros.folderpath_writeData, Pros.filename_SPforceData);
    save(Pros.filepath_SPforceData,'F_sp')
    if ~exist(Pros.filepath_SPforceData,'file')
        disp(['δ���泬����������' Pros.filename_SPforceData]);
    end
    
    % ���泬������ͼ��
    Pros.filename_SPforceImage = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod  '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_SPforceImg.bmp'];
    Pros.filepath_SPforceImage = fullfile(Pros.folderpath_writeData, Pros.filename_SPforceImage);
    map=hot(256);
    imwrite(F_sp, map, Pros.filepath_SPforceImage);
    if ~exist(Pros.filepath_SPforceImage,'file')
        disp(['δ���泬������ͼ��' Pros.filename_SPforceImage]);
    end
    
    %     i=i+1;
    %     Pros.index_exportData = i;
    %     Pros.filename_writeData =  [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_ExportData.mat'];
    %     Pros.filepath_writeData = fullfile(Pros.folderpath_writeData, Pros.filename_writeData);
    
    %     save(Pros.filepath_writeData,'ExportData');
    %     if Pros.iteration_outer~=Pros.numIteration_outer && exist(Pros.filepath_writeData,'file')
    %         disp(['�ѱ������� ' Pros.filename_writeData]);
    %     end
    %     if Pros.iteration_outer==Pros.numIteration_outer && exist(Pros.filepath_writeData,'file')
    %         disp(['�ѱ����������� ' Pros.filename_writeData]);
    %     end
    % end
    
end

