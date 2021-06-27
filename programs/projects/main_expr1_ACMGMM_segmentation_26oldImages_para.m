%% ���ڷָ��������
% ʵ��1��ȫ�ලACMGMM��ʵ��ϵ�У�ACMGMM ���� 26 ��ԭ�����ĵ�ͼ��ĵ��Ρ�



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
Args.folderpath_EachImageResourcesBaseFolder = '.\data\expr1_ACMGMM_ԭ�����ĵ�ͼ\original resources';
folderpath_EachImageInitBaseFolder{1} = '.\data\expr1_ACMGMM_ԭ�����ĵ�ͼ\init resources\circle_SDF_kmeans100';
% folderpath_EachImageInitBaseFolder{3} = '.\data\resources\MSRA1K\init resources\kmeans100';
Args.folderpath_ResultsBaseFolder = '.\data\expr1_ACMGMM_ԭ�����ĵ�ͼ\segmentations' ;

Args.markType='contour';

Args.timestep=0.1;  % time step, default = 0.10
Args.numIteration_outer= 001000  ;		% ��ѭ��������default = 1000
Args.smallNumber=realmin + 1E-20;  % ������ӵķ�ֹ�������������С����



%% %%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%



%% ʹ�� ACMGMM ����
Args.evolutionMethod='ACMGMM';

%% ACMGMM ��������
% probability term
Args.timestep=0.1;  % time step, default = 0.10
Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta =0.5; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
Args.sigma= 0.3;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.

% ���²���Ҫ��
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
Args.initializeType = 'SDF' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
Args.contoursInitValue =1 ;    % the value used for initialization contours.

% ���²��ܸ�
Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��




%% ACMGMM  �ڲ�ͬͣ��������
Args = setSegmentationMethod(Args, Args.evolutionMethod);
i=0;
for init=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(init{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=init{1};
    for endloop=[0.0010 0.0003 0.0001]
        Args.proportionPixelsToEndLoop = endloop;
        for epsilon=[0.5 0.2]
            Args.epsilon = epsilon;
            for sigma=[1.5 0.3]
                Args.sigma = sigma;
                for hsize=[15 5]
                    Args.hsize = hsize;
                    Args.foldername_experiment =[ ...
                        'ACMGMM' ...
                        '_el' num2str(Args.proportionPixelsToEndLoop) ...
                        '_epsilon' num2str(Args.epsilon) ...
                        '_sigma' num2str(Args.sigma) ...
                        '_hsize' num2str(Args.hsize) ...
                        '_' datestr(now,'ddHHMM') ...
                        ];
                    Args = setSegmentationMethod(Args, Args.evolutionMethod);
                    segmentation_func(Args);
                end
            end
        end
    end
end


%
% %% ʹ�� CV ����
% Args.evolutionMethod='CV';
%
% %% CV ��������
% Args.timestep = 0.10;	% time step .default=0.1.
% Args.epsilon = 0.5;			% papramater that specifies the width of the Heaviside function. default = 1.
% Args.lambda1 = 1;		% coefficeient of the weighted fitting term default=1.0.
% Args.lambda2 = 1;		% coefficeient of the weighted fitting term default=1.0.
% Args.beta = 0.50;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.06*255*255
% Args.gamma = 0 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
%
% % ���²���Ҫ��
% Args.heavisideFunctionType = '2'; % heaviside����������
% Args.initializeType = 'SDF' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
%
% Args.contoursInitValue = 1;    % the value used for initialization contours.
%
% % ���²��ܸ�
% Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
%
% %% CV �ڲ�ͬͣ��������
% Args = setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for init=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(init{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=init{1};
%     for endloop=[0.00100 0.00030 0.00010]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =['CV' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end
%
% %% ʹ�� GMM ����
% Args.evolutionMethod='GMM';
%
% %% GMM ��������
% % ���²��ܸ�
% Args.numOfComponents = 2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
% Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
% Args.initializeType = 'no' ;
%
%
% %% GMM �ڲ�ͬͣ��������
% Args = setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for init=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(init{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=init{1};
%     for endloop=[0.00100 0.00030 0.00010]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =['GMM' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end
%
%
% %% ʹ�� LIF ����
% Args.evolutionMethod='LIF';
%
% %% LIF ��������
% % ������1
% Args.timestep = 0.050;	% time step . default=0.005.
% Args.epsilon = 1.0 ;		% papramater that specifies the width of the Heaviside function. default = 1.
% Args.beta = 0.5;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255*255
% Args.sigma = 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
% Args.hsize = 15.0 ;			% ��˹�˲�����ģ���С��default=15, also means 15 x 15.
% Args.sigma_phi = 1.0 ; % the variance of regularized Gaussian kernel
% Args.hsize_phi = 5.0 ; % ��˹�˲�����ģ���С��default=5.
% % ���²���Ҫ��
% Args.heavisideFunctionType = '2'; % heaviside����������
% Args.initializeType = 'staircase' ;
% % 'user' ��ʾ���Զ����������ɽ�Ծ����
% % 'SDF' ��ʾ�þ�����뺯��
%
% Args.contoursInitValue = 1;    % the value used for initialization contours.
%
% % ���²��ܸ�
% Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��
%
% %% LIF �ڲ�ͬͣ��������
% Args = setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for init=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(init{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=init{1};
%     for endloop=[0.00100 0.00030 0.00010]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =['LIF' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end









%% end
% text=['����ȫ��������ϡ�'];
% sp.Speak(text);















