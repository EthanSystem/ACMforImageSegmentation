function [ Pros ] = visualizeContours_DRLSE( contours, image010,Args,Pros, Results  )
%visualizeContours_DRLSE 此处显示有关此函数的摘要
%   此处显示详细说明
if strcmp(Args.isVisualEvolution,'yes')==1
    
    
    if Pros.iteration_outer==1
        nrow=1;
        ncol=3;
        Pros.handle_figure_evolution = figure('name','evolution show');
        Pros.handle_figure_evolution.Position = [20 100 1200 400];
        Pros.handle_axes_evolutionContours = subplot(nrow,ncol,1);
        Pros.handle_axes_surfContours = subplot(nrow,ncol,2);
        Pros.handle_axes_imagescContours = subplot(nrow,ncol,3);

        colormap(parula);
        
    end
    
    if mod(Pros.iteration_outer,Args.periodToVisual)==0
        % reshape the contours to fit function
        temp010=reshape(contours,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
        
        figure(Pros.handle_figure_evolution);
        
        %% draw the subplot 1
        subplot(Pros.handle_axes_evolutionContours);
        title(['iteration ' num2str(Pros.iteration_outer)]);
        hold(Pros.handle_axes_evolutionContours ,'on');
        set(gca,'Color',[0.8 0.8 0.8]);
        axis equal;
        image(image010);
        % used for flash effection
        for j=1:1:2
            [~,~] = contour(temp010,[0 0],'m');
            pause(0.05);
            [~,~] = contour(temp010,[0 0],'y');
            pause(0.1);
            [~,~] = contour(temp010,[0 0],'m');
            pause(0.05);
        end
        hold(Pros.handle_axes_evolutionContours ,'off');
                
        %% draw the subplot 2
        subplot(Pros.handle_axes_surfContours);
        title(['surf contours at iteration ' num2str(Pros.iteration_outer)]);
        cla;
        hold(Pros.handle_axes_surfContours ,'on');
        surf(temp010);
        contour(temp010,[0 0],'r');
        view([-12 30]);
        alpha(0.66);
        shading interp;
        hold(Pros.handle_axes_surfContours ,'off');
        
        %% draw the subplot 3
        subplot(Pros.handle_axes_imagescContours);
        title(['image contours at iteration ' num2str(Pros.iteration_outer)]);
        cla;
        hold(Pros.handle_axes_imagescContours ,'on');
        imagesc(temp010);
        contour(temp010,[0 0],'r');
        axis equal;
        hold(Pros.handle_axes_imagescContours ,'off');
        
  
        
		%% save screen shot
		folderpath_screenShot = Results.experiments(Pros.index_expriment).eachOriginalImage(Pros.index_eachOriginalImage).eachMarkedImage(Pros.index_eachMarkedImage).screenShot.folderpath;
		filepath_screenShot=fullfile(folderpath_screenShot, [Args.processedImageName '_iteration_outer_' num2str(Pros.iteration_outer) '.jpg']);
		saveas(gcf,filepath_screenShot);
		clear folderpath_screenShot filepath_screenShot;

	end
    
end



end
