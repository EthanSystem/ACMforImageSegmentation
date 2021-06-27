% function [] = segmentation_func(evolutionMethod, mardType, initMethod, foldername_EachImageBaseFolder, foldername_ResultsBaseFolder, proportionPixelsToEndLoop)
function [] = segmentation_func(Args)
% segmentation_eachIter.m ���ڷָ�һ�������ͼ��

%% ��飺
% ���ڶ�һ��ͼ���ò�ͬ�ķָ��㷨�ָ�ͼ��������Ӧ��������ں�������������ÿ�����е���һ�ַָ��㷨�ĸ�����һ�����ֵ����һ��ͼ��
% Reference :
...Guowei Gao ,Chenglin Wen ,Huibin Wang, Fast and robust image segmentation with active contours and Student's-t mixture model
    
...��Դ���� resources �ļ�����
    ...������� results �ļ�����
    
%% ע�����


%% Ԥ����
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');
% addpath( genpath( '.' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ���������ļ���resource�Ľṹ��EachImage �͹����洢����ʵ���results�ļ�������ļ�·�������ƵĽṹ�� Results
Pros = Args; % ��Args���е�һϵ�в�������Pros

EachImage = createEachImageStructureForSegmentation(Pros.folderpath_EachImageResourcesBaseFolder, Pros.folderpath_EachImageInitBaseFolder, Pros.numUselessFiles);

% input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ����������������� Ctrl+c ��ֹ����')

% indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% indexOfBwImageFolder = findIndexOfFolderName(EachImage, 'bw images');
% indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth bw images');
% indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');



% Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);

%% ��ȡ��ʼ����Ϣ�� Args0 �ļ�����ֵ
load(EachImage.Args(1).path);
Args.initializeType = Args0.initializeType ;
clear Args0;
Pros = Args; % ��Args���е�һϵ�в�������Pros

%% ��������ʵ����ļ��У�������ʵ��
% Pros.foldername_eachIndexOfExperiment=dir(Pros.folderpath_ResultsBaseFolder);	% ÿ��ʵ����ļ����б�
% Pros.index_experiment=Results.num_experiments+1;

% �����������ļ���
% switch Pros.outputMode
%     case 'datatime'
%         % ����һ������Ϊ������ʱ����������ļ�������ÿһ�ε�ʵ������
%         % ��ʽ1
%         %                 Pros.foldername_experiment=[Pros.evolutionMethod '_' datestr(now,'ddHHMMSS')];
%         % ��ʽ2
%         switch Pros.evolutionMethod
%             case 'GMM'
%                 Pros.foldername_experiment=[Pros.evolutionMethod '_numState' num2str(Pros.numOfComponents) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%             case 'CV'
%                 Pros.foldername_experiment=[Pros.evolutionMethod '_step' num2str(Pros.timestep) '_beta' num2str(Pros.beta) '_epsilon' num2str(Pros.epsilon) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%             otherwise
%                 %                         				Pros.foldername_experiment=[Pros.evolutionMethod '_step' num2str(Pros.timestep) '_beta' num2str(Pros.beta) '_epsilon' num2str(Pros.epsilon) '_hsize' num2str(Pros.hsize) '_sigma' num2str(Pros.sigma) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%                 %                 Pros.foldername_experiment=[Pros.evolutionMethod '_nu' num2str(Pros.nu) '_' datestr(now,'ddHHMMSS')];
%                 Pros.foldername_experiment=[Pros.evolutionMethod '_' Pros.weight_Eacm '_' datestr(now,'ddHHMMSS')];
%                 Pros.foldername_experiment=[Pros.evolutionMethod '_' datestr(now,'ddHHMMSS')];
%         end
%     case 'index'
%         Pros.foldername_experiment = ['��' num2str(index_experiment) '��ʵ��'];
% end

Pros.folderpath_experiment=fullfile(Pros.folderpath_ResultsBaseFolder, Pros.foldername_experiment);
mkdir(Pros.folderpath_experiment);

% ����diary����ļ���
Pros.foldername_diary = 'diary output';
Pros.folderpath_diary = fullfile(Pros.folderpath_experiment, Pros.foldername_diary);
if ~exist(Pros.folderpath_diary,'dir')
    mkdir(Pros.folderpath_diary );
end

%% ���� diary ��¼
Pros.filepath_diary = fullfile(Pros.folderpath_diary , ['diary.txt']);
diary(Pros.filepath_diary);
diary on;
Args % ��ӡ Args

% ѡ����Ҫ�� markType
switch Pros.markType
    case 'scribble'
        num_processedImages = EachImage.num_scribbledImage;
    case 'contour'
        num_processedImages = EachImage.num_contourImage;
    case 'original'
        num_processedImages = EachImage.num_originalImage;
    otherwise
        error('error at choose mark type !');
end



% ��������ÿ�����ͼ��֮���Args��Ϣ�ļ���·��
Pros.folderpath_ArgsOutput = fullfile(Pros.folderpath_experiment, 'Args output');
if ~exist(Pros.folderpath_ArgsOutput ,'dir')
    mkdir(Pros.folderpath_ArgsOutput);
end

% ���շָ��ֵͼ��ͼ�ļ���·��
Pros.folderpath_bwImage = fullfile(Pros.folderpath_experiment, 'bw images');
if ~exist(Pros.folderpath_bwImage,'dir')
    mkdir(Pros.folderpath_bwImage);
end

% ���շָ��ֵͼ�����ļ���·��
Pros.folderpath_bwData = fullfile(Pros.folderpath_experiment, 'bw data');
if ~exist(Pros.folderpath_bwData,'dir')
    mkdir(Pros.folderpath_bwData);
end

% ����Ƕ�뺯�������ļ���·��
Pros.folderpath_phiData = fullfile(Pros.folderpath_experiment, 'phi data');
if ~exist(Pros.folderpath_phiData,'dir')
    mkdir(Pros.folderpath_phiData);
end

% ��������ÿ�����ͼ��֮�����������ļ���·��
Pros.folderpath_writeData=fullfile(Pros.folderpath_experiment, 'write data');
if ~exist(Pros.folderpath_writeData,'dir')
    mkdir(Pros.folderpath_writeData);
end

% ��������ÿ�����ͼ��֮��Ľ��ͼ�ļ���·��
Pros.folderpath_screenShot=fullfile(Pros.folderpath_experiment, 'screen shot');
if ~exist(Pros.folderpath_screenShot,'dir')
    mkdir(Pros.folderpath_screenShot);
end

% ��������ÿ�����ͼ��ı�����������ļ���·��
Pros.folderpath_seeds=fullfile(Pros.folderpath_experiment, 'seeds data');
if ~exist(Pros.folderpath_seeds,'dir')
    mkdir(Pros.folderpath_seeds);
end

% ��������ÿ�����ͼ��֮����������ָ�� time �� iteration �������ļ���·��
Pros.folderpath_evaluation=fullfile(Pros.folderpath_experiment, 'evaluation data');
if ~exist(Pros.folderpath_evaluation,'dir')
    mkdir(Pros.folderpath_evaluation);
end

% ��ʼ��¼��ʱ��
startTotalTime = clock;
totalIteration = 0;
elipsedTime = 0;

elipsedEachTime.name=cell(num_processedImages,1);
elipsedEachTime.time =zeros(num_processedImages,1);
elipsedEachTime.iteration = zeros(num_processedImages,1);

%% �������ڲ��Է����Ĵ���ͼ��ĸ���
if strcmp(Pros.isTestOnlyFewImages,'yes')
    array_processedImages=(1:Pros.numImagesToTest) ;
else
    array_processedImages=(1:num_processedImages);
end

if strcmp(Pros.isRunArrayProcessedImages,'yes')
    array_processedImages=Args.arrayProcessedImages;
else
    array_processedImages=(1:num_processedImages);
end

for index_processedImage = array_processedImages
    disp(['����ͼ��' num2str(index_processedImage) '/' num2str(num_processedImages)]);
    
    %% ��ȡͼ����ʾ
    index_originalImage = findIndexOfOriginalImageAtEachScribbledImage(EachImage, index_processedImage, 'mark');
    Pros.filename_originalImage =  EachImage.originalImage(index_originalImage).name; % ԭʼͼ������;
    Pros.filepath_originalImage =EachImage.originalImage(index_originalImage).path;
    image010_original = imread(Pros.filepath_originalImage);
    % properties setting
    Pros.sizeOfImage=size(image010_original);
    Pros.numData = Pros.sizeOfImage(1).*Pros.sizeOfImage(2);
    
    %% ��ͬ��ʼ��ģʽ����ʾ
    switch Pros.markType
        case 'scribble'
            markTypeName = 'Ϳѻ';
            Pros.filename_processedImage =EachImage.scribbledImage(index_processedImage).name;
            Pros.filepath_processedImage =EachImage.scribbledImage(index_processedImage).path;
            % ��ȡ��ʼ��������������Ϣ����ֵ��Э����
            Pros.filename_Prior = EachImage.prior(index_processedImage).name;
            Pros.filepath_Prior = EachImage.prior(index_processedImage).path;
            load(Pros.filepath_Prior);
            Pros.filename_mu = EachImage.mu(index_processedImage).name;
            Pros.filepath_mu = EachImage.mu(index_processedImage).path;
            load(Pros.filepath_mu);
            Pros.filename_Sigma = EachImage.Sigma(index_processedImage).name;
            Pros.filepath_Sigma = EachImage.Sigma(index_processedImage).path;
            load(Pros.filepath_Sigma);
            % ��ȡ��ʼ�������ĺķ�ʱ��
            Pros.filename_time= EachImage.time(index_processedImage).name;
            Pros.filepath_time = EachImage.time(index_processedImage).path;
            load(Pros.filepath_time);
            Pros.elipsedEachTime = time0;
            % ��ȡ��ʼ�������ĳ�ʼˮƽ��Ƕ�뺯��phi0
            Pros.filename_phi= EachImage.phi(index_processedImage).name;
            Pros.filepath_phi= EachImage.phi(index_processedImage).path;
            load(Pros.filepath_phi);
            % ��ʼˮƽ��Ƕ�뺯��phi0Ԥ����Ϊ������
            if 1==strcmp('yes' ,Pros.isMinMaxInitContours)
                phi0=reshape(mapminmax(reshape(phi0,1,[]), Pros.contoursInitMinValue, Pros.contoursInitMaxValue), Pros.sizeOfImage(1), Pros.sizeOfImage(2));
            end
            % ��ȡ�б�����ݡ��ޱ������
            load(EachImage.seedsIndex1(index_processedImage).path);
            load(EachImage.seedsIndex2(index_processedImage).path);
            [seedsIndex1_x,seedsIndex1_y]=ind2sub([Pros.sizeOfImage(1),Pros.sizeOfImage(2)],seedsIndex1);
            [seedsIndex2_x,seedsIndex2_y]=ind2sub([Pros.sizeOfImage(1),Pros.sizeOfImage(2)],seedsIndex2);
            
        case 'contour'
            markTypeName = '����';
            Pros.filename_processedImage =EachImage.contourImage(index_processedImage).name;
            Pros.filepath_processedImage =EachImage.contourImage(index_processedImage).path;
            % ��ȡ��ʼ��������������Ϣ����ֵ��Э����
            Pros.filename_Prior = EachImage.prior(index_processedImage).name;
            Pros.filepath_Prior = EachImage.prior(index_processedImage).path;
            load(Pros.filepath_Prior);
            Pros.filename_mu = EachImage.mu(index_processedImage).name;
            Pros.filepath_mu = EachImage.mu(index_processedImage).path;
            load(Pros.filepath_mu);
            Pros.filename_Sigma = EachImage.Sigma(index_processedImage).name;
            Pros.filepath_Sigma = EachImage.Sigma(index_processedImage).path;
            load(Pros.filepath_Sigma);
            % ��ȡ��ʼ�������ĺķ�ʱ��
            Pros.filename_time= EachImage.time(index_processedImage).name;
            Pros.filepath_time = EachImage.time(index_processedImage).path;
            load(Pros.filepath_time);
            Pros.elipsedEachTime = time0;
            % ��ȡ��ʼ�������ĳ�ʼˮƽ��Ƕ�뺯��phi0
            Pros.filename_phi= EachImage.phi(index_processedImage).name;
            Pros.filepath_phi= EachImage.phi(index_processedImage).path;
            load(Pros.filepath_phi);
            % ��ʼˮƽ��Ƕ�뺯��phi0Ԥ����Ϊ������
            if Pros.isMinMaxInitContours
                phi0=reshape(mapminmax(reshape(phi0,1,Pros.numData), Pros.contoursInitMinValue, Pros.contoursInitMaxValue), Pros.sizeOfImage(1), Pros.sizeOfImage(2));
            end
            
            
        case 'original'
            markTypeName = 'ԭͼ';
            Pros.filename_processedImage = EachImage.originalImage(index_processedImage).name;
            Pros.filepath_processedImage =EachImage.originalImage(index_processedImage).path;
            
            
        otherwise
            error('error at choose mark type !');
    end
    
    % �������� Pros
    Pros.iteration_inner=Args.iteration_inner;
    Pros.iteration_outer=Args.iteration_outer;
    Pros.filename_ArgsOutput = [Pros.filename_processedImage(1:end-4) '_Args.mat'];
    Pros.filepath_ArgsOutput = fullfile(Pros.folderpath_ArgsOutput, Pros.filename_ArgsOutput);
    Pros.filename_bwImage = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_bwImage.bmp'];
    Pros.filepath_bwImage = fullfile(Pros.folderpath_bwImage, Pros.filename_bwImage);
    Pros.filename_bwData = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_bwData.mat'];
    Pros.filepath_bwData = fullfile(Pros.folderpath_bwData, Pros.filename_bwData);
    Pros.filename_phiData = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_phiData.mat'];
    Pros.filepath_phiData = fullfile(Pros.folderpath_phiData, Pros.filename_phiData);
    Pros.filename_writeData =  [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_ExportData.mat'];
    Pros.filepath_writeData = fullfile(Pros.folderpath_writeData, Pros.filename_writeData);
    Pros.index_exportData = 1;
    
    %% ��ȡͼ����ʾ
    image010_processed = imread(Pros.filepath_processedImage);
    
    
    %% ��ʼ������
    text = ['��ʼͼ�� ' Pros.filename_originalImage ' ��' markTypeName 'ģʽ�� ' Pros.filename_processedImage ' ��ʵ��...'];
    if strcmp(Pros.isVoice,'yes')==1
        sp.Speak(text);
    end
    disp(text);
    
    
    
    %% ��ʾArgs
    % ����Ҫ��ӡ����Ļ����Ϣ
    Args.originalImageName =Pros.filename_originalImage ;
    Args.processedImageNmae = Pros.filename_processedImage ;
    Args.nameOfExperiment =Pros.foldername_experiment ;
    Pros.Args = Args; % �����յ�Args����Pros�����ڴ洢Args������
    disp(['ԭʼͼ��' Args.originalImageName]) % ����Ļ���ԭʼͼ������
    disp(['����ͼ��' Args.processedImageNmae]) % ����Ļ�������ͼ������
    
    Pros.numPixelChangedToContinue = Pros.proportionPixelsToEndLoop.*Pros.numData;	% ͣ������֮һ�����ݻ������������������֮���ǰ�����ĸı����������С�����ֵ�����������ѭ��
        
    
    %% start level set evolution
    switch Pros.evolutionMethod
        case 'semiACMGMMSP_2'
            %% ACMGMM+semisupervised+SP ����2 ����[1]�Ļ����ϣ����뽻����ල�������[2] X. Zhou, X. Li and W. Hu���˵ķ������ѳ�����������ˮƽ����
            [Pros, phi] = evolution_ACMGMMandSPsemisupervised_2( Pros, image010_original ,image010_processed, seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 );
            
        case 'semiACMGMMSP_2_2'
            %% ACMGMM+semisupervised+SP ����2 ����[1]�Ļ����ϣ����뽻����ල�������[2] X. Zhou, X. Li and W. Hu���˵ķ������ѳ�����������ˮƽ����
            [Pros, phi] = evolution_ACMGMMandSPsemisupervised_2_2( Pros, image010_original ,image010_processed, seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 );
            
        case 'semiACMGMMSP_1'
            %% ACMGMM+semisupervised+SP ����1 ����[1]�Ļ����ϣ����뽻����ල�������[2] X. Zhou, X. Li and W. Hu���˵ķ������ѳ�����������ˮƽ����
            [Pros, phi] = evolution_ACMGMMandSPsemisupervised_1( Pros, image010_original ,image010_processed, seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 );
            
        case 'semiACMGMMSP_1_2'
            %% ACMGMM+semisupervised+SP ����1 ����[1]�Ļ����ϣ����뽻����ල�������[2] X. Zhou, X. Li and W. Hu���˵ķ������ѳ�����������ˮƽ����
            [Pros, phi] = evolution_ACMGMMandSPsemisupervised_1_2( Pros, image010_original ,image010_processed, seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 );
            
            
        case 'semiACMGMM'
            %% ACM&GMM+Semi-supurvised : ʵ�ֻ��� [1] �ķ������� [3] ����ʽ��������
            [ Pros, phi ] = evolution_ACMGMMandSemisupervised( Pros, image010_original ,image010_processed , seedsIndex1,seedsIndex2, phi0, Prior0, mu0, Sigma0);
            
        case 'semiACMGMM_Eacm'
            %% ACM&GMM+Semi-supurvised with Huang Tan ����������
            [ Pros, phi ] = evolution_ACMGMMandSemisupervised_Eacm( Pros, image010_original ,image010_processed , seedsIndex1,seedsIndex2, phi0, Prior0, mu0, Sigma0);
            
            
        case 'semiACM_Eacm'
            %% Semi-supurvised only with Huang Tan ����������
            %% TODO
            [ Pros, phi ] = evolution_ACMandSemisupervised_Eacm( Pros, image010_original ,image010_processed , seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0);
            
            
        case 'semiACM_HuangTan'
            %% ̷����ʦ��ˮƽ���ݻ�����
            [Pros, phi] = evolution_ACMandSemisupervised_HuangTan( Pros, image010_original, image010_processed, seedsIndex1, seedsIndex2, phi0 );
            
        case 'ACM_SP'
            %% ACM+SP ��ʵ��[2] X. Zhou, X. Li and W. Hu���˵ķ�����������������ˮƽ����
            [Pros, phi] = evolution_ACMandSP( Pros, image010_original ,image010_processed, phi0);
            
            
        case 'ACMGMM'
            %% ACM&GMM new�� ���[1] Guowei Gao���˵ķ���������ˮƽ���ݻ������������ʽ(25)
            [ Pros, phi] = evolution_ACMandGMMnew_pi2(Pros,  image010_original, image010_processed, phi0, Prior0, mu0, Sigma0);
            
        case 'ACMGMMpi1'
            %% ACM&GMM pi 1�����[1] Guowei Gao���˵ķ���������ˮƽ���ݻ������������ʽ(23)
            [ Pros, phi] = evolution_ACMandGMM_pi1(Pros,  image010_original, image010_processed);
            
        case 'ACMGMMpi2'
            %% ACM&GMM pi 2�����[1] Guowei Gao���˵ķ���������ˮƽ���ݻ������������ʽ(25)
            [ Pros, phi] = evolution_ACMandGMM_pi2(Pros,  image010_original, image010_processed);
            
        case 'ACMandGM'
            %% ACM&GM�� [5]�ڶ��ڵķ���������ˮƽ���ݻ�
            [ Pros, phi ] = evolution_ACMandGM(Pros,  image010_original, image010_processed, phi0);
            
        case 'semiCV'
            %% CV��ʹ����չ����ɫ�ռ��CVģ�͵ģ���ල�ķ���������ˮƽ���ݻ�
            %% TODO
            %   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
            %   Author: Chunming Li, all right reserved
            %   email: li_chunming@hotmail.com
            %   URL:   http://www.engr.uconn.edu/~cmli
            [ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV(Pros,  image010_original, image010_processed, phi0);   % update level set function
            
            
        case 'CV'
            %% CV��ʹ����չ����ɫ�ռ��CVģ�͵ķ���������ˮƽ���ݻ�
            %   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
            %   Author: Chunming Li, all right reserved
            %   email: li_chunming@hotmail.com
            %   URL:   http://www.engr.uconn.edu/~cmli
            [ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV(Pros,  image010_original, image010_processed, phi0);   % update level set function
            
            
        case 'CVgray'
            %% CV gray��ʹ�ô�ͳ�Ĵ���Ҷ�ͼ���CVģ�͵ķ���������ˮƽ���ݻ�
            %   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
            %   Author: Chunming Li, all right reserved
            %   email: li_chunming@hotmail.com
            %   URL:   http://www.engr.uconn.edu/~cmli
            [ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV_gray(Pros,  image010_original, image010_processed, phi0);   % update level set function
            
        case 'semiGMM'
            %% GMM��ʹ��GMM�İ�ල����ָ�
            %% TODO
            
        case 'GMM'
            %% GMM��ʹ��GMM�Ķ���ָ�
            [Pros, phi] = evolution_GMM(Pros, image010_original, image010_processed, Prior0, mu0, Sigma0);
            
        case 'ACMandGMMtoEq18'
            %% ACMandGMMtoEq18���˷����ǽ��[1]�ķ��������ǲ��������(23)(25)ʽ��������Ϣ����ֻ�õ�(18)��
            % �����ݻ�һ���õ���һ������
            [Pros, phi ] = evolution_ACMandGMMtoEq18(Pros,  image010_original, image010_processed);
            
            
            
        case 'LBF'
            %% LBF��ʹ�øĽ�Ϊ�����ɫͼ���LBF����������ˮƽ���ݻ�
            %�����������ݻ�ˮƽ��������������£�C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation.
            %IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
            %phiΪˮƽ��������IΪͼ��,KsigmaΪ�˺���,nu����Ȩֵ,timestepʱ�䲽��,mu���ž��뺯��Ȩֵ
            %lambda1��lambda2ΪȨֵ��epsilon���ƽ�Ծ�ͳ������
            %By Liushigang.
            [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF(Pros, image010_original, image010_processed, phi0);
            
            
        case 'LBFgray'
            %% LBF gray��ʹ�ô�ͳ�Ĵ���Ҷ�ͼ���LBF����������ˮƽ���ݻ�
            %�����������ݻ�ˮƽ��������������£�C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation.
            %IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
            %phiΪˮƽ��������IΪͼ��,KsigmaΪ�˺���,nu����Ȩֵ,timestepʱ�䲽��,mu���ž��뺯��Ȩֵ
            %lambda1��lambda2ΪȨֵ��epsilon���ƽ�Ծ�ͳ������
            %By Liushigang.
            [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF_gray(Pros, image010_original, image010_processed, phi0);
            
            
        case 'semiLIF'
            %% LIF��ʹ�øĽ�Ϊ�����ɫͼ���LIF����������ˮƽ���ݻ�
            % This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
            %    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
            % Author: Kaihua Zhang, all rights reserved
            % E-mail: zhkhua@mail.ustc.edu.cn
            % http://www4.comp.polyu.edu.hk/~cslzhang/
            %  Notes:
            %   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
            %   2. Intial contour should be set properly.
            %% TODO
            
        case 'LIF'
            %% LIF��ʹ�øĽ�Ϊ�����ɫͼ���LIF����������ˮƽ���ݻ�
            % This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
            %    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
            % Author: Kaihua Zhang, all rights reserved
            % E-mail: zhkhua@mail.ustc.edu.cn
            % http://www4.comp.polyu.edu.hk/~cslzhang/
            %  Notes:
            %   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
            %   2. Intial contour should be set properly.
            [ Pros, phi] = evolution_LIF(Pros, image010_original, image010_processed, phi0);
            
            
        case 'LIFgray'
            %% LIF gray��ʹ�ô�ͳ�Ĵ���Ҷ�ͼ���LIF����������ˮƽ���ݻ�
            % This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
            %    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
            % Author: Kaihua Zhang, all rights reserved
            % E-mail: zhkhua@mail.ustc.edu.cn
            % http://www4.comp.polyu.edu.hk/~cslzhang/
            %  Notes:
            %   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
            %   2. Intial contour should be set properly.
            [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LIF_gray(Pros, image010_original, image010_processed, phi0);
            
            
        case 'DRLSE'
            %% DRLSE��ʹ�������DRLSE�ķ���������ˮƽ���ݻ�
            %% generate edge indicator function.
            %% TODO
            image010_gray =256.* image010_processed(:,:,1);
            G=fspecial('gaussian',Args.hsize ,Args.sigma);
            image010_smooth=conv2(image010_gray,G,'same');  % smooth image by Gaussiin convolution
            [Ix,Iy]=gradient(image010_smooth);
            f=Ix.^2+Iy.^2;
            g=1./(1+f);  % edge indicator function.
            
            % ��ʼ������
            phi = phi0;
            
            [Pros, phi] = visualizeContours_DRLSE( phi, image010_original, image010_data, Pros,Results );
            
            while Pros.iteration_outer<=Args.numIteration_outer
                %% �����ݻ�һ���õ���һ������
                [Pros, phi] = evolution_DRLSE( phi, g, Args,Pros );
                
                %% visualization
                Pros = visualizeContours_DRLSE( phi, image010,Args,Pros,Results );
                %%
                Pros.iteration_outer=Pros.iteration_outer+1;
            end
            
            
        otherwise
            error('error at choose evolution method !');
    end  % end this evolution method
    
    %% ��ʱÿ��ͼ����ʱ��
    elipsedEachTime(index_processedImage).name = Pros.filename_originalImage(1:end-4) ;
    elipsedEachTime(index_processedImage).time = Pros.elipsedEachTime;
    elipsedEachTime(index_processedImage).iteration = Pros.iteration_outer-1;
    elipsedTime = elipsedTime+elipsedEachTime(index_processedImage).time ;
    remainingTime = (elipsedTime/index_processedImage)*(num_processedImages - index_processedImage);
    totalIteration = totalIteration+Pros.iteration_outer-1;
    disp(['����ͼ����ʱ�䣺 ' num2str(elipsedEachTime(index_processedImage).time) ' ��'])
    disp(['�ݻ������� ' num2str(elipsedEachTime(index_processedImage).iteration)])
    disp(['Ԥ��ʣ��ʱ�䣺 ' num2str(remainingTime) ' ��'])
    
    %% д���ؼ�������
    Pros.filename_bwImageEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod  '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_bwImg.bmp'];
    Pros.filepath_bwImageEnd = fullfile(Pros.folderpath_bwImage, Pros.filename_bwImageEnd);
    Pros.filename_bwDataEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_bwData.mat'];
    Pros.filepath_bwDataEnd = fullfile(Pros.folderpath_bwData, Pros.filename_bwDataEnd);
    Pros.filename_phiDataEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_phiData.mat'];
    Pros.filepath_phiDataEnd = fullfile(Pros.folderpath_phiData, Pros.filename_phiDataEnd);
    
    % д������Ƕ�뺯������
    phiData = reshape(phi,  Pros.sizeOfImage(1), Pros.sizeOfImage(2));
    %     save(Pros.filepath_phiDataEnd,'phiData');         % ������ phiData
    if exist(Pros.filepath_phiDataEnd,'file')
        disp(['�ѱ�������Ƕ�뺯������ ' Pros.filename_phiDataEnd]);
    else
        disp(['δ��������Ƕ�뺯������ ' Pros.filename_phiDataEnd]);
    end
    
    % ����\phi �ָ�õ��Ķ�ֵͼ����
    bwData=zeros(Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    bwData(phiData(:)>=0)=1;
    bwData = im2bw(bwData);
    % �������շָ��ֵͼ
    imwrite(bwData, Pros.filepath_bwImageEnd,'bmp');
    if exist(Pros.filepath_bwImageEnd,'file')
        disp(['�ѱ������շָ��ֵͼ ' Pros.filename_bwImageEnd]);
    else
        disp(['δ�������շָ��ֵͼ ' Pros.filename_bwImageEnd]);
    end
    
    
    disp(' ')
    
    %% �洢 Args
    Args.elipsedTimes = elipsedEachTime(index_processedImage).time;
    Args.iterations =  elipsedEachTime(index_processedImage).iteration;
    save(Pros.filepath_ArgsOutput, 'Args'); % ����Args��mat�ļ�
    
    pause(0.5);
end % end marked image

%% save data of elipsed total time and average iteration and each elipsed time and iteration.
averageIteration = totalIteration/num_processedImages;
% Pros.filepath_elipsedEachTime = fullfile(Pros.folderpath_evaluation , ['time' num2str(elipsedTime) '_iter' num2str(averageIteration) '.mat']);
Pros.filepath_elipsedEachTime = fullfile(Pros.folderpath_evaluation , ['time.mat']);
elipsedEachTime=struct2table(elipsedEachTime);
save(Pros.filepath_elipsedEachTime,'elipsedEachTime');
disp(' ')

%% �����������
elapsedTotalTime = etime(clock,startTotalTime);
disp(['ƽ���ݻ������� ' num2str(averageIteration)])
disp(['����ʱ�䣺' num2str(elapsedTotalTime) '�롣'])
text=['����������ϡ�'];
% text=['����������ϡ�����ʱ�䣺' num2str(elapsedTotalTime) '�롣'];
disp(text);
% sp.Speak(text);

%% ֹͣ��¼����������������ݲ�����
diary off;








%%
end
