function [ f_data_pixels ,f_data, SuperPixels, S_sp_c, probability_foreground, probability_background, Pros] = ...
    compute_f_data( SuperPixels, SuperPixelsDistance, indicatorOfClass, phi, Pros)
% CREATE_F_DATA 生成我们写的 F_data
...input:
    ......SuperPixels: 超像素
    ......SuperPixelsDistance: 超像素的距离
    ......indicatorOfClass: 标记为前景或背景的标签示性向量
    ......Pros: 属性集合
    ...output:
    ......f_data_pixels: 对应到了每个超像素点的F_data
    ......f_data: 超像素的F_data
    ......SuperPixels: 超像素
    ......S_sp_c: 判别准则
    ......probability: 每个超像素分配为前景或背景的概率
    ......Pros:  属性集合
    
%% achieve the k - nn cluster
% 我们将两个两个之间的超像素的欧氏距离作为k近邻的数据点，这样，有N个超像素就会有C_N^2个距离的数据点
% 以D(.) 为metric ，用KNN实现，输出某个超像素sp的k近邻元素
% achieve the equation (9) and (10) in this paper .
SuperPixels=k_nn_cluster( SuperPixels, SuperPixelsDistance, indicatorOfClass, Pros.numNearestNeighbors,Pros);

%% 用KDE计算似然值
% achieve the equation (9) and (10) in this paper .
probability_foreground=zeros(1,Pros.numSP);
probability_background=zeros(1,Pros.numSP);

for i=1:1:Pros.numSP
    probability_foreground(i)=1/Pros.numNearestNeighbors .* sum(exp(-((SuperPixels(i).nearestNeighbors.foreground.data.^2)/(2*Pros.Sigma1^2))));
    probability_background(i)=1/Pros.numNearestNeighbors .* sum(exp(-((SuperPixels(i).nearestNeighbors.background.data.^2)/(2*Pros.Sigma1^2))));
end


%% 实现判别准则 S_sp_c
% achieve the equation (7) in this paper .
S_sp_c=zeros(1,Pros.numSP);
for i=1:1:Pros.numSP
    S_sp_c(i)=(probability_foreground(i)-probability_background(i))./(probability_foreground(i)+probability_background(i));
end


%% 产生 f_data
% 这里，我们把判别准则作为外部力的数据项。
% If Sp>0（应该属于前景） & 实际的标签Indicative∈前景
% Then F_data = 向外的很小的值（即值应该是正数）
% If Sp>0（应该属于前景） & 实际的标签Indicative∈背景
% Then F_data = 向外的大的值（即值应该是正数）
% If Sp<0 （应该属于背景）& 实际的标签Indicative∈前景
% Then F_data = 向内的大的值（即值应该是负数）
% If Sp<0 （应该属于背景）& 实际的标签Indicative∈背景
% Then F_data = 向内的很小的值（即值应该是负数）
f_data=zeros(1,length(S_sp_c));
for i=1:1:Pros.numSP
    if ( S_sp_c(i)>=0 && indicatorOfClass.foregroundIndicative(i)==1 )
        f_data(i) = 0;
    elseif ( S_sp_c(i)>=0 && indicatorOfClass.backgroundIndicative(i)==1 )
        f_data(i) = -S_sp_c(i);
    elseif ( S_sp_c(i)<0 && indicatorOfClass.foregroundIndicative(i)==1 )
        f_data(i) = -S_sp_c(i);
    elseif ( S_sp_c(i)<0 && indicatorOfClass.backgroundIndicative(i)==1 )
        f_data(i) = 0;
    end
end

% %% 产生 f_data
% % 这里，我们把判别准则作为外部力的数据项。
% % If Sp>0（应该属于前景） & 实际的标签Indicative∈前景
% % Then F_data = 向外的很小的值（即值应该是正数）
% % If Sp>0（应该属于前景） & 实际的标签Indicative∈背景
% % Then F_data = 向外的大的值（即值应该是正数）
% % If Sp<0 （应该属于背景）& 实际的标签Indicative∈前景
% % Then F_data = 向内的大的值（即值应该是负数）
% % If Sp<0 （应该属于背景）& 实际的标签Indicative∈背景
% % Then F_data = 向内的很小的值（即值应该是负数）
% f_data=zeros(1,length(S_sp_c));
% for i=1:1:Pros.numSP
%     if ( S_sp_c(i)>=0 & phi>=0 )
%         f_data(i)=0*0.1;
%     elseif ( S_sp_c(i)>=0 & phi<0)
%         f_data(i)=phi.*0.8.*S_sp_c(i);
%     elseif ( S_sp_c(i)<0 & phi>=0)
%         f_data(i)=phi.*0.8.*S_sp_c(i);
%     elseif ( S_sp_c(i)<0 & phi<0 )
%         f_data(i)=0*0.1;
%     end
% end


%% assign each force which at each superpixels to each pixels correspondingly .
f_data_pixels=zeros(Pros.sizeOfImage(1),Pros.sizeOfImage(2));
for i=1:1:Pros.numSP
    for j=1:1:length(SuperPixels(i).pos)
        f_data_pixels(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))=f_data(i);
    end
end

%%




end

