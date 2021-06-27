function [Pros, phi_shaped] = evolution_ACMandSP( Pros, image_original ,image_processed, phi0)
% evolution_ACMandGMM_fixedTime ��������[1]���ݻ�ģ�͵ĸ��졣�õ�������Ϣ��ʽ(25����
%   input:
% Pros��Pros�ṹ��
% image_original��Ҫ�����ͼ���Ӧ��ԭʼͼ��
% image_processed��Ҫ�����ͼ��
% output:
% phi�����յ�Ƕ�뺯��
% Pros���ݻ���������µ�Pros�ṹ�塣

%  �������µ��������������Ľ���
% TODO
%



%% initialization
numState =2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol;
Pxi = zeros( numPixels,numState); % Pxi���������ʡ�ͼ����������������
phi = phi0;
phi_shaped = reshape(phi0, [], 1); % ��ʼ���� Ƕ�뺯������������1.


% ��ʼ��ͣ������
oldBwData=zeros(numPixels,1);
oldBwData(phi_shaped>=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;


%% ��ʼ���ε�����ʱ
% TODO ������
tic;

%% ѡȡ��ɫ�ռ�,
%  only to testing the RGB color space.
% TODO �Ժ󵥶���Ϊ����
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
%% �� vl-feat ���ĺ������ɳ����ء�
% segmentsValue �洢����ÿ�����ر����ֵĳ����صı�ǩֵ
segmentsValue=vl_slic(image_data, Pros.SuperPixels_lengthOfSide, Pros.SuperPixels_regulation);

%% find the number of SP.
numSP=max(segmentsValue(:))+1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ѷ�Ӧ�ڻ��ֳ����ĳ����ص� segments ��Ϊ��Ǹó����صļǺţ��� segments
% �������ҵ���Ӧ�ó����صļǺţ���Ӧͼ���HSVֵ���� imhist() ����ֱ��ͼ���� histcounts() ��Ϊ��ȡֱ��ͼ�����ݷ�����
% ��������� SuperPixels(i).histogram ������ͨ��ֵ���С�

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

% ȥ����Щ�յı�ǩֵ
for i=size(SuperPixels,2):-1:1
    if isempty(SuperPixels(i).pos)
        SuperPixels(i)=[];
    end
end

clear numSP;
Pros.numSP=size(SuperPixels,2);

%% ��ֱ��ͼ��Ϣ��Ϊ������֮һ
for i=1:1:Pros.numSP
    [SuperPixels(i).histogram_channel1,~]=histcounts(SuperPixels(i).ColorSpace_value(:,1), Pros.numBins);
    [SuperPixels(i).histogram_channel2,~]=histcounts(SuperPixels(i).ColorSpace_value(:,2), Pros.numBins);
    [SuperPixels(i).histogram_channel3,~]=histcounts(SuperPixels(i).ColorSpace_value(:,3), Pros.numBins);
end

%% calculate center point at SP .
SuperPixels = computeSPCenterPoint(SuperPixels);

%% ���㡢���ӻ���ʾ�ָ�����
if strcmp(Pros.isVisualSegoutput ,'yes')==1
    [segments_outline, segments_imgMarkup, segments_RGBImgMarkup]=...
        visual_SpSegmentations(image_colorspaced, image_original, segmentsValue, SuperPixels, Pros);
end
% Pros.segOutline=segments_outline;


%% ѡȡ������֮��ľ����ȣ��������ӻ�
% ���Բ���ŷʽ�����Լ򻯼���
% ���ȣ����Ƕ��Ѿ���ȡͼ�����ͨ��ͼ���ֱ��ͼ��ȡĳ��ͨ����Ϊ������
...����ÿ��ͨ���ֱ���ŷʽ��ʽ�������
    ...�������������أ�Ȼ�������롣
    % �������ŷʽ�ľ���Ĺ�ʽ
[ SuperPixelsDistance ] = computeSPDistance( SuperPixels, Pros );

%% �������ڳ����ص��ݶ��½������̵����ݻ�
% ��paper��ĳ�����������F��



%% ��ʼ������
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



%% ��ָʾ������Ϊ�ⲿ�� F_data
% �ο����� ��Li, C. and C. Xu, et al. (2010). Level set evolution without re-initialization: A new variational formulation. IEEE Computer Society Conference on Computer Vision and Pattern Recognition.��
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
% % while (Pros.elipsedEachTime<=Pros.numTime) % �Ƚ�ͬһʱ���ͣ������
% % while (Pros.iteration_outer<=Pros.numIteration_outer) % �Ƚ�ͬһ������ͣ������
% while (Pros.iteration_outer<=Pros.numIteration_outer &&	numPixelChanged>=Pros.numPixelChangedToContinue) % ��������������ͣ������
while (Pros.iteration_outer<=Pros.numIteration_outer) % ��������������ͣ������
    %% Labels ���жϳ������У��������ڻ��ֵ������ߵ�Ӱ���£������ص�ǰ�����߱����Ĺ���
    indicatorOfClass=LabelingSP(SuperPixels, phi, Pros);
    
    
    %% �����ⲿ�� F_data
    [ f_data01_pixels, f_data01 ,SuperPixels, S_sp_c, probability_foreground, probability_background, Pros]=...
        compute_f_data( SuperPixels, SuperPixelsDistance, indicatorOfClass, phi ,Pros);
    
    %% ���� F
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
    
%     %% �������ɵ� contours �У�ÿ�������ص����ص�� contours ֵȡƽ��ֵ��һ����...
%     % ������Ч������ÿ�� EVOLUTION ֮����������ܱ����ڳ����صı߽��ϡ�
%     for i=1:1:Pros.numSP
%         for j=1:1:length(SuperPixels(i).pos)
%             temp(j)=phi(SuperPixels(i).pos(j,1), SuperPixels(i).pos(j,2));
%         end
%         meanContourValueOfSuperPixels(i)=mean(temp);
%     end
%     phi=SP2pixels(meanContourValueOfSuperPixels, SuperPixels ,Pros);
    
    %% �������ε�����ʱ
    elipsedTime020 = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime020;
    
    
    %% Visualization
    [  Pros] = visualizeEvolution( SuperPixels, image_data_colorspaced , phi, f_data, segmentsValue, Pros );
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
    
    %% visualization
    % Ƕ�뺯������������1.
    phi_shaped = reshape(phi, [], 1);
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi_shaped<=0)=1;
        bwData = im2bw(bwData);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi_shaped, bwData, Pix, Px, Pxi, Pi_vis );
        
        
    end
    
    %% write data
    if strcmp(Pros.isNotWriteDataAtAll,'no')
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi_shaped>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
        filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwData, 'bmp');
        if exist(filepath_bwData,'file')
            disp(['�ѱ���ָ��ֵͼ���� ' filename_bwData]);
        else
            disp(['δ����ָ��ֵͼ���� ' filename_bwData]);
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

