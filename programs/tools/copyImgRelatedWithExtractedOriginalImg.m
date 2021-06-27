function []=copyImgRelatedWithExtractedOriginalImg(Args, mode)
%% ���
% ��ȡָ���ļ��е�������ԭͼ��ص�ͼ����ص���ֵͼ���������ָ�����Ķ�ֵͼ����ͬһ���ļ���������һ��ɸѡ��

%% ���
% copyImgRelatedWithExtractedOriginalImg.m ʵ����ȡ����������ͼ���Լ���ֵͼ��ָ���ļ����Ա����˹�ɸѡ
% ģʽ1 ��ȡ��Ӧͼ������ݣ�������Ϊ��һ��ͼ������ʹ�ͼ���ӻ��Ű��ͼ�񼯺ϡ�
% ģʽ2 ��ȡ��Ӧͼ������ݣ�������Ϊ��һ�����µĳ�ʼ���������зָ�ͷ�����ͼ�񼯺ϡ�

%% Ԥ����
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '2' ;
Args.isVisual = 'no' ;  % ���ƹ��̲����ӻ���������������в鿴����� 'yes'��ʾ���ƹ����п��ӻ� ��'no'��ʾ���ƹ����в����ӻ���Ĭ��'no'
Args.numUselessFiles = 0; % Ҫ�ų���ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���

switch Args.mode
    case '1'    % ģʽ1 ��ȡ��Ӧͼ������ݣ�������Ϊ��һ��ͼ������ʹ�ͼ���ӻ��Ű��ͼ�񼯺ϡ�
        Args.folderpath_originalResourcesBaseFolder = '.\data\resources\MSRA1K\original resources' ; % ������ȡ�ļ��������ԭʼ��Դ original resources �Ļ���·�������磬MSRA1K���ݿ��1000��ͼ���ڵ�·������
        Args.folderpath_initResourcesBaseFolder='.\data\resources\MSRA1K\init resources'; % ������ȡ�ļ��ĵ�����ĳ�ʼ���ļ� init resources �Ļ���·��
        Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\evaluation\expr2' ; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
        Args.folderpath_experiment = '.\data\expr_1000images\extract\��ҵ����\expr2\��ҵ�����������ͼƬ' ; % ����ȡ���ļ���ԭʼͼ������·����
        Args.folderpath_output = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_��ҵ�����������ͼƬ' ; % ����� evaluation ͼ���·��
        
        
    case '2'    % ģʽ2 ��ȡ��Ӧͼ������ݣ�������Ϊ��һ�����µĳ�ʼ���������зָ�ͷ�����ͼ�񼯺ϡ�
        Args.folderpath_originalResourcesBaseFolder = '.\data\resources\MSRA1K\original resources' ; % ������ȡ�ļ��������ԭʼ��Դ original resources �Ļ���·�������磬MSRA1K���ݿ��1000��ͼ���ڵ�·������
        Args.folderpath_initResourcesBaseFolder='.\data\resources\MSRA1K\init resources'; % ������ȡ�ļ��ĵ�����ĳ�ʼ���ļ� init resources �Ļ���·��
        Args.folderpath_experiment = '.\data\expr_1000images\extract\��ҵ����\expr3\��ҵ���ĳ����ؿ��ӻ�������' ; % ����� original resources ͼ���·��
        Args.folderpath_output = '.\data\expr3_seg\��ҵ���ĳ����ؿ��ӻ�������' ; % ����� init resources ͼ���·��
        
    otherwise
        error('error at choose mode !');
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% properties
Pros = Args;


%% �����ļ��е���Դresources �ṹ��EachImage������results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
switch Pros.mode
    case '1'    % ģʽ1 ��ȡ��Ӧͼ������ݣ�������Ϊ��һ��ͼ������ʹ�ͼ���ӻ��Ű��ͼ�񼯺ϡ�
        EachImage_ref = createEachImageStructure(Pros.folderpath_originalResourcesBaseFolder , Pros.folderpath_initResourcesBaseFolder, Pros.numUselessFiles);
        Results_ref = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);
    case '2'    % ģʽ2 ��ȡ��Ӧͼ������ݣ�������Ϊ��һ�����µĳ�ʼ���������зָ�ͷ�����ͼ�񼯺ϡ�
        EachImage_ref = createEachImageStructure(Pros.folderpath_originalResourcesBaseFolder , Pros.folderpath_initResourcesBaseFolder, Pros.numUselessFiles);
        %         Results_ref = createResultsStructure(Pros.folderpath_output ,Pros.numUselessFiles);
    otherwise
        error('error at choose mode !');
end

%% ����ʵ���飺
Args.experiment = input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ�Ļ���Enter������������ Ctrl+c ��ֹ����')

%% properties
Pros.num_scribble =1; % ��ǵ�������Ŀǰ�����ǲ�ͬ�ı�Ƕ�ʵ������Ӱ�죬�������Ϊ1��

% Ҫ�����ͼ��������
Pros.num_image = EachImage_ref.num_groundTruthBwImage;
if (1==strcmp(Args.mode,'1'))
    Pros.num_experiments = Results_ref.num_experiments;
end


%% collect �ռ���Ҫ��ͼ�񣬲��������ļ����Է����û�ɸѡ������Щͼ���Ƶ�ָ�����ļ���
% if ~exist(folderpath_output_originalResources,'dir')
%     mkdir(folderpath_output_originalResources);
% end
%
% if ~exist(Pros.folderpath_output_initResources,'dir')
%     mkdir(Pros.folderpath_output_initResources);
% end


switch Pros.mode
    case '1'
        %% ģʽ1 ��ȡ��Ӧͼ������ݣ�������Ϊ��һ��ͼ������ʹ�ͼ���ӻ��Ű��ͼ�񼯺ϡ�
        % �����ļ��е���Դresources �ṹ��EachImage������results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
        % original resources �ļ������
        folderpath_output_originalResources = fullfile(Pros.folderpath_output, 'original resources');
        if exist(folderpath_output_originalResources, 'dir')
            rmdir(folderpath_output_originalResources,'s')
        end
        mkdir(folderpath_output_originalResources);
        
        folderpath_output_originalImages = fullfile(folderpath_output_originalResources, 'original images');
        if exist(folderpath_output_originalImages, 'dir')
            rmdir(folderpath_output_originalImages,'s')
        end
        mkdir(folderpath_output_originalImages);
        
        folderpath_output_originalGTImages = fullfile(folderpath_output_originalResources, 'ground truth bw images');
        if exist(folderpath_output_originalGTImages, 'dir')
            rmdir(folderpath_output_originalGTImages,'s')
        end
        mkdir(folderpath_output_originalGTImages);
        
        folderpath_output_scribbledImages = fullfile(folderpath_output_originalResources, 'scribbled images');
        if exist(folderpath_output_scribbledImages, 'dir')
            rmdir(folderpath_output_scribbledImages,'s')
        end
        mkdir(folderpath_output_scribbledImages);
        
        % ��ȡ���ԭʼͼ������ͼ����������������ȡ��ص�ͼ������ֵͼ���������Ķ�ֵͼ�ȵȡ�
        [indexes] = findIndexOfExistOriginalImage(Pros.folderpath_experiment ,EachImage_ref);
        
        for i=indexes
            copyfile(EachImage_ref.originalImage(i).path, fullfile(folderpath_output_originalImages, EachImage_ref.originalImage(i).name));
            copyfile(EachImage_ref.groundTruthBwImage(i).path, fullfile(folderpath_output_originalGTImages, EachImage_ref.groundTruthBwImage(i).name));
            %                     copyfile(EachImage_ref.contourImage(i).path, fullfile(folderpath_output_originalResources, 'contour images', EachImage_ref.contourImage(i).name));
            copyfile(EachImage_ref.scribbledImage(i).path, fullfile(folderpath_output_scribbledImages, EachImage_ref.scribbledImage(i).name));
            %                     copyfile(EachImage_ref.prior(i).path, fullfile(folderpath_output_originalResources, 'prior', EachImage_ref.prior(i).name));
            %                     copyfile(EachImage_ref.mu(i).path, fullfile(folderpath_output_originalResources, 'mu', EachImage_ref.mu(i).name));
            %                     copyfile(EachImage_ref.Sigma(i).path, fullfile(folderpath_output_originalResources, 'Sigma', EachImage_ref.Sigma(i).name));
            %                     copyfile(EachImage_ref.time(i).path, fullfile(folderpath_output_originalResources, 'time', EachImage_ref.time(i).name));
            %                     copyfile(EachImage_ref.phi(i).path, fullfile(folderpath_output_originalResources, 'phi', EachImage_ref.phi(i).name));
        end
        
        % calculation �ļ������
        folderpath_output_calculation = fullfile(Pros.folderpath_output, 'calculation');
        if exist(folderpath_output_calculation, 'dir')
            rmdir(folderpath_output_calculation,'s')
        end
        mkdir(folderpath_output_calculation);
        
        for index_experiment=1:Results_ref.num_experiments
            folderpath_bwData= fullfile(folderpath_output_calculation,Results_ref.experiments(index_experiment).name ,'bw data');
            if exist(folderpath_bwData, 'dir')
                rmdir(folderpath_bwData,'s')
            end
            mkdir(folderpath_bwData);
            
            folderpath_bwImage= fullfile(folderpath_output_calculation, Results_ref.experiments(index_experiment).name ,'bw images');
            if exist(folderpath_bwImage, 'dir')
                rmdir(folderpath_bwImage,'s')
            end
            mkdir(folderpath_bwImage);
            
            folderpath_evaluationData = fullfile(folderpath_output_calculation, Results_ref.experiments(index_experiment).name, 'evaluation data');
            if exist(folderpath_evaluationData, 'dir')
                rmdir(folderpath_evaluationData,'s')
            end
            mkdir(folderpath_evaluationData);
            
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'jaccardIndex.mat'));
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'jaccardDistance.mat'));
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'modifiedHausdorffDistance.mat'));
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'F1.mat'));
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'Precision.mat'));
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'Recall.mat'));
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'macroF1.mat'));
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'time.mat'));
            load(fullfile(Results_ref.experiments(index_experiment).folderpath_evaluationData, 'ME.mat'));
            
            % TODO : bw data ����ȡ�����Ժ󲹳�
            %             for i=indexes
            %                 % bw data
            %                 filename_newImg = [EachImage_ref.originalImage(i).name(1:end-4) '_' Results_ref.experiments(index_experiment).name '.bmp'];
            %                 copyfile(Results_ref.experiments(index_experiment).bwImages(i).path, fullfile(folderpath_bwImage, filename_newImg ));
            %             end
            
            for i=indexes
                % bw image
                filename_newImg = [EachImage_ref.originalImage(i).name(1:end-4) '_' Results_ref.experiments(index_experiment).name '.bmp'];
                copyfile(Results_ref.experiments(index_experiment).bwImages(i).path, fullfile(folderpath_bwImage, filename_newImg ));
            end
            
            % jaccardIndex
            temp=jaccardIndex(indexes);
            clear jaccardIndex;
            jaccardIndex = temp;
            save(fullfile(folderpath_evaluationData, 'jaccardIndex.mat'), 'jaccardIndex');
            
            % jaccardDistance
            temp=jaccardDistance(indexes);
            clear jaccardDistance;
            jaccardDistance = temp;
            clear temp;
            save(fullfile(folderpath_evaluationData, 'jaccardDistance.mat'), 'jaccardDistance');
            
            % modifiedHausdorffDistance
            temp =modifiedHausdorffDistance(indexes);
            clear modifiedHausdorffDistance;
            modifiedHausdorffDistance = temp ;
            clear temp;
            save(fullfile(folderpath_evaluationData, 'modifiedHausdorffDistance.mat'), 'modifiedHausdorffDistance');
            
            % Precision
            temp=Precision(indexes);
            clear Precision;
            Precision = temp;
            save(fullfile(folderpath_evaluationData, 'Precision.mat'), 'Precision');
            
            % Recall
            temp=Recall(indexes);
            clear Recall;
            Recall = temp;
            save(fullfile(folderpath_evaluationData, 'Recall.mat'), 'Recall');
            
            % F1
            temp=F1(indexes);
            clear F1;
            F1 = temp;
            clear temp;
            save(fullfile(folderpath_evaluationData, 'F1.mat'), 'F1');
            
            % macroF1
            [macroPrecision, macroRecall, macroF1]=macroPR_evaluation(Precision,Recall,F1);
            save(fullfile(folderpath_evaluationData, 'macroF1.mat'), 'macroF1');
            
            % ME
            temp=ME(indexes);
            clear ME;
            ME = temp;
            save(fullfile(folderpath_evaluationData, 'ME.mat'), 'ME');
            
            % time & iteration
            temp1=elipsedEachTime.name(indexes);
            temp2=elipsedEachTime.time(indexes);
            temp3=elipsedEachTime.iteration(indexes);
            clear elipsedEachTime;
            elipsedEachTime.name=temp1;
            elipsedEachTime.time=temp2;
            elipsedEachTime.iteration=temp3;
            save(fullfile(folderpath_evaluationData, 'time.mat'), 'elipsedEachTime');
        end
        
        % �����ļ������
        folderpath_output_segmentation = fullfile(Pros.folderpath_output, 'segmentation');
        if exist(folderpath_output_segmentation, 'dir')
            rmdir(folderpath_output_segmentation,'s')
        end
        mkdir(folderpath_output_segmentation);
        
        folderpath_output_evaluation = fullfile(Pros.folderpath_output, 'evaluation');
        if exist(folderpath_output_evaluation, 'dir')
            rmdir(folderpath_output_evaluation,'s')
        end
        mkdir(folderpath_output_evaluation);
        
        folderpath_output_analysis = fullfile(Pros.folderpath_output, 'analysis');
        if exist(folderpath_output_analysis, 'dir')
            rmdir(folderpath_output_analysis,'s')
        end
        mkdir(folderpath_output_analysis);
        
        folderpath_output_exportForPaper = fullfile(Pros.folderpath_output, 'exportForPaper');
        if exist(folderpath_output_exportForPaper, 'dir')
            rmdir(folderpath_output_exportForPaper,'s')
        end
        mkdir(folderpath_output_exportForPaper);
        
        folderpath_output_extract = fullfile(Pros.folderpath_output, 'extract');
        if exist(folderpath_output_extract, 'dir')
            rmdir(folderpath_output_extract,'s')
        end
        mkdir(folderpath_output_extract);
        
        folderpath_output_initResources = fullfile(Pros.folderpath_output, 'init resources');
        if exist(folderpath_output_initResources, 'dir')
            rmdir(folderpath_output_initResources,'s')
        end
        mkdir(folderpath_output_initResources);
        
        
        
    case '2'
        %% ģʽ2 ��ȡ��Ӧͼ������ݣ�������Ϊ��һ�����µĳ�ʼ���������зָ�ͷ�����ͼ�񼯺ϡ�
        
        
        % ��ȡ���ԭʼͼ������ͼ����������������ȡ��ص�ͼ������ֵͼ���������Ķ�ֵͼ�ȵȡ�
        [indexes] = findIndexOfExistOriginalImage(Pros.folderpath_experiment ,EachImage_ref);
        
        
        % original resources �ļ������
        folderpath_output_originalResources = fullfile(Pros.folderpath_output, 'original resources');
        mkdir(folderpath_output_originalResources);
        folderpath_output_originalImages = fullfile(folderpath_output_originalResources, 'original images');
        mkdir(folderpath_output_originalImages);
        folderpath_output_originalGTImages = fullfile(folderpath_output_originalResources, 'ground truth bw images');
        mkdir(folderpath_output_originalGTImages);
        folderpath_output_scribbledImages = fullfile(folderpath_output_originalResources, 'scribbled images');
        mkdir(folderpath_output_scribbledImages);
        folderpath_output_seedsIndex1 = fullfile(folderpath_output_originalResources,'seedsIndex1');
        mkdir(folderpath_output_seedsIndex1);
        folderpath_output_seedsIndex2 = fullfile(folderpath_output_originalResources, 'seedsIndex2');
        mkdir(folderpath_output_seedsIndex2);
        folderpath_output_seeds1 = fullfile(folderpath_output_originalResources, 'seeds1');
        mkdir(folderpath_output_seeds1);
        folderpath_output_seeds2 = fullfile(folderpath_output_originalResources, 'seeds2');
        mkdir(folderpath_output_seeds2);
        folderpath_output_seedsImg1 = fullfile(folderpath_output_originalResources, 'seedsImg1');
        mkdir(folderpath_output_seedsImg1);
        folderpath_output_seedsImg2 = fullfile(folderpath_output_originalResources, 'seedsImg2');
        mkdir(folderpath_output_seedsImg2);
        
        for i=indexes
            copyfile(EachImage_ref.originalImage(i).path, fullfile(folderpath_output_originalImages, EachImage_ref.originalImage(i).name));
            copyfile(EachImage_ref.groundTruthBwImage(i).path, fullfile(folderpath_output_originalGTImages, EachImage_ref.groundTruthBwImage(i).name));
            copyfile(EachImage_ref.scribbledImage(i).path, fullfile(folderpath_output_scribbledImages, EachImage_ref.scribbledImage(i).name));
            copyfile(EachImage_ref.seedsIndex1(i).path, fullfile(folderpath_output_seedsIndex1, EachImage_ref.seedsIndex1(i).name));
            copyfile(EachImage_ref.seedsIndex2(i).path, fullfile(folderpath_output_seedsIndex2, EachImage_ref.seedsIndex2(i).name));
            copyfile(EachImage_ref.seeds1(i).path, fullfile(folderpath_output_seeds1, EachImage_ref.seeds1(i).name));
            copyfile(EachImage_ref.seeds2(i).path, fullfile(folderpath_output_seeds2, EachImage_ref.seeds2(i).name));
            copyfile(EachImage_ref.seedsImg1(i).path, fullfile(folderpath_output_seedsImg1, EachImage_ref.seedsImg1(i).name));
            copyfile(EachImage_ref.seedsImg2(i).path, fullfile(folderpath_output_seedsImg2, EachImage_ref.seedsImg2(i).name));
        end
        
        % init resources �ļ������
        folderpath_output_initResources = fullfile(Pros.folderpath_output, 'init resources');
        mkdir(folderpath_output_initResources);
        for j=1:EachImage_ref.num_initMethods
            % ����ÿ����ʼ���������ļ��м���������ļ���
            folderpath_output_initMethods = fullfile(folderpath_output_initResources, EachImage_ref.initMethods(j).name);
            mkdir(folderpath_output_initMethods);
            folderpath_output_contourImages = fullfile(folderpath_output_initMethods, 'contour images');
            mkdir(folderpath_output_contourImages);
            folderpath_output_phi = fullfile(folderpath_output_initMethods, 'phi');
            mkdir(folderpath_output_phi);
            folderpath_output_mu = fullfile(folderpath_output_initMethods, 'mu');
            mkdir(folderpath_output_mu);
            folderpath_output_Sigma = fullfile(folderpath_output_initMethods, 'Sigma');
            mkdir(folderpath_output_Sigma);
            folderpath_output_prior = fullfile(folderpath_output_initMethods, 'prior');
            mkdir(folderpath_output_prior);
            folderpath_output_time = fullfile(folderpath_output_initMethods, 'time');
            mkdir(folderpath_output_time);
            folderpath_output_Args = fullfile(folderpath_output_initMethods, 'Args');
            mkdir(folderpath_output_Args);
            
            % copy Args �ļ�
            copyfile(EachImage_ref.initMethods(j).Args.path, fullfile(folderpath_output_Args, EachImage_ref.initMethods(j).Args.name));
            % copy ÿ��ͼ��
            for i=indexes
                copyfile(EachImage_ref.initMethods(j).contourImage(i).path, fullfile(folderpath_output_contourImages, EachImage_ref.initMethods(j).contourImage(i).name));
                copyfile(EachImage_ref.initMethods(j).phi(i).path, fullfile(folderpath_output_phi, EachImage_ref.initMethods(j).phi(i).name));
                copyfile(EachImage_ref.initMethods(j).mu(i).path, fullfile(folderpath_output_mu, EachImage_ref.initMethods(j).mu(i).name));
                copyfile(EachImage_ref.initMethods(j).Sigma(i).path, fullfile(folderpath_output_Sigma, EachImage_ref.initMethods(j).Sigma(i).name));
                copyfile(EachImage_ref.initMethods(j).prior(i).path, fullfile(folderpath_output_prior, EachImage_ref.initMethods(j).prior(i).name));
                copyfile(EachImage_ref.initMethods(j).time(i).path, fullfile(folderpath_output_time, EachImage_ref.initMethods(j).time(i).name));
            end
            
        end
        
        % �����ļ������
        folderpath_output_segmentation = fullfile(Pros.folderpath_output, 'segmentation');
        mkdir(folderpath_output_segmentation);
        folderpath_output_calculation = fullfile(Pros.folderpath_output, 'calculation');
        mkdir(folderpath_output_calculation);
        folderpath_output_evaluation = fullfile(Pros.folderpath_output, 'evaluation');
        mkdir(folderpath_output_evaluation);
        folderpath_output_analysis = fullfile(Pros.folderpath_output, 'analysis');
        mkdir(folderpath_output_analysis);
        folderpath_output_exportForPaper = fullfile(Pros.folderpath_output, 'exportForPaper');
        mkdir(folderpath_output_exportForPaper);
        folderpath_output_extract = fullfile(Pros.folderpath_output, 'extract');
        mkdir(folderpath_output_extract);
        folderpath_output_temp = fullfile(Pros.folderpath_output, 'temp');
        mkdir(folderpath_output_temp);
        
        
        
        
    otherwise
        error('error at choose mode !');
        
end


%%
text=['����������ϡ�'];
disp(text)
sp.Speak(text);

