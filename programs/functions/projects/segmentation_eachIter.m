%% ��飺
% ���ڶ�һ��ͼ���ò�ͬ�ķָ��㷨�ָ�ͼ��������Ӧ��������ں�������������ÿ�����е���һ�ַָ��㷨�ĸ�����һ�����ֵ����һ��ͼ��
% Reference :
...Guowei Gao ,Chenglin Wen ,Huibin Wang, Fast and robust image segmentation with active contours and Student's-t mixture model
	
...��Դ���� resources �ļ�����
	...������� results �ļ�����
	
%% ע�����
% �ֶ����ļ��С�ACM+GMM����Ϊ��ǰ�ļ��С��ֶ���������ļ��С�functions������projects���������ļ������·����


%% Ԥ����
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');
% addpath( genpath( '.' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���


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
	% 	...'LBF'							LBF���������ڲ�ɫͼ Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
...'LIF'								LIF���������ڲ�ɫͼ Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
	...'CVgray'											CVģ�ͷ�����reference: Chan, T.F. and L.A. Vese, Active contours without edges. IEEE Transactions on Image Processing, 2001. 10(2): p. 266-77.
	...'LBFgray'							LBF���������ڻҶ�ͼ Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
	...'LIFgray'								LIF���������ڻҶ�ͼ Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
	Args.evolutionMethod = 'ACMGMM' ;	% ѡ���ݻ�ģ��

Args.markType = 'contour' ;	% ѡ�������ͣ���ʾ��ʲô���͵Ľ���ʽ��ǽ��зָ��ѡ 'original' 'contour' 'scribble'��'original' ��ʾ���ý���ʽ��ǣ�ֱ����ԭͼ��'contour' ��ʾ�ñ�ķ�ʽ��ʼ��������ͼ��Ϊ��ʼ����'scribble' ��ʾ�ý���ʽ
Args.initMethod = 'circle+ACMGMM' ; % ѡ���ʼ�����ͣ���ʾ��ʲô���͵ĳ�ʼ����������ѡ 'circle' 'kmeans' 'kmeans+ACMGMM' 'circle+ACMGMM'
Args.maxIterOfKmeans = 100; % �� k-means ��ʼ����ʱ���������������

% Args.foldername_EachImageBaseFolder = '.\data\resources\temp_circleACMGMM_epsilon0.5_sigma0.3';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\temp_circleACMGMM_epsilon0.5_sigma0.3';
% Args.foldername_EachImageBaseFolder = '.\data\resources\temp_circle';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\temp_circle';
Args.foldername_EachImageBaseFolder = '.\data\resources\circleACMGMM_epsilon0.5_sigma0.3';
Args.foldername_ResultsBaseFolder = '.\data\segmentations\circleACMGMM_epsilon0.5_sigma0.3';
% Args.foldername_EachImageBaseFolder = '.\data\resources\circle';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\circle';

Args.isNotVisiualEvolutionAtAll = 'yes' ; % �������й������Ƿ���ȫ�����ӻ��м���̺ͱ����м����ͼ ��Ĭ�� 'yes'
Args.isVisualEvolution = 'no' ;	% �������й������Ƿ���ӻ���ʾ���ͼ���������ս��ͼ����Ҫ���ӻ��ͱ���ġ�Ĭ�� 'no'
Args.periodOfVisual = 10 ;	% ���ӻ���ʾ���ͼ�ĵ����������ڣ���ÿ��������ʾһ�ν��ͼ��Ĭ�� 10

Args.isNotWriteDataAtAll = 'yes' ; % �������й����в����Ľ�������Ƿ񱣴棬����ǣ���ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
Args.isWriteData = 'no' ;		% �������й����в����Ľ�������Ƿ񱣴棬�������ս�����ݻ���Ҫ����ġ�Ĭ�� 'no'
Args.periodOfWriteData = 1 ; % д���ݵĵ����������ڣ���ÿ����������һ�γ������й����в�������һ�������ݡ�Ĭ�� 10

Args.isVoice = 'no' ;		% �������й������Ƿ�������ʾ��Ĭ�� 'no'

Args.circleRadius=100; % setting radius of contour circle if you use SDF to initiate a phi function

% ����ͣ������
Args.proportionPixelsToEndLoop = 0.00100 ; % �����ݻ�ѭ��ֹͣ���������������ڵ���֮�䣬ǰ�������������ı������ռ�������������ı���ֵС���趨ֵʱ��ֹͣ��ֵ��[0,1]
Args.numIteration_inner=1 ;				% ��ѭ��������default = 1
Args.iteration_inner=1 ;						% ��ѭ����ʼֵ��default = 1
Args.numIteration_outer= 1000  ;		% ��ѭ��������default = 1000
Args.iteration_outer=1 ;						% ��ѭ����ʼֵ��default = 1
Args.numTime = 3.0 ;			% ÿ��ͼ��������̶�ʱ�䣬����������ʱ�����ڸõ�������֮��ֹͣѭ����

Args.outputMode = 'datatime';	% ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index' ��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime' ���Ƽ���Ĭ��ֵ��

Args.numUselessFiles = 0;   % ��ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų������ļ������������Ǵ˹�����bug��



switch Args.evolutionMethod
	case 'ACMGMM'
		% probability term
		Args.timestep=0.10;  % time step, default = 0.10
		Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
		Args.beta =0.50; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
		Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
		Args.sigma= 0.3;     % scale parameter in Gaussian kernel , default is 1.5 .
		Args.hsize= 15 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
		
		% ���²���Ҫ��
		Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
		Args.initializeType = 'user' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
		
		% ���²��ܸ�
		Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
		Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
		
		
		
	case 'ACMGMMpi1'
		% probability term
		Args.timestep=0.10;  % time step
		Args.epsilon = 0.05 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at [1].
		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
		
		% ���²���Ҫ��
		Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
		
		% ���²��ܸ�
		Args.piType='1';   % pi�����ͣ�'1' ��ʾʽ��(23)�����ġ�
		Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
		
		
		
	case 'ACMGMMpi2'
		% probability term
		Args.timestep=0.10;  % time step
		Args.epsilon = 1.00 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at [1].
		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
		
		% ���²���Ҫ��
		Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
		
		% ���²��ܸ�
		Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
		Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
		
		
	case 'ACMandGM'
		% probability term
		Args.timestep=0.10;  % time step
		Args.epsilon=1.00;		% papramater that specifies the width of the DiracDelta function. default=1.00.
		Args.mu = 1.0;			% coefficeient of the weighted probability term prob(phi).
		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.00 .
		
		% ���²���Ҫ��
		Args.heavisideFunctionType = '2'; % ѡ��heaviside���������ͣ�default = '2'
		Args.initializeType = 'user' ;		% ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
		Args.contoursInitValue = 2;			% ��ʼ��������ֵ������ѡ���˲����Զ�����״���ݶ�����������ʼ��������Ч��
		
		% ���²��ܸ�
		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		Args.numOfComponents = 1;	% ���е�GMM��֦�����ڱ��㷨��=1���ڱ�������֦������1������������GMM��һ����ʾǰ����һ����ʾ������������������Ͳ������������
		
		
		
		
	case 'CV'
		Args.timestep = 0.10;	% time step .default=0.1.
		Args.epsilon = 0.5;			% papramater that specifies the width of the Heaviside function. default = 1.
		Args.lambda1 = 1;		% coefficeient of the weighted fitting term default=1.0.
		Args.lambda2 = 1;		% coefficeient of the weighted fitting term default=1.0.
		Args.beta =0.50;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.06*255*255
		Args.gamma = 0 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
		
		% ���²���Ҫ��
		Args.heavisideFunctionType = '2'; % heaviside����������
		Args.initializeType = 'user' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% ���²��ܸ�
		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
		
		
	case 'GMM'
		% ���²��ܸ�
		Args.numOfComponents = 2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
		Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		Args.initializeType = 'no' ;
		
		
	case 'LBF'
		Args.timestep = 0.1;	% time step .default=0.1.
		Args.epsilon = 1.00;		% papramater that specifies the width of the Heaviside function. default = 1.
		Args.mu = 1;	%���Ʒ��ž��뺯��Ȩֵ��default =1.0
		Args.lambda1 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
		Args.lambda2 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
		Args.beta = 2.0;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255^255
		Args.sigma= 3.0;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
		Args.hsize=round(2*Args.sigma)*2+1 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
		% ���²���Ҫ��
		Args.heavisideFunctionType = '2'; % heaviside����������
		Args.initializeType = 'user' ;
		% 'user' ��ʾ���Զ����������ɽ�Ծ����
		% 'SDF' ��ʾ�þ�����뺯��
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% ���²��ܸ�
		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
		
		
		
		
		
	case 'LBFgray'
		Args.timestep = 0.1;	% time step .default=0.1.
		Args.epsilon = 1.00;		% papramater that specifies the width of the Heaviside function. default = 1.
		Args.mu = 1;	%���Ʒ��ž��뺯��Ȩֵ��default =1.0
		Args.lambda1 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
		Args.lambda2 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
		Args.beta =0.001*255*255;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255^255
		Args.sigma= 3.0;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
		Args.hsize=round(2*Args.sigma)*2+1 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
		% ���²���Ҫ��
		Args.heavisideFunctionType = '2'; % heaviside����������
		Args.initializeType = 'user' ;
		% 'user' ��ʾ���Զ����������ɽ�Ծ����
		% 'SDF' ��ʾ�þ�����뺯��
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% ���²��ܸ�
		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
	case 'LIF'
		% ������1
		Args.timestep = 0.1;	% time step . default=0.005.
		Args.epsilon = 0.5 ;		% papramater that specifies the width of the Heaviside function. default = 1.
		Args.mu = 1;	%���Ʒ��ž��뺯��Ȩֵ��default =1.0
		Args.beta =0.5;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255*255
		Args.sigma= 0.3 ;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
		Args.hsize=5.0 ;			% ��˹�˲�����ģ���С��default=15, also means 15 x 15.
		Args.sigma_phi = 1.0 ; % the variance of regularized Gaussian kernel
		Args.hsize_phi = 5.0 ; % ��˹�˲�����ģ���С��default=5.
		% ���²���Ҫ��
		Args.heavisideFunctionType = '2'; % heaviside����������
		Args.initializeType = 'user' ;
		% 'user' ��ʾ���Զ����������ɽ�Ծ����
		% 'SDF' ��ʾ�þ�����뺯��
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% ���²��ܸ�
		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		% 		% ������2
		% 		Args.timestep = 0.1;	% time step . default=0.005.
		% 		Args.epsilon = 1.00 ;		% papramater that specifies the width of the Heaviside function. default = 1.
		% 		Args.mu = 1;	%���Ʒ��ž��뺯��Ȩֵ��default =1.0
		% 		Args.beta =2;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255^255
		% 		Args.sigma= 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
		% 		Args.hsize=05 ;			% ��˹�˲�����ģ���С��default=15, also means 15 x 15.
		% 		Args.sigma_phi = 0.5 ; % the variance of regularized Gaussian kernel
		% 		Args.hsize_phi = 5.0 ; % ��˹�˲�����ģ���С��default=5.
		% 		% ���²���Ҫ��
		% 		Args.heavisideFunctionType = '2'; % heaviside����������
		% 		Args.initializeType = 'user' ;
		% 		% 'user' ��ʾ���Զ����������ɽ�Ծ����
		% 		% 'SDF' ��ʾ�þ�����뺯��
		%
		% 		Args.contoursInitValue = 2;    % the value used for initialization contours.
		%
		% 		% ���²��ܸ�
		% 		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
		
		
	case 'LIFgray'
		Args.timestep = 0.1;	% time step . default=0.005.
		Args.epsilon = 1.00 ;		% papramater that specifies the width of the Heaviside function. default = 1.
		Args.mu = 1;	%���Ʒ��ž��뺯��Ȩֵ��default =1.0
		Args.beta =2;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255^255
		Args.sigma= 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
		Args.hsize=15;			% ��˹�˲�����ģ���С��default=15 or 2*round(2*Args.sigma)*2+1, also means 15 x 15.
		Args.sigma_phi = 1.5 ; % the variance of regularized Gaussian kernel
		Args.hsize_phi = 5.0 ; % ��˹�˲�����ģ���С��default=5.
		% ���²���Ҫ��
		Args.heavisideFunctionType = '2'; % heaviside����������
		Args.initializeType = 'user' ;
		% 'user' ��ʾ���Զ����������ɽ�Ծ����
		% 'SDF' ��ʾ�þ�����뺯��
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% ���²��ܸ�
		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
	case 'ACMandGMMtoEq18'
		Args.timestep = 0.10;  % time step
		Args.epsilon = 0.05; % papramater that specifies the width of the DiracDelta function.
		Args.mu = 1.0;  % coefficeient of the weighted probability term prob(phi).
		Args.beta = 0.50; % coefficeient of the weighted length term L(phi). default=0.5.
		Args.gamma = 0.00;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
		Args.heavisideFunctionType = '2'; % ѡ��heaviside����������
		
		% ���²��ܸ�
		Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		Args.initializeType = 'SDF' ;		% ѡ��Ƕ�뺯����ʼ����ʽ
		Args.contoursInitValue = 2;   % the value used for initialization contours.
		Args.numOfComponents = 2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
		
		
		
		
	case 'CVgray'
		Args.timestep = 0.10 ;	% time step .default=0.1.
		Args.epsilon = 1 ;			% papramater that specifies the width of the Heaviside function. default = 1.
		Args.lambda_1 = 1 ;		% coefficeient of the weighted fitting term default=1.0.
		Args.lambda_2 = 1 ;		% coefficeient of the weighted fitting term default=1.0.
		Args.beta = 0.50 ;		% coefficeient of the weighted length term L(phi). default=0.5. ��or also 0.06*255^2
		Args.gamma = 0.00 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
		
		% ���²���Ҫ��
		Args.heavisideFunctionType = '2' ; % heaviside����������
		Args.initializeType = 'SDF'  ;
		Args.contoursInitValue = 2 ;    % the value used for initialization contours.
		
		% ���²��ܸ�
		Args.isNeedInitializingContourByLSMethod = 'yes' ;  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		
		
		
		
	case 'DRLSE'
		Args.timestep=5.0;  % time step. default is 5.0
		
		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
		Args.initializeType = 'user' ;
		Args.contoursInitValue = 2;		% the value used for initialization contours.
		
		Args.heavisideFunctionType = '3'; % heaviside���������� .default is '3'
		Args.mu=0.2/Args.timestep;  % coefficient of the distance regularization term R(phi) , default is 0.2/Args.timestep or 0.04.
		Args.lambda=5.0; % coefficient of the weighted length term L(phi) , default is 5.0 .
		Args.alfa=1.5;  % coefficient of the weighted area term A(phi) , default is 1.50 .
		Args.epsilon=1.5; % papramater that specifies the width of the DiracDelta function, default is 1.50 .
		Args.sigma=1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
		Args.hsize=15 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
		
		% potential function
		% use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model
		% or use double-well potential in Eq. (16), which is good for both edge and region based models
		% or use default choice of potential function .
		Args.potentialFunction = 'double-well';
		
		
		
		
	otherwise
		error('error at choose evolution method !');
end










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ���������ļ���resource�Ľṹ��EachImage �͹����洢����ʵ���results�ļ�������ļ�·�������ƵĽṹ�� Results
Args % ��ӡ Args
Pros = Args; % ��Args���еĵ�һϵ�в�������Pros



EachImage = createEachImageStructure(Pros.foldername_EachImageBaseFolder, Pros.numUselessFiles);

input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ����������������� Ctrl+c ��ֹ����')
% indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% indexOfBwImageFolder = findIndexOfFolderName(EachImage, 'bw images');
% indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth bw images');
% indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');



Results = createResultsStructure(Pros.foldername_ResultsBaseFolder ,Pros.numUselessFiles);




% for numTime = [0.1,0.2,0.6,0.7,0.8,0.9]

%% ��������ʵ����ļ��У�������ʵ��
Pros.foldername_eachIndexOfExperiment=dir(Results.folderpath_outputBase);	% ÿ��ʵ����ļ����б�
% num_experiment=length(Pros.foldername_eachIndexOfExperiment)-2;
Pros.index_experiment=Results.num_experiments+1;

% �����������ļ���
switch Pros.outputMode
	case 'datatime'
		% ����һ������Ϊ������ʱ����������ļ�������ÿһ�ε�ʵ������
		switch Pros.evolutionMethod
			case 'GMM'
				Pros.foldername_experiment=[Pros.evolutionMethod '_numState' num2str(Pros.numOfComponents) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
				% 				Pros.foldername_experiment=[datestr(now,'ddHHMMSS') '_' Pros.evolutionMethod '_numState' num2str(Pros.numOfComponents) '_numIter' num2str(Pros.numIteration_outer) '_end' num2str(Pros.proportionPixelsToEndLoop)];
				% 				Pros.foldername_experiment=[datestr(now,'ddHHMMSS') '_' Pros.evolutionMethod '_numState' num2str(Pros.numOfComponents) '_numTime' num2str(Pros.numTime) '_end' num2str(Pros.proportionPixelsToEndLoop)];
			case 'CV'
				Pros.foldername_experiment=[Pros.evolutionMethod '_step' num2str(Pros.timestep) '_beta' num2str(Pros.beta) '_epsilon' num2str(Pros.epsilon) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
			otherwise
				Pros.foldername_experiment=[Pros.evolutionMethod '_step' num2str(Pros.timestep) '_beta' num2str(Pros.beta) '_epsilon' num2str(Pros.epsilon) '_hsize' num2str(Pros.hsize) '_sigma' num2str(Pros.sigma) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
				% 				Pros.foldername_experiment=[datestr(now,'ddHHMMSS') '_' Pros.evolutionMethod '_beta' num2str(Pros.beta) '_init' Pros.initializeType '_numIter' num2str(Pros.numIteration_outer) '_end' num2str(Pros.proportionPixelsToEndLoop)];
				% 				Pros.foldername_experiment=[datestr(now,'ddHHMMSS') '_' Pros.evolutionMethod '_beta' num2str(Pros.beta) '_init' Pros.initializeType '_numTime' num2str(Pros.numTime) '_end' num2str(Pros.proportionPixelsToEndLoop)];
		end
	case 'index'
		Pros.foldername_experiment = ['��' num2str(index_experiment) '��ʵ��'];
end
Pros.folderpath_experiment=fullfile(Results.folderpath_outputBase, Pros.foldername_experiment);
mkdir(Pros.folderpath_experiment);

% ����diary����ļ���
Pros.foldername_diary = 'diary output';
Pros.folderpath_diary = fullfile(Pros.folderpath_experiment, Pros.foldername_diary);
if ~exist(Pros.folderpath_diary,'dir')
	mkdir(Pros.folderpath_diary );
end

%% ���� diary ��¼
Pros.filepath_diary = fullfile(Pros.folderpath_diary , ['diary.txt']);
diary(Pros.filepath_diary);
diary on;
Args % ��ӡ Args

% ѡ����Ҫ��markType
switch Pros.markType
	case 'scribble'
		num_processedImages = EachImage.num_scribbledImage;
	case 'contour'
		num_processedImages = EachImage.num_contourImage;
	case 'original'
		num_processedImages = EachImage.num_originalImage;
	otherwise
		error('error at choose mark type !');
end



% ��������ÿ�����ͼ��֮���Args��Ϣ�ļ���·��
Pros.folderpath_ArgsOutput = fullfile(Pros.folderpath_experiment, 'Args output');
if ~exist(Pros.folderpath_ArgsOutput ,'dir');
	mkdir(Pros.folderpath_ArgsOutput);
end

% ���շָ��ֵͼ��ͼ�ļ���·��
Pros.folderpath_bwImage = fullfile(Pros.folderpath_experiment, 'bw images');
if ~exist(Pros.folderpath_bwImage,'dir')
	mkdir(Pros.folderpath_bwImage);
end

% ���շָ��ֵͼ�����ļ���·��
Pros.folderpath_bwData = fullfile(Pros.folderpath_experiment, 'bw data');
if ~exist(Pros.folderpath_bwData,'dir')
	mkdir(Pros.folderpath_bwData);
end

% ����Ƕ�뺯�������ļ���·��
Pros.folderpath_phiData = fullfile(Pros.folderpath_experiment, 'phi data');
if ~exist(Pros.folderpath_phiData,'dir')
	mkdir(Pros.folderpath_phiData);
end

% ��������ÿ�����ͼ��֮�����������ļ���·��
Pros.folderpath_writeData=fullfile(Pros.folderpath_experiment, 'write data');
if ~exist(Pros.folderpath_writeData,'dir')
	mkdir(Pros.folderpath_writeData);
end

% ��������ÿ�����ͼ��֮��Ľ��ͼ�ļ���·��
Pros.folderpath_screenShot=fullfile(Pros.folderpath_experiment, 'screen shot');
if ~exist(Pros.folderpath_screenShot,'dir')
	mkdir(Pros.folderpath_screenShot);
end
% ��������ÿ�����ͼ��ı�����������ļ���·��
Pros.folderpath_seeds=fullfile(Pros.folderpath_experiment, 'seeds data');
if ~exist(Pros.folderpath_seeds,'dir')
	mkdir(Pros.folderpath_seeds);
end

% ��������ÿ�����ͼ��֮����������ָ�� time �� iteration �������ļ���·��
Pros.folderpath_evaluation=fullfile(Pros.folderpath_experiment, 'evaluation data');
if ~exist(Pros.folderpath_evaluation,'dir')
	mkdir(Pros.folderpath_evaluation);
end

% ��ʼ��¼��ʱ��
startTotalTime = clock;
totalIteration = 0;
elipsedTime = 0;




elipsedEachTime.name=cell(num_processedImages,1);
elipsedEachTime.time =zeros(num_processedImages,1);
elipsedEachTime.iteration = zeros(num_processedImages,1);

for index_processedImage = 1:num_processedImages
	disp(['����ͼ��' num2str(index_processedImage) '/' num2str(num_processedImages)]);
	
	Pros.iteration_inner=Args.iteration_inner;
	Pros.iteration_outer=Args.iteration_outer;
	
	switch Pros.markType
		case 'scribble'
			markTypeName = 'Ϳѻ';
			Pros.filename_processedImage = EachImage.scribbledImage(index_processedImage).name;
			Pros.filepath_processedImage = EachImage.scribbledImage(index_processedImage).path;
			index_originalImage = findIndexOfOriginalImageAtEachScribbledImage(EachImage, index_processedImage, 'mark');
			
		case 'contour'
			markTypeName = '����';
			Pros.filename_processedImage =EachImage.contourImage(index_processedImage).name;
			Pros.filepath_processedImage =EachImage.contourImage(index_processedImage).path;
			index_originalImage = findIndexOfOriginalImageAtEachContourImage(EachImage, index_processedImage, 'contour');
			% ��ȡ��ʼ��������������Ϣ����ֵ��Э����
			Pros.filename_Prior = EachImage.prior(index_processedImage).name;
			Pros.filepath_Prior = EachImage.prior(index_processedImage).path;
			load(Pros.filepath_Prior);
			Pros.filename_mu = EachImage.mu(index_processedImage).name;
			Pros.filepath_mu = EachImage.mu(index_processedImage).path;
			load(Pros.filepath_mu);
			Pros.filename_Sigma = EachImage.Sigma(index_processedImage).name;
			Pros.filepath_Sigma = EachImage.Sigma(index_processedImage).path;
			load(Pros.filepath_Sigma);
			% ��ȡ��ʼ�������ĺķ�ʱ��
			Pros.filename_time= EachImage.time(index_processedImage).name;
			Pros.filepath_time = EachImage.time(index_processedImage).path;
			load(Pros.filepath_time);
			Pros.elipsedEachTime = time0;
			% ��ȡ��ʼ�������ĳ�ʼˮƽ��Ƕ�뺯��phi0
			Pros.filename_phi= EachImage.phi(index_processedImage).name;
			Pros.filepath_phi= EachImage.phi(index_processedImage).path;
			load(Pros.filepath_phi);
			
			
		case 'original'
			markTypeName = 'ԭͼ';
			Pros.filename_processedImage = EachImage.originalImage(index_processedImage).name;
			Pros.filepath_processedImage =EachImage.originalImage(index_processedImage).path;
			index_originalImage = index_processedImage;
			
			
		otherwise
			error('error at choose mark type !');
	end
	
	% �������� Pros
	Pros.filename_originalImage =  EachImage.originalImage(index_originalImage).name; % ԭʼͼ������;
	Pros.filepath_originalImage =EachImage.originalImage(index_originalImage).path;
	Pros.filename_ArgsOutput = [Pros.filename_processedImage(1:end-4) '_Args.mat'];
	Pros.filepath_ArgsOutput = fullfile(Pros.folderpath_ArgsOutput, Pros.filename_ArgsOutput);
	Pros.filename_bwImage = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_bwImage.bmp'];
	Pros.filepath_bwImage = fullfile(Pros.folderpath_bwImage, Pros.filename_bwImage);
	Pros.filename_bwData = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_bwData.mat'];
	Pros.filepath_bwData = fullfile(Pros.folderpath_bwData, Pros.filename_bwData);
	Pros.filename_phiData = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_phiData.mat'];
	Pros.filepath_phiData = fullfile(Pros.folderpath_phiData, Pros.filename_phiData);
	Pros.filename_writeData =  [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_ExportData.mat'];
	Pros.filepath_writeData = fullfile(Pros.folderpath_writeData, Pros.filename_writeData);
	Pros.index_exportData = 1;
	
	
	%% ��ʼ������
	text = ['��ʼͼ�� ' Pros.filename_originalImage ' ��' markTypeName ' ' Pros.filename_processedImage ' ��ʵ��...'];
	if strcmp(Pros.isVoice,'yes')==1
		sp.Speak(text);
	end
	disp(text);
	
	
	%% ��ȡͼ����ʾ
	image010_original = imread(Pros.filepath_originalImage);
	image010_processed = imread(Pros.filepath_processedImage);
	
	%% ��ʾArgs
	% ����Ҫ��ӡ����Ļ����Ϣ
	Args.originalImageName =Pros.filename_originalImage ;
	Args.processedImageNmae = Pros.filename_processedImage ;
	Args.nameOfExperiment =Pros.foldername_experiment ;
	Pros.Args = Args; % �����յ�Args����Pros�����ڴ洢Args������
	disp(['ԭʼͼ��' Args.originalImageName]) % ����Ļ���ԭʼͼ������
	disp(['����ͼ��' Args.processedImageNmae]) % ����Ļ�������ͼ������
	
	% properties setting
	Pros.sizeOfImage=[size(image010_original)];
	Pros.numData = Pros.sizeOfImage(1).*Pros.sizeOfImage(2);
	Pros.numPixelChangedToContinue = Pros.proportionPixelsToEndLoop.*Pros.numData;	% ͣ������֮һ�����ݻ������������������֮���ǰ�����ĸı����������С�����ֵ�����������ѭ��
	
	
	%
	% 		%% initializing a contour of image
	% 			switch Pros.initMethod
	% 				case 'circle'
	% 					% ��һ����ԲȦ���ɾ�����뺯��
	% 					Pros.circleCenterX=Pros.sizeOfImage(1)/2;
	% 					Pros.circleCenterY=Pros.sizeOfImage(2)/2;
	% 					phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
	%
	% 				otherwise
	% 			end
	%
	
	
	%% start level set evolution
	switch Pros.evolutionMethod
		case 'ACMGMM'
			%% ACM&GMM new�� ���[1] Guowei Gao���˵ķ���������ˮƽ���ݻ������������ʽ(25)
			% �����ݻ�һ���õ���һ������
			[ Pros, phi] = evolution_ACMandGMMnew_pi2(Pros,  image010_original, image010_processed, phi0, Prior0, mu0, Sigma0);
			
		case 'ACMGMMpi1'
			%% ACM&GMM pi 1�����[1] Guowei Gao���˵ķ���������ˮƽ���ݻ������������ʽ(23)
			% �����ݻ�һ���õ���һ������
			[ Pros, phi] = evolution_ACMandGMM_pi1(Pros,  image010_original, image010_processed);
			
		case 'ACMGMMpi2'
			%% ACM&GMM pi 2�����[1] Guowei Gao���˵ķ���������ˮƽ���ݻ������������ʽ(25)
			% �����ݻ�һ���õ���һ������
			[ Pros, phi] = evolution_ACMandGMM_pi2(Pros,  image010_original, image010_processed);
			
		case 'ACMandGM'
			%% ACM&GM�� [5]�ڶ��ڵķ���������ˮƽ���ݻ�
			[ Pros, phi ] = evolution_ACMandGM(Pros,  image010_original, image010_processed, phi0);
			
		case 'CV'
			%% CV��ʹ����չ����ɫ�ռ��CVģ�͵ķ���������ˮƽ���ݻ�
			%   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
			%   Author: Chunming Li, all right reserved
			%   email: li_chunming@hotmail.com
			%   URL:   http://www.engr.uconn.edu/~cmli
			[ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV(Pros,  image010_original, image010_processed, phi0);   % update level set function
			
			
		case 'CVgray'
			%% CV gray��ʹ�ô�ͳ�Ĵ���Ҷ�ͼ���CVģ�͵ķ���������ˮƽ���ݻ�
			%   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
			%   Author: Chunming Li, all right reserved
			%   email: li_chunming@hotmail.com
			%   URL:   http://www.engr.uconn.edu/~cmli
			[ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV_gray(Pros,  image010_original, image010_processed, phi0);   % update level set function
			
			
		case 'GMM'
			%% GMM��ʹ��GMM�Ķ���ָ�
			[Pros, phi] = evolution_GMM(Pros, image010_original, image010_processed, Prior0, mu0, Sigma0);
			
		case 'ACMandGMMtoEq18'
			%% ACMandGMMtoEq18���˷����ǽ��[1]�ķ��������ǲ��������(23)(25)ʽ��������Ϣ����ֻ�õ�(18)��
			% �����ݻ�һ���õ���һ������
			[Pros, phi ] = evolution_ACMandGMMtoEq18(Pros,  image010_original, image010_processed);
			
			
			
		case 'LBF'
			%% LBF��ʹ�øĽ�Ϊ�����ɫͼ���LBF����������ˮƽ���ݻ�
			%�����������ݻ�ˮƽ��������������£�C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation.
			%IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
			%phiΪˮƽ��������IΪͼ��,KsigmaΪ�˺���,nu����Ȩֵ,timestepʱ�䲽��,mu���ž��뺯��Ȩֵ
			%lambda1��lambda2ΪȨֵ��epsilon���ƽ�Ծ�ͳ������
			%By Liushigang.
			[ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF(Pros, image010_original, image010_processed, phi0);
			
			
		case 'LBFgray'
			%% LBF gray��ʹ�ô�ͳ�Ĵ���Ҷ�ͼ���LBF����������ˮƽ���ݻ�
			%�����������ݻ�ˮƽ��������������£�C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation.
			%IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
			%phiΪˮƽ��������IΪͼ��,KsigmaΪ�˺���,nu����Ȩֵ,timestepʱ�䲽��,mu���ž��뺯��Ȩֵ
			%lambda1��lambda2ΪȨֵ��epsilon���ƽ�Ծ�ͳ������
			%By Liushigang.
			[ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF_gray(Pros, image010_original, image010_processed, phi0);
			
			
		case 'LIF'
			%% LIF��ʹ�øĽ�Ϊ�����ɫͼ���LIF����������ˮƽ���ݻ�
			% This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
			%    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
			% Author: Kaihua Zhang, all rights reserved
			% E-mail: zhkhua@mail.ustc.edu.cn
			% http://www4.comp.polyu.edu.hk/~cslzhang/
			%  Notes:
			%   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
			%   2. Intial contour should be set properly.
			[ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LIF(Pros, image010_original, image010_processed, phi0);
			
			
		case 'LIFgray'
			%% LIF gray��ʹ�ô�ͳ�Ĵ���Ҷ�ͼ���LIF����������ˮƽ���ݻ�
			% This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
			%    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
			% Author: Kaihua Zhang, all rights reserved
			% E-mail: zhkhua@mail.ustc.edu.cn
			% http://www4.comp.polyu.edu.hk/~cslzhang/
			%  Notes:
			%   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
			%   2. Intial contour should be set properly.
			[ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LIF_gray(Pros, image010_original, image010_processed, phi0);
			
			
		case 'DRLSE'
			%% DRLSE��ʹ�������DRLSE�ķ���������ˮƽ���ݻ�
			%% generate edge indicator function.
			
			image010_gray =256.* image010_processed(:,:,1);
			G=fspecial('gaussian',Args.hsize ,Args.sigma);
			image010_smooth=conv2(image010_gray,G,'same');  % smooth image by Gaussiin convolution
			[Ix,Iy]=gradient(image010_smooth);
			f=Ix.^2+Iy.^2;
			g=1./(1+f);  % edge indicator function.
			
			% ��ʼ������
			phi = phi0;
			
			[Pros, phi] = visualizeContours_DRLSE( phi, image010_original, image010_data, Pros,Results );
			
			while Pros.iteration_outer<=Args.numIteration_outer
				%% �����ݻ�һ���õ���һ������
				[Pros, phi] = evolution_DRLSE( phi, g, Args,Pros );
				
				%% visualization
				Pros = visualizeContours_DRLSE( phi, image010,Args,Pros,Results );
				%%
				Pros.iteration_outer=Pros.iteration_outer+1;
			end
			
			
		otherwise
			error('error at choose evolution method !');
	end  % end this evolution method
	
	%% ��ʱÿ��ͼ����ʱ��
	elipsedEachTime(index_processedImage).name = Pros.filename_originalImage(1:end-4) ;
	elipsedEachTime(index_processedImage).time = Pros.elipsedEachTime;
	elipsedEachTime(index_processedImage).iteration = Pros.iteration_outer-1;
	elipsedTime = elipsedTime+elipsedEachTime(index_processedImage).time ;
	remainingTime = (elipsedTime/index_processedImage)*(num_processedImages - index_processedImage);
	totalIteration = totalIteration+Pros.iteration_outer-1;
	disp(['����ͼ����ʱ�䣺 ' num2str(elipsedEachTime(index_processedImage).time) ' ��'])
	disp(['�ݻ������� ' num2str(elipsedEachTime(index_processedImage).iteration)])
	disp(['Ԥ��ʣ��ʱ�䣺 ' num2str(remainingTime) ' ��'])
	
	%% д���ؼ�������
	Pros.filename_bwImageEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod  '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_bwImage.bmp'];
	Pros.filepath_bwImageEnd = fullfile(Pros.folderpath_bwImage, Pros.filename_bwImageEnd);
	Pros.filename_bwDataEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_bwData.mat'];
	Pros.filepath_bwDataEnd = fullfile(Pros.folderpath_bwData, Pros.filename_bwDataEnd);
	Pros.filename_phiDataEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_phiData.mat'];
	Pros.filepath_phiDataEnd = fullfile(Pros.folderpath_phiData, Pros.filename_phiDataEnd);
	
	% д������Ƕ�뺯������
	phiData = reshape(phi,  Pros.sizeOfImage(1), Pros.sizeOfImage(2));
	%     save(Pros.filepath_phiDataEnd,'phiData');
	if exist(Pros.filepath_phiDataEnd,'file')
		disp(['�ѱ�������Ƕ�뺯������ ' Pros.filename_phiDataEnd]);
	else
		disp(['δ��������Ƕ�뺯������ ' Pros.filename_phiDataEnd]);
	end
	
	% ����\phi �ָ�õ��Ķ�ֵͼ����
	bwData=zeros(Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	bwData(phiData>=0)=1;
	bwData = im2bw(bwData);
	% �������շָ��ֵͼ
	imwrite(bwData, Pros.filepath_bwImageEnd,'bmp');
	if exist(Pros.filepath_bwImage,'file')
		disp(['�ѱ������շָ��ֵͼ ' Pros.filename_bwImageEnd]);
	else
		disp(['δ�������շָ��ֵͼ ' Pros.filename_bwImageEnd]);
	end
	% д�����շָ��ֵͼ����
	%     save(Pros.filepath_bwDataEnd,'bwData');
	%     if exist(Pros.filepath_bwDataEnd,'file')
	%         disp(['�ѱ������շָ��ֵͼ���� ' Pros.filename_bwDataEnd]);
	%     else
	%         disp(['δ�������շָ��ֵͼ���� ' Pros.filename_bwDataEnd]);
	%     end
	
	
	disp(' ')
	
	%% �洢 Args
	Args.realTime = elipsedEachTime(index_processedImage).time;
	Args.iterations =  elipsedEachTime(index_processedImage).iteration;
	save(Pros.filepath_ArgsOutput, 'Args'); % ����Args��mat�ļ�
	
end % end this marked image

%% save data of elipsed total time and average iteration and each elipsed time and iteration.
averageIteration = totalIteration/num_processedImages;
Pros.filepath_elipsedEachTime = fullfile(Pros.folderpath_evaluation , ['time' num2str(elipsedTime) '_iter' num2str(averageIteration) '.mat']);
% Pros.filepath_elipsedEachTime = fullfile(Pros.folderpath_evaluation , ['time.mat']);
elipsedEachTime=struct2table(elipsedEachTime);
save(Pros.filepath_elipsedEachTime,'elipsedEachTime');
disp(' ')

%% �����������
elapsedTotalTime = etime(clock,startTotalTime);
disp(['ƽ���ݻ������� ' num2str(averageIteration)])
disp(['����ʱ�䣺' num2str(elapsedTotalTime) '�롣'])
text=['����������ϡ�'];
% text=['����������ϡ�����ʱ�䣺' num2str(elapsedTotalTime) '�롣'];
disp(text);
sp.Speak(text);

%% ֹͣ��¼����������������ݲ�����
diary off;





