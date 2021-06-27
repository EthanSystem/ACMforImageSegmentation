%% 简介：
...资源放在 resources 文件夹中
...可视化结果放在 results 文件夹中

%% 建议：
...建议在main程序的EVOLUTION函数那句上设置断点，以便每一代都可以暂停观察结果。
...相对路径放在Project_MATLAB的父文件夹中。
    
    %% 注意事项
...如果刚运行的时候或者运行到一段代数突然报错
    ...是因为在计算k近邻的时候，实际的前景或者背景的数量小于k个，导致数组下标索引溢出导致的。
    ...目前不影响正确的实验结果，暂时不修复。
...如果用一些颜色空间计算时报错，请尝试修改 arguments.SuperPixels_lengthOfSide、arguments.SuperPixels_regulation等参数。



%%

% % 每次启动MATLAB后只需要运行一次。
% VLROOTS='';
% run('C:\Softwares\VLFeat\toolbox\vl_setup');
% % vl_version verbose
% % addpath of vl-feat. the pathname may be different in different PC.



%% Main 函数
clear all;
close all;
clc;
diary off;




%% parameters settings
% arguments 字段表示程序运行前手动设置的参数

% 今天的第几次试验，用于产生一个文件夹，记录实验结果截图
Args.howManyTimesOfExperiment = 4;

% 划分的超像素的边长
Args.SuperPixels_lengthOfSide=20;

% 划分的超像素的规则度
Args.SuperPixels_regulation=1;

% 特征子的直方图的柱数
Args.numBins=16;

% number of nearest neighbors . 建议不要赋值太大，目前的程序还没有改进，否则容易报错
Args.numNearestNeighbors=10;

% 高斯核带宽参数
Args.Sigma1=10;

% 颜色空间
% 可选值有 'RGB' 'LAB' 'HSV' 三者之一
Args.colorspace='RGB';

% 超像素力的类型，'SP'，'DEF'，'SP DEF'三者选一
Args.fType='SP';

% 水平集演化参数
% 演化步进值
Args.timestep=5; % time step
Args.epsilon=1.5; % the papramater in the definition of smoothed Dirac function
Args.mu=0.2/Args.timestep;  % coefficient of the internal (penalizing) energy term P(\phi)
Args.lambda=5; % coefficient of the weighted length term Lg(\phi)
Args.alpha=1.5; % coefficient of the weighted area term Ag(\phi);

% 演化代数
Args.numIteration = 100;
Args.iteration = 1;

% 可视化显示的迭代次数周期
Args.periodToVisual = 1;

% 轮廓的初始化
% 可以用任一方式初始化，'BOX'、'USER' 二者选择一个
Args.contourType='USER';
Args.contourIn0=5;
Args.boxWidth=20;


% 是否可视化的开关
Args.isVisualEvolution='yes';
Args.isVisualSegoutput='yes';
Args.isVisualSPDistanceMat='yes';
Args.isVisualProbability='yes';
Args.isVisualSspc='yes';

Args.isVisual_f_data='yes';
Args.isVisualLabels='yes';





% 显示
Args


%% 建立数据文件夹
str020=datestr(now,'yyyymmdd');
folderName020=(str020);
str025=num2str(Args.howManyTimesOfExperiment);     
folderName025=str025;
% folderName030=str030;   可以删除
folderParentPath01=(['.\results\Export Data']);
folderPath01=([folderParentPath01,'\',folderName020,'\',folderName025]);
sentence015=(['mkdir(''',folderPath01,''');']);
eval(sentence015);


%% intialization
% properties 字段表示程序运行中产生的参数值
Pros.iteration = Args.iteration;
% 文件路径
Pros.folderpath = folderPath01;


%% create a image

image010=imread('.\data\resources\picture04.jpg');
% imshow(image01);

%% create sp by SLIC method .

Pros.sizeOfImg=size(image010);
image010=im2single(image010);  % 归一化，为了后面调用 vl_slic(.)


% 选取颜色空间
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


% 用vl-feat 包的函数生成超像素。默认设置：超像素边长=20，规则度=1；
segments.value=vl_slic(image020, Args.SuperPixels_lengthOfSide, Args.SuperPixels_regulation);



%% extracting features of each HSV chanel in each SP .

% find the number of SP.
Pros.numSP=max(segments.value(:))+1;

% image02=uint8(256*image02);   % 转回 256 uint

% 把对应于划分出来的超像素的 segments 作为标记该超像素的记号，对 segments
% 遍历，找到对应该超像素的记号，对应图像的HSV值，用 imhist() 生成直方图，用histcounts()作为提取直方图的数据方法。
% 结果保存在 SuperPixels(i).histogram的三个通道值当中。

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

%% 计算、可视化显示分割区域
[segments.segOutline, segments.imgMarkup, segments.RGBImgMarkup]=...
    segoutput(image020, image010, segments.value, Args, Pros);

Pros.segOutline=segments.segOutline;


%% 选取超像素之间的距离测度，并做可视化
% 可以采用欧式距离以简化计算
% 首先，我们对已经提取图像的三通道图像的直方图，取某个通道作为特征子
...计算每个通道分别用欧式公式计算距离
    ...输入两个超像素，然后计算距离。
    % 计算基于欧式的距离的公式
[ SuperPixelsDistance ] = computeSPDistance( SuperPixels ,Args, Pros );

%% 构建基于超像素的梯度下降流方程迭代演化
% 把paper里的超像素力放入F中



%% 初始化轮廓
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



%% 边指示函数作为外部力 F_data
% 参考论文 《Li, C. and C. Xu, et al. (2010). Level set evolution without re-initialization: A new variational formulation. IEEE Computer Society Conference on Computer Vision and Pattern Recognition.》
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
    %% Labels ：判断超像素中，超像素在划分的轮廓线的影响下，超像素的前景或者背景的归属
    labels=LabelingSP(SuperPixels, contours, Args, Pros);
    
    
    %% 计算外部力 F_data
    [ f_data01_pixels, f_data01 ,SuperPixels, S_sp_c, probability, Pros]=...
        compute_f_data( SuperPixels, SuperPixelsDistance, labels, Args, Pros);
    
    %% 生成 F
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
    %% 把新生成的 contours 中，每个超像素的像素点的 contours 值取平均值归一化。...
    % 这样的效果就是每次 EVOLUTION 之后的轮廓总能保持在超像素的边界上。
    for i=1:1:Pros.numSP
        for j=1:1:length(SuperPixels(i).pos)
            temp(j)=contours(SuperPixels(i).pos(j,1), SuperPixels(i).pos(j,2));
        end
        meanContourValueOfSuperPixels(i)=mean(temp);
    end
    contours=SP2pixels(meanContourValueOfSuperPixels, SuperPixels ,Pros);
    
    
    
    %% Visualization
    [  Pros] = visualizeEvolution( SuperPixels, image010 , contours, f , segments, Args, Pros );
    % %   此处显示详细说明
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



%% 可视化



% %% 停止记录公共窗口输出的数据
% diary off;
% %% 输出结果到 Export Data
% sentence060=(['save(''',SET.export_data_folder_path,'\','Export Data'',''ExportData'');']);
% eval(sentence060);
%



%% 程序结束提醒
sp=actxserver('SAPI.SpVoice');
text='程序运行完毕';
sp.Speak(text)





