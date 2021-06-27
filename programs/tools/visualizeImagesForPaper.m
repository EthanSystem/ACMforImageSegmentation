%% ���
% visualizeImagesForPaper.m ���ӻ���Ҫ��ͼ����������չʾ��
% mode = '1' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ����ԭͼ����ֵͼ���������Ķ�ֵͼ��
% mode = '2' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ����ԭͼ����ֵͼ���������Ķ�ֵͼ���� mode = '1' ��ת��
% mode = '3' ���Ʋ�ͬ�����Ķ�ֵͼ���ڶԱȣ��������Զ�������з�ʽ�����ļ��С�
% mode = '4' �� mode = '3' ��ת��
% mode = '5' ���Ʋ�ͬ�����Ķ�ֵͼ���ڶԱȡ�

%% Ԥ����
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '2' ;


Args.folderpath_outputBase = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_��ҵ����ǰ�󱳾����С��\exportForPaper'; % ָ������������ļ��еĻ���·����

Args.outputMode = 'datatime';	 % ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index'��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime'���Ƽ���Ĭ��ֵ��Args.num_scribble = 1; % ���д������ͼ��ı������������Ŀǰ��ʱ�����ǲ�ͬ��ǶԷָ�Ч����Ӱ�죬��������һ��ͼ��һ�ֱ�ǣ����Ŀǰ�ֶ�����Ϊ1��
Args.isVisual = 'off' ;  % ���ƹ��̲����ӻ���������������в鿴����� 'on'��ʾ���ƹ����п��ӻ� ��'off'��ʾ���ƹ����в����ӻ���Ĭ��'off'
Args.numUselessFiles = 0; % Ҫ�ų����ļ���������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���
Args.numImagesShow = 15 ; % ÿ��figҪչʾ��ͼ�����������

% ���� mode '1' '2'
Args.folderpath_reourcesDatasets = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_��ҵ����ǰ�󱳾����С��\original resources'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
% ��ʵ folderpath_initBaseFolder ��ʵ��ʹ���в���Ҫ���������һ���Ϳ����ˡ�
Args.folderpath_initBaseFolder = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_��ҵ����ǰ�󱳾����С��\init resources'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_��ҵ����ǰ�󱳾����С��\calculation'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
Args.isOriginalImages = 'yes'; % �Ƿ����ԭͼ
Args.isGTImages = 'yes'; % �Ƿ������ֵͼ
Args.isScribbledImages = 'no'; % �Ƿ���Ʊ��ͼ
% Args.foldersWhoIsOriginal=[1];      % װ��ԭͼ���ļ������
% Args.foldersWhoIsScribbled=[2];           % װ�˱��ͼ���ļ������
% Args.foldersWhoIsGtImage=[3];      % װ����ֵ��ֵͼ���ļ������
% Args.foldersWhoIsBwImage=[4:6];      % װ�˽����ֵͼ���ļ������

% ���� mode '3' '4'
Args.folderpath_customeInput = '.\data\extract\5images'; % ���ڼ����ļ��ĸ�·��
Args.foldersWhoIsOriginal=[1];      % װ��ԭͼ���ļ������
Args.foldersWhoIsScribbled=[2];           % װ�˱��ͼ���ļ������
Args.foldersWhoIsBwImage=[];      % װ�˽����ֵͼ���ļ������
Args.foldersWhoIsGtImage=[];      % װ����ֵ��ֵͼ���ļ������
Args.foldersWhoNeedColormap = [3:6];       % װ����Ҫ��colormap������ļ�����ţ�������ָ��������ͼ��
Args.foldersWhoNeedScale = [3];         % װ����Ҫ���ߴ�������ļ������
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% properties
Pros = Args;

%% �����ļ��е���Դresources �ṹ��EachImage������results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
EachImage = createEachImageStructure(Pros.folderpath_reourcesDatasets, Pros.folderpath_initBaseFolder, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder, Pros.numUselessFiles);

% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');

input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ����������������� Ctrl+c ��ֹ����')

%% �����������۵Ŀ��ӻ����ļ��У������п��ӻ�
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
% Ҫ�����ԭʼͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų�
Pros.num_originalImage = EachImage.num_originalImage;
Pros.num_experiments = Results.num_experiments;

% ȷ������ʵ���ļ������⣬������Щ�ļ��в������
num_noExperimentsFolders = 0;
if (1==strcmp(Pros.isOriginalImages,'yes'))
    num_noExperimentsFolders=num_noExperimentsFolders+1;
end
if (1==strcmp(Pros.isGTImages,'yes'))
    num_noExperimentsFolders=num_noExperimentsFolders+1;
end
if (1==strcmp(Pros.isScribbledImages,'yes'))
    num_noExperimentsFolders=num_noExperimentsFolders+1;
end

% %% ��¼��־
% % ����diary����ļ���
% Pros.filename_diary = 'diary evaluation analyse.txt';
% Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
% diary(Pros.filepath_diary);
% diary on;
%

%% ��ʱ
tic;
%% ���� mode '1' '2' ��������ȡ�ļ��Ľṹ
if (1==strcmp(Pros.mode,'1') || 1==strcmp(Pros.mode,'2'))
    
    % �ҳ�ͼ�񼯵�����ͼ����ݺ�ߴ�����ֵ
    for i=1:EachImage.num_originalImage
        image010 = imread(EachImage.originalImage(i).path);
        [sizeImage(i,1) , sizeImage(i,2) , sizeImage(i,3)] = size(image010);
    end
    sizeImage=int16(sizeImage);
    clear image010;
    
    maxSizeImage = max(sizeImage); % ÿ����ͼ�������ܱ߿հף������سߴ�
    sizeBox = maxSizeImage+10; sizeBox(3)=[]; % ÿ����ͼ�����ܱ߿հף������سߴ�
end


%% ���� mode '3' '4' ��������ȡ�ļ��Ľṹ
if (1==strcmp(Pros.mode,'3') || 1==strcmp(Pros.mode,'4'))
    folderpath_sub=dir(Pros.folderpath_customeInput);
    folderpath_sub(1:2)=[];
    for i =1:length(folderpath_sub)
        folder_images{i}=dir([fullfile(folderpath_sub(i).folder,folderpath_sub(i).name) '\*']);
        folder_images{i}(1:2)=[];
    end
    
    %% �ҳ�ͼ�񼯵�����ͼ����ݺ�ߴ�����ֵ
    for idx_img=1:length(folder_images{Pros.foldersWhoIsOriginal(1)})
        image010 = imread(fullfile(folder_images{Pros.foldersWhoIsOriginal(1)}(idx_img).folder ,folder_images{Pros.foldersWhoIsOriginal(1)}(idx_img).name));
        [sizeImage(idx_img,1) , sizeImage(idx_img,2) , sizeImage(idx_img,3)] = size(image010);
    end
    sizeImage=int16(sizeImage);
    clear image010;
    
    maxSizeImage = max(sizeImage); % ÿ����ͼ�������ܱ߿հף������سߴ�
    sizeBox = maxSizeImage+10; sizeBox(3)=[]; % ÿ����ͼ�����ܱ߿հף������سߴ�
    
    if ~isempty(Pros.foldersWhoNeedScale)
        for idx_folder=Pros.foldersWhoNeedScale
            for idx_img=1:length(folder_images{idx_folder})
                image050 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name));
                image055=imresize(image050,[sizeImage(idx_img,1) sizeImage(idx_img,2)]);
                imwrite(image055,[fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name)]);
            end
        end
    end
end

switch Pros.mode
    %     case '1'
    %         %% mode = '1' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ����ԭͼ����ֵͼ���������Ķ�ֵͼ��
    %
    %         % �ҳ�ͼ�񼯵�����ͼ����ݺ�ߴ�����ֵ
    %         for i=1:EachImage.num_originalImage
    %             image010 = imread(EachImage.originalImage(i).path);
    %             [sizeImage(i,1) , sizeImage(i,2) , sizeImage(i,3)] = size(image010);
    %         end
    %         sizeImage=int16(sizeImage);
    %         clear image010;
    %
    %         maxSizeImage = max(sizeImage); % ÿ����ͼ�������ܱ߿հף������سߴ�
    %         sizeBox = maxSizeImage+10; sizeBox(3)=[]; % ÿ����ͼ�����ܱ߿հף������سߴ�
    %         numBox = int16([EachImage.num_originalImage, Results.num_experiments + num_noExperimentsFolders]); % ��ͼ���� (���� , ����)
    %
    %         figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % �ö�ά�������ĳ�����ͼ figure����ɫ����
    %
    %         pos_box = int16([1 1]); % ָ��Ӧ�÷����� figure �ĵ�ǰ box �����Ͻ�λ�ã�figure �����Ͻ�Ϊԭ��(1,1)
    %         pos_img = pos_box+5; % ָ��Ӧ�÷����� figure �ĵ�ǰ image �����Ͻ�λ��
    %
    %         % drawing each original image
    %         if (1==strcmp(Pros.isOriginalImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.originalImage(idx_img).path))/256;
    %                 pos_img(2) = pos_box(2)+sizeBox(2)/2-sizeImage(idx_img,2)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(1) = pos_box(1)+sizeImage(idx_img,1)+10;
    %                 pos_img(1) = pos_box(1);
    %             end
    %             pos_box(2) = pos_box(2)+sizeBox(2);
    %             pos_box(1) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each gt-image
    %         if (1==strcmp(Pros.isGTImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.groundTruthBwImage(idx_img).path))/256;
    %                 pos_img(2) = pos_box(2)+sizeBox(2)/2-sizeImage(idx_img,2)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(1) = pos_box(1)+sizeImage(idx_img,1)+10;
    %                 pos_img(1) = pos_box(1);
    %             end
    %             pos_box(2) = pos_box(2)+sizeBox(2);
    %             pos_box(1) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each bw-image of each method
    %         for idx_folder = 1:Results.num_experiments
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = repmat(imread(Results.experiments(idx_folder).bwImages(idx_img).path),1,1,3);
    %                 pos_img(2) = pos_box(2)+sizeBox(2)/2-sizeImage(idx_img,2)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(1) = pos_box(1)+sizeImage(idx_img,1)+10;
    %                 pos_img(1) = pos_box(1);
    %             end
    %             pos_box(2) = pos_box(2)+sizeBox(2);
    %             pos_box(1) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %
    %
    %
    %     case '2'
    %         %% mode = '2' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ����ԭͼ����ֵͼ���������Ķ�ֵͼ���� mode = '1' ��ת��
    %
    %         % �ҳ�ͼ�񼯵�����ͼ����ݺ�ߴ�����ֵ
    %         for i=1:EachImage.num_originalImage
    %             image010 = imread(EachImage.originalImage(i).path);
    %             [sizeImage(i,1) , sizeImage(i,2) , sizeImage(i,3)] = size(image010);
    %         end
    %         sizeImage=int16(sizeImage);
    %         clear image010;
    %
    %         maxSizeImage = max(sizeImage); % ÿ����ͼ�������ܱ߿հף������سߴ�
    %         sizeBox = maxSizeImage+10; sizeBox(3)=[]; % ÿ����ͼ�����ܱ߿հף������سߴ�
    %         numBox = int16([Results.num_experiments + num_noExperimentsFolders, EachImage.num_originalImage]); % ��ͼ���� (���� , ����)
    %
    %
    %         figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % �ö�ά�������ĳ�����ͼ figure����ɫ����
    %
    %         pos_box = int16([1 1]); % ָ��Ӧ�÷����� figure �ĵ�ǰ box �����Ͻ�λ�ã�figure �����Ͻ�Ϊԭ��(1,1)
    %         pos_img = pos_box+5; % ָ��Ӧ�÷����� figure �ĵ�ǰ image �����Ͻ�λ��
    %
    %         % drawing each original image
    %         if (1==strcmp(Pros.isOriginalImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.originalImage(idx_img).path))/256;
    %                 pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
    %                 pos_img(2) = pos_box(2);
    %             end
    %             pos_box(1) = pos_box(1)+sizeBox(1);
    %             pos_box(2) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each scribbled image
    %         if (1==strcmp(Pros.isScribbledImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.scribbledImage(idx_img).path))/256;
    %                 pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
    %                 pos_img(2) = pos_box(2);
    %             end
    %             pos_box(1) = pos_box(1)+sizeBox(1);
    %             pos_box(2) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each gt-image
    %         if (1==strcmp(Pros.isGTImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.groundTruthBwImage(idx_img).path))/256;
    %                 pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
    %                 pos_img(2) = pos_box(2);
    %             end
    %             pos_box(1) = pos_box(1)+sizeBox(1);
    %             pos_box(2) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each bw-image of each method
    %         for idx_folder = 1:Results.num_experiments
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = repmat(imread(Results.experiments(idx_folder).bwImages(idx_img).path),1,1,3);
    %                 pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
    %                 pos_img(2) = pos_box(2);
    %             end
    %             pos_box(1) = pos_box(1)+sizeBox(1);
    %             pos_box(2) = 1;
    %             pos_img = pos_box+5;
    %         end
    
    case '1'
        %% mode = '1' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ����ԭͼ����ֵͼ���������Ķ�ֵͼ��
        numBox = int16([Pros.num_originalImage, Pros.num_experiments + num_noExperimentsFolders]); % ��ͼ���� (���� , ����)
        direct1=1;
        direct2=2;
        
        
        
    case '2'
        %% mode = '2' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ����ԭͼ����ֵͼ���������Ķ�ֵͼ���� mode = '1' ��ת��
        numBox = int16([ Pros.num_experiments + num_noExperimentsFolders ,Pros.num_originalImage]); % ��ͼ���� (���� , ����)
        direct1=2;
        direct2=1;
        
        
    case '3'
        %% mode = '3' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ�����������Զ��壻
        numBox = int16([length(folder_images{Pros.foldersWhoIsOriginal}), length(folderpath_sub)]); % ��ͼ���� (���� , ����)
        direct1=1;
        direct2=2;
        
        
    case '4'
        %% mode = '4' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ�����������Զ��壻
        
        numBox = int16([length(folderpath_sub) ,length(folder_images{Pros.foldersWhoIsOriginal})]); % ��ͼ���� (���� , ����)
        direct1=2;
        direct2=1;
        
    case '5'
        %% TODO:
        
        
        
    otherwise
        error('error at choose mode !')
        
end

if (1==strcmp(Pros.mode,'1') || 1==strcmp(Pros.mode,'2'))
    
    figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % �ö�ά�������ĳ�����ͼ figure����ɫ����
    
    pos_box = int16([1 1]); % ָ��Ӧ�÷����� figure �ĵ�ǰ box �����Ͻ�λ�ã�figure �����Ͻ�Ϊԭ��(1,1)
    pos_img = pos_box+5; % ָ��Ӧ�÷����� figure �ĵ�ǰ image �����Ͻ�λ��
    
    idx_noExperimentFolder = 0;
    
    % drawing each original image
    if (1==strcmp(Pros.isOriginalImages,'yes'))
        idx_noExperimentFolder = idx_noExperimentFolder +1;
        switch Pros.mode
            case '1'
                pos_box = int16([1 (idx_noExperimentFolder-1)*sizeBox(direct2)+1]);
            case '2'
                pos_box = int16([(idx_noExperimentFolder-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:EachImage.num_originalImage
            image010 = double(imread(EachImage.originalImage(idx_img).path))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each scribbled image
    if (1==strcmp(Pros.isScribbledImages,'yes'))
        idx_noExperimentFolder = idx_noExperimentFolder +1;
        switch Pros.mode
            case '1'
                pos_box = int16([1 (idx_noExperimentFolder-1)*sizeBox(direct2)+1]);
            case '2'
                pos_box = int16([(idx_noExperimentFolder-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:EachImage.num_originalImage
            image010 = double(imread(EachImage.scribbledImage(idx_img).path))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each GT-images
    if (1==strcmp(Pros.isGTImages,'yes'))
        idx_noExperimentFolder = idx_noExperimentFolder +1;
        switch Pros.mode
            case '1'
                pos_box = int16([1 (idx_noExperimentFolder-1)*sizeBox(direct2)+1]);
            case '2'
                pos_box = int16([(idx_noExperimentFolder-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:EachImage.num_originalImage
            image010 = double(imread(EachImage.groundTruthBwImage(idx_img).path))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each bw-images
    for idx_folder = 1:Results.num_experiments
        switch Pros.mode
            case '1'
                pos_box = int16([1 (num_noExperimentsFolders + idx_folder -1)*sizeBox(direct2)+1]);
            case '2'
                pos_box = int16([(num_noExperimentsFolders + idx_folder -1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img=1:EachImage.num_originalImage
            image010 = repmat(imread(Results.experiments(idx_folder).bwImages(idx_img).path),1,1,3);
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
end

if (1==strcmp(Pros.mode,'3') || 1==strcmp(Pros.mode,'4'))
    figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % �ö�ά�������ĳ�����ͼ figure����ɫ����
    
    pos_box = int16([1 1]); % ָ��Ӧ�÷����� figure �ĵ�ǰ box �����Ͻ�λ�ã�figure �����Ͻ�Ϊԭ��(1,1)
    pos_img = pos_box+5; % ָ��Ӧ�÷����� figure �ĵ�ǰ image �����Ͻ�λ��
    
    % drawing each original image
    if ~isempty(Pros.foldersWhoIsOriginal)
        switch Pros.mode
            case '3'
                pos_box = int16([1 (Pros.foldersWhoIsOriginal(1)-1)*sizeBox(direct2)+1]);
            case '4'
                pos_box = int16([(Pros.foldersWhoIsOriginal(1)-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:length(folder_images{Pros.foldersWhoIsOriginal(1)})
            image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsOriginal}(idx_img).folder ,folder_images{Pros.foldersWhoIsOriginal}(idx_img).name)))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each scribbled image
    if ~isempty(Pros.foldersWhoIsScribbled)
        switch Pros.mode
            case '3'
                pos_box = int16([1 (Pros.foldersWhoIsScribbled(1)-1)*sizeBox(direct2)+1]);
            case '4'
                pos_box = int16([(Pros.foldersWhoIsScribbled(1)-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:length(folder_images{Pros.foldersWhoIsScribbled})
            image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsScribbled}(idx_img).folder ,folder_images{Pros.foldersWhoIsScribbled}(idx_img).name)))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each GT-images
    if ~isempty(Pros.foldersWhoIsGtImage)
        switch Pros.mode
            case '3'
                pos_box = int16([1 (Pros.foldersWhoIsGtImage(1)-1)*sizeBox(direct2)+1]);
            case '4'
                pos_box = int16([(Pros.foldersWhoIsGtImage(1)-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img=1:length(folder_images{Pros.foldersWhoIsGtImage})
            image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsGtImage}(idx_img).folder ,folder_images{Pros.foldersWhoIsGtImage}(idx_img).name)))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each bw-images
    if ~isempty(Pros.foldersWhoIsBwImage)
        for idx_folder=Pros.foldersWhoIsBwImage
            switch Pros.mode
                case '3'
                    pos_box = int16([1 (idx_folder-1)*sizeBox(direct2)+1]);
                case '4'
                    pos_box = int16([(idx_folder-1)*sizeBox(direct2)+1 1]);
            end
            pos_img = pos_box+5;
            for idx_img=1:length(folder_images{idx_folder})
                image010 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name));
                pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
                figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
                pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
                pos_img(direct1) = pos_box(direct1);
            end
        end
    end
    
    % drawing each images that need colormaping
    if ~isempty(Pros.foldersWhoNeedColormap)
        for idx_folder=Pros.foldersWhoNeedColormap
            switch Pros.mode
                case '3'
                    pos_box = int16([1 (idx_folder-1)*sizeBox(direct2)+1]);
                case '4'
                    pos_box = int16([(idx_folder-1)*sizeBox(direct2)+1 1]);
            end
            pos_img = pos_box+5;
            for idx_img = 1:length(folder_images{idx_folder})
                image010 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name)); % uint8
                [numRow,numCol,numChannal]=size(image010);
                
                if numChannal==1
                    colormap010=colormap(parula(256));
                    image020=double(zeros(numRow,numCol,3));
                    for i=1:1:256
                        [row,col,value]=find(image010==i-1);
                        if ~isempty(row)
                            for j=1:length(row)
                                image020(row(j),col(j),:)=colormap010(i,:);
                            end
                        end
                    end
                else
                    image020=double(image010)/256;
                end
                
                pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
                figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image020;
                pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
                pos_img(direct1) = pos_box(direct1);
            end
        end
    end
end

% show
figure010 = uint8(256*figure010);
% imtool(figure010);


% save
filename_figure = ['����չʾ��ͼ.bmp'];
filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
imwrite(figure010, filepath_figure);


% %% mode = '4' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��ÿһ�б�ʾһ��ͼ��ÿ��ͼ�����������Զ��壻
%
% folderpath_sub=dir(Pros.folderpath_customeInput);
% folderpath_sub(1:2)=[];
% for i =1:length(folderpath_sub)
%     folder_images{i}=dir([fullfile(folderpath_sub(i).folder,folderpath_sub(i).name) '\*']);
%     folder_images{i}(1:2)=[];
% end
%
% % �ҳ�ͼ�񼯵�����ͼ����ݺ�ߴ�����ֵ
% for idx_img=1:length(folder_images{Pros.foldersWhoIsOriginal(1)})
%     image010 = imread(fullfile(folder_images{Pros.foldersWhoIsOriginal(1)}(idx_img).folder ,folder_images{Pros.foldersWhoIsOriginal(1)}(idx_img).name));
%     [sizeImage(idx_img,1) , sizeImage(idx_img,2) , sizeImage(idx_img,3)] = size(image010);
% end
% sizeImage=int16(sizeImage);
% clear image010;
%
% maxSizeImage = max(sizeImage); % ÿ����ͼ�������ܱ߿հף������سߴ�
% sizeBox = maxSizeImage+10; sizeBox(3)=[]; % ÿ����ͼ�����ܱ߿հף������سߴ�
% numBox = int16([length(folderpath_sub) ,length(folder_images{Pros.foldersWhoIsOriginal})]); % ��ͼ���� (���� , ����)
%
% figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % �ö�ά�������ĳ�����ͼ figure����ɫ����
%
% pos_box = int16([1 1]); % ָ��Ӧ�÷����� figure �ĵ�ǰ box �����Ͻ�λ�ã�figure �����Ͻ�Ϊԭ��(1,1)
% pos_img = pos_box+5; % ָ��Ӧ�÷����� figure �ĵ�ǰ image �����Ͻ�λ��
%
% % drawing each original image
% if ~isempty(Pros.foldersWhoIsOriginal)
%     pos_box = int16([(Pros.foldersWhoIsOriginal(1)-1)*sizeBox(1)+1 1]);
%     pos_img = pos_box+5;
%     for idx_img = 1:length(folder_images{Pros.foldersWhoIsOriginal(1)})
%         image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsOriginal}(idx_img).folder ,folder_images{Pros.foldersWhoIsOriginal}(idx_img).name)))/256;
%         pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%         figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
%         pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%         pos_img(2) = pos_box(2);
%     end
% end
%
% % drawing each scribbled image
% if ~isempty(Pros.foldersWhoIsScribbled)
%     pos_box = int16([(Pros.foldersWhoIsScribbled(1)-1)*sizeBox(1)+1 1]);
%     pos_img = pos_box+5;
%     for idx_img = 1:length(folder_images{Pros.foldersWhoIsScribbled}(2))
%         image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsScribbled}(idx_img).folder ,folder_images{Pros.foldersWhoIsScribbled}(idx_img).name)))/256;
%         pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%         figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
%         pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%         pos_img(2) = pos_box(2);
%     end
% end
%
% % drawing each GT-images
% if ~isempty(Pros.foldersWhoIsGtImage)
%     pos_box = int16([(Pros.foldersWhoIsGtImage(1)-1)*sizeBox(1)+1 1]);
%     pos_img = pos_box+5;
%     for idx_img=1:length(folder_images{Pros.foldersWhoIsGtImage})
%         image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsGtImage}(idx_img).folder ,folder_images{Pros.foldersWhoIsGtImage}(idx_img).name)))/256;
%         pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%         figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
%         pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%         pos_img(2) = pos_box(2);
%     end
% end
%
% % drawing each bw-images
% if ~isempty(Pros.foldersWhoIsBwImage)
%     for idx_folder=Pros.foldersWhoIsBwImage
%         pos_box = int16([(idx_folder-1)*sizeBox(1)+1 1]);
%         pos_img = pos_box+5;
%         for idx_img=1:length(folder_images{idx_folder})
%             image010 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name));
%             pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%             figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
%             pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%             pos_img(2) = pos_box(2);
%         end
%     end
% end
%
% % drawing each images that need colormaping
% if ~isempty(Pros.foldersWhoNeedColormap)
%     for idx_folder=Pros.foldersWhoNeedColormap
%         pos_box = int16([(idx_folder-1)*sizeBox(1)+1 1]);
%         pos_img = pos_box+5;
%         for idx_img = 1:length(folder_images{idx_folder})
%             image010 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name)); % uint8
%             [numRow,numCol,numChannal]=size(image010);
%
%             if numChannal==1
%                 colormap010=colormap(parula(256));
%                 image020=double(zeros(numRow,numCol,3));
%                 for i=1:1:256
%                     [row,col,value]=find(image010==i-1);
%                     if ~isempty(row)
%                         for j=1:length(row)
%                             image020(row(j),col(j),:)=colormap010(i,:);
%                         end
%                     end
%                 end
%             else
%                 image020=double(image010)/256;
%             end
%
%             pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%             figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image020;
%             pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%             pos_img(2) = pos_box(2);
%         end
%     end
% end
%
%
% % show
% figure010 = uint8(256*figure010);
% imtool(figure010);
%
% % save
% filename_figure = ['����չʾ��ͼ.bmp'];
% filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
% imwrite(figure010, filepath_figure);
%
%
%










%%
diary off;
toc;
text=['����������ϡ�'];
disp(text)
sp.Speak(text);
