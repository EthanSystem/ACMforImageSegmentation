function [ numPixelChanged ] = endLoopCondition( bwData )
%ENDLOOPCONDITION �ж��Ƿ���Ҫ�����ݻ�ѭ��
%   �˴���ʾ��ϸ˵��
if Pros.iteration_outer ==1
	oldBwData = Inf();
end
pixelChanged = xor(bwData, oldBwData);
numPixelChanged = sum(pixelChanged(:));
oldBwData = bwData;
Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1

end

