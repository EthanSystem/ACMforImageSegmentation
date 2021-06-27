function [ S_sp_c_Markup, Pros ] = visualizeSspc(SuperPixels, S_sp_c ,arguments, Pros)
%visualizeSspc 使用光谱序列涂色每个超像素的区域以显示其属于前景和属于背景的概率的情况
...inputs: 
...SuperPixels: 
...S_sp_c:
...arguments
...properties
...outputs:
...S_sp_c_Markup: 对S_sp_c的可视化数据
...properties: 把图像对象的句柄保存起来下一次显示的时候用

S_sp_c_Markup = SP2pixels(S_sp_c, SuperPixels, Pros);


%% Visualization
if strcmp(arguments.isVisualSspc,'yes')==1
    if Pros.iteration_outer==1
        Pros.handles_figure_S_Sp_c = figure('name','S sp contour show');
        % create folders for save screen shot
        Pros.folderpath_visualize_Sspc = ([Pros.folderpath_screenShot,'\','S SP C']);
        sentence015=(['mkdir(''',Pros.folderpath_visualize_Sspc,''');']);
        eval(sentence015);
        
    end
    
    if mod(Pros.iteration_outer , arguments.periodOfVisual)==0
        figure(Pros.handles_figure_S_Sp_c);
        imagesc(S_sp_c_Markup);
        hold on;
        colormap(hot);
        set(gca,'Clim',[-1 1]);
        set(gca,'Color',[0.8 0.8 0.8]);
        colorbar;
        axis equal;
%         plot(segments.segOutline);  % 附上边线
        
        title(['S\_sp\_c show at iteration\_outer ',num2str(Pros.iteration_outer)]);
        hold off;
        
        %% save screen shot
        folderpath020=([Pros.folderpath_visualize_Sspc,'\',Pros.filename_originalImage(1:end-4),'_iter',num2str(Pros.iteration_outer)]);
        saveas(gcf,folderpath020,'jpg');

    end
    
end

end

