function [Args] = initSegmentationMethod(Args, evolutionMethod )
% setEvolutionMethod ����ָ���ķ����Ĳ�����
% input:
% Args:
% evolutionMethod:
% output:
% Args:

%   �˴���ʾ��ϸ˵��
Args.evolutionMethod = evolutionMethod;
switch Args.evolutionMethod
    
    case 'semiACMGMMSP_2'
        %% parameters settings
        % probability term
        Args.timestep=0.10 ;  % time step, default = 0.10
        Args.epsilon = 0.1 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta =0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.lambda = 3.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
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
%         % ��˹�˴������
%         Args.Sigma1=0.15;
        
        
        
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
        Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
        Args.initializeType = 'staircase' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        Args.scaleOflabeledProbabilities = 2.0;  % ͼ����б�������ĸ���ֵ��δ��������ĸ���ֵ�����ֵ����Сֵ����Ҫ��С���ı���ֵ��Ĭ������ 2.0 ����
        Args.numIteration_SP = 3 ;  % �����ؼ����ݻ�ѭ��������Ĭ��Ϊ 3
        
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
        
        
    case 'semiACMGMMSP_2_2'
        %% parameters settings
        % probability term
        Args.timestep=0.10 ;  % time step, default = 0.10
        Args.epsilon = 0.1 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta =0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.lambda = 3.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
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
%         % ��˹�˴������
%         Args.Sigma1=0.15;
        
        
        
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
        Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
        Args.initializeType = 'staircase' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        Args.scaleOflabeledProbabilities = 2.0;  % ͼ����б�������ĸ���ֵ��δ��������ĸ���ֵ�����ֵ����Сֵ����Ҫ��С���ı���ֵ��Ĭ������ 2.0 ����
        Args.numIteration_SP = 3 ;  % �����ؼ����ݻ�ѭ��������Ĭ��Ϊ 3
        
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
        
    case 'semiACMGMMSP_1'
        %% parameters settings
        % probability term
        Args.timestep=0.10 ;  % time step, default = 0.10
        Args.epsilon = 0.2 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.lambda = 5.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
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
%         % ��˹�˴������
%         Args.Sigma1=0.15;
        
        
        
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
        
    case 'semiACMGMMSP_1_2'
        %% parameters settings
        % probability term
        Args.timestep=0.10 ;  % time step, default = 0.10
        Args.epsilon = 0.2 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.lambda = 5.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
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
%         % ��˹�˴������
%         Args.Sigma1=0.15;
        
        
        
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
        
        
    case 'semiACMGMM'
        %% ACM_semisupervised
        % probability term
        Args.timestep=0.10;  % time step, default = 0.10
        Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
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
        
        
    case 'semiACMGMM_Eacm'
        %% ACMGMM_semisupervised_Eacm
        % probability term
        Args.timestep=0.1;  % time step, default = 0.10
        Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta =0.5; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.nu = 10; % coefficient of the weighted E_ACM term. default=10;
        Args.sigma= 0.3;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
        
        % ���²���Ҫ��
        Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
        Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
        %         Args.initializeType = 'staircase' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'staircase' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
        Args.scaleOflabeledProbabilities = 2.0;  % ͼ����б�������ĸ���ֵ��δ��������ĸ���ֵ�����ֵ����Сֵ����Ҫ��С���ı���ֵ��Ĭ������ 2.0 ����
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        Args.isMinMaxInitContours = 'yes';   % �Ƿ�����ˮƽ��Ƕ�뺯���ĳ�ʼ������ֵ
        Args.contoursInitMinValue = -1;   % ˮƽ����ʼǶ�뺯��������ֵ��
        Args.contoursInitMaxValue = 1;   % ˮƽ����ʼǶ�뺯��������ֵ��
        
        % ���²��ܸ�
        Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
        Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        
        
        
    case 'semiACM_Eacm'
        %% TODO
        
        
        
    case 'semiACM_HuangTan'
        %% TODO
        Args.timestep=5;  % time step, default = 5
        Args.lambda =  5;  % lambda: coefficient of the weighted length term L(\phi)
        Args.mu =  0.2/Args.timestep;  %   mu: coefficient of the internal (penalizing) energy term P(\phi)
        Args.alf = 1.5; %   alf: coefficient of the weighted area term A(\phi), choose smaller alf
        Args.epsilon = 1.5 ; %   epsilon: the papramater in the definition of smooth Dirac function, default value is 1.5
        Args.weight_Eacm = 10 ;  % weight of new regulation term, default value is 10
        Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 15 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
        
        Args.initializeType ='staircase'; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
        Args.contoursInitValue = 4 ;    % the value used for initialization contours.
        
    case 'ACM_SP'
        %% parameters settings
        % ���ֵĳ����صı߳�
        Args.SuperPixels_lengthOfSide=20;
        % ���ֵĳ����صĹ����
        Args.SuperPixels_regulation=1.0;
        % �����ӵ�ֱ��ͼ������
        Args.numBins=16;
        % ��ɫ�����ӺͿռ������ӵ�Ȩ��
        Args.weight_feature = 0.5;  % Ȩ��ֵ ��ʾ��ɫ�����ӵ�Ȩ��ֵ��(1-Ȩ��ֵ) ��ʾ�ռ������ӵ�Ȩ��ֵ
        
        % number of nearest neighbors . ���鲻Ҫ��ֵ̫��Ŀǰ�ĳ���û�иĽ����������ױ���
        Args.numNearestNeighbors=10;
        % ��˹�˴������
        Args.Sigma1=0.15;
        
        Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
        
        
        % ��ɫ�ռ�
        % ��ѡֵ�� 'RGB' 'LAB' 'HSV' ����֮һ
        Args.colorspace='LAB';
        % �������������ͣ�'SP'��'DEF'��'SP DEF'����ѡһ
        Args.forceType= 'SP DEF';
        
        % ˮƽ���ݻ�����
        % �ݻ�����ֵ
        Args.timestep= 1.0; % time step
        Args.epsilon= 1.5; % the papramater in the definition of smoothed Dirac function
        Args.mu= 0.2/Args.timestep;  % coefficient of the internal (penalizing) energy term P(\phi)
        Args.lambda=5; % coefficient of the weighted length term Lg(\phi)
        Args.alpha=1.5; % coefficient of the weighted area term Ag(\phi);
        Args.weight_Fdata = 1.0 ; % coefficeint of the weighted F_data term;
        
        
        
        
        % �Ƿ��������²����д�̽��
        % �����ĳ�ʼ��
        % ��������һ��ʽ��ʼ����'BOX'��'USER' ����ѡ��һ��
        Args.contourType='USER';
        Args.boxWidth=20;
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        Args.isMinMaxInitContours = 'yes';   % �Ƿ�����ˮƽ��Ƕ�뺯���ĳ�ʼ������ֵ
        Args.contoursInitMinValue = -1;   % ˮƽ����ʼǶ�뺯��������ֵ��
        Args.contoursInitMaxValue = 1;   % ˮƽ����ʼǶ�뺯��������ֵ��
        
        % % �Ƿ���ӻ��Ŀ���
        Args.isVisualEvolution='no';
        Args.isVisualSegoutput='no';
        Args.isVisualSPDistanceMat='no';
        Args.isVisualProbability='no';
        Args.isVisualSspc='no';
        
        Args.isVisual_f_data='no';
        Args.isVisualLabels='no';
        
        
        
        
    case 'ACMGMM'
        % probability term
        Args.timestep=0.1;  % time step, default = 0.10
        Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta =0.5; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
        
        % ���²���Ҫ��
        Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
        Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
        Args.initializeType = 'staircase' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        
        % ���²��ܸ�
        Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
        Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        
        
    case 'CV'
        Args.timestep = 0.10;	% time step .default=0.1.
        Args.epsilon = 0.5;			% papramater that specifies the width of the Heaviside function. default = 1.
        Args.lambda1 = 1;		% coefficeient of the weighted fitting term default=1.0.
        Args.lambda2 = 1;		% coefficeient of the weighted fitting term default=1.0.
        Args.beta =0.50;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.06*255*255
        Args.gamma = 0 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
        
        % ���²���Ҫ��
        Args.heavisideFunctionType = '2'; % heaviside����������
        Args.initializeType = 'staircase' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
        Args.contoursInitValue = 1;    % the value used for initialization contours.
        
        % ���²��ܸ�
        Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        
        
        
        % 	case 'ACMGMMpi1'
        % 		% probability term
        % 		Args.timestep=0.10;  % time step
        % 		Args.epsilon = 0.05 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at [1].
        % 		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
        % 		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
        % 		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
        %
        % 		% ���²���Ҫ��
        % 		Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
        %
        % 		% ���²��ܸ�
        % 		Args.piType='1';   % pi�����ͣ�'1' ��ʾʽ��(23)�����ġ�
        % 		Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        %
        %
        %
        %
        %
        % 	case 'ACMGMMpi2'
        % 		% probability term
        % 		Args.timestep=0.10;  % time step
        % 		Args.epsilon = 1.00 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at [1].
        % 		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
        % 		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
        % 		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
        %
        % 		% ���²���Ҫ��
        % 		Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
        %
        % 		% ���²��ܸ�
        % 		Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
        % 		Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        %
        %
        %
        %
        % 	case 'ACMandGM'
        % 		% probability term
        % 		Args.timestep=0.10;  % time step
        % 		Args.epsilon=1.00;		% papramater that specifies the width of the DiracDelta function. default=1.00.
        % 		Args.mu = 1.0;			% coefficeient of the weighted probability term prob(phi).
        % 		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
        % 		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.00 .
        %
        % 		% ���²���Ҫ��
        % 		Args.heavisideFunctionType = '2'; % ѡ��heaviside���������ͣ�default = '2'
        % 		Args.initializeType = 'user' ;		% ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
        % 		Args.contoursInitValue = 2;			% ��ʼ��������ֵ������ѡ���˲����Զ�����״���ݶ�����������ʼ��������Ч��
        %
        % 		% ���²��ܸ�
        % 		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        % 		Args.numOfComponents = 1;	% ���е�GMM��֦�����ڱ��㷨��=1���ڱ�������֦������1������������GMM��һ����ʾǰ����һ����ʾ������������������Ͳ������������
        
        
        
    case 'GMM'
        % ���²��ܸ�
        Args.numOfComponents = 2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
        Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        Args.initializeType = 'no' ;
        
        % 	case 'LBF'
        % 		Args.timestep = 0.1;	% time step .default=0.1.
        % 		Args.epsilon = 1.00;		% papramater that specifies the width of the Heaviside function. default = 1.
        % 		Args.mu = 1;	%���Ʒ��ž��뺯��Ȩֵ��default =1.0
        % 		Args.lambda1 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.lambda2 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.beta = 2.0;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255^255
        % 		Args.sigma= 3.0;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
        % 		Args.hsize=round(2*Args.sigma)*2+1 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
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
        %
        %
        %
        %
        %
        %
        %
        % 	case 'LBFgray'
        % 		Args.timestep = 0.1;	% time step .default=0.1.
        % 		Args.epsilon = 1.00;		% papramater that specifies the width of the Heaviside function. default = 1.
        % 		Args.mu = 1;	%���Ʒ��ž��뺯��Ȩֵ��default =1.0
        % 		Args.lambda1 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.lambda2 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.beta =0.001*255*255;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255^255
        % 		Args.sigma= 3.0;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
        % 		Args.hsize=round(2*Args.sigma)*2+1 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
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
        
        
    case 'LIF'
        % ������1
        Args.timestep = 0.050;	% time step . default=0.005.
        Args.epsilon = 1.0 ;		% papramater that specifies the width of the Heaviside function. default = 1.
        Args.beta = 0.5;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255*255
        Args.sigma = 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
        Args.hsize = 15.0 ;			% ��˹�˲�����ģ���С��default=15, also means 15 x 15.
        Args.sigma_phi = 1.0 ; % the variance of regularized Gaussian kernel
        Args.hsize_phi = 5.0 ; % ��˹�˲�����ģ���С��default=5.
        % ���²���Ҫ��
        Args.heavisideFunctionType = '2'; % heaviside����������
        Args.initializeType = 'staircase' ;
        % 'user' ��ʾ���Զ����������ɽ�Ծ����
        % 'SDF' ��ʾ�þ�����뺯��
        
        Args.contoursInitValue = 1;    % the value used for initialization contours.
        
        % ���²��ܸ�
        Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        
        
        
        
        
        
        % 	case 'LIFgray'
        % 		Args.timestep = 0.1;	% time step . default=0.005.
        % 		Args.epsilon = 1.00 ;		% papramater that specifies the width of the Heaviside function. default = 1.
        % 		Args.mu = 1;	%���Ʒ��ž��뺯��Ȩֵ��default =1.0
        % 		Args.beta =2;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255^255
        % 		Args.sigma= 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
        % 		Args.hsize=15;			% ��˹�˲�����ģ���С��default=15 or 2*round(2*Args.sigma)*2+1, also means 15 x 15.
        % 		Args.sigma_phi = 1.5 ; % the variance of regularized Gaussian kernel
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
        %
        %
        % 	case 'ACMandGMMtoEq18'
        % 		Args.timestep = 0.10;  % time step
        % 		Args.epsilon = 0.05; % papramater that specifies the width of the DiracDelta function.
        % 		Args.mu = 1.0;  % coefficeient of the weighted probability term prob(phi).
        % 		Args.beta = 0.50; % coefficeient of the weighted length term L(phi). default=0.5.
        % 		Args.gamma = 0.00;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
        % 		Args.heavisideFunctionType = '2'; % ѡ��heaviside����������
        %
        % 		% ���²��ܸ�
        % 		Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        % 		Args.initializeType = 'SDF' ;		% ѡ��Ƕ�뺯����ʼ����ʽ
        % 		Args.contoursInitValue = 2;   % the value used for initialization contours.
        % 		Args.numOfComponents = 2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
        %
        %
        %
        %
        % 	case 'CVgray'
        % 		Args.timestep = 0.10 ;	% time step .default=0.1.
        % 		Args.epsilon = 1 ;			% papramater that specifies the width of the Heaviside function. default = 1.
        % 		Args.lambda_1 = 1 ;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.lambda_2 = 1 ;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.beta = 0.50 ;		% coefficeient of the weighted length term L(phi). default=0.5. ��or also 0.06*255^2
        % 		Args.gamma = 0.00 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
        %
        % 		% ���²���Ҫ��
        % 		Args.heavisideFunctionType = '2' ; % heaviside����������
        % 		Args.initializeType = 'SDF'  ;
        % 		Args.contoursInitValue = 2 ;    % the value used for initialization contours.
        %
        % 		% ���²��ܸ�
        % 		Args.isNeedInitializingContourByLSMethod = 'yes' ;  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        %
        %
        %
        %
        % 	case 'DRLSE'
        % 		Args.timestep=5.0;  % time step. default is 5.0
        %
        % 		Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
        % 		Args.initializeType = 'user' ;
        % 		Args.contoursInitValue = 2;		% the value used for initialization contours.
        %
        % 		Args.heavisideFunctionType = '3'; % heaviside���������� .default is '3'
        % 		Args.mu=0.2/Args.timestep;  % coefficient of the distance regularization term R(phi) , default is 0.2/Args.timestep or 0.04.
        % 		Args.lambda=5.0; % coefficient of the weighted length term L(phi) , default is 5.0 .
        % 		Args.alfa=1.5;  % coefficient of the weighted area term A(phi) , default is 1.50 .
        % 		Args.epsilon=1.5; % papramater that specifies the width of the DiracDelta function, default is 1.50 .
        % 		Args.sigma=1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
        % 		Args.hsize=15 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
        %
        % 		% potential function
        % 		% use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model
        % 		% or use double-well potential in Eq. (16), which is good for both edge and region based models
        % 		% or use default choice of potential function .
        % 		Args.potentialFunction = 'double-well';
        
        
    otherwise
        error('error at choose evolution method !');
end

end

