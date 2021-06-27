function []=collectImagesForExtractByOtherIndicator_func(Args)
%% ���
% collectImagesForExtractByOtherIndicator.m ʵ����ȡ����������ͼ���Լ���ֵͼ��ָ���ļ����Ա����˹�ɸѡ
% ��ȡָ�����ļ����ļ��е�ģʽ���������֣�
% ģʽ1 ��ʾ�ڴ��н�ǿ������ָ������������µĵ�һ��ɸѡ�£���ȡ��Ӧͼ��
% ģʽ2 ��ʾ�ڴ��н���������ָ������������µĵ�һ��ɸѡ�£���ȡ��Ӧͼ��
% ģʽ3 ��ʾ��ɸѡ������£���ȡ��Ӧͼ��
% ע���������ʱ����ʾҪ������ʵ���飡


diary off;


% %% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args.mode = '3' ; % ��ȡָ�����ļ����ļ��е�ģʽ������������
% Args.folderpath_reourcesDatasets = '.\candidate\resources';    % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��
% Args.folderpath_initDatasets = '.\candidate\init resources';    % ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
% Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\evaluation'; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
% % Args.folderpath_finalResultsBaseFolder = '.\data\evaluation\circleACMGMM 5-28������\Ҫ��kmeans+AMCGMM�����\end0.001'; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
% Args.folderpath_outputBase = '.\data\ACMGMMSEMI\MSRA1K\extract'; % ��ȡ�ļ���Ŀ���ļ���
% 
% Args.outputMode = 'datatime' ;	 % ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index'��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime'���Ƽ���Ĭ��ֵ��
% Args.num_scribble = 1; % ���д������ͼ��ı������������Ŀǰ��ʱ�����ǲ�ͬ��ǶԷָ�Ч����Ӱ�죬��������һ��ͼ��һ�ֱ�ǣ����Ŀǰ�ֶ�����Ϊ1��
% Args.isVisual = 'no' ;  % ���ƹ��̲����ӻ���������������в鿴����� 'yes'��ʾ���ƹ����п��ӻ� ��'no'��ʾ���ƹ����в����ӻ���Ĭ��'no'
% Args.numUselessFiles = 0; % Ҫ�ų���ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���
% Args.ratioOfGood = 0.85 ; % ����õ�ͼ�����ռ��ָ���ֵ�ı�����ֵ��ֵ��[0,1]��Ĭ�� 0.85
% Args.ratioOfBad = 0.5 ; % ������ͼ�����ռ��ָ���ֵ�ı�����ֵ��ֵ��[0,1]��Ĭ�� 0.65
% Args.ratioOfBetter = 0.001 ; % ���ַ����Ƚ�ʱ������AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá�ֵ��[0,1]��Ĭ�� 0.3
% Args.ratioOfBetterAtBothGood = 0.001 ; % ���ַ����Ƚ�ʱ�����ַ������õ�����£�����AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá�ֵ��[0,1]��Ĭ��0.1
% Args.ratioOfRegion = 1.0; % ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���ȶ�����Ч�����õ�ͼ������ ռ ʵ����Ч���ȶ�����Ч���õ�ͼ������ �ı�����
% Args.ratioOfRand = 0.1; % ����ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���õ�ͼ������ռ��ͼ�������ı����������Χ��
% Args.numImagesShow = 1000 ; % Ҫ��ȡ��ͼ����������������
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% properties
Pros = Args

%% �����ļ��е���Դresources �ṹ��EachImage������results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
EachImage = createEachImageStructure(Pros.folderpath_reourcesDatasets ,Pros.folderpath_initDatasets, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);
% Results_final = createResultsStructure(Pros.folderpath_finalResultsBaseFolder, Pros.numUselessFiles);

% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');
%

%% ����ʵ���飺
Args.experiment = input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ�Ļ�������ָ��ʵ���飬������������ Ctrl+c ��ֹ����')

%% �����ļ���
switch Args.outputMode
    case 'datatime'
        % ����һ������Ϊ������ʱ����������ļ�������ÿһ�ε�ʵ������
        Pros.foldername_experiment=[datestr(now,'dd-HHMMSS') '_evaluationAnalyse'];
    case 'index'
        Pros.foldername_experiment = ['��' num2str(index_experiment) '��ʵ��'];
end
Pros.folderpath_experiment=fullfile(Pros.folderpath_outputBase, Pros.foldername_experiment);
mkdir(Pros.folderpath_experiment);

% properties
Pros.num_scribble =1; % ��ǵ�������Ŀǰ�����ǲ�ͬ�ı�Ƕ�ʵ������Ӱ�죬�������Ϊ1
% Ҫ�����ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų�
Pros.num_image = EachImage.num_groundTruthBwImage;
Pros.num_experiments = Results.num_experiments;

%% ��¼��־
% ����diary����ļ���
Pros.filename_diary = 'diary evaluation analyse.txt';
Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
diary(Pros.filepath_diary);
diary on;
Args

%% ��ʱ
tic;

switch Pros.mode
    case '1'
        
        %% ��ӡ
        disp(['����õ�ͼ�����ռ��ָ���ֵ�ı�����ֵ��' num2str(Pros.ratioOfGood)])
        disp(['������ͼ�����ռ��ָ���ֵ�ı�����ֵ��' num2str(Pros.ratioOfBad)])
        disp(['���ַ����Ƚ�ʱ������AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá���ֵ����Ϊ��' num2str(Pros.ratioOfBetter)])
        disp(['���ַ����Ƚ�ʱ�����ַ������õ�����£�����AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá���ֵ����Ϊ��' num2str(Pros.ratioOfBetterAtBothGood)])
        disp(['ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���õ�ͼ������ռ��ͼ�������ı�������ֵ����Ϊ��' num2str(Pros.ratioOfRegion)])
        disp(['����ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���õ�ͼ������ռ��ͼ�������ı����������Χ����ֵ����Ϊ��' num2str(Pros.ratioOfRand)])
        
        %%
        JD=zeros(Pros.num_image,Pros.num_experiments);
        for i=1:Pros.num_experiments
            % 			filenameStr = '_Jaccard_compareTwo' ;
            load(fullfile(Results.experiments(i).folderpath_evaluationData, 'jaccardDistance.mat'));
            JD(:,i)=jaccardDistance;
            clear jaccardDistance;
        end
        labelStr_JD= 'Jaccard Distance';
        ceilValue_JD = 1; % ָ���ֵ�ܴﵽ�����ֵ�趨����ͬ��
        isReverseAxes_JD = 'yes'; % ���ָ����ԽСԽ�ã�����Ҫ��ת����ͬ��
        
        MHD=zeros(Pros.num_image,Pros.num_experiments);
        for i=1:Pros.num_experiments
            % 			filenameStr = '_Jaccard_compareTwo' ;
            load(fullfile(Results.experiments(i).folderpath_evaluationData, 'modifiedHausdorffDistance.mat'));
            MHD(:,i)=modifiedHausdorffDistance;
            clear modifiedHausdorffDistance;
        end
        labelStr_MHD = 'Modified Hausdorff Distance';
        ceilValue_MHD = max(MHD(:));
        isReverseAxes_MHD = 'yes';
        
        F1indicator=zeros(Pros.num_image,Pros.num_experiments);
        for i=1:Pros.num_experiments
            % 			filenameStr = '_Jaccard_compareTwo' ;
            load(fullfile(Results.experiments(i).folderpath_evaluationData, 'F1.mat'));
            F1indicator(:,i)=F1;
            clear F1;
        end
        labelStr_F1 = 'F1';
        ceilValue_F1 = 1;
        isReverseAxes_F1 = 'no';
        
        
        %% ͳ�ƶԱ����ַ����ڸ���ָ���£�ͼ������������
        % ��JDָ���£����ַ�������Ч�������ʵ����������������Ч������һЩ��ͼ��
        imagesBothNotBadAnd1better_JD(:,1)=find((JD(:,1)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,2)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,3)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,1)-JD(:,2)>Pros.ratioOfBetter) & (JD(:,1)-JD(:,3)>Pros.ratioOfBetter));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1better_JD(:,i+1) = JD(imagesBothNotBadAnd1better_JD(:,1),i);
        end
        num_imagesBothNotBadAnd1better_JD=size(imagesBothNotBadAnd1better_JD,1);
        
        % ��MHDָ���£����ַ�������Ч�������ʵ����������������Ч������һЩ��ͼ��
        imagesBothNotBadAnd1better_MHD(:,1) = find((MHD(:,1)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,2)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,3)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,1)-MHD(:,2)>Pros.ratioOfBetter) & (MHD(:,1)-MHD(:,3)>Pros.ratioOfBetter));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1better_MHD(:,i+1) = MHD(imagesBothNotBadAnd1better_MHD(:,1),i);
        end
        num_imagesBothNotBadAnd1better_MHD=size(imagesBothNotBadAnd1better_MHD,1);
        
        % ��F1ָ���£����ַ�������Ч�������ʵ����������������Ч������һЩ��ͼ��
        imagesBothNotBadAnd1better_F1(:,1) = find((F1indicator(:,1)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,2)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,3)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,1)-F1indicator(:,2)>Pros.ratioOfBetter) & (F1indicator(:,1)-F1indicator(:,3)>Pros.ratioOfBetter));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1better_F1(:,i+1) = F1indicator(imagesBothNotBadAnd1better_F1(:,1),i);
        end
        num_imagesBothNotBadAnd1better_F1=size(imagesBothNotBadAnd1better_F1,1);
        
        
        % ��JDָ���£����ַ�������Ч�������ʵ����������������Ч����һЩ��ͼ��
        imagesBothNotBadAnd1worse_JD(:,1)=find((JD(:,1)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,2)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,3)<=(1-Pros.ratioOfBad)*ceilValue_JD) & ((JD(:,2)-JD(:,1)>Pros.ratioOfBetter) | (JD(:,3)-JD(:,1)>Pros.ratioOfBetter)));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1worse_JD(:,i+1) = JD(imagesBothNotBadAnd1worse_JD(:,1),i);
        end
        num_imagesBothNotBadAnd1worse_JD=size(imagesBothNotBadAnd1worse_JD,1);
        
        % ��MHDָ���£����ַ�������Ч�������ʵ����������������Ч����һЩ��ͼ��
        imagesBothNotBadAnd1worse_MHD(:,1) = find((MHD(:,1)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,2)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,3)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & ((MHD(:,2)-MHD(:,1)>Pros.ratioOfBetter) | (MHD(:,3)-MHD(:,1)>Pros.ratioOfBetter)));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1worse_MHD(:,i+1) = MHD(imagesBothNotBadAnd1worse_MHD(:,1),i);
        end
        num_imagesBothNotBadAnd1worse_MHD=size(imagesBothNotBadAnd1worse_MHD,1);
        
        % ��F1ָ���£����ַ�������Ч�������ʵ����������������Ч����һЩ��ͼ��
        imagesBothNotBadAnd1worse_F1(:,1) = find((F1indicator(:,1)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,2)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,3)>=Pros.ratioOfBad*ceilValue_F1) & ((F1indicator(:,2)-F1indicator(:,1)>Pros.ratioOfBetter) | (F1indicator(:,3)-F1indicator(:,1)>Pros.ratioOfBetter)));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1worse_F1(:,i+1) = F1indicator(imagesBothNotBadAnd1worse_F1(:,1),i);
        end
        num_imagesBothNotBadAnd1worse_F1=size(imagesBothNotBadAnd1worse_F1,1);
        
        
        %% ��ȡ���ͼ��
        % Ԥ��ȡ���ͼ��
        images_JD=union(imagesBothNotBadAnd1better_JD(:,1),imagesBothNotBadAnd1worse_JD(1:num_imagesBothNotBadAnd1better_JD*Pros.ratioOfRegion,1));
        images_MHD=union(imagesBothNotBadAnd1better_MHD(:,1),imagesBothNotBadAnd1worse_MHD(1:num_imagesBothNotBadAnd1better_MHD*Pros.ratioOfRegion,1));
        images_F1=union(imagesBothNotBadAnd1better_F1(:,1),imagesBothNotBadAnd1worse_F1(1:num_imagesBothNotBadAnd1better_F1*Pros.ratioOfRegion,1));
        temp010=union(images_JD,images_MHD);
        imagesNeed=union(temp010,images_F1);
        numImageRatio = Pros.numImagesShow/size(imagesNeed,1);  % ������Ǵ�����Ҫ��ͼ����ռ�����ı���
        images_JD=[];
        images_MHD=[];
        images_F1=[];
        temp010=[];
        imagesNeed=[];
        % ��ʽ��ȡ���ͼ�������������ȡ������ÿ�ζ����ܲ�һ��
        randInterger1 = randperm(size(imagesBothNotBadAnd1better_JD,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_JD));
        temp005=imagesBothNotBadAnd1better_JD(randInterger1,1);
        randInterger2 = randperm(size(imagesBothNotBadAnd1worse_JD,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_JD*Pros.ratioOfRegion));
        temp006=imagesBothNotBadAnd1worse_JD(randInterger2,1);
        images_JD=union(temp005,temp006);
        randInterger3 = randperm(size(imagesBothNotBadAnd1better_MHD,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_MHD));
        temp005=imagesBothNotBadAnd1better_MHD(randInterger3,1);
        randInterger4 = randperm(size(imagesBothNotBadAnd1worse_MHD,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_MHD*Pros.ratioOfRegion));
        temp006=imagesBothNotBadAnd1worse_MHD(randInterger4,1);
        images_MHD=union(temp005,temp006);
        temp007=imagesBothNotBadAnd1better_F1(randInterger3,1);
        randInterger4 = randperm(size(imagesBothNotBadAnd1worse_F1,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_F1*Pros.ratioOfRegion));
        temp008=imagesBothNotBadAnd1worse_F1(randInterger4,1);
        images_F1=union(temp007,temp008);
        temp010=union(images_JD,images_MHD);
        imagesNeed=union(temp010,images_F1);
        num_imagesNeeded = size(imagesNeed,1);
        
        %% collect �ռ���Ҫ��ͼ��ָ�����ļ���
        folderpath_images = Pros.folderpath_experiment;
        if ~exist(folderpath_images,'dir')
            mkdir(folderpath_images);
        end
        for i=1:num_imagesNeeded
            copyfile(EachImage.originalImage(imagesNeed(i)).path, folderpath_images);
            copyfile(EachImage.groundTruthBwImage(imagesNeed(i)).path, folderpath_images);
            copyfile(EachImage.contourImage(imagesNeed(i)).path, folderpath_images);
            copyfile(EachImage.scribbledImage(imagesNeed(i)).path, folderpath_images);
        end
        
        
    case '2'
        %% TODO
        
    case '3'
        %% ��ȡ���ͼ��
        % ��ȡ���ͼ���������ļ����Է����û�ɸѡ
        
        folderpath_images = Pros.folderpath_experiment;
        if ~exist(folderpath_images,'dir')
            mkdir(folderpath_images);
        end
        
        for index_experiment = 1:Pros.num_experiments
            load(fullfile(Results.experiments(index_experiment).folderpath_evaluationData, 'time.mat'));
        end
        
        for index_image=1:Pros.num_image
            % extracting original image
            copyfile(EachImage.originalImage(index_image).path, fullfile(folderpath_images, EachImage.originalImage(index_image).name));
            % extracting initalized contour
            filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_init.bmp'];
            copyfile(EachImage.contourImage(index_image).path, fullfile(folderpath_images, filename_newImg));
            % extracting ground truth image
            filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_gt.bmp'];
            copyfile(EachImage.groundTruthBwImage(index_image).path, fullfile(folderpath_images, filename_newImg));
            % �����Ҫ�м����Ļ�������������δ��롾
            % 			for index_experiment = 1:Pros.num_experiments
            % 							filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_' Results_final.experiments(index_experiment).name '.bmp'];
            % 				copyfile(Results_final.experiments(index_experiment).bwImages(index_image).path, fullfile(folderpath_images, filename_newImg));
            % 			end
            % ��
        end
        
        % extracting bw-image of each methods
        for index_experiment = 1:Pros.num_experiments
            load(fullfile(Results.experiments(index_experiment).folderpath_evaluationData, 'time.mat'));
            for index_image=1:Pros.num_image
                filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_' Results.experiments(index_experiment).name '_iter' num2str(elipsedEachTime.iteration(index_image)) '_time' num2str(elipsedEachTime.time(index_image)) '.bmp'];
                copyfile(Results.experiments(index_experiment).bwImages(index_image).path, fullfile(folderpath_images, filename_newImg));
            end
        end
        
        
        
    otherwise
        error('error at choose mode');
end


%%
diary off;
toc;
text=['����������ϡ�'];
disp(text)
sp.Speak(text);

end
