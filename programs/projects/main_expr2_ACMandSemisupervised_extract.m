%% ������ȡͼ���������
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

%% init global parameters

initExtractArgsFirst;
Args.mode = '1' ; % ��ȡָ�����ļ����ļ��е�ģʽ
Args.folderpath_EachImageResourcesBaseFolder = '.\candidate\resources';    % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��

Args.folderpath_outputBase = '.\data\ACMGMMSEMI\MSRA1K\extract'; % ��ȡ�ļ���Ŀ���ļ���


%% extract
Args.folderpath_EachImageInitBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_kmean100';    % ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\semisupervised';
Args = setExtractArgs(Args);
collectImagesForExtractByOtherIndicator_func(Args);

Args.folderpath_initDatasets = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle';    % ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\unsupervised';
Args = setExtractArgs(Args);
collectImagesForExtractByOtherIndicator_func(Args);










