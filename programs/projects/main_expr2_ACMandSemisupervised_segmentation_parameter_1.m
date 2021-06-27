%% ���ڷָ��������
% 		a. ���� ACMGMM �����࣬�ڣ�
% 		evolution_ACMandSemisupervised_Eacm
% 		�ķ����Ĵ����У�
% 		�ֱ�����˲�ͬ Eacm�������Ȩ��nu{ 1, 10, 100, 1000} ��� ������Ȩ��beta{0.0 ,  0.5 , 2.0 , 10.0} ��� �����Ȩ��gamma{0.0 , 0.5 , 2.0 , 10.0} ��� ����ֵtimestep{0.1 , 0.3 , 1.0 , 5.0} һ�� 256 ��ʵ���顣̽�������������ڷָ�����Ӱ�졣



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
initSegmentationArgsFirst;

% �����ȫ��������
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\segmentations';



%% semi-supervised segmentation


% folderpath_EachImageInitBaseFolder_1{4} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_kmeans100_1'; % ���Ƽ�
% folderpath_EachImageInitBaseFolder_1{5} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_1'; % ���Ƽ�
% folderpath_EachImageInitBaseFolder_1{6} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_1'; % ���Ƽ�
% folderpath_EachImageInitBaseFolder_1{7} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{8} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{9} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_2'; % �Ƽ�

Args.markType='scribble';

% Args.timestep=10;  % time step, default = 0.10



%% ACMGMM_semisupervised_Eacm �� ��ͬ��ʼ�������¡���ͬ Eacm ��Ȩ���¡���ͬ����ֵ������Ȩ�ء����Ȩ��
Args.evolutionMethod='semiACMGMM_Eacm';
Args=initSegmentationMethod(Args, Args.evolutionMethod);
for method=folderpath_EachImageInitBaseFolder_1
    if isempty(method{1})
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=method{1};
    for nu=[1 100]
        Args.nu = nu;
        for timestep=[0.01 0.03 0.10 0.25]
            Args.timestep=timestep;
            for beta=[0.00 0.01 0.10 0.25]
                Args.beta=beta;
                for gamma=[0.00 0.01 0.03 0.10 0.30]
                    Args.gamma=gamma;
                    Args.foldername_experiment =['ACMGMMsemi' '_timestep' num2str(Args.timestep) '_gamma' num2str(Args.gamma) '_beta' num2str(Args.beta) '_nu' num2str(Args.nu) '_' datestr(now,'ddHHMMSS')];
                    Args = setSegmentationMethod(Args, Args.evolutionMethod);
                    segmentation_func(Args);
                end
            end
        end
    end
end






%% end
text=['����ȫ��������ϡ�'];
sp.Speak(text);





