% %% ���ڼ�������ֵ��������
%% ע�����
% �ֶ����ļ��С�ACM+GMM����Ϊ��ǰ�ļ��С��ֶ���������ļ��С�functions������projects���������ļ������·����


%% Ԥ����
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');
addpath( genpath( '.\functions' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���
addpath( genpath( '.\projects' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���
addpath( genpath( '.\tools' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���

%% segmentation

% ��ʼȫ��������
initEvaluationCalculateArgsFirst;


Args.folderpath_resourcesBaseFolder='.\data\ACMGMMSEMI\MSRA1K\original resources';

% ��ʵ folderpath_initBaseFolder �ڼ���ָ���ʱ����Ҫ���������һ���Ϳ����ˡ�
Args.folderpath_initBaseFolder='.\data\ACMGMMSEMI\MSRA1K\init resources\circle';

%% �����޼ල
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\����1 ������g�������㷽ʽ\new\su';
Args.mode = '3';
Args = setEvaluationCalculate(Args);
evaluationCalculate_func(Args, Args.mode);

%% ���ڰ�ල
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\����1 ������g�������㷽ʽ\new\semi';
Args.mode = '1';
Args = setEvaluationCalculate(Args);
evaluationCalculate_func(Args, Args.mode);

% Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\unsupervised';
% Args.mode = '3';
% Args = setEvaluationCalculate(Args);
% evaluationCalculate_func(Args, Args.mode);






%% end
text=['����ȫ��������ϡ�'];
sp.Speak(text);














