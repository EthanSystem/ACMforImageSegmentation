function [ S_sp_c_Markup, Pros ] = visualizeSspc(SuperPixels, S_sp_c ,arguments, Pros)
%visualizeSspc ʹ�ù�������Ϳɫÿ�������ص���������ʾ������ǰ�������ڱ����ĸ��ʵ����
...inputs: 
...SuperPixels: 
...S_sp_c:
...arguments
...properties
...outputs:
...S_sp_c_Markup: ��S_sp_c�Ŀ��ӻ�����
...properties: ��ͼ�����ľ������������һ����ʾ��ʱ����

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
%         plot(segments.segOutline);  % ���ϱ���
        
        title(['S\_sp\_c show at iteration\_outer ',num2str(Pros.iteration_outer)]);
        hold off;
        
        %% save screen shot
        folderpath020=([Pros.folderpath_visualize_Sspc,'\',Pros.filename_originalImage(1:end-4),'_iter',num2str(Pros.iteration_outer)]);
        saveas(gcf,folderpath020,'jpg');

    end
    
end

end

