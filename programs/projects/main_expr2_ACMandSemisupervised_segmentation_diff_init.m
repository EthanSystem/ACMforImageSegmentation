%% ���ڷָ��������

%  ���� ACMGMM���ڣ�
% evolution_ACMandGMMnew_pi2
% evolution_ACMandSemisupervised
% evolution_ACMandSemisupervised_Eacm
% �ķ����Ĵ����У�
% �����˲�ͬ�ĳ�ʼ���������жϲ�ͬ�ĳ�ʼ��������ʵ������Ӱ�졣


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


folderpath_EachImageInitBaseFolder_1{4} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_kmeans100_1'; % ���Ƽ�
folderpath_EachImageInitBaseFolder_1{5} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_1'; % ���Ƽ�
folderpath_EachImageInitBaseFolder_1{6} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_1'; % ���Ƽ�
folderpath_EachImageInitBaseFolder_1{7} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{8} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{9} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_2'; % �Ƽ�

Args.markType='scribble';

% Args.timestep=10;  % time step, default = 0.10

%% ACMGMM_semisupervised  �ڲ�ͬͣ��������
Args.evolutionMethod='semiACMGMM';
for endloop=[0.001,0.0001]
    Args.proportionPixelsToEndLoop = endloop;
    for i=folderpath_EachImageInitBaseFolder_1
        if isempty(i{1})
            continue;
        end
        Args.folderpath_EachImageInitBaseFolder=i{1};
        Args.foldername_experiment =['ACMGMMsemi' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
        Args=initSegmentationMethod(Args, Args.evolutionMethod);
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end


%% ACMGMM_semisupervised_Eacm �ڲ�ͬͣ�������º� Eacm ��Ȩ����
Args.evolutionMethod='semiACMGMM_Eacm';
for endloop=[0.001,0.0001]
    Args.proportionPixelsToEndLoop = endloop;
    for i=folderpath_EachImageInitBaseFolder_1
        if isempty(i{1})
            continue;
        end
        Args.folderpath_EachImageInitBaseFolder=i{1};
        for j=[1,10,100,1000]
            Args.weight_Eacm = j;
            Args.foldername_experiment =['ACMGMMsemiEacm' '_nu' num2str(Args.weight_Eacm) '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
            Args=initSegmentationMethod(Args, Args.evolutionMethod);
%             Args.timestep=1;
            Args = setSegmentationMethod(Args, Args.evolutionMethod);
            segmentation_func(Args);
        end
    end
end




%% ACMGMM_semisupervised_Eacm �ڲ�ͬ Eacm ��Ȩ����
% Args.evolutionMethod='semiACMGMM_Eacm';
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for j=[1,10,100,1000]
%         Args.weight_Eacm = j;
%         Args.foldername_experiment =[Args.evolutionMethod '_weightEacm_' num2str(Args.weight_Eacm) '_' datestr(now,'ddHHMMSS')];
%         Args=initSegmentationMethod(Args, Args.evolutionMethod);
% %         Args.timestep=1;
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end



%% ACM_semisupervised_HuangTan �ڲ�ͬ Eacm ��Ȩ����
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     Args.evolutionMethod='semiACM_HuangTan';
%     for j=[1,10,50,200,500,2000,5000]
%         Args.weight_Eacm = j;
%         Args.foldername_experiment =[Args.evolutionMethod '_weightEacm_' num2str(Args.weight_Eacm) '_' datestr(now,'ddHHMMSS')];
%         Args=initSegmentationMethod(Args, Args.evolutionMethod);
%         Args.timestep=1;
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end





%% unsupervised segmentation

% ACM and unsupervised

folderpath_EachImageInitBaseFolder_2{1} = '.\data\ACMGMMSEMI\MSRA1K\init resources\kmeans100';
folderpath_EachImageInitBaseFolder_2{2} = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle_SDF_kmeans100'; % ���Ƽ�
folderpath_EachImageInitBaseFolder_2{3} = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle_staircase_kmeans100'; % �Ƽ�


Args.markType='contour';


%% ACMGMM �ڲ�ͬͣ��������
Args.evolutionMethod='ACMGMM';
for endloop=[0.001,0.0001]
    Args.proportionPixelsToEndLoop = endloop;
    for i=folderpath_EachImageInitBaseFolder_2
        if isempty(i{1})
            continue;
        end
        Args.folderpath_EachImageInitBaseFolder=i{1};
        Args.foldername_experiment =['ACMGMM' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
        Args=initSegmentationMethod(Args, Args.evolutionMethod);
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end


%% LIF �ڲ�ͬͣ��������
% for endloop=[0.001,0.0003,0.0001]
%     Args.proportionPixelsToEndLoop = endloop;
%     for i=folderpath_EachImageInitBaseFolder_2
%         if isempty(i{1})
%             continue;
%         end
%         Args.folderpath_EachImageInitBaseFolder=i{1};
%         Args.evolutionMethod='LIF';
%         Args.foldername_experiment =[Args.evolutionMethod '_EndLoop' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%         Args=initSegmentationMethod(Args, Args.evolutionMethod);
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end







%% end
text=['����ȫ��������ϡ�'];
sp.Speak(text);





