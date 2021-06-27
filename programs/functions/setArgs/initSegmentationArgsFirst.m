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
    
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K\original resources';
Args.folderpath_EachImageInitBaseFolder = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
Args.folderpath_ResultsBaseFolder = '.\data\resources\MSRA1K\segmentations';

Args.evolutionMethod = 'semiACMGMMSP_1_2' ;	% ѡ���ݻ�ģ��

Args.markType = 'scribble' ;	% ѡ�������ͣ���ʾ��ʲô���͵Ľ���ʽ��ǽ��зָ��ѡ 'original' 'contour' 'scribble'��'original' ��ʾ���ý���ʽ��ǣ�ֱ����ԭͼ��'contour' ��ʾ�ñ�ķ�ʽ��ʼ��������ͼ��Ϊ��ʼ����'scribble' ��ʾ�ý���ʽ
Args.initMethod = 'scribbled_kmeans' ; % ѡ���ʼ�����ͣ���ʾ��ʲô���͵ĳ�ʼ����������ѡ 'circle' 'kmeans' 'kmeans+ACMGMM' 'circle+ACMGMM'
Args.maxIterOfKmeans = 100; % �� k-means ��ʼ����ʱ���������������


Args.isNotVisiualEvolutionAtAll = 'yes' ; % �������й������Ƿ���ȫ�����ӻ��м���̺ͱ����м����ͼ ����� 'yes'����ô�Ͳ����ӻ��ͱ����м����ͼ��Ĭ�� 'yes'
Args.isVisualEvolution = 'no' ;	% �������й������Ƿ���ӻ���ʾ���ͼ���������ս��ͼ����Ҫ���ӻ��ͱ���ġ�Ĭ�� 'no'
Args.isVisibleVisualEvolution = 'off' ;  % % �������й������Ƿ���ӻ���ʾ���ͼ�����ǽ��ͼ����Ҫ����ġ�Ĭ�� 'off'
Args.periodOfVisual = 1 ;	% ���ӻ���ʾ���ͼ�ĵ����������ڣ���ÿ��������ʾһ�ν��ͼ��Ĭ�� 10

Args.isNotWriteDataAtAll = 'yes' ; % �������й����в����Ľ�������Ƿ񱣴棬��� 'yes'����ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
Args.isWriteData = 'no' ;		% �������й����в����Ľ�������Ƿ񱣴棬�������ս�����ݻ���Ҫ����ġ�Ĭ�� 'no'
Args.periodOfWriteData = 1 ; % д���ݵĵ����������ڣ���ÿ����������һ�γ������й����в�������һ�������ݡ�Ĭ�� 10

Args.isTestOnlyFewImages = 'no' ; % ÿ�ַ����Ƿ����е�ʱ��ֻ����ǰ����ͼ������Ϊ���ԡ�Ĭ�� 'no'��
Args.numImagesToTest = 20 ; % ÿ�ַ����������ݿ��ǰ����ͼ��Ĭ�� 3, 10��

Args.isRunArrayProcessedImages = 'no' ; % ÿ�ַ����Ƿ�ֻ�������������һ����ͼ��
Args.arrayProcessedImages = [3] ; % ÿ�ַ������е�ʱ�򣬴����������һ����ͼ��

Args.isVoice = 'no' ;		% �������й������Ƿ�������ʾ��Ĭ�� 'no'

Args.circleRadius = 100 ; % setting radius of contour circle if you use SDF to initiate a phi function

% ����ͣ������
Args.proportionPixelsToEndLoop = 0.00100 ; % �����ݻ�ѭ��ֹͣ���������������ڵ���֮�䣬ǰ�������������ı������ռ�������������ı���ֵС���趨ֵʱ��ֹͣ��ֵ��[0,1]��Ĭ�� 0.00100 ��
Args.numIteration_inner=1 ;				% ��ѭ��������default = 1
Args.iteration_inner=1 ;						% ��ѭ����ʼֵ��default = 1
Args.numIteration_outer= 1000  ;		% ��ѭ��������default = 1000
Args.iteration_outer=1 ;						% ��ѭ����ʼֵ��default = 1
Args.numTime = 3.0 ;			% ÿ��ͼ��������̶�ʱ�䣬����������ʱ�����ڸõ�������֮��ֹͣѭ����

Args.outputMode = 'datatime';	% ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index' ��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime' ���Ƽ���Ĭ��ֵ��

Args.numUselessFiles = 0;   % ��ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų������ļ������������Ǵ˹�����bug��

% �Ƿ��������²����д�̽��
% �����ĳ�ʼ��
% ��������һ��ʽ��ʼ����'BOX'��'USER' ����ѡ��һ��
Args.contourType='USER';
Args.boxWidth=20;
Args.contoursInitValue =1 ;    % the value used for initialization contours.
Args.isMinMaxInitContours = 'yes';   % �Ƿ�����ˮƽ��Ƕ�뺯���ĳ�ʼ������ֵ
Args.contoursInitMinValue = -1;   % ˮƽ����ʼǶ�뺯��������ֵ��
Args.contoursInitMaxValue = 1;   % ˮƽ����ʼǶ�뺯��������ֵ��

Args.smallNumber=realmin+1E-20;  % ������ӵķ�ֹ�������������С����
