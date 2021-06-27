function [Pros, phi_shaped] = evolution_ACMandSP( Pros, image_original ,image_processed, phi0)
% evolution_ACMandGMM_fixedTime 基于文献[1]的演化模型的改造。用的先验信息是式(25）。
%   input:
% Pros：Pros结构体
% image_original：要处理的图像对应的原始图像。
% image_processed：要处理的图像。
% output:
% phi：最终的嵌入函数
% Pros：演化结束后更新的Pros结构体。

%  基于以下的文章下面做出改进。
% TODO
%



%% initialization
numState =2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol;
Pxi = zeros( numPixels,numState); % Pxi：条件概率。图像像素数×分类数
phi = phi0;
phi_shaped = reshape(phi0, [], 1); % 初始化的 嵌入函数。像素数×1.


% 初始化停机条件
oldBwData=zeros(numPixels,1);
oldBwData(phi_shaped>=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;


%% 开始本次迭代计时
% TODO 后续改
tic;

%% 选取颜色空间,
%  only to testing the RGB color space.
% TODO 以后单独列为函数
try
    switch Pros.colorspace
        case 'LAB'
            image_colorspaced=rgb2lab(image_original);
        case 'HSV'
            image_colorspaced=rgb2hsv(image_original);
        case 'RGB'
            image_colorspaced=image_original;
    end
catch
    disp('colorspace is wrong');
end
image_data_colorspaced = im2single(image_colorspaced);
image_data = im2single(image_original);
%% 用 vl-feat 包的函数生成超像素。
% segmentsValue 存储的是每个像素被划分的超像素的标签值
segmentsValue=vl_slic(image_data, Pros.SuperPixels_lengthOfSide, Pros.SuperPixels_regulation);

%% find the number of SP.
numSP=max(segmentsValue(:))+1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 把对应于划分出来的超像素的 segments 作为标记该超像素的记号，对 segments
% 遍历，找到对应该超像素的记号，对应图像的HSV值，用 imhist() 生成直方图，用 histcounts() 作为提取直方图的数据方法。
% 结果保存在 SuperPixels(i).histogram 的三个通道值当中。

for i=1:1:numSP
    [row,col,val]=find(single(segmentsValue)==i-1);
    for j=1:1:length(row)
        SuperPixels(i).pos(j,1)=row(j);
        SuperPixels(i).pos(j,2)=col(j);
    end
    
    for j=1:length(row)
        SuperPixels(i).ColorSpace_value(j,:)=image_data_colorspaced(row(j),col(j),:);
    end
end

% 去掉那些空的标签值
for i=size(SuperPixels,2):-1:1
    if isempty(SuperPixels(i).pos)
        SuperPixels(i)=[];
    end
end

clear numSP;
Pros.numSP=size(SuperPixels,2);

%% 以直方图信息作为特征子之一
for i=1:1:Pros.numSP
    [SuperPixels(i).histogram_channel1,~]=histcounts(SuperPixels(i).ColorSpace_value(:,1), Pros.numBins);
    [SuperPixels(i).histogram_channel2,~]=histcounts(SuperPixels(i).ColorSpace_value(:,2), Pros.numBins);
    [SuperPixels(i).histogram_channel3,~]=histcounts(SuperPixels(i).ColorSpace_value(:,3), Pros.numBins);
end

%% calculate center point at SP .
SuperPixels = computeSPCenterPoint(SuperPixels);

%% 计算、可视化显示分割区域
if strcmp(Pros.isVisualSegoutput ,'yes')==1
    [segments_outline, segments_imgMarkup, segments_RGBImgMarkup]=...
        visual_SpSegmentations(image_colorspaced, image_original, segmentsValue, SuperPixels, Pros);
end
% Pros.segOutline=segments_outline;


%% 选取超像素之间的距离测度，并做可视化
% 可以采用欧式距离以简化计算
% 首先，我们对已经提取图像的三通道图像的直方图，取某个通道作为特征子
...计算每个通道分别用欧式公式计算距离
    ...输入两个超像素，然后计算距离。
    % 计算基于欧式的距离的公式
[ SuperPixelsDistance ] = computeSPDistance( SuperPixels, Pros );

%% 构建基于超像素的梯度下降流方程迭代演化
% 把paper里的超像素力放入F中



%% 初始化轮廓
% image010_contour=imread('.\resources\picture04_initial_user_contour.jpg');
% image010_contour=rgb2gray(image010_contour);
% [ initialContour ] = initialContour( image010_contour, Pros);

%% initial level set evolution
if strcmp(Pros.isVisualEvolution,'yes')==1
    Pros.handle_figure_evolution = figure('name','evolution');
    % properties.handle_axes_evolution = axes;
    imagesc(image_original);
    % hold(properties.handle_axes_evolution, 'on');
    hold on;
    [c,h] = contour(phi0,[0 0],'m');
    hold off;
end



%% 边指示函数作为外部力 F_data
% 参考论文 《Li, C. and C. Xu, et al. (2010). Level set evolution without re-initialization: A new variational formulation. IEEE Computer Society Conference on Computer Vision and Pattern Recognition.》
Pros.sigma=1.5;
G_sigma=fspecial('gaussian', Pros.hsize, Pros.sigma);
image_data_smoothed=conv2(rgb2gray(image_original), G_sigma, 'same'); 
% [Ix1,Iy1]=gradient(image_data_smoothed(:,:,1));
% f1=Ix1.^2+Iy1.^2;
% [Ix2,Iy2]=gradient(image_data_smoothed(:,:,2));
% f2=Ix2.^2+Iy2.^2;
% [Ix3,Iy3]=gradient(image_data_smoothed(:,:,3));
% f3=Ix3.^2+Iy3.^2;
% ff=(f1+f2+f3)./3;
[lx,ly]=gradient(image_data_smoothed);
ff=lx.^2+ly.^2;

f_data02=1./(1+ff);  % edge indicator function.
clear f1 f2 f3 ff;



%% start loops of level set evolution
% % while (Pros.elipsedEachTime<=Pros.numTime) % 比较同一时间的停机条件
% % while (Pros.iteration_outer<=Pros.numIteration_outer) % 比较同一代数的停机条件
% while (Pros.iteration_outer<=Pros.numIteration_outer &&	numPixelChanged>=Pros.numPixelChangedToContinue) % 给定收敛条件的停机条件
while (Pros.iteration_outer<=Pros.numIteration_outer) % 给定收敛条件的停机条件
    %% Labels ：判断超像素中，超像素在划分的轮廓线的影响下，超像素的前景或者背景的归属
    indicatorOfClass=LabelingSP(SuperPixels, phi, Pros);
    
    
    %% 计算外部力 F_data
    [ f_data01_pixels, f_data01 ,SuperPixels, S_sp_c, probability_foreground, probability_background, Pros]=...
        compute_f_data( SuperPixels, SuperPixelsDistance, indicatorOfClass, phi ,Pros);
    
    %% 生成 F
    switch Pros.forceType
        case 'SP'
            f_data=f_data01_pixels;
        case 'DEF'
            f_data=f_data02;
        case 'SP DEF'
            f_data= f_data01_pixels + f_data02 ;
    end
    
    %% display the visiuallization of labelled SP at each superpixels at real time
    if strcmp(Pros.isVisualLabels,'yes')==1
        [ label_Markup, Pros ] = visualizeLabelledSP( indicatorOfClass , SuperPixels, Pros);
    end
    %% display the visiuallization of KDE at each superpixels at real time
    %
    if strcmp(Pros.isVisualProbability,'yes')==1
        [probability_Markup, Pros] = visualizeProbability(SuperPixels, probability_foreground , probability_background, Pros);
    end
    %% display the visiuallization of S_sp_c at each superpixels at real time
    if strcmp(Pros.isVisualSspc,'yes')==1
        [S_sp_c_Markup, Pros] = visualizeSspc( SuperPixels, S_sp_c, Pros, Pros);
    end
    %% display the visiuallization of f_data at each superpixels at real time
    if strcmp(Pros.isVisual_f_data,'yes')==1
        f_data_history=zeros(Pros.numIteration_outer, Pros.numSP);
        [ f_data_markup, f_data_history, Pros ] = visualizeFData( f_data , f_data_history, f_data01_pixels, f_data02, SuperPixels,  Pros );
    end
    
    
    %% evolution now
    phi = EVOLUTION( phi, f_data, Pros.lambda, Pros.mu, Pros.alpha, Pros.epsilon, Pros.timestep, Pros);
    
%     %% 把新生成的 contours 中，每个超像素的像素点的 contours 值取平均值归一化。...
%     % 这样的效果就是每次 EVOLUTION 之后的轮廓总能保持在超像素的边界上。
%     for i=1:1:Pros.numSP
%         for j=1:1:length(SuperPixels(i).pos)
%             temp(j)=phi(SuperPixels(i).pos(j,1), SuperPixels(i).pos(j,2));
%         end
%         meanContourValueOfSuperPixels(i)=mean(temp);
%     end
%     phi=SP2pixels(meanContourValueOfSuperPixels, SuperPixels ,Pros);
    
    %% 结束本次迭代计时
    elipsedTime020 = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime020;
    
    
    %% Visualization
    [  Pros] = visualizeEvolution( SuperPixels, image_data_colorspaced , phi, f_data, segmentsValue, Pros );
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
    
    %% visualization
    % 嵌入函数。像素数×1.
    phi_shaped = reshape(phi, [], 1);
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi_shaped<=0)=1;
        bwData = im2bw(bwData);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi_shaped, bwData, Pix, Px, Pxi, Pi_vis );
        
        
    end
    
    %% write data
    if strcmp(Pros.isNotWriteDataAtAll,'no')
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi_shaped>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
        filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwData, 'bmp');
        if exist(filepath_bwData,'file')
            disp(['已保存分割二值图数据 ' filename_bwData]);
        else
            disp(['未保存分割二值图数据 ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            %% TODO
            [Pros ] = writeData_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi_shaped, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
        end
    end
    
    %%
    bwData=zeros(numPixels,1);
    bwData(phi_shaped>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
end % end loop

end

