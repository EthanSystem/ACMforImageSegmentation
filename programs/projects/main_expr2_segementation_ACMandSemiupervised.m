%% ���ڷָ��������
% ʵ��2 ��ලACMGMM��ʵ��ϵ��


%% ע�����
% �ֶ����ļ��С�ACM����Ϊ��ǰ�ļ��С��ֶ���������ļ��С�functions������projects���������ļ������·����


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


%% ·��������
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K\original resources';
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\segmentations\test analysis' ;

%% semi-supervised segmentation
% folderpath_EachImageInitBaseFolder_1{1} = '.\data\resources\MSRA1K\init resources\scribbled_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{2} = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{3} = '.\data\resources\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{4} = '.\data\resources\MSRA1K\init resources\scribbled_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{5} = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{6} = '.\data\resources\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_2';

Args.markType='scribble';

Args.timestep=0.1;  % time step, default = 0.10
Args.numIteration_outer= 1000  ;		% ��ѭ��������default = 1000

%% ACM_semisupervised
% probability term
Args.timestep=0.10;  % time step, default = 0.10
Args.epsilon = 0.2 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta =0.5; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.

% ���²���Ҫ��
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
Args.initializeType = 'staircase' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
Args.contoursInitValue =1 ;    % the value used for initialization contours.
Args.scaleOflabeledProbabilities = 2.0;  % ͼ����б�������ĸ���ֵ��δ��������ĸ���ֵ�����ֵ����Сֵ����Ҫ��С���ı���ֵ��Ĭ������ 2.0 ����

% ���²��ܸ�
Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��

%% %%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%


%% ACMGMM_semisupervised  �� ��ͬ��ʼ�������¡���ͬͣ��������
Args.evolutionMethod='semiACMGMM';
Args=initSegmentationMethod(Args, Args.evolutionMethod);
i=0;
for init=folderpath_EachImageInitBaseFolder_1
    i=i+1;
    if isempty(init{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=init{1};
    for endloop=[0.00100 0.00030 0.00010]
        Args.proportionPixelsToEndLoop = endloop;
        Args.foldername_experiment =['ACMGMMsemi' '_init' num2str(i) '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end



%% ACMGMM_semisupervised_Eacm �� ��ͬ��ʼ�������¡���ͬͣ��������
% Args.evolutionMethod='semiACM_HuangTan';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for endloop=[0.001,0.0001]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =['ACMGMMsemiEacm' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end



%% ACMGMM_semisupervised_Eacm �ڲ�ͬ��ʼ�������¡���ͬͣ�������¡� Eacm ��Ȩ����
% Args.evolutionMethod='semiACMGMM_Eacm';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for endloop=[0.001,0.0001]
%         Args.proportionPixelsToEndLoop = endloop;
%         for j=[1,10,100,1000]
%             Args.weight_Eacm = j;
%             Args.foldername_experiment =['ACMGMMsemiEacm' '_nu' num2str(Args.weight_Eacm) '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%             Args = setSegmentationMethod(Args, Args.evolutionMethod);
%             segmentation_func(Args);
%         end
%     end
% end
%



%% ACMGMM_semisupervised_Eacm �� ��ͬ��ʼ�������¡���ͬ Eacm ��Ȩ���¡���ͬ����ֵ������Ȩ�ء����Ȩ��
% Args.evolutionMethod='semiACMGMM_Eacm';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for method=folderpath_EachImageInitBaseFolder_1
%     if isempty(method{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=method{1};
%     for nu=[1,10,100,1000]
%         Args.nu = nu;
%         for timestep=[0.1 0.3 1.0 5.0]
%             Args.timestep=timestep;
%             for beta=[0.0 0.5 2.0 10.0]
%                 Args.beta=beta;
%                 for gamma=[0.0 0.5 2.0 10.0]
%                     Args.gamma=gamma;
%                     Args.foldername_experiment =['ACMGMMsemi' '_nu' num2str(Args.nu) '_beta' num2str(Args.beta) '_gamma' num2str(Args.gamma) '_timestep' num2str(Args.timestep) '_' datestr(now,'ddHHMMSS')];
%                     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                     segmentation_func(Args);
%                 end
%             end
%         end
%     end
% end



%% ACM_semisupervised_HuangTan �� ��ͬ��ʼ�������¡���ͬ Eacm ��Ȩ����
% Args.evolutionMethod='semiACM_HuangTan';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for j=[1,50,100,200,300,500,1000,5000]
%         Args.weight_Eacm = j;
%         Args.foldername_experiment =[Args.evolutionMethod '_weightEacm_' num2str(Args.weight_Eacm) '_' datestr(now,'ddHHMMSS')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end
%




%% unsupervised segmentation

% ACM and unsupervised

% folderpath_EachImageInitBaseFolder_2{1} = '.\data\ACMGMMSEMI\MSRA1K\init resources\kmeans100';
% folderpath_EachImageInitBaseFolder_2{2} = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle_SDF_kmeans100'; % ���Ƽ�
folderpath_EachImageInitBaseFolder_2{3} = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle_staircase_kmeans100'; % �Ƽ�


Args.markType='scribble';


%% ACMGMM �� ��ͬ��ʼ�������¡���ͬͣ��������
Args.evolutionMethod='ACMGMM';
Args=initSegmentationMethod(Args, Args.evolutionMethod);
for i=folderpath_EachImageInitBaseFolder_2
    if isempty(i{1})
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=i{1};
    for endloop=[0.001,0.0001]
        Args.proportionPixelsToEndLoop = endloop;
        Args.foldername_experiment =['ACMGMM' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end


%% LIF �ڲ�ͬ ��ʼ�������¡�ͣ��������
% Args.evolutionMethod='LIF';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for i=folderpath_EachImageInitBaseFolder_2
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for endloop=[0.001,0.0003,0.0001]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =[Args.evolutionMethod '_EndLoop' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end







%% end
text=['����ȫ��������ϡ�'];
% sp.Speak(text);





