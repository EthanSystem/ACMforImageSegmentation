function [ labels ] = LabelingSP( SuperPixels , contours , Pros)
% LABELINGSP 根据contours的值，或者根据用户定义的前景或者背景的标记，对每个超像素属于前景或者背景的的标记
...inputs:
...SuperPixels: 
...contours: 轮廓线
...arguments
...properties
...outputs:
...outputs:
...labels: 前景或背景的标记



pixelsLabeling=contours;
pixelsLabeling(pixelsLabeling<=0)=0;  % contours 小于零的标记为背景0
pixelsLabeling(pixelsLabeling>0)=1; % % contours 大于零的标记为前景1

labels.foregroundIndicative=zeros(1,Pros.numSP);
labels.backgroundIndicative=zeros(1,Pros.numSP);
labels.foreground=[];
labels.background=[];


% 判断这些超像素归属前景或背景
for i=1:1:Pros.numSP
    numPixelsInSP=length(SuperPixels(i).pos);
    
    % 统计每个超像素中，像素点落在前景和背景的个数
    count_foreground=0;
    count_background=0;
    for j=1:1:numPixelsInSP
        if (pixelsLabeling(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))==0)
            count_foreground=count_foreground+1;
        elseif (pixelsLabeling(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))==1)
            count_background=count_background+1;
        end
        
    end
    
    
    if count_foreground==numPixelsInSP
        labels.foregroundIndicative(i)=1;
        labels.foreground=[labels.foreground i];
    elseif count_background==numPixelsInSP
        labels.backgroundIndicative(i)=1;
        labels.background=[labels.background i];
    else % 如果轮廓穿过超像素时，前景区域更大，则整个超像素划为前景，否则划为背景
        if count_foreground>=count_background
            labels.foregroundIndicative(i)=1;
            labels.foreground=[labels.foreground i];
        end
    end
    
end

labels.foregroundCount=sum(labels.foregroundIndicative);
labels.backgroundCount=sum(labels.backgroundIndicative);



end

