%% ��飺
...��Դ���� resources �ļ�����
...���ӻ�������� results �ļ�����

%% ���飺
...������main�����EVOLUTION�����Ǿ������öϵ㣬�Ա�ÿһ����������ͣ�۲�����
...���·������Project_MATLAB�ĸ��ļ����С�
    
    %% ע������
...��������е�ʱ��������е�һ�δ���ͻȻ����
    ...����Ϊ�ڼ���k���ڵ�ʱ��ʵ�ʵ�ǰ�����߱���������С��k�������������±�����������µġ�
    ...Ŀǰ��Ӱ����ȷ��ʵ��������ʱ���޸���
...�����һЩ��ɫ�ռ����ʱ�����볢���޸� arguments.SuperPixels_lengthOfSide��arguments.SuperPixels_regulation�Ȳ�����



%%

% % ÿ������MATLAB��ֻ��Ҫ����һ�Ρ�
% VLROOTS='';
% run('C:\Softwares\VLFeat\toolbox\vl_setup');
% % vl_version verbose
% % addpath of vl-feat. the pathname may be different in different PC.



%% Main ����
clear all;
close all;
clc;
diary off;




%% parameters settings
% arguments �ֶα�ʾ��������ǰ�ֶ����õĲ���

% ����ĵڼ������飬���ڲ���һ���ļ��У���¼ʵ������ͼ
Args.howManyTimesOfExperiment = 4;

% ���ֵĳ����صı߳�
Args.SuperPixels_lengthOfSide=20;

% ���ֵĳ����صĹ����
Args.SuperPixels_regulation=1;

% �����ӵ�ֱ��ͼ������
Args.numBins=16;

% number of nearest neighbors . ���鲻Ҫ��ֵ̫��Ŀǰ�ĳ���û�иĽ����������ױ���
Args.numNearestNeighbors=10;

% ��˹�˴������
Args.Sigma1=10;

% ��ɫ�ռ�
% ��ѡֵ�� 'RGB' 'LAB' 'HSV' ����֮һ
Args.colorspace='RGB';

% �������������ͣ�'SP'��'DEF'��'SP DEF'����ѡһ
Args.fType='SP';

% ˮƽ���ݻ�����
% �ݻ�����ֵ
Args.timestep=5; % time step
Args.epsilon=1.5; % the papramater in the definition of smoothed Dirac function
Args.mu=0.2/Args.timestep;  % coefficient of the internal (penalizing) energy term P(\phi)
Args.lambda=5; % coefficient of the weighted length term Lg(\phi)
Args.alpha=1.5; % coefficient of the weighted area term Ag(\phi);

% �ݻ�����
Args.numIteration = 100;
Args.iteration = 1;

% ���ӻ���ʾ�ĵ�����������
Args.periodToVisual = 1;

% �����ĳ�ʼ��
% ��������һ��ʽ��ʼ����'BOX'��'USER' ����ѡ��һ��
Args.contourType='USER';
Args.contourIn0=5;
Args.boxWidth=20;


% �Ƿ���ӻ��Ŀ���
Args.isVisualEvolution='yes';
Args.isVisualSegoutput='yes';
Args.isVisualSPDistanceMat='yes';
Args.isVisualProbability='yes';
Args.isVisualSspc='yes';

Args.isVisual_f_data='yes';
Args.isVisualLabels='yes';





% ��ʾ
Args


%% ���������ļ���
str020=datestr(now,'yyyymmdd');
folderName020=(str020);
str025=num2str(Args.howManyTimesOfExperiment);     
folderName025=str025;
% folderName030=str030;   ����ɾ��
folderParentPath01=(['.\results\Export Data']);
folderPath01=([folderParentPath01,'\',folderName020,'\',folderName025]);
sentence015=(['mkdir(''',folderPath01,''');']);
eval(sentence015);


%% intialization
% properties �ֶα�ʾ���������в����Ĳ���ֵ
Pros.iteration = Args.iteration;
% �ļ�·��
Pros.folderpath = folderPath01;


%% create a image

image010=imread('.\data\resources\picture04.jpg');
% imshow(image01);

%% create sp by SLIC method .

Pros.sizeOfImg=size(image010);
image010=im2single(image010);  % ��һ����Ϊ�˺������ vl_slic(.)


% ѡȡ��ɫ�ռ�
try
    switch Args.colorspace
        case 'LAB'
            image020=rgb2lab(image010);
        case 'HSV'
            image020=rgb2hsv(image010);
        case 'RGB'
            image020=image010;
    end
catch
    disp('colorspace is wrong');
end


% ��vl-feat ���ĺ������ɳ����ء�Ĭ�����ã������ر߳�=20�������=1��
segments.value=vl_slic(image020, Args.SuperPixels_lengthOfSide, Args.SuperPixels_regulation);



%% extracting features of each HSV chanel in each SP .

% find the number of SP.
Pros.numSP=max(segments.value(:))+1;

% image02=uint8(256*image02);   % ת�� 256 uint

% �Ѷ�Ӧ�ڻ��ֳ����ĳ����ص� segments ��Ϊ��Ǹó����صļǺţ��� segments
% �������ҵ���Ӧ�ó����صļǺţ���Ӧͼ���HSVֵ���� imhist() ����ֱ��ͼ����histcounts()��Ϊ��ȡֱ��ͼ�����ݷ�����
% ��������� SuperPixels(i).histogram������ͨ��ֵ���С�

for i=1:1:Pros.numSP
    [row,col,val]=find(single(segments.value)==i-1);
    for j=1:1:length(row)
        SuperPixels(i).pos(j,1)=row(j);
        SuperPixels(i).pos(j,2)=col(j);
    end
    
    for j=1:length(row)
        SuperPixels(i).ColorSpace_value(j,:)=image020(row(j),col(j),:);
    end
end


for i=1:1:Pros.numSP
    if i==1500
        a=i;
    end
    
    [SuperPixels(i).histogram_channel1,~]=histcounts(SuperPixels(i).ColorSpace_value(:,1), Args.numBins);
    [SuperPixels(i).histogram_channel2,~]=histcounts(SuperPixels(i).ColorSpace_value(:,2), Args.numBins);
    [SuperPixels(i).histogram_channel3,~]=histcounts(SuperPixels(i).ColorSpace_value(:,3), Args.numBins);
    
end

%% calculate center point at SP .
Pros.SuperPixelsPos = computeSPCenterPoint(SuperPixels);

%% ���㡢���ӻ���ʾ�ָ�����
[segments.segOutline, segments.imgMarkup, segments.RGBImgMarkup]=...
    segoutput(image020, image010, segments.value, Args, Pros);

Pros.segOutline=segments.segOutline;


%% ѡȡ������֮��ľ����ȣ��������ӻ�
% ���Բ���ŷʽ�����Լ򻯼���
% ���ȣ����Ƕ��Ѿ���ȡͼ�����ͨ��ͼ���ֱ��ͼ��ȡĳ��ͨ����Ϊ������
...����ÿ��ͨ���ֱ���ŷʽ��ʽ�������
    ...�������������أ�Ȼ�������롣
    % �������ŷʽ�ľ���Ĺ�ʽ
[ SuperPixelsDistance ] = computeSPDistance( SuperPixels ,Args, Pros );

%% �������ڳ����ص��ݶ��½������̵����ݻ�
% ��paper��ĳ�����������F��



%% ��ʼ������
image010_contour=imread('.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_2\contour images\0_0_77_contour.bmp');
% image010_contour=rgb2gray(image010_contour);
[ initialContour ] = initialContour( image010_contour, Args, Pros);

%% initial level set evolution
if strcmp(Args.isVisualEvolution,'yes')==1
    numIter=1;   %  number of iterations.
    contours=initialContour;
    Pros.handle_figure_evolution = figure('name','evolution');
    % properties.handle_axes_evolution = axes;
    imagesc(image010);
    % hold(properties.handle_axes_evolution, 'on');
    hold on;
    [c,h] = contour(contours,[0 0],'m');
    hold off;
end



%% ��ָʾ������Ϊ�ⲿ�� F_data
% �ο����� ��Li, C. and C. Xu, et al. (2010). Level set evolution without re-initialization: A new variational formulation. IEEE Computer Society Conference on Computer Vision and Pattern Recognition.��
% sigma=1.5;
% G_sigma=fspecial('gaussian',15,sigma);
% image03_smooth=conv2(image03(:,:,1),G_sigma,'same');
[Ix1,Iy1]=gradient(image020(:,:,1));
f1=Ix1.^2+Iy1.^2;
[Ix2,Iy2]=gradient(image020(:,:,2));
f2=Ix2.^2+Iy2.^2;
[Ix3,Iy3]=gradient(image020(:,:,3));
f3=Ix3.^2+Iy3.^2;
ff=(f1+f2+f3)./3;

f_data02=1./(1+f1);  % edge indicator function.
clear f1 f2 f3;



%% start loops of level set evolution
while Pros.iteration ~= Args.numIteration
    %% Labels ���жϳ������У��������ڻ��ֵ������ߵ�Ӱ���£������ص�ǰ�����߱����Ĺ���
    labels=LabelingSP(SuperPixels, contours, Args, Pros);
    
    
    %% �����ⲿ�� F_data
    [ f_data01_pixels, f_data01 ,SuperPixels, S_sp_c, probability, Pros]=...
        compute_f_data( SuperPixels, SuperPixelsDistance, labels, Args, Pros);
    
    %% ���� F
    switch Args.fType
        case 'SP'
            f=f_data01_pixels;
        case 'DEF'
            f=f_data02;
        case 'SP DEF'
            f=f_data01_pixels + f_data02 ;
    end
    
    %% display the visiuallization of labelled SP at each superpixels at real time
    if strcmp(Args.isVisualLabels,'yes')==1
        [ label_Markup, Pros ] = visualizeLabelledSP( labels , SuperPixels, Args, Pros);
    end
    %% display the visiuallization of KDE at each superpixels at real time
    %
    if strcmp(Args.isVisualProbability,'yes')==1
        [probability_Markup, Pros] = visualizeProbability(SuperPixels, probability.foreground , probability.background ,Args, Pros);
    end
    %% display the visiuallization of S_sp_c at each superpixels at real time
    if strcmp(Args.isVisualSspc,'yes')==1
        [S_sp_c_Markup, Pros] = visualizeSspc( SuperPixels, S_sp_c, Args, Pros);
    end
    %% display the visiuallization of f_data at each superpixels at real time
    if strcmp(Args.isVisual_f_data,'yes')==1
        f_data_history=zeros(Args.numIteration, Pros.numSP);
        [ f_data_markup,f_data_history, Pros  ] = visualizeFData( f , f_data_history, f_data01_pixels, f_data02, SuperPixels, Args, Pros );
    end
    
    
    %% evolution now
    contours = EVOLUTION( contours, f, Args.lambda, Args.mu, Args.alpha, Args.epsilon, Args.timestep, numIter);
    %% �������ɵ� contours �У�ÿ�������ص����ص�� contours ֵȡƽ��ֵ��һ����...
    % ������Ч������ÿ�� EVOLUTION ֮����������ܱ����ڳ����صı߽��ϡ�
    for i=1:1:Pros.numSP
        for j=1:1:length(SuperPixels(i).pos)
            temp(j)=contours(SuperPixels(i).pos(j,1), SuperPixels(i).pos(j,2));
        end
        meanContourValueOfSuperPixels(i)=mean(temp);
    end
    contours=SP2pixels(meanContourValueOfSuperPixels, SuperPixels ,Pros);
    
    
    
    %% Visualization
    [  Pros] = visualizeEvolution( SuperPixels, image010 , contours, f , segments, Args, Pros );
    % %   �˴���ʾ��ϸ˵��
    % if strcmp(arguments.isVisualEvolution,'yes')==1;
    %
    %     figure(properties.handle_figure_evolution);
    %     imagesc(image010);
    %     %         hold(properties.handle_axes_evolution,'on');
    %     hold on;
    %     iterNum=[num2str(properties.iteration), ' iterations'];
    %     title(iterNum);
    %     % used for flash effection
    %     for j=1:1:3
    %         [~,~] = contour(contours,[0 0],'m');
    %         pause(0.2);
    %         [~,~] = contour(contours,[0 0],'y');
    %         pause(0.2);
    %     end
    %     %         hold(properties.handle_figure_evolution.CurrentAxes,'off');
    %     hold off;
    %
    %
    %
    % end
    %
    
    
    
    %%
    
    Pros.iteration=Pros.iteration+1;
    
end



%% ���ӻ�



% %% ֹͣ��¼�����������������
% diary off;
% %% �������� Export Data
% sentence060=(['save(''',SET.export_data_folder_path,'\','Export Data'',''ExportData'');']);
% eval(sentence060);
%



%% �����������
sp=actxserver('SAPI.SpVoice');
text='�����������';
sp.Speak(text)





