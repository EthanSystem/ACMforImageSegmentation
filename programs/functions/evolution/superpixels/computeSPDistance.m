function [ SuperPixelsDistance ] = computeSPDistance( SuperPixels ,Pros)
%COMPUTESPDISTANCE 此处显示有关此函数的摘要
% 计算基于欧式的距离的公式
SuperPixelsDistance_color = zeros(Pros.numSP,Pros.numSP);
SuperPixelsDistance_space = zeros(Pros.numSP,Pros.numSP);

%% 方法1 欧式空间 颜色特征子 & xy空间特征子
for i=1:1:Pros.numSP
    for j=1:1:Pros.numSP
        SuperPixelsDistance_color(i,j) = ...
            norm(...
            [(SuperPixels(i).histogram_channel1 - SuperPixels(j).histogram_channel1); ...
            (SuperPixels(i).histogram_channel2 - SuperPixels(j).histogram_channel2);...
            (SuperPixels(i).histogram_channel3 - SuperPixels(j).histogram_channel3)] ...
            ,2);  ...
        SuperPixelsDistance_space(i,j) = ...
            norm(...
            [(SuperPixels(i).centerPointPosition_1 - SuperPixels(j).centerPointPosition_1);...
            (SuperPixels(i).centerPointPosition_2 - SuperPixels(j).centerPointPosition_2)] ...
            ,2);  ...
    end
end
SuperPixelsDistance = Pros.weight_feature .* reshape(mapminmax(reshape(SuperPixelsDistance_color,1,Pros.numSP*Pros.numSP),0.01,0.99),Pros.numSP,Pros.numSP) + ...
    (1-Pros.weight_feature) .* reshape(mapminmax(reshape(SuperPixelsDistance_space,1,Pros.numSP*Pros.numSP),0.01,0.99),Pros.numSP,Pros.numSP) ;

%% Visualization
if strcmp(Pros.isVisualSPDistanceMat ,'yes')==1
    if Pros.iteration_outer==1
        Pros.handle_figure_SPDistanceMat = figure('name','所有的超像素的相互距离矩阵');
        colormap('jet');
        axis equal; box off; axis off;
        imagesc(SuperPixelsDistance);
        title('所有的超像素的相互距离矩阵');
        %         title(['iteration ',num2str(properties.iteration)]);
        colorbar;
        
    end
    
 
end


end

