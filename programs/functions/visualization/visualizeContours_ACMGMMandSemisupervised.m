function [ Pros ] = visualizeContours_ACMGMMandSemisupervised( Pros, image_original, image_processed, phi, L_phi,  bwData, Pix, Px, Pxi, Pi_vis )
%visualizeContours_ACMandGMM 可视化基于[1]的演化模型的轮廓的中间过程。
%   input:
% Pros：结构体
% image_original：要处理的图像对应的原始图像。单张图像。
% image_processed：要处理的图像。单张图像。
% phi：嵌入函数。图像像素数×1
% bwData：二值图数据。单张图像的尺寸。
% Pix：后验概率。图像像素数×分类数
% Px：高斯概率。图像像素数×1
% Pxi：条件概率。图像像素数×分类数
% Pi：先验概率。1×分类数
% output:
% Pros：更新后的结构体

if Pros.iteration_outer==1
    nrow=5;
    ncol=5;
    Pros.handle_figure_evolution = figure('Name','evolution show');
    Pros.handle_figure_evolution.Position = [20 20 1500 1200];
    Pros.handle_axes_evolutionContours = subplot(nrow,ncol,1);
    Pros.handle_axes_surfContours = subplot(nrow,ncol,2);
    Pros.handle_axes_imagescContours = subplot(nrow,ncol,3);
    Pros.handle_axes_bwImagescContours = subplot(nrow,ncol,4);
    Pros.handle_axes_originalImage = subplot(nrow,ncol,6);
    Pros.handle_axes_surfPixForeground = subplot(nrow,ncol,7);
    Pros.handle_axes_imagescPixForeground = subplot(nrow,ncol,8);
    Pros.handle_axes_surfPixBackground = subplot(nrow,ncol,9);
    Pros.handle_axes_imagescPixBackground = subplot(nrow,ncol,10);
    Pros.handle_axes_processedImage = subplot(nrow,ncol,11);
    Pros.handle_axes_surfPx = subplot(nrow,ncol,12);
    Pros.handle_axes_imagescPx = subplot(nrow,ncol,13);
    Pros.handle_axes_surf_L_phi = subplot(nrow,ncol,14);
    Pros.handle_axes_imagesc_L_phi = subplot(nrow,ncol,15);
    Pros.handle_axes_surfPxiForeground = subplot(nrow,ncol,17);
    Pros.handle_axes_imagescPxiForeground = subplot(nrow,ncol,18);
    Pros.handle_axes_surfPxiBackground = subplot(nrow,ncol,19);
    Pros.handle_axes_imagescPxiBackground = subplot(nrow,ncol,20);
    Pros.handle_axes_surfPiForeground = subplot(nrow,ncol,22);
    Pros.handle_axes_imagescPiForeground = subplot(nrow,ncol,23);
    Pros.handle_axes_surfPiBackground = subplot(nrow,ncol,24);
    Pros.handle_axes_imagescPiBackground = subplot(nrow,ncol,25);
end


if  ( ( (strcmp(Pros.isVisualEvolution,'yes')==1) && (Pros.iteration_outer==1 || Pros.iteration_outer==Pros.numIteration_outer || mod(Pros.iteration_outer,Pros.periodOfVisual)==0) ) ...
        || (strcmp(Pros.isVisualEvolution,'yes')==0 && Pros.iteration_outer==Pros.numIteration_outer ) )
    
    %% 绘制轮廓
    temp010=reshape(phi,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    figure(Pros.handle_figure_evolution);
    Pros.handle_figure_evolution
    %% draw the subplot 1 :contours with original image
    subplot(Pros.handle_axes_evolutionContours);
    title(['contours with image at iteration ' num2str(Pros.iteration_outer)]);
    hold(Pros.handle_axes_evolutionContours ,'on');
    set(gca,'Color',[0.8 0.8 0.8]);
    axis equal;
    axis ij;
    axis off;
    colormap(Pros.handle_axes_evolutionContours,parula);
    image(image_original);
    % 	% used for flash effection
    % 	for j=1:1:2
    % 		[~,~] = contour(temp010,[0 0],'y');
    % 		pause(0.05);
    % 		[~,~] = contour(temp010,[0 0],'m');
    % 		pause(0.1);
    % 		[~,~] = contour(temp010,[0 0],'y');
    % 		pause(0.05);
    % 	end
    
    % 	do not use flash effection
    contour(temp010,[0 0],'r');
    pause(0.05);
    
    hold(Pros.handle_axes_evolutionContours ,'off');
    
    %% draw the subplot 2 :surface of phi
    subplot(Pros.handle_axes_surfContours);
    title(['surf contours at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surfContours ,'on');
    colormap(Pros.handle_axes_surfContours, parula);
    axis ij;
    surf(temp010);
    alpha(0.50);
    contour(temp010,[0 0],'r');
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surfContours ,'off');
    
    %% draw the subplot 3 :map of phi
    subplot(Pros.handle_axes_imagescContours);
    title(['image contours at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagescContours ,'on');
    colormap(Pros.handle_axes_imagescContours, gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp010);
    contour(temp010,[0 0],'r');
    hold(Pros.handle_axes_imagescContours ,'off');
    
    %% draw the subplot 4 : binary map of phi
    temp015=reshape(bwData, Pros.sizeOfImage(1), Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_bwImagescContours);
    title(['binary contours at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_bwImagescContours ,'on');
    % 	colormap_010=[0,0,1;1,0,0];
    colormap(Pros.handle_axes_bwImagescContours, gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp015);
    hold(Pros.handle_axes_bwImagescContours ,'off');
    clear temp010 temp015;
    
    
    %% draw the subplot 6 :original image
    subplot(Pros.handle_axes_originalImage);
    filename_originalImage = strrep(Pros.filename_originalImage,'_','\_');
    title(['original image ' filename_originalImage]);
    cla;
    hold(Pros.handle_axes_originalImage ,'on');
    image(image_original);
    axis ij;
    axis equal;
    axis off;
    hold(Pros.handle_axes_originalImage ,'off');
    
    %% draw the subplot 7 : surface of Pix foreground
    temp020=reshape(Pix(:,1) ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_surfPixForeground);
    title(['surf Pix foreground at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surfPixForeground ,'on');
    colormap(Pros.handle_axes_surfPixForeground,parula);
    axis ij;
    surf(temp020);
    alpha(0.50);
    % 	contour(temp020,[0.5 0.5],'r','LineWidth',2);
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surfPixForeground ,'off');
    
    %% draw the subplot 8 : map of Pix foreground
    subplot(Pros.handle_axes_imagescPixForeground );
    title(['mapping Pix foreground at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagescPixForeground  ,'on');
    colormap(Pros.handle_axes_imagescPixForeground ,gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp020);
    % 	contour(temp020,[0.5 0.5],'r','LineWidth',2);
    hold(Pros.handle_axes_imagescPixForeground  ,'off');
    clear temp020;
    
    %% draw the subplot 9: surface of Pix background
    temp025=reshape(Pix(:,2) ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_surfPixBackground);
    title(['surf Pix background at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surfPixBackground ,'on');
    colormap(Pros.handle_axes_surfPixBackground,parula);
    axis ij;
    surf(temp025);
    alpha(0.50);
    % 	contour(temp025,[0.5 0.5],'r','LineWidth',2);
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surfPixBackground ,'off');
    
    %% draw the subplot 10: map of Pix background
    subplot(Pros.handle_axes_imagescPixBackground);
    title(['mapping Pix background at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagescPixBackground ,'on');
    colormap(Pros.handle_axes_imagescPixBackground,gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp025);
    % 	contour(temp025,[0.5 0.5],'r','LineWidth',2);
    hold(Pros.handle_axes_imagescPixBackground ,'off');
    clear temp025;
    
    %% draw the subplot 11 :processed image
    subplot(Pros.handle_axes_processedImage);
    filename_processedImage = strrep(Pros.filename_processedImage,'_','\_');
    title(['processed image ' filename_processedImage]);
    cla;
    hold(Pros.handle_axes_processedImage ,'on');
    imshow(image_processed);
    axis ij;
    axis equal;
    axis off;
    hold(Pros.handle_axes_processedImage ,'off');
    
    %% draw the subplot 12 : surface of Px
    temp040=reshape(Px ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_surfPx);
    title(['surf Px at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surfPx ,'on');
    colormap(Pros.handle_axes_surfPx,parula);
    axis ij;
    surf(temp040);
    alpha(0.50);
    % 	contour(temp040,[0.5 0.5],'r','LineWidth',2);
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surfPx ,'off');
    
    %% draw the subplot 13 : map of Px
    subplot(Pros.handle_axes_imagescPx);
    title(['mapping Px at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagescPx ,'on');
    colormap(Pros.handle_axes_imagescPx,gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp040);
    % 	contour(temp040,[0.5 0.5],'r','LineWidth',2);
    hold(Pros.handle_axes_imagescPx ,'off');
    clear temp040;
    
    %% draw the subplot 14 : surface of L_phi
    temp045=reshape(L_phi ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_surf_L_phi);
    title(['surf L\_phi at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surf_L_phi ,'on');
    colormap(Pros.handle_axes_surf_L_phi,parula);
    axis ij;
    surf(temp045);
    alpha(0.50);
    % 	contour(temp040,[0.5 0.5],'r','LineWidth',2);
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surf_L_phi ,'off');
    
    %% draw the subplot 15 : map of L_phi
    subplot(Pros.handle_axes_imagesc_L_phi );
    title(['mapping L\_phi at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagesc_L_phi  ,'on');
    colormap(Pros.handle_axes_imagesc_L_phi ,gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp045);
    %     contour(temp020,[0.0 0.0],'r','LineWidth',2);
    hold(Pros.handle_axes_imagesc_L_phi  ,'off');
    clear temp045;
    
    %% draw the subplot 17 : surface of Pxi foreground
    temp050=reshape(Pxi(:,1) ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_surfPxiForeground);
    title(['surf Pxi foreground at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surfPxiForeground ,'on');
    colormap(Pros.handle_axes_surfPxiForeground,parula);
    axis ij;
    surf(temp050);
    alpha(0.50);
    % 	contour(temp050,[0.5 0.5],'r','LineWidth',2);
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surfPxiForeground ,'off');
    
    %% draw the subplot 18 : map of Pxi foreground
    subplot(Pros.handle_axes_imagescPxiForeground);
    title(['mapping Pxi foreground at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagescPxiForeground ,'on');
    colormap(Pros.handle_axes_imagescPxiForeground,gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp050);
    % 	contour(temp050,[0.5 0.5],'r','LineWidth',2);
    hold(Pros.handle_axes_imagescPxiForeground ,'off');
    clear temp050;
    
    %% draw the subplot 19: surface of Pxi background
    temp055=reshape(Pxi(:,2) ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_surfPxiBackground);
    title(['surf Pxi background at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surfPxiBackground ,'on');
    colormap(Pros.handle_axes_surfPxiBackground,parula);
    axis ij;
    surf(temp055);
    alpha(0.50);
    % 	contour(temp055,[0.5 0.5],'r','LineWidth',2);
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surfPxiBackground ,'off');
    
    %% draw the subplot 20: map of Pxi background
    subplot(Pros.handle_axes_imagescPxiBackground);
    title(['mapping Pxi background at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagescPxiBackground ,'on');
    colormap(Pros.handle_axes_imagescPxiBackground,gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp055);
    % 	contour(temp055,[0.5 0.5],'r','LineWidth',2);
    hold(Pros.handle_axes_imagescPxiBackground ,'off');
    clear temp055;
    
    %% draw the subplot 22 : surface of Pi foreground
    temp060=reshape(Pi_vis(:,1) ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_surfPiForeground);
    title(['surf Pi foreground at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surfPiForeground ,'on');
    colormap(Pros.handle_axes_surfPiForeground,parula);
    axis ij;
    surf(temp060);
    alpha(0.50);
    % 	contour(temp060,[0.5 0.5],'r','LineWidth',2);
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surfPiForeground ,'off');
    
    %% draw the subplot 23 : map of Pi foreground
    subplot(Pros.handle_axes_imagescPiForeground);
    title(['mapping Pi foreground at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagescPiForeground ,'on');
    colormap(Pros.handle_axes_imagescPiForeground,gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp060);
    % 	contour(temp060,[0.5 0.5],'r','LineWidth',2);
    hold(Pros.handle_axes_imagescPiForeground ,'off');
    clear temp060;
    
    %% draw the subplot 24: surface of Pi background
    temp065=reshape(Pi_vis(:,2) ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    subplot(Pros.handle_axes_surfPiBackground);
    title(['surf Pi background at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_surfPiBackground ,'on');
    colormap(Pros.handle_axes_surfPiBackground,parula);
    axis ij;
    surf(temp065);
    alpha(0.50);
    % 	contour(temp065,[0.5 0.5],'r','LineWidth',2);
    view([-12 30]);
    shading interp;
    hold(Pros.handle_axes_surfPiBackground ,'off');
    
    %% draw the subplot 25: map of Pi backgrounds
    subplot(Pros.handle_axes_imagescPiBackground);
    title(['mapping Pi background at iteration ' num2str(Pros.iteration_outer)]);
    cla;
    hold(Pros.handle_axes_imagescPiBackground ,'on');
    colormap(Pros.handle_axes_imagescPiBackground,gray);
    axis ij;
    axis equal;
    axis off;
    imagesc(temp065);
    % 	contour(temp065,[0.5 0.5],'r','LineWidth',2);
    hold(Pros.handle_axes_imagescPiBackground ,'off');
    clear temp065;
    
    %% save screen shot
    Pros.filename_screenShot = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_screenShot.jpg'];
    Pros.filepath_screenShot = fullfile(Pros.folderpath_screenShot, Pros.filename_screenShot);
    saveas(gcf, Pros.filepath_screenShot);
    if Pros.iteration_outer~=Pros.numIteration_outer
        disp(['已保存截图 ' Pros.filename_screenShot]);
    else
        disp(['已保存最终截图 ' Pros.filename_screenShot]);
    end
end

end






