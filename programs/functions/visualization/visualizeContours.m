function [ Pros ] = visualizeContours( contours, Pix_foreground, Pix_background, Pxi_foreground, Pxi_background, image010,Args,Pros )
%visualizeContours 可视化自定义演化模型的轮廓的中间过程.

if strcmp(Args.isVisualEvolution,'yes')==1
    
    
    if Pros.iteration_outer==1
        nrow=3;
        ncol=3;
        Pros.handle_figure_evolution = figure('name','evolution show');
        Pros.handle_figure_evolution.Position = [20 100 1000 1000];
        Pros.handle_axes_evolutionContours = subplot(nrow,ncol,1);
        Pros.handle_axes_surfContours = subplot(nrow,ncol,2);
        Pros.handle_axes_imagescContours = subplot(nrow,ncol,3);
        Pros.handle_axes_surfPixForeground = subplot(nrow,ncol,5);
        Pros.handle_axes_surfPixBackground = subplot(nrow,ncol,6);
        Pros.handle_axes_surfPxiForeground = subplot(nrow,ncol,8);
        Pros.handle_axes_surfPxiBackground = subplot(nrow,ncol,9);
        colormap(parula);
        
        % create folders for save screen shot
        Pros.folderpath_visualize_evolution = ([Pros.folderpath,'\','screen shot','\','evolution']);
        sentence015=(['mkdir(''',Pros.folderpath_visualize_evolution,''');']);
        eval(sentence015);
        
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
        
        %% draw the subplot 5
        temp020=reshape(Pix_foreground,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
        subplot(Pros.handle_axes_surfPixForeground);
        title(['surf Pix foreground at iteration ' num2str(Pros.iteration_outer)]);
        cla;
        hold(Pros.handle_axes_surfPixForeground ,'on');
        surf(temp020);
        contour(temp020,[0 0],'r');
        view([-12 30]);
        shading interp;
        hold(Pros.handle_axes_surfPixForeground ,'off');
        clear temp020;
        
        %% draw the subplot 6
        temp020=reshape(Pix_background,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
        subplot(Pros.handle_axes_surfPixBackground);
        title(['surf Pix background at iteration ' num2str(Pros.iteration_outer)]);
        cla;
        hold(Pros.handle_axes_surfPixBackground ,'on');
        surf(temp020);
        contour(temp020,[0 0],'r');
        view([-12 30]);
        shading interp;
        hold(Pros.handle_axes_surfPixBackground ,'off');
        clear temp020;
        
        %% draw the subplot 8
        temp020=reshape(Pxi_foreground,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
        subplot(Pros.handle_axes_surfPxiForeground);
        title(['surf Pxi foreground at iteration ' num2str(Pros.iteration_outer)]);
        cla;
        hold(Pros.handle_axes_surfPxiForeground ,'on');
        surf(temp020);
        contour(temp020,[0 0],'r');
        view([-12 30]);
        shading interp;
        hold(Pros.handle_axes_surfPxiForeground ,'off');
        clear temp020;
        
        %% draw the subplot 9
        temp020=reshape(Pxi_background,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
        subplot(Pros.handle_axes_surfPxiBackground);
        title(['surf Pxi background at iteration ' num2str(Pros.iteration_outer)]);
        cla;
        hold(Pros.handle_axes_surfPxiBackground ,'on');
        surf(temp020);
        contour(temp020,[0 0],'r');
        view([-12 30]);
        shading interp;
        hold(Pros.handle_axes_surfPxiBackground ,'off');
        clear temp020;
        
        %% save screen shot
        folderpath020=([Pros.folderpath_visualize_evolution,'\','iteration_outer ',num2str(Pros.iteration_outer)]);
        saveas(gcf,folderpath020,'jpg');
        
        clear temp010;
    end
    
end



end
