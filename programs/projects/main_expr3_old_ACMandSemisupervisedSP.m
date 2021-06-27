%% ���ڷָ��������

% ʵ��2�����볬�������İ�ලACMGMM��ʵ��ϵ��

%% ע�����
% �ֶ����ļ��С�ACM+GMM����Ϊ��ǰ�ļ��С��ֶ���������ļ��С�functions������projects���������ļ������·����

%%

% ÿ������MATLAB��ֻ��Ҫ����һ�Ρ�
VLROOTS='';
run('C:\Softwares\VLFeat\toolbox\vl_setup');
% vl_version verbose
% addpath of vl-feat. the pathname may be different in different PC.


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
Args.folderpath_EachImageResourcesBaseFolder = '.\data\ACMGMMSEMI\MSRA1K 10 images\original resources';
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K 10 images\segmentations\test analysis';

%% semi-supervised segmentation
% folderpath_EachImageInitBaseFolder_1{1} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{2} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_circle_SDF_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{3} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_circle_staircase_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{4} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{5} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_circle_SDF_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{6} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_circle_staircase_kmeans100_2';

% folderpath_EachImageInitBaseFolder_1{1} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{2} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_circle_SDF_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{3} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_circle_staircase_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{4} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{5} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_circle_SDF_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{6} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_circle_staircase_kmeans100_2';


%% ���ô���
% Args.numIteration_outer= 10  ;		% ��ѭ��������default = 1000
% Args.numIteration_inner= 1 ;  % ��ѭ��������default = 1




%% parameters settings
% probability term
Args.timestep=0.10 ;  % time step, default = 0.10
Args.epsilon = 0.1 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta =0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
Args.lambda = 1.00 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.

% ���ֵĳ����صı߳�
Args.SuperPixels_lengthOfSide = 15 ;

% ���ֵĳ����صĹ����
Args.SuperPixels_regulation = 1.0 ;


%         % ��˹�˴������
%         Args.Sigma1=0.15;
%
%         Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
%         Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.


% ��ɫ�ռ�
% ��ѡֵ�� 'RGB' 'LAB' 'HSV' ����֮һ
Args.colorspace='RGB';


% ���²���Ҫ��
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
Args.initializeType = 'staircase' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
Args.contoursInitValue =1 ;    % the value used for initialization contours.
Args.scaleOflabeledProbabilities = 2.0;  % ͼ����б�������ĸ���ֵ��δ��������ĸ���ֵ�����ֵ����Сֵ����Ҫ��С���ı���ֵ��Ĭ������ 2.0 ����


% ���²��ܸ�
Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��

%         % �Ƿ��������²����д�̽��
%         % �����ĳ�ʼ��
%         % ��������һ��ʽ��ʼ����'BOX'��'USER' ����ѡ��һ��
%         Args.contourType = 'USER';
%         Args.boxWidth=20;
%         Args.contoursInitValue =1 ;    % the value used for initialization contours.
%         Args.isMinMaxInitContours = 'yes';   % �Ƿ�����ˮƽ��Ƕ�뺯���ĳ�ʼ������ֵ
%         Args.contoursInitMinValue = -1;   % ˮƽ����ʼǶ�뺯��������ֵ��
%         Args.contoursInitMaxValue = 1;   % ˮƽ����ʼǶ�뺯��������ֵ��

% % �Ƿ���ӻ��Ŀ���
Args.isVisualEvolution='no';
Args.isVisualSegoutput='no';
Args.isVisualSPDistanceMat='no';
Args.isVisualProbability='no';
Args.isVisualSspc='no';

Args.isVisual_f_data='no';
Args.isVisualLabels='no';



%% %%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%


%% ���Է���ר��
Args.foldername_experiment =['semiACMGMMSP' '_' datestr(now,'ddHHMMSS')];
Args = setSegmentationMethod(Args, Args.evolutionMethod);
segmentation_func(Args);



%% ���飺��ʼ����ʽ��Ӱ��
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder_1
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     Args.foldername_experiment =['semiACMGMMandSP' '_init' num2str(i) '_' datestr(now,'ddHHMMSS')];
%     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%     segmentation_func(Args);
% end

%% ���飺�ݻ�������Ӱ��
% for numIteration_outer=[10 100 1000]
%     Args.numIteration_outer=numIteration_outer;
%     Args.foldername_experiment =['semiACMGMMandSP' '_iter' num2str(numIteration_outer) '_' datestr(now,'ddHHMMSS')];
%     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%     segmentation_func(Args);
% end

%% ���飺��ɫ�ռ䡢����ֵ���㷽�� ��Ӱ��
% for colorspace= {'LAB' 'HSV' 'RGB'}
%     Args.colorspace=colorspace{1};
%     for SPFeatureMethod={'2' '3'}
%         Args.foldername_experiment =['color' colorspace{1} '_feature' SPFeatureMethod{1} '_' datestr(now,'ddHHMMSS')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end



%% evolution_ACMGMMandSPsemisupervised_2 �� ��ͬ�����µ�����������
% Args=setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder_1
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for SPFeatureMethod = {'2' '3'}
%         Args.SPFeatureMethod = SPFeatureMethod{1};
%         for colorspace={'LAB' 'HSV'}
%             Args.colorspace=colorspace{1};
%             for timestep=[0.1 0.3]
%                 Args.timestep=timestep;
%                 for weight_feature=[0.00 0.01 0.10 0.25 0.50 0.75 0.90 0.99 1.00]
%                     Args.weight_feature = weight_feature;
%                     for beta=[0.0 0.3 5.0]
%                         Args.beta=beta;
%                         for gamma=[0.0 0.3 5.0]
%                             Args.gamma=gamma;
%                             Args.foldername_experiment =['ACMGMMsemi' '_init' num2str(i) '_feature' num2str(Args.SPFeatureMethod) '_color' num2str(Args.colorspace) '_timestep' num2str(Args.timestep) '_wf' num2str(Args.weight_feature) '_beta' num2str(Args.beta) '_gamma' num2str(Args.gamma)];
%                             Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                             segmentation_func(Args);
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end



%% end
text=['����ȫ��������ϡ�'];
sp.Speak(text);















