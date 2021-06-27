function [ fowlkesAndMallowsIndex ] = FMI_evaluation( A, B )
%FMI_EVALUATION calculate FMI evaluation
% A means ground truth image.
% B means our bw-image.

%  FMI_evaluation.m
% Compute the Fowldes and Mallows Index of two images.

% A value of "1" = the line object (foreground).
% A value of "0" = the background.

A=im2bw(A);
B=im2bw(B);

A=double(A);
B=double(B);
p=zeros(2,2);
p=double(p);
[B1,B2]=size(A);
Asize = size(A);
Bsize = size(B);
% Check if the points have the same dimensions
if Asize(2) ~= Bsize(2)
	error('The dimensions of points in the two sets are not equal');
end

% 创建分类结果混淆矩阵,
% 其中，	p1==TN		p3==FP
%				p2==FN		p4==TP
for x=1:B1;
	for y=1:B2;
		p(A(x,y)+1,B(x,y)+1)=p(A(x,y)+1,B(x,y)+1)+1;
	end
end

fowlkesAndMallowsIndex = sqrt();
end

