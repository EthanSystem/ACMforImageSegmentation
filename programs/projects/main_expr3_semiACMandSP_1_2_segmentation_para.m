%% ���ڷָ��������
% ʵ��3�����볬�������İ�ලACMGMM��ʵ��ϵ�У�
% semiACMandSP_1_2 ��������

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



%% %%%% ��ʼȫ�������� %%%%%%
initSegmentationArgsFirst;
Args.timestep=0.10;  % time step, default = 0.10
Args.numIteration_outer = 1000  ;		% ��ѭ��������default = 1000
Args.smallNumber=realmin + 1E-20;  % ������ӵķ�ֹ�������������С����
Args.proportionPixelsToEndLoop = 0.00010 ; % �����ݻ�ѭ��ֹͣ���������������ڵ���֮�䣬ǰ�������������ı������ռ�������������ı���ֵС���趨ֵʱ��ֹͣ��ֵ��[0,1]��Ĭ�� 0.00100 ��
Args.isNotWriteDataAtAll = 'yes' ; % �������й����в����Ľ�������Ƿ񱣴棬��� 'yes'����ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
Args.periodOfWriteData = 1 ; % д���ݵĵ����������ڣ���ÿ����������һ�γ������й����в�������һ�������ݡ�Ĭ�� 10


%% ·��������
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K 10 images\original resources';

folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K 10 images\init resources\scribbled_circle_SDF_kmeans100_2';

Args.folderpath_ResultsBaseFolder = '.\data\expr3_semiACMGMMSP_1_2_para\oldSP_one' ;

Args.markType='scribble';


%% %%%%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%

%% ʹ�� ACMGMMandSPsemisupervised_1 ����
Args.evolutionMethod = 'semiACMGMMSP_1_2';

%% ACMGMMandSPsemisupervised_1 ��������
% probability term
Args.timestep = 0.10 ;  % time step, default = 0.10
Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
Args.lambda = 1.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
Args.sigma = 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize = 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.

% ���ֵĳ����صı߳�
Args.SuperPixels_lengthOfSide = 15 ;

% ���ֵĳ����صĹ����
Args.SuperPixels_regulation = 1.0 ;

% ��ɫ�����ӺͿռ������ӵ�Ȩ��
Args.weight_feature = 1.0;  % Ȩ��ֵ ��ʾ��ɫ�����ӵ�Ȩ��ֵ��(1-Ȩ��ֵ) ��ʾ�ռ������ӵ�Ȩ��ֵ

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


%% %%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%

%% ACMGMMandSPsemisupervised_1_2 ���Է���ר�� %%%%%%%%%%%%%%%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     Args.foldername_experiment =['semiACMGMMSP_1_2' '_' datestr(now,'ddHHMMSS')];
%     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%     segmentation_func(Args);
% end

%% ACMGMMandSPsemisupervised_1_2 �� ��ͬ�����µ�����������1 %%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for colorspace={'RGB' 'LAB' 'HSV'}
%         Args.colorspace=colorspace{1};
%         for SuperPixels_lengthOfSide=[5 15]
%             Args.SuperPixels_lengthOfSide=SuperPixels_lengthOfSide;
%             for SuperPixels_regulation=[1.00 0.85 0.50]
%                 Args.SuperPixels_regulation=SuperPixels_regulation;
%                 for lambda=[100.0 010.0 001.0 000.1 000.0]
%                     Args.lambda=lambda;
%                     Args.foldername_experiment =[...
%                         'semiSP_1' ...
%                         '_piType' Args.piType ...
%                         '_color' Args.colorspace ...
%                         '_SPsize' num2str(Args.SuperPixels_lengthOfSide) ...
%                         '_SPreg' num2str(Args.SuperPixels_regulation) ...
%                         '_step' num2str(Args.timestep) ...
%                         '_epsilon' num2str(Args.epsilon) ...
%                         '_lambda' num2str(Args.lambda)];
%                     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                     segmentation_func(Args);
%                 end
%             end
%         end
%     end
% end


%% ACMGMMandSPsemisupervised_1_2 �� ��ͬ�����µ�����������2 %%%%%%%%%%%%%%
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
%         for colorspace={'RGB' 'LAB'}
%             Args.colorspace=colorspace{1};
%             for SuperPixels_lengthOfSide=[5 15]
%                 Args.SuperPixels_lengthOfSide=SuperPixels_lengthOfSide;
%                 for epsilon=[1.00 0.50 0.20 0.10 0.05]
%                     Args.epsilon=epsilon;
%                     for lambda=[100.0 010.0 001.0 000.1 000.0]
%                         Args.lambda=lambda;
%                         Args.foldername_experiment =[...
%                             'semiSP_1' ...
%                             '_piType' Args.piType ...
%                             '_color' Args.colorspace ...
%                             '_SPsize' num2str(Args.SuperPixels_lengthOfSide) ...
%                             '_epsilon' num2str(Args.epsilon) ...
%                             '_lambda' num2str(Args.lambda)];
%                         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                         segmentation_func(Args);
%                     end
%                 end
%             end
%         end
%     end
% end
%


%% ACMGMMandSPsemisupervised_1_2 �� ��ͬ�����µ�����������3 %%%%%%%%%%%%%%
% i=0;
% idx_smallNumber=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for smallNumber=[realmin+1E-20 realmin+1E-25 realmin+1E-50 realmin+1E-100 realmin]
%         Args.smallNumber=smallNumber;
%         idx_smallNumber=idx_smallNumber+1;
%         for epsilon=[1.00 0.50 0.20]
%             Args.epsilon=epsilon;
%             for lambda=[010.0 001.0]
%                 Args.lambda=lambda;
%                 Args.foldername_experiment =[...
%                     'semiSP_1' ...
%                     '_smallNumber' num2str(idx_smallNumber) ...
%                     '_epsilon' num2str(Args.epsilon) ...
%                     '_lambda' num2str(Args.lambda)];
%                 Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                 segmentation_func(Args);
%             end
%         end
%     end
% end



%% ACMGMMandSPsemisupervised_1_2 �� ��ͬ�����µ�����������3 %%%%%%%%%%%%%%
i=0;
j=0;
idx_smallNumber=0;
for initMethod=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(initMethod{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=initMethod{1};
    for el=[0.00100 0.00030 0.00010]
        j=j+1;
        Args.proportionPixelsToEndLoop=el;
        for lambda=[010.0 001.0 000.1]
            Args.lambda=lambda;
            Args.foldername_experiment =[...
                'semiSP_1' ...
                '_el' num2str(j) ...
                '_lambda' num2str(Args.lambda) ...
                ] ;
            Args = setSegmentationMethod(Args, Args.evolutionMethod);
            segmentation_func(Args);
        end
    end
end



%% end
% text=['����ȫ��������ϡ�'];
% sp.Speak(text);















