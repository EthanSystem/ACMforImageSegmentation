function [ Pros ] = visualizeContours_CV(Pros, image_original, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, diracPhi, DeltaPhi )
%visualizeContours_CV 此处显示有关此函数的摘要
%   此处显示详细说明


%% evolution
if Pros.iteration_outer==1
	nrow=4;
	ncol=5;
	Pros.handle_figure_evolution = figure('Name','evolution show');
	Pros.handle_figure_evolution.Position = [20 20 2100 1400];
	Pros.handle_axes_evolutionContours = subplot(nrow,ncol,1);
	Pros.handle_axes_surfContours = subplot(nrow,ncol,2);
	Pros.handle_axes_imagescContours = subplot(nrow,ncol,3);
	Pros.handle_axes_bwImagescContours = subplot(nrow,ncol,4);
	Pros.handle_axes_originalImage = subplot(nrow,ncol,6);
	Pros.handle_axes_surfAreaTerm= subplot(nrow,ncol,7);
	Pros.handle_axes_imagescAreaTerm= subplot(nrow,ncol,8);
	Pros.handle_axes_processedImage = subplot(nrow,ncol,11);
	Pros.handle_axes_surfRegularTerm = subplot(nrow,ncol,12);
	Pros.handle_axes_imagescRegularTerm = subplot(nrow,ncol,13);
	Pros.handle_axes_surfEdgeTerm = subplot(nrow,ncol,14);
	Pros.handle_axes_imagescEdgeTerm = subplot(nrow,ncol,15);
	Pros.handle_axes_surfdiracPhi= subplot(nrow,ncol,17);
	Pros.handle_axes_imagescdiracPhi = subplot(nrow,ncol,18);
	Pros.handle_axes_surfDeltaphi = subplot(nrow,ncol,19);
	Pros.handle_axes_imagescDeltaphi= subplot(nrow,ncol,20);
end

if  ( ( (strcmp(Pros.isVisualEvolution,'yes')==1) && (Pros.iteration_outer==1 || Pros.iteration_outer==Pros.numIteration_outer || mod(Pros.iteration_outer,Pros.periodOfVisual)==0) ) ...
		|| (strcmp(Pros.isVisualEvolution,'yes')==0 && Pros.iteration_outer==Pros.numIteration_outer ) )
	% reshape the contours to fit function
	temp010=reshape(phi,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	
	figure(Pros.handle_figure_evolution);
	
	%% draw the subplot 1
	subplot(Pros.handle_axes_evolutionContours);
	title(['iteration ' num2str(Pros.iteration_outer)]);
	hold(Pros.handle_axes_evolutionContours ,'on');
	set(gca,'Color',[0.8 0.8 0.8]);
	axis equal;
	axis ij;
	axis off;
	image(image_original);
	% used for flash effection
	%         for j=1:1:2
	%             [~,~] = contour(temp010,[0 0],'m');
	%             pause(0.05);
	%             [~,~] = contour(temp010,[0 0],'y');
	%             pause(0.1);
	%             [~,~] = contour(temp010,[0 0],'m');
	%             pause(0.05);
	%         end
	contour(temp010,[0 0],'r');
	pause(0.05);
	
	hold(Pros.handle_axes_evolutionContours ,'off');
	
	%% draw the subplot 2 :surface of phi
	subplot(Pros.handle_axes_surfContours);
	title(['surf contours at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_surfContours ,'on');
	axis ij;
	colormap(Pros.handle_axes_surfContours,parula);
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
	
	%% draw the subplot 4: binary map of phi
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
	
	
	%% draw the subplot 5 : original image
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
	
	%% draw the subplot 7: surface of area term
	temp020 = reshape(areaTerm, Pros.sizeOfImage(1), Pros.sizeOfImage(2));
	subplot(Pros.handle_axes_surfAreaTerm);
	title(['surf area term at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_surfAreaTerm ,'on');
	colormap(Pros.handle_axes_surfAreaTerm,parula);
	axis ij;
	surf(temp020);
	alpha(0.66);
	contour(temp020,[0 0],'r','LineWidth',1);
	view([-12 30]);
	shading interp;
	hold(Pros.handle_axes_surfAreaTerm ,'off');
	
	%% draw the subplot 8: map of Heaviside(phi)
	subplot(Pros.handle_axes_imagescAreaTerm);
	title(['image area term at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_imagescAreaTerm ,'on');
	axis ij;
	axis equal;
	axis off;
	colormap(Pros.handle_axes_imagescAreaTerm,gray);
	imagesc(temp020);
	contour(temp020,[0 0],'r','LineWidth',1);
	hold(Pros.handle_axes_imagescAreaTerm ,'off');
	
	%% draw the subplot 9 :processed image
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
	
	%% draw the subplot 10: surface of Dirac(phi)
	temp025 = reshape(diracPhi, Pros.sizeOfImage(1), Pros.sizeOfImage(2));
	subplot(Pros.handle_axes_surfdiracPhi);
	title(['surf Dirac(phi) at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_surfdiracPhi ,'on');
	axis ij;
	colormap(Pros.handle_axes_surfdiracPhi,parula);
	surf(temp025);
	alpha(0.66);
	contour(temp025,[0 0],'r','LineWidth',1);
	view([-12 30]);
	shading interp;
	hold(Pros.handle_axes_surfdiracPhi ,'off');
	
	%% draw the subplot 11: map of Dirac(phi)
	subplot(Pros.handle_axes_imagescdiracPhi);
	title(['image Dirac(phi) at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_imagescdiracPhi ,'on');
	axis ij;
	axis equal;
	axis off;
	colormap(Pros.handle_axes_imagescdiracPhi, gray);
	imagesc(temp025);
	contour(temp025,[0 0],'r','LineWidth',1);
	hold(Pros.handle_axes_imagescdiracPhi ,'off');
	
	%% draw the subplot 12 : surface of regular term
	temp070=reshape(regularTerm ,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	subplot(Pros.handle_axes_surfRegularTerm);
	title(['surf regular term at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_surfRegularTerm ,'on');
	colormap(Pros.handle_axes_surfRegularTerm,parula);
	axis ij;
	surf(temp070);
	alpha(0.50);
	contour(temp070,[0.0 0.0],'r','LineWidth',1);
	view([-12 30]);
	shading interp;
	hold(Pros.handle_axes_surfRegularTerm ,'off');
	
	%% draw the subplot 13: map of regular term
	subplot(Pros.handle_axes_imagescRegularTerm);
	title(['mapping regular term at iteration ' num2str(Pros.iteration_outer)]);
	cla;
	hold(Pros.handle_axes_imagescRegularTerm ,'on');
	colormap(Pros.handle_axes_imagescRegularTerm,gray);
	axis ij;
	axis equal;
	axis off;
	imagesc(temp070);
	contour(temp070,[0.0 0.0],'r','LineWidth',1);
	hold(Pros.handle_axes_imagescRegularTerm ,'off');
	clear temp070;
	
	%% draw the subplot 14 : surface of edge term
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
	
	%% draw the subplot 15: map of edge term
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
	
	%% draw the subplot 19 : surface of DeltaPhi
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
	
	%% draw the subplot 20: map of DeltaPhi
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




