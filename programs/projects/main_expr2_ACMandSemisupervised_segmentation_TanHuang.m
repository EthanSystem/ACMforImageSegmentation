%% ���ڷָ��������
% Ŀ����̽��̷��ʦ��������ķָ�Ч����ʲô����Ӱ��϶ࣿ


%% �û������ʼ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args �ṹ������ֶα�ʾ��������ǰ�ֶ����õĲ���

% ѡ���ݻ�ģʽ
...'ACMGMM'		����[1]���·���
    ... 'ACMGMMpi1'                          ����[1]�ķ����ı��ֵĵ�һ��������Ϣ�ļ��㷽ʽ
    ...'ACMGMMpi2'					����[1]�ķ����ı��ֵĵڶ���������Ϣ�ļ��㷽ʽ
    ...'ACMandGM'							��ʦ�ṩ�ĵڶ��²��ֵķ���������
    ...'ACMandGMMtoEq18'                      ���[1]�ķ��������ǲ��������(23)(25)ʽ��������Ϣ����ֻ�õ�(18)
    ...'GMM'										GMM �Ĵ�ͳ����
    ...'DRLSE'									    DRLSEģ�͡��˷����������ṩ C. Li, C. Xu, C. Gui, M. D. Fox, "Distance Regularized Level Set Evolution and Its Application to Image Segmentation", IEEE Trans. Image Processing, vol. 19 (12), pp.3243-3254, 2010....�ķ���
    ...'CV'											CVģ�ͷ��������ڲ�ɫͼ��Chan, T. F. and B. Y. Sandberg, et al. (2000). "Active Contours without Edges for Vector-Valued Images." Journal of Visual Communication and Image Representation 11 (2): 130-141.
    ...'LBF'							LBF���������ڲ�ɫͼ Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
    ...'LIF'								LIF���������ڲ�ɫͼ Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
    ...'CVgray'											CVģ�ͷ�����reference: Chan, T.F. and L.A. Vese, Active contours without edges. IEEE Transactions on Image Processing, 2001. 10(2): p. 266-77.
    ...'LBFgray'							LBF���������ڻҶ�ͼ Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
    ...'LIFgray'								LIF���������ڻҶ�ͼ Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
    
% Args.folderpath_EachImageResourcesBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\original resources';
% Args.folderpath_EachImageInitBaseFolder = '.\candidate\init resources';
% Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\segmentations';
% 
% Args.evolutionMethod = 'semiACMGMM' ;	% ѡ���ݻ�ģ��
% 
% Args.markType = 'scribble' ;	% ѡ�������ͣ���ʾ��ʲô���͵Ľ���ʽ��ǽ��зָ��ѡ 'original' 'contour' 'scribble'��'original' ��ʾ���ý���ʽ��ǣ�ֱ����ԭͼ��'contour' ��ʾ�ñ�ķ�ʽ��ʼ��������ͼ��Ϊ��ʼ����'scribble' ��ʾ�ý���ʽ
% Args.initMethod = 'scribbled_kmeans' ; % ѡ���ʼ�����ͣ���ʾ��ʲô���͵ĳ�ʼ����������ѡ 'circle' 'kmeans' 'kmeans+ACMGMM' 'circle+ACMGMM'
% Args.maxIterOfKmeans = 100; % �� k-means ��ʼ����ʱ���������������
% 
% 
% Args.isNotVisiualEvolutionAtAll = 'yes' ; % �������й������Ƿ���ȫ�����ӻ��м���̺ͱ����м����ͼ ����� 'yes'����ô�Ͳ����ӻ��ͱ����м����ͼ��Ĭ�� 'yes'
% Args.isVisualEvolution = 'no' ;	% �������й������Ƿ���ӻ���ʾ���ͼ���������ս��ͼ����Ҫ���ӻ��ͱ���ġ�Ĭ�� 'no'
% Args.isVisibleVisualEvolution = 'off' ;  % % �������й������Ƿ���ӻ���ʾ���ͼ�����ǽ��ͼ����Ҫ����ġ�Ĭ�� 'off'
% Args.periodOfVisual = 1 ;	% ���ӻ���ʾ���ͼ�ĵ����������ڣ���ÿ��������ʾһ�ν��ͼ��Ĭ�� 10
% 
% Args.isNotWriteDataAtAll = 'yes' ; % �������й����в����Ľ�������Ƿ񱣴棬��� 'yes'����ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
% Args.isWriteData = 'no' ;		% �������й����в����Ľ�������Ƿ񱣴棬�������ս�����ݻ���Ҫ����ġ�Ĭ�� 'no'
% Args.periodOfWriteData = 1 ; % д���ݵĵ����������ڣ���ÿ����������һ�γ������й����в�������һ�������ݡ�Ĭ�� 10
% 
% Args.isTestOnlyFewImages = 'yes' ; % ÿ�ַ����Ƿ����е�ʱ��ֻ����ǰ����ͼ������Ϊ���ԡ�Ĭ�� 'no'��
% Args.numImagesToTest = 10; % ÿ�ַ����������ݿ��ǰ����ͼ��Ĭ�� 3, 10��
% 
% Args.isVoice = 'no' ;		% �������й������Ƿ�������ʾ��Ĭ�� 'no'
% 
% Args.circleRadius=100; % setting radius of contour circle if you use SDF to initiate a phi function
% 
% % ����ͣ������
% Args.proportionPixelsToEndLoop = 0.001000 ; % �����ݻ�ѭ��ֹͣ���������������ڵ���֮�䣬ǰ�������������ı������ռ�������������ı���ֵС���趨ֵʱ��ֹͣ��ֵ��[0,1]
% Args.numIteration_inner=1 ;				% ��ѭ��������default = 1
% Args.iteration_inner=1 ;						% ��ѭ����ʼֵ��default = 1
% Args.numIteration_outer= 1000  ;		% ��ѭ��������default = 1000
% Args.iteration_outer=1 ;						% ��ѭ����ʼֵ��default = 1
% Args.numTime = 3.0 ;			% ÿ��ͼ��������̶�ʱ�䣬����������ʱ�����ڸõ�������֮��ֹͣѭ����
% 
% Args.outputMode = 'datatime';	% ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index' ��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime' ���Ƽ���Ĭ��ֵ��
% 
% Args.numUselessFiles = 0;   % ��ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų������ļ������������Ǵ˹�����bug��
% 
% Args.initialzeType = 'staircase'; % ��ʼ�����ǽ�Ծ����
% 
% case 'ACM_semisupervised_HuangTan'
% Args.timestep=5;  % time step, default = 5
% Args.lambda =  5;  % lambda: coefficient of the weighted length term L(\phi)
% Args.mu =  0.2/Args.timestep;  %   mu: coefficient of the internal (penalizing) energy term P(\phi)
% Args.alf = 1.5; %   alf: coefficient of the weighted area term A(\phi), choose smaller alf
% Args.epsilon = 1.5 ; %   epsilon: the papramater in the definition of smooth Dirac function, default value is 1.5
% Args.weight_Eacm = 10 ;  % weight of new regulation term, default value is 10
% Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
% Args.hsize= 15 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
% 
% Args.initializeType ='staircase'; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
% Args.contoursInitValue = 4 ;    % the value used for initialization contours.


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



%% ACM_semisupervised_HuangTan �� ��ͬ��ʼ�������¡���ͬ Eacm ��Ȩ����
% ���÷ָ��
Args.evolutionMethod='semiACM_HuangTan';
% ��ʼ���ָ���Ĳ���
Args=initSegmentationMethod(Args, Args.evolutionMethod);
% ��ʼ������
for i=folderpath_EachImageInitBaseFolder_1
    if isempty(i{1})
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=i{1};
    for j=[1,100,1000]
        Args.weight_Eacm = j;
        Args.foldername_experiment =[Args.evolutionMethod '_weightEacm_' num2str(Args.weight_Eacm) '_' datestr(now,'ddHHMMSS')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end





%% end
text=['����ȫ��������ϡ�'];
sp.Speak(text);





