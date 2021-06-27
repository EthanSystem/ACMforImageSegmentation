function [ output_args ] = setArgsReference( input_args )
%SETARGS �˴���ʾ�йش˺�����ժҪ
%   will be useless in future version.

%% �û������ʼ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args �ṹ������ֶα�ʾ��������ǰ�ֶ����õĲ���

% ѡ���ݻ�ģʽ
...'ACMandSemisupervised'       ���� [1] �������뽻��ʽ���·���
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
    Args.evolutionMethod = 'ACMandSemisupervised' ;	% ѡ���ݻ�ģ��

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


end

