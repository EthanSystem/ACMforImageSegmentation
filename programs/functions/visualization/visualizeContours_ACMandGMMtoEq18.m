function [ Pros ] = visualizeContours_ACMandGMMtoEq18( Pros, image_original, image_processed,phi, bwData, Pix, Pxi, Pi, probabilityTerm, edgeTerm,dirac_phi, DeltaPhi )
%visualizeContours_ACMandGMMtoEq18 可视化基于[1]的到式(18)的演化模型的轮廓的中间过程。
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
% probabilityTerm：概率项。图像像素数×1
% edgeTerm ：边界项。图像像素数×1
% dirac_phi：狄拉克函数数据。图像像素数×1
% DeltaPhi：更新值。图像像素数×1
% output:
% Pros：更新后的结构体

if Pros.iteration_outer==1
	nrow=5;
	ncol=5;
	Pros.handle_figure_evolution = figure('Name','evolution show');
	Pros.handle_figure_evolution.Position = [20 20 2100 1400];
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
	Pros.handle_axes_surfPxiForeground = subplot(nrow,ncol,12);
	Pros.handle_axes_imagescPxiForeground = subplot(nrow,ncol,13);
	Pros.handle_axes_surfPxiBackground = subplot(nrow,ncol,14);
	Pros.handle_axes_imagescPxiBackground = subplot(nrow,ncol,15);
	Pros.handle_axes_piePiForeground = subplot(nrow,ncol,16);
	Pros.handle_axes_surfProbabilityTerm = subplot(nrow,ncol,17);
	Pros.handle_axes_imagescProbabilityTerm = subplot(nrow,ncol,18);
	Pros.handle_axes_surfEdgeTerm = subplot(nrow,ncol,19);
	Pros.handle_axes_imagescEdgeTerm = subplot(nrow,ncol,20);
	Pros.handle_axes_surfdiracPhi= subplot(nrow,ncol,22);
	Pros.handle_axes_imagescdiracPhi = subplot(nrow,ncol,23);
	Pros.handle_axes_surfDeltaphi = subplot(nrow,ncol,24);
	Pros.handle_axes_imagescDeltaphi= subplot(nrow,ncol,25);
end

if  ( ( (strcmp(Pros.isVisualEvolution,'yes')==1) && (Pros.iteration_outer==1 || Pros.iteration_outer==Pros.numIteration_outer || mod(Pros.iteration_outer,Pros.periodOfVisual)==0) ) ...
		|| (strcmp(Pros.isVisualEvolution,'yes')==0 && Pros.iteration_outer==Pros.numIteration_outer ) )
	
	%% 绘制轮廓
	temp010=reshape(phi,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	figure(Pros.handle_figure_evolution);
	
	%% draw the subplot 1 :contours with original image
	subplot(Pros.handle_axes_evolutionContours);
	title(['iteration ' num2str(Pros.iteration_outer)]);
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
	contour(temp010,[0 0],'r','LineWidth',1);
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
	contour(temp010,[0 0],'r','LineWidth',1);
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
	image(image_processed);
	axis ij;
	axis equal;
	axis off;
	hold(Pros.handle_axes_processedImage ,'off');
	
	%% draw the subplot 12 : surface of Pxi foreground
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
	
	%% draw the subplot 13 : map of Pxi foreground
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
	
	%% draw the subplot 14: surface of Pxi background
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
	
	%% draw the subplot 15: map of Pxi background
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
	
	%% draw the subplot 16 : plot Pi foreground and background
	temp060=Pi;
	subplot(Pros.handle_axes_piePiForeground);
	title(['pie Pi at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_piePiForeground ,'on');
	pie(temp060);
	axis equal;
	axis off;
	legend('foreground','background','Location','best');
	hold(Pros.handle_axes_piePiForeground ,'off');
	clear temp060;
	
	%% draw the subplot 17 : surface of probability term
	temp070=reshape(probabilityTerm ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	subplot(Pros.handle_axes_surfProbabilityTerm);
	title(['surf probability term at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_surfProbabilityTerm ,'on');
	colormap(Pros.handle_axes_surfProbabilityTerm,parula);
	axis ij;
	surf(temp070);
	alpha(0.50);
	contour(temp070,[0.0 0.0],'r','LineWidth',1);
	view([-12 30]);
	shading interp;
	hold(Pros.handle_axes_surfProbabilityTerm ,'off');
	
	%% draw the subplot 18: map of probability term
	subplot(Pros.handle_axes_imagescProbabilityTerm);
	title(['mapping probability term at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_imagescProbabilityTerm ,'on');
	colormap(Pros.handle_axes_imagescProbabilityTerm,gray);
	axis ij;
	axis equal;
	axis off;
	imagesc(temp070);
	contour(temp070,[0.0 0.0],'r','LineWidth',1);
	hold(Pros.handle_axes_imagescProbabilityTerm ,'off');
	clear temp070;
	
	%% draw the subplot 19 : surface of edge term
	temp075=reshape(edgeTerm ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	subplot(Pros.handle_axes_surfEdgeTerm);
	title(['surf edge term at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_surfEdgeTerm ,'on');
	colormap(Pros.handle_axes_surfEdgeTerm,parula);
	axis ij;
	surf(temp075);
	alpha(0.50);
	contour(temp075,[0.0 0.0],'r','LineWidth',1);
	view([-12 30]);
	shading interp;
	hold(Pros.handle_axes_surfEdgeTerm ,'off');
	
	%% draw the subplot 20: map of edge term
	subplot(Pros.handle_axes_imagescEdgeTerm);
	title(['mapping edge term at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_imagescEdgeTerm ,'on');
	colormap(Pros.handle_axes_imagescEdgeTerm,gray);
	axis ij;
	axis equal;
	axis off;
	imagesc(temp075);
	contour(temp075,[0.0 0.0],'r','LineWidth',1);
	hold(Pros.handle_axes_imagescEdgeTerm ,'off');
	clear temp075;
	
	%% draw the subplot 22: surface of diracPhi
	temp080=reshape(dirac_phi ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	subplot(Pros.handle_axes_surfdiracPhi);
	title(['surf dirac(phi) at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_surfdiracPhi ,'on');
	colormap(Pros.handle_axes_surfdiracPhi,parula);
	axis ij;
	surf(temp080);
	alpha(0.50);
	% 	contour(temp080,[0.0 0.0],'r','LineWidth',2);
	view([-12 30]);
	shading interp;
	hold(Pros.handle_axes_surfdiracPhi ,'off');
	
	%% draw the subplot 23: map of diracPhi
	subplot(Pros.handle_axes_imagescdiracPhi);
	title(['mapping dirac(phi) at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_imagescdiracPhi ,'on');
	colormap(Pros.handle_axes_imagescdiracPhi,gray);
	axis ij;
	axis equal;
	axis off;
	imagesc(temp080);
	% 	contour(temp055,[0.0 0.0],'r','LineWidth',2);
	hold(Pros.handle_axes_imagescdiracPhi ,'off');
	clear temp080;
	
	%% draw the subplot 24 : surface of DeltaPhi
	temp085=reshape(DeltaPhi ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	subplot(Pros.handle_axes_surfDeltaphi);
	title(['surf DeltaPhi at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_surfDeltaphi ,'on');
	colormap(Pros.handle_axes_surfDeltaphi,parula);
	axis ij;
	surf(temp085);
	alpha(0.50);
	contour(temp085,[0.0 0.0],'r','LineWidth',1);
	view([-12 30]);
	shading interp;
	hold(Pros.handle_axes_surfDeltaphi ,'off');
	
	%% draw the subplot 25: map of DeltaPhi
	subplot(Pros.handle_axes_imagescDeltaphi);
	title(['mapping DeltaPhi at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_imagescDeltaphi ,'on');
	colormap(Pros.handle_axes_imagescDeltaphi,gray);
	axis ij;
	axis equal;
	axis off;
	imagesc(temp085);
	contour(temp085,[0.0 0.0],'r','LineWidth',1);
	hold(Pros.handle_axes_imagescDeltaphi ,'off');
	clear temp085;
	
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






