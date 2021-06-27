%% ���ڷָ��������
% ʵ��2 ��ලACMGMM��ʵ��ϵ�У��������顣


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
% folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K\init resources\scribbled_kmeans100_1';
% folderpath_EachImageInitBaseFolder{2} = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_1';
% folderpath_EachImageInitBaseFolder{3} = '.\data\resources\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_1';
% folderpath_EachImageInitBaseFolder{4} = '.\data\resources\MSRA1K\init resources\scribbled_kmeans100_2';
folderpath_EachImageInitBaseFolder{5} = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
% folderpath_EachImageInitBaseFolder{6} = '.\data\resources\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_2';

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

%% ACM_semisupervised ���Է���ר�� %%%%%%%%%%%%%%%%%%%%%%%%%
i=0;
for initMethod=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(initMethod{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=initMethod{1};
    Args.foldername_experiment =['semiACMGMM' '_piType' Args.piType '_' datestr(now,'ddHHMMSS')];
    Args = setSegmentationMethod(Args, Args.evolutionMethod);
    segmentation_func(Args);
end


%% ACMGMM_semisupervised �� ��ͬ�����µ����������� %%%%%%%%%
% Args.evolutionMethod='semiACMGMM';
% Args=setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for piType = {'1' '2'}
%         Args.piType = piType{1};
%         for timestep=[0.1 0.3]
%             Args.timestep=timestep;
%             for epsilon=[1.00 0.50 0.20 0.10 0.05]
%                 Args.epsilon=epsilon;
%                 for sigma=[0.1 0.3 1.5 5.0]
%                     Args.sigma=sigma;
%                     for hsize=[5 15]
%                         Args.hsize=hsize;
%                         Args.foldername_experiment =['semi' '_piType' Args.piType ...
%                             '_timestep' num2str(Args.timestep) '_epsilon' num2str(Args.epsilon) ...
%                             '_sigma' num2str(Args.sigma) '_hsize' num2str(Args.hsize)];
%                         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                         segmentation_func(Args);
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% 


%% end
% text=['����ȫ��������ϡ�'];
% sp.Speak(text);















