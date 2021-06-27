function []=copyImgRelatedWithExtractedOriginalImg(Args, mode)
%% 简介
% 提取指定文件夹的所有与原图相关的图像（相关的真值图、各方法分割出来的二值图）到同一个文件夹用于下一次筛选。

%% 简介
% copyImgRelatedWithExtractedOriginalImg.m 实现提取各个方法的图像以及真值图到指定文件夹以便于人工筛选
% 模式1 提取相应图像和数据，用于作为下一次图像分析和大图可视化排版的图像集合。
% 模式2 提取相应图像和数据，用于作为下一次用新的初始化轮廓进行分割和分析的图像集合。

%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '2' ;
Args.isVisual = 'no' ;  % 绘制过程不可视化，程序结束后自行查看结果。 'yes'表示绘制过程中可视化 ，'no'表示绘制过程中不可视化。默认'no'
Args.numUselessFiles = 0; % 要排除的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除。

switch Args.mode
    case '1'    % 模式1 提取相应图像和数据，用于作为下一次图像分析和大图可视化排版的图像集合。
        Args.folderpath_originalResourcesBaseFolder = '.\data\resources\MSRA1K\original resources' ; % 用于提取文件的主库的原始资源 original resources 的基本路径（比如，MSRA1K数据库的1000张图所在的路径）。
        Args.folderpath_initResourcesBaseFolder='.\data\resources\MSRA1K\init resources'; % 用于提取文件的的主库的初始化文件 init resources 的基本路径
        Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\evaluation\expr2' ; % 用于提取文件的结构体 Results 的基本路径。
        Args.folderpath_experiment = '.\data\expr_1000images\extract\毕业论文\expr2\毕业论文有歧义的图片' ; % 待提取的文件的原始图像所在路径。
        Args.folderpath_output = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_毕业论文有歧义的图片' ; % 输出的 evaluation 图像的路径
        
        
    case '2'    % 模式2 提取相应图像和数据，用于作为下一次用新的初始化轮廓进行分割和分析的图像集合。
        Args.folderpath_originalResourcesBaseFolder = '.\data\resources\MSRA1K\original resources' ; % 用于提取文件的主库的原始资源 original resources 的基本路径（比如，MSRA1K数据库的1000张图所在的路径）。
        Args.folderpath_initResourcesBaseFolder='.\data\resources\MSRA1K\init resources'; % 用于提取文件的的主库的初始化文件 init resources 的基本路径
        Args.folderpath_experiment = '.\data\expr_1000images\extract\毕业论文\expr3\毕业论文超像素可视化分析的' ; % 输出的 original resources 图像的路径
        Args.folderpath_output = '.\data\expr3_seg\毕业论文超像素可视化分析的' ; % 输出的 init resources 图像的路径
        
    otherwise
        error('error at choose mode !');
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% properties
Pros = Args;


%% 构建文件夹的资源resources 结构体EachImage，构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
switch Pros.mode
    case '1'    % 模式1 提取相应图像和数据，用于作为下一次图像分析和大图可视化排版的图像集合。
        EachImage_ref = createEachImageStructure(Pros.folderpath_originalResourcesBaseFolder , Pros.folderpath_initResourcesBaseFolder, Pros.numUselessFiles);
        Results_ref = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);
    case '2'    % 模式2 提取相应图像和数据，用于作为下一次用新的初始化轮廓进行分割和分析的图像集合。
        EachImage_ref = createEachImageStructure(Pros.folderpath_originalResourcesBaseFolder , Pros.folderpath_initResourcesBaseFolder, Pros.numUselessFiles);
        %         Results_ref = createResultsStructure(Pros.folderpath_output ,Pros.numUselessFiles);
    otherwise
        error('error at choose mode !');
end

%% 设置实验组：
Args.experiment = input('确认文件夹里的文件数量是否正确？正确的话按Enter键继续，否则按 Ctrl+c 终止程序。')

%% properties
Pros.num_scribble =1; % 标记的数量。目前不考虑不同的标记对实验结果的影响，因此设置为1。

% 要处理的图像数量。
Pros.num_image = EachImage_ref.num_groundTruthBwImage;
if (1==strcmp(Args.mode,'1'))
    Pros.num_experiments = Results_ref.num_experiments;
end


%% collect 收集需要的图像，并重命名文件名以方便用户筛选，将这些图像复制到指定的文件夹
% if ~exist(folderpath_output_originalResources,'dir')
%     mkdir(folderpath_output_originalResources);
% end
%
% if ~exist(Pros.folderpath_output_initResources,'dir')
%     mkdir(Pros.folderpath_output_initResources);
% end


switch Pros.mode
    case '1'
        %% 模式1 提取相应图像和数据，用于作为下一次图像分析和大图可视化排版的图像集合。
        % 构建文件夹的资源resources 结构体EachImage，构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
        % original resources 文件夹里的
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
        
        % 提取相关原始图像所在图像库的索引，用于提取相关的图像，如真值图、各方法的二值图等等。
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
        
        % calculation 文件夹里的
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
            
            % TODO : bw data 的提取代码以后补充
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
        
        % 其它文件夹里的
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
        %% 模式2 提取相应图像和数据，用于作为下一次用新的初始化轮廓进行分割和分析的图像集合。
        
        
        % 提取相关原始图像所在图像库的索引，用于提取相关的图像，如真值图、各方法的二值图等等。
        [indexes] = findIndexOfExistOriginalImage(Pros.folderpath_experiment ,EachImage_ref);
        
        
        % original resources 文件夹里的
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
        
        % init resources 文件夹里的
        folderpath_output_initResources = fullfile(Pros.folderpath_output, 'init resources');
        mkdir(folderpath_output_initResources);
        for j=1:EachImage_ref.num_initMethods
            % 生成每个初始化方法的文件夹及其各个子文件夹
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
            
            % copy Args 文件
            copyfile(EachImage_ref.initMethods(j).Args.path, fullfile(folderpath_output_Args, EachImage_ref.initMethods(j).Args.name));
            % copy 每个图像
            for i=indexes
                copyfile(EachImage_ref.initMethods(j).contourImage(i).path, fullfile(folderpath_output_contourImages, EachImage_ref.initMethods(j).contourImage(i).name));
                copyfile(EachImage_ref.initMethods(j).phi(i).path, fullfile(folderpath_output_phi, EachImage_ref.initMethods(j).phi(i).name));
                copyfile(EachImage_ref.initMethods(j).mu(i).path, fullfile(folderpath_output_mu, EachImage_ref.initMethods(j).mu(i).name));
                copyfile(EachImage_ref.initMethods(j).Sigma(i).path, fullfile(folderpath_output_Sigma, EachImage_ref.initMethods(j).Sigma(i).name));
                copyfile(EachImage_ref.initMethods(j).prior(i).path, fullfile(folderpath_output_prior, EachImage_ref.initMethods(j).prior(i).name));
                copyfile(EachImage_ref.initMethods(j).time(i).path, fullfile(folderpath_output_time, EachImage_ref.initMethods(j).time(i).name));
            end
            
        end
        
        % 其它文件夹里的
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
text=['程序运行完毕。'];
disp(text)
sp.Speak(text);

