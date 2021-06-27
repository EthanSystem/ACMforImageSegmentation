function []=evaluationCalculate_func(Args, mode)
%% ���
% evaluationCalculate.m ʵ�ּ�������ָ�ꡣ

%% Ԥ����
close all;
clc;
diary off;

%
% %% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args.folderpath_resourcesBaseFolder = '.\candidate\resources'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
% Args.folderpath_initBaseFolder ='.\candidate\resources'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
% Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
% Args.beta = 1; % the F_1 ָ���� F-beta ָ���� beta =1 ʱ��������
% Args.num_scribble=1; % ���д������ͼ��ı������������Ŀǰ��ʱ�����ǲ�ͬ��ǶԷָ�Ч����Ӱ�죬��������һ��ͼ��һ�ֱ�ǣ����Ŀǰ�ֶ�����Ϊ1��
% Args.numUselessFiles = 0; % Ҫ�����ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ����ᱻ���������Ҫ�ֶ��ų�
% Args.mode = '3' ; % ��'1' ��ʾ����תͼ��'2' ��ʾ���ݼ���ָ��ͬʱ�ж��Ƿ�תͼ��'3' ��ʾ���� ��׼��P ָ���ж��Ƿ�תͼ��
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%
%

%% properties

Pros = Args;
Pros.mode = mode;

disp(Pros.mode)


%% �����ļ��е���Դresources �ṹ��EachImage ����results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
EachImage = createEachImageStructure(Pros.folderpath_resourcesBaseFolder, Pros.folderpath_initBaseFolder, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);

% input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ����������������� Ctrl+c ��ֹ����')

% useless...
% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');
%


%% ��������ֵ
%% ��������ʵ���ļ�������ָ���������

Pros.num_image = EachImage.num_groundTruthBwImage ;
jaccardIndex=1./zeros(Pros.num_image,Pros.num_scribble);
jaccardDistance=1./zeros(Pros.num_image,Pros.num_scribble);
modifiedHausdorffDistance=1./zeros(Pros.num_image, Pros.num_scribble);
Precision=1./zeros(Pros.num_image, Pros.num_scribble);
Recall=1./zeros(Pros.num_image, Pros.num_scribble);
F1=1./zeros(Pros.num_image, Pros.num_scribble);
ME=1./zeros(Pros.num_image, Pros.num_scribble);
inverseBwImage = zeros(Pros.num_image, Pros.num_scribble);  % ���ͼ���Ƿ�ת��0��������ת����1���޷�ת��-1���з�ת��
tic;

for index_experiment = 1:Results.num_experiments
    
    % ����diary����ļ���
    Pros.foldername_diary = 'diary output';
    Pros.folderpath_diary = fullfile(Results.experiments(index_experiment).folderpath, Pros.foldername_diary);
    if ~exist(Pros.folderpath_diary,'dir')
        mkdir(Pros.folderpath_diary );
    end
    Pros.filepath_diary = fullfile(Pros.folderpath_diary , ['diary evaluation calculate.txt']);
    diary(Pros.filepath_diary);
    diary on;
    
    
    %% ����ָ��ļ���
    switch Pros.mode
        case '1' % ����ָ�꣨����תͼ��
            for index_image = 1:Pros.num_image
                for index_scribble=1:Pros.num_scribble
                    
                    disp(['experiment ' num2str(index_experiment) '    image ' num2str(index_image) '    scribble ' num2str(index_scribble)]);
                    
                    filepath_groundTruthImages = EachImage.groundTruthBwImage(index_image).path;
                    filename_bwData = Results.experiments(index_experiment).bwImages(index_image).name;
                    filepath_bwData = Results.experiments(index_experiment).bwImages(index_image).path;
                    gtImage = imread(filepath_groundTruthImages);
                    bwData_1=imread(filepath_bwData);
                    
                    % jaccardDistance
                    [jaccardIndex_temp_1, jaccardDistance_temp_1] = Jacard_evaluation(gtImage, bwData_1);
                    jaccardIndex(index_image)=jaccardIndex_temp_1;
                    jaccardDistance(index_image)=jaccardDistance_temp_1;
                    
                    % Modified Hausdorff distance
                    [modifiedHausdorffDistance_temp_1] = ModHausdorffDist(gtImage, bwData_1);
                    modifiedHausdorffDistance(index_image)=modifiedHausdorffDistance_temp_1;
                    
                    % P-R
                    [Precision_temp_1, Recall_temp_1, F1_temp_1,ME_temp_1]=PR_evaluation(gtImage,bwData_1,Pros.beta);
                    Precision(index_image, index_scribble)=Precision_temp_1;
                    Recall(index_image, index_scribble)=Recall_temp_1;
                    F1(index_image)=F1_temp_1;
                    ME(index_image)=ME_temp_1;
                    
                    % macro-F1
                    [macroPrecision, macroRecall, macroF1]=macroPR_evaluation(Precision,Recall,F1);
                    
                end % end scribble loop
            end % end image loop
            
            
            
        case '2'     % ���ݼ���ָ��ͬʱ�ж��Ƿ�תͼ��
            
            for index_image = 1:Pros.num_image
                for index_scribble=1:Pros.num_scribble
                    disp(['experiment ' num2str(index_experiment) '    image ' num2str(index_image) '    scribble ' num2str(index_scribble)]);
                    
                    filepath_groundTruthImages = EachImage.groundTruthBwImage(index_image).path;
                    filename_bwData = Results.experiments(index_experiment).bwImages(index_image).name;
                    filepath_bwData = Results.experiments(index_experiment).bwImages(index_image).path;
                    gtImage = imread(filepath_groundTruthImages);
                    bwData_1=imread(filepath_bwData);
                    bwData_2=~bwData_1;
                    
                    % ����ָ�꣨�ᷴתͼ��
                    inverseBwImage(index_image,index_scribble)=1;
                    
                    % ��Ϊ�޼ල�ָ���ָܷ������ǰ���ͱ������෴�ģ�������Ҫ�ж��Ƿ���������������������ת�����ҳ�������õ�ͼ�񣬲��Ҹ���ԭ�����ļ���
                    % jaccardDistance
                    [jaccardIndex_temp_1, jaccardDistance_temp_1] = Jacard_evaluation(gtImage, bwData_1);
                    [jaccardIndex_temp_2, jaccardDistance_temp_2] = Jacard_evaluation(gtImage, bwData_2);
                    
                    if jaccardDistance_temp_1<=jaccardDistance_temp_2
                        jaccardDistance(index_image)=jaccardDistance_temp_1;
                        jaccardIndex(index_image)=jaccardIndex_temp_1;
                    else
                        jaccardDistance(index_image)=jaccardDistance_temp_2;
                        jaccardIndex(index_image)=jaccardIndex_temp_2;
                        imwrite(bwData_2, filepath_bwData);
                        inverseBwImage(index_image,index_scribble)=-1;
                        disp(['�Ѿ��� jaccard ��� ָ��ļ����ж� ' filename_bwData ' ���з�ת����'])
                    end
                    
                    % Modified Hausdorff distance
                    [modifiedHausdorffDistance_temp_1] = ModHausdorffDist(gtImage, bwData_1);
                    [modifiedHausdorffDistance_temp_2] = ModHausdorffDist(gtImage, bwData_2);
                    if modifiedHausdorffDistance_temp_1<=modifiedHausdorffDistance_temp_2
                        modifiedHausdorffDistance(index_image)=modifiedHausdorffDistance_temp_1;
                    else
                        modifiedHausdorffDistance(index_image)=modifiedHausdorffDistance_temp_2;
                        imwrite(bwData_2, filepath_bwData);
                        inverseBwImage(index_image,index_scribble)=-1;
                        disp(['�Ѿ��� Modified Hausdorff distance ָ��ļ����ж� ' filename_bwData ' ���з�ת����'])
                        
                    end
                    
                    % P-R
                    [Precision_temp_1, Recall_temp_1, F1_temp_1, ME_temp_1]=PR_evaluation(gtImage,bwData_1,Pros.beta);
                    [Precision_temp_2, Recall_temp_2, F1_temp_2, ME_temp_2]=PR_evaluation(gtImage,bwData_2,Pros.beta);
                    % ��Ϊ�޼ල�ָ���ָܷ������ǰ���ͱ������෴�ģ����ҿ��ܻ�����ڻ��������г���F1ָ��ʽ�ӵķ�ĸ��0����������NaN�������������Ҫ�ж��Ƿ���������������������ת�����ҳ�������õ�ͼ��
                    
                    % calculate F1
                    if (isnan(F1_temp_1)==0 && isnan(F1_temp_2)==0)
                        if F1_temp_1>=F1_temp_2
                            Precision(index_image, index_scribble)=Precision_temp_1;
                            Recall(index_image, index_scribble)=Recall_temp_1;
                            F1(index_image)=F1_temp_1;
                            ME(index_image)=ME_temp_1;
                        else
                            Precision(index_image, index_scribble)=Precision_temp_2;
                            Recall(index_image, index_scribble)=Recall_temp_2;
                            F1(index_image)=F1_temp_2;
                            ME(index_image)=ME_temp_2;
                            imwrite(bwData_2, filepath_bwData);
                            inverseBwImage(index_image,index_scribble)=-1;
                            disp(['�Ѿ��� F1 ָ��ļ����ж� ' filename_bwData ' ���з�ת����'])
                        end
                    else
                        if (isnan(F1_temp_1)==1 && isnan(F1_temp_2)==0)
                            F1(index_image)=F1_temp_2;
                        else
                            F1(index_image)=F1_temp_1;
                        end
                    end
                    
                    % macro-F1
                    [macroPrecision, macroRecall, macroF1]=macroPR_evaluation(Precision,Recall,F1);
                    
                end % end scribble loop
            end % end image loop
            
            
            
        case '3'  % ���� ��׼�� ָ���ж��Ƿ�תͼ��
            for index_image = 1:Pros.num_image
                for index_scribble=1:Pros.num_scribble
                    disp(['experiment ' num2str(index_experiment) '    image ' num2str(index_image) '    scribble ' num2str(index_scribble)]);
                    
                    filepath_groundTruthImages = EachImage.groundTruthBwImage(index_image).path;
                    filename_bwData = Results.experiments(index_experiment).bwImages(index_image).name;
                    filepath_bwData = Results.experiments(index_experiment).bwImages(index_image).path;
                    gtImage = imread(filepath_groundTruthImages);
                    bwData_1=imread(filepath_bwData);
                    bwData_2=~bwData_1;
                    % ����ָ�꣨�ᷴתͼ��
                    inverseBwImage(index_image,index_scribble)=1;
                    
                    % P-R
                    [Precision_temp_1, Recall_temp_1, F1_temp_1, ME_temp_1]=PR_evaluation(gtImage,bwData_1,Pros.beta);
                    [Precision_temp_2, Recall_temp_2, F1_temp_2, ME_temp_2]=PR_evaluation(gtImage,bwData_2,Pros.beta);
                    
                    if Precision_temp_1<Precision_temp_2
                        bwData_1=bwData_2;
                        imwrite(bwData_1, filepath_bwData);
                        inverseBwImage(index_image,index_scribble)=-1;
                        disp(['�Ѿ��� ' filename_bwData ' ���з�ת����'])
                    end
                    
                    % jaccardDistance
                    [jaccardIndex_temp_1, jaccardDistance_temp_1] = Jacard_evaluation(gtImage, bwData_1);
                    jaccardIndex(index_image)=jaccardIndex_temp_1;
                    jaccardDistance(index_image)=jaccardDistance_temp_1;
                    
                    % Modified Hausdorff distance
                    [modifiedHausdorffDistance_temp_1] = ModHausdorffDist(gtImage, bwData_1);
                    modifiedHausdorffDistance(index_image)=modifiedHausdorffDistance_temp_1;
                    
                    % P-R
                    [Precision_temp_1, Recall_temp_1, F1_temp_1,ME_temp_1]=PR_evaluation(gtImage,bwData_1,Pros.beta);
                    Precision(index_image, index_scribble)=Precision_temp_1;
                    Recall(index_image, index_scribble)=Recall_temp_1;
                    F1(index_image)=F1_temp_1;
                    ME(index_image)=ME_temp_1;
                    
                    % macro-F1
                    [macroPrecision, macroRecall, macroF1]=macroPR_evaluation(Precision,Recall,F1);
                    
                end % end scribble loop
            end % end image loop
            
            
    end % end switch
    
    
    
    %% calculate mean
    mean_jaccardIdnex = mean(jaccardIndex)
    mean_jaccardDistance = mean(jaccardDistance)
    mean_modifiedHausdorffDistance=mean(modifiedHausdorffDistance)
    mean_F1=mean(F1)
    mean_precision=mean(Precision)
    mean_recall=mean(Recall)
    mean_ME=mean(ME)
    
    %% calculate variance
    var_jaccardIdnex = var(jaccardIndex)
    var_jaccardDistance = var(jaccardDistance)
    var_modifiedHausdorffDistance=var(modifiedHausdorffDistance)
    var_F1=var(F1)
    var_precision = var(Precision)
    var_recall=var(Recall)
    var_ME=var(ME)
    
    %% calculate maximum
    max_jaccardIdnex = max(jaccardIndex)
    max_jaccardDistance = max(jaccardDistance)
    max_modifiedHausdorffDistance=max(modifiedHausdorffDistance)
    max_F1=max(F1)
    max_precision = max(Precision)
    max_recall=max(Recall)
    max_ME=max(ME)
    
    %% calculate mininum
    min_jaccardIdnex = min(jaccardIndex)
    min_jaccardDistance = min(jaccardDistance)
    min_modifiedHausdorffDistance=min(modifiedHausdorffDistance)
    min_F1=min(F1)
    min_precision = min(Precision)
    min_recall=min(Recall)
    min_ME=min(ME)
    
    %% calculate median
    median_jaccardIdnex = median(jaccardIndex)
    median_jaccardDistance = median(jaccardDistance)
    median_modifiedHausdorffDistance=median(modifiedHausdorffDistance)
    median_F1=median(F1)
    median_precision = median(Precision)
    median_recall=median(Recall)
    median_ME=median(ME)
    
    %% ��������
    Pros.folderpath_evaluationsData = Results.experiments(index_experiment).folderpath_evaluationData;
    save(fullfile(Pros.folderpath_evaluationsData, 'jaccardIndex.mat'), 'jaccardIndex');
    save(fullfile(Pros.folderpath_evaluationsData, 'jaccardDistance.mat'), 'jaccardDistance');
    save(fullfile(Pros.folderpath_evaluationsData, 'modifiedHausdorffDistance.mat'), 'modifiedHausdorffDistance');
    save(fullfile(Pros.folderpath_evaluationsData, 'F1.mat'), 'F1');
    save(fullfile(Pros.folderpath_evaluationsData, 'Precision.mat'), 'Precision');
    save(fullfile(Pros.folderpath_evaluationsData, 'Recall.mat'), 'Recall');
    save(fullfile(Pros.folderpath_evaluationsData, 'macroF1.mat'), 'macroF1');
    save(fullfile(Pros.folderpath_evaluationsData, 'ME.mat'), 'ME');
    save(fullfile(Pros.folderpath_evaluationsData, 'inverseBwImage.mat'), 'inverseBwImage');
    
    %% �ر���־��¼
    diary off;
    
end % end experiment loop



end










