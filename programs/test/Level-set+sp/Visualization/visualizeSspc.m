function [ S_sp_c_Markup, properties ] = visualizeSspc(SuperPixels, S_sp_c ,arguments, properties)
%visualizeSspc ʹ�ù�������Ϳɫÿ�������ص���������ʾ������ǰ�������ڱ����ĸ��ʵ����
...inputs: 
...SuperPixels: 
...S_sp_c:
...arguments
...properties
...outputs:
...S_sp_c_Markup: ��S_sp_c�Ŀ��ӻ�����
...properties: ��ͼ�����ľ������������һ����ʾ��ʱ����

S_sp_c_Markup = SP2pixels(S_sp_c, SuperPixels, properties);


%% Visualization
if strcmp(arguments.isVisualSspc,'yes')==1
    if properties.iteration==1
        properties.handles_figure_S_Sp_c = figure('name','S sp contour show');
        % create folders for save screen shot
        properties.folderpath_visualize_Sspc = ([properties.folderpath,'\','screen shot','\','S SP C']);
        sentence015=(['mkdir(''',properties.folderpath_visualize_Sspc,''');']);
        eval(sentence015);
        
    end
    
    if mod(properties.iteration , arguments.periodToVisual)==0
        figure(properties.handles_figure_S_Sp_c);
        imagesc(S_sp_c_Markup);
        hold on;
        colormap(hot);
        set(gca,'Clim',[-1 1]);
        set(gca,'Color',[0.8 0.8 0.8]);
        colorbar;
        axis equal;
%         plot(segments.segOutline);  % ���ϱ���
        
        title(['S\_sp\_c show at iteration ',num2str(properties.iteration)]);
        hold off;
        
        %% save screen shot
        folderpath020=([properties.folderpath_visualize_Sspc,'\','iteration ',num2str(properties.iteration)]);
        saveas(gcf,folderpath020,'jpg');

    end
    
end

end

