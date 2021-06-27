function [ numPixelChanged ] = endLoopCondition( bwData )
%ENDLOOPCONDITION 判断是否需要继续演化循环
%   此处显示详细说明
if Pros.iteration_outer ==1
	oldBwData = Inf();
end
pixelChanged = xor(bwData, oldBwData);
numPixelChanged = sum(pixelChanged(:));
oldBwData = bwData;
Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1

end

