%% ���ڼ�������ֵ��������
% ʵ��1,2,3һ��������2018/03/01

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

%% �����޼ල
Args.folderpath_resourcesBaseFolder = '.\data\resources\MSRA1K\original resources'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
% ��ʵ folderpath_initBaseFolder �ڼ���ָ���ʱ����Ҫ���������һ���Ϳ����ˡ�
Args.folderpath_initBaseFolder ='.\data\resources\MSRA1K\init resources'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\calculation\unsu'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
Args.mode = '3';
Args = setEvaluationCalculate(Args);
evaluationCalculate_func(Args, Args.mode);

%% ���ڰ�ල
Args.folderpath_resourcesBaseFolder = '.\data\resources\MSRA1K\original resources'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
% ��ʵ folderpath_initBaseFolder �ڼ���ָ���ʱ����Ҫ���������һ���Ϳ����ˡ�
Args.folderpath_initBaseFolder ='.\data\resources\MSRA1K\init resources'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\calculation\su'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
Args.mode = '1';
Args = setEvaluationCalculate(Args);
evaluationCalculate_func(Args, Args.mode);




%% end
text=['����ȫ��������ϡ�'];
% sp.Speak(text);














