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

%% ��ʼȫ��������
setEvaluationCalculateArgsFirst;

%% �����ȫ��������
% Args.isNotWriteDataAtAll = 'yes' ; % �������й����в����Ľ�������Ƿ񱣴棬����ǣ���ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
% Args.foldername_EachImageBaseFolder = '.\data\resources\circle';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\circle';

evaluationCalculate_func(Args)





































