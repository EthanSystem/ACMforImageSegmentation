%% ���ڷָ��������
% ʵ��1��ȫ�ලACMGMM��ʵ��ϵ�У�ACMGMM��CV��GMM��LIF���� circleACMGMM 5-28������\��Ҫ���м����н�� ����Щͼ��

%% ע�����
% �ֶ����ļ��С�ACM+GMM����Ϊ��ǰ�ļ��С��ֶ���������ļ��С�functions������projects���������ļ������·����


%% Ԥ����
clear all;
close all;
clc;
diary off;
addpath( genpath( '.\functions' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���
addpath( genpath( '.\projects' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���
addpath( genpath( '.\tools' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���

%% segmentation

% init
clear;
setSegmentationArgsFirst;
initArgsACMGMM;
initArgsCV;
initArgsGMM;
initArgsLIF;

%% ���������
Args.initMethod = 'circle+ACMGMM';
Args.proportionPixelsToEndLoop = 0.00010;
Args.numIteration_outer = 1000;
Args.isNotWriteDataAtAll = 'yes' ; % �������й����в����Ľ�������Ƿ񱣴棬����ǣ���ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
Args.foldername_EachImageBaseFolder = '.\data\resources\circleACMGMM 5-28������\��Ҫ���м����н����';
Args.foldername_ResultsBaseFolder = '.\data\segmentations\circleACMGMM 5-28������\��Ҫ���м����н����\����';
Args.evolutionMethod='ACMGMM';
Args = setEvolutionMethod(Args, Args.evolutionMethod);
segmentation_func(Args);
Args.evolutionMethod='CV';
Args = setEvolutionMethod(Args, Args.evolutionMethod);
segmentation_func(Args);
Args.evolutionMethod='GMM';
Args = setEvolutionMethod(Args, Args.evolutionMethod);
segmentation_func(Args);
Args.evolutionMethod='LIF';
Args = setEvolutionMethod(Args, Args.evolutionMethod);
segmentation_func(Args);


% %% �������
% Args.initMethod = 'circle+ACMGMM';
% Args.proportionPixelsToEndLoop = 0.00010;
% Args.numIteration_outer = 30;
% Args.isNotWriteDataAtAll = 'no' ; % �������й����в����Ľ�������Ƿ񱣴棬����ǣ���ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
% Args.foldername_EachImageBaseFolder = '.\data\resources\circleACMGMM 5-28������\��Ҫ���м����н����';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\circleACMGMM 5-28������\��Ҫ���м����н����\���';
% Args.evolutionMethod='ACMGMM';
% Args = setEvolutionMethod(Args, Args.evolutionMethod);
% segmentation_func(Args);
% Args.evolutionMethod='CV';
% Args = setEvolutionMethod(Args, Args.evolutionMethod);
% segmentation_func(Args);
% Args.evolutionMethod='GMM';
% Args = setEvolutionMethod(Args, Args.evolutionMethod);
% segmentation_func(Args);
% Args.evolutionMethod='LIF';
% Args = setEvolutionMethod(Args, Args.evolutionMethod);
% segmentation_func(Args);







% % segmentation
% for evolutionMethod=['ACMGMM';'CV';'GMM';'LIF']
% 	segmentation_func(evolutionMethod);
% end

% end


%% calculation
% % init
% clear;
% setEvaluationCalculateArgsFirst
% 
% copyfile('\data\segmentations\circleACMGMM_epsilon0.5_sigma0.3\*','\data\calculation\circleACMGMM_epsilon0.5_sigma0.3\*')
% 
% % calculation
% Args.folderpath_EachImageBaseFolder = '.\data\resources\circleACMGMM_epsilon0.5_sigma0.3'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
% Args.folderpath_ResultsBaseFolder = '.\data\calculation\circleACMGMM_epsilon0.5_sigma0.3'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
% evaluationCalculate_func(Args);
% 
% Args.folderpath_EachImageBaseFolder = '.\data\resources\circle'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
% Args.folderpath_ResultsBaseFolder = '.\data\calculation\circle'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
% evaluationCalculate_func(Args);

















