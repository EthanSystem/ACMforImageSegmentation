function [ indicatorOfClass ] = LabelingSP( SuperPixels , phi , Pros)
% LABELINGSP 根据contours的值，或者根据用户定义的前景或者背景的标记，对每个超像素属于前景或者背景的的标记
...inputs:
...SuperPixels: 
...contours: 轮廓线
...arguments
...properties
...outputs:
...outputs:
...labels: 前景或背景的标记



pixelsLabeling=phi;
pixelsLabeling(pixelsLabeling>=0)=1;  % phi 大于零的标记为前景=1
pixelsLabeling(pixelsLabeling<0)=0; % % phi 小于零的标记为背景=0

indicatorOfClass.foregroundIndicative=zeros(1,Pros.numSP);
indicatorOfClass.backgroundIndicative=zeros(1,Pros.numSP);
indicatorOfClass.foreground=[];
indicatorOfClass.background=[];


% 判断这些超像素归属前景或背景
for i=1:1:Pros.numSP
    numPixelsInSP=length(SuperPixels(i).pos);
    
    % 统计每个超像素中，像素点落在前景和背景的个数
    count_foreground=0;
    count_background=0;
    for j=1:1:numPixelsInSP
        if (pixelsLabeling(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))==1)
            count_foreground=count_foreground+1;
        elseif (pixelsLabeling(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))==0)
            count_background=count_background+1;
        end
        
    end
    
    
    if count_foreground==numPixelsInSP
        indicatorOfClass.foregroundIndicative(i)=1;
        indicatorOfClass.foreground=[indicatorOfClass.foreground i];
    elseif count_background==numPixelsInSP
        indicatorOfClass.backgroundIndicative(i)=1;
        indicatorOfClass.background=[indicatorOfClass.background i];
    else % 如果轮廓穿过超像素时，前景区域更大，则整个超像素划为前景，否则划为背景
        if count_foreground>=count_background
            indicatorOfClass.foregroundIndicative(i)=1;
            indicatorOfClass.foreground=[indicatorOfClass.foreground i];
        end
    end
    
end

indicatorOfClass.foregroundCount=sum(indicatorOfClass.foregroundIndicative);
indicatorOfClass.backgroundCount=sum(indicatorOfClass.backgroundIndicative);



end

