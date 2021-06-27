%% ���ڷָ��������
% ʵ��3�����볬�������İ�ලACMGMM��ʵ��ϵ�У�����1000��ͼ��

%% ע�����
% �ֶ����ļ��С�ACM����Ϊ��ǰ�ļ��С��ֶ���������ļ��С�functions������projects���������ļ������·����

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



%% %%%% ��ʼȫ�������� %%%%%%
initSegmentationArgsFirst;


%% %%%%% ����ʵ��ĳ�ʼ������ %%%%%%%%%%%%%%%%%%%

%% ·��������
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K\original resources';
folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\segmentations' ;

Args.markType='scribble';

Args.timestep=0.1;  % time step, default = 0.10
Args.numIteration_outer= 1000  ;		% ��ѭ��������default = 1000
Args.smallNumber=realmin + 1E-20;  % ������ӵķ�ֹ�������������С����



%% %%%%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%

%% ʹ�� ACMGMMandSPsemisupervised_1 ����
Args.evolutionMethod = 'semiACMGMMSP_1';

%% ACMGMMandSPsemisupervised_1 ��������
% probability term
Args.timestep=0.10 ;  % time step, default = 0.10
Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
Args.lambda = 1.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.

% ���ֵĳ����صı߳�
Args.SuperPixels_lengthOfSide = 10 ;

% ���ֵĳ����صĹ����
Args.SuperPixels_regulation = 1.0 ;

% ��ɫ�����ӺͿռ������ӵ�Ȩ��
Args.weight_feature = 0.5;  % Ȩ��ֵ ��ʾ��ɫ�����ӵ�Ȩ��ֵ��(1-Ȩ��ֵ) ��ʾ�ռ������ӵ�Ȩ��ֵ

% number of nearest neighbors . ���鲻Ҫ��ֵ̫��Ŀǰ�ĳ���û�иĽ����������ױ���
Args.numNearestNeighbors = 10;



% ��ɫ�ռ�
% ��ѡֵ�� 'RGB' 'LAB' 'HSV' ����֮һ
Args.colorspace='RGB';
% �������������ͣ�'SP'��'DEF'��'SP DEF'����ѡһ
Args.forceType= 'SP DEF';
% ѡ����㳬���������ķ���������ѡ���У� '1' ~ '5'
Args.SPFeatureMethod = '3' ;

% ���²���Ҫ��
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
Args.piType = '2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
Args.initializeType = 'staircase' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
Args.contoursInitValue = 1 ;    % the value used for initialization contours.
Args.scaleOflabeledProbabilities = 2.0;  % ͼ����б�������ĸ���ֵ��δ��������ĸ���ֵ�����ֵ����Сֵ����Ҫ��С���ı���ֵ��Ĭ������ 2.0 ����


% ���²��ܸ�
Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��

% % �Ƿ���ӻ��Ŀ���
Args.isVisualEvolution='no';
Args.isVisualSegoutput='no';
Args.isVisualSPDistanceMat='no';
Args.isVisualProbability='no';
Args.isVisualSspc='no';

Args.isVisual_f_data='no';
Args.isVisualLabels='no';


%% ACMGMMandSP_semisupervised_1  �ڲ�ͬͣ��������
Args=setSegmentationMethod(Args, Args.evolutionMethod);
i=0;
for init=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(init{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=init{1};
    for endloop=[0.00100 0.00030 0.00010]
        Args.proportionPixelsToEndLoop = endloop;
        Args.foldername_experiment =['ACMGMMSPsemi_1_stable' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end

%% end
% text=['����ȫ��������ϡ�'];
% sp.Speak(text);















