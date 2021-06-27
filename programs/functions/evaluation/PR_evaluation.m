function [ Precision , Recall, F_beta,ME] = PR_evaluation( A, B, beta )
%PR_EVALUATION 计算F1指标。
%   input:
% A：标准二值图：一张图像数据。
% B：我们的二值图：一张图像数据。
% output:
% Precision：查准率。数值0~1。
% Recall：查全率。数值0~1。
% F1：F1指标。0~1。
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
% 其中，p1==p(1,1)==TN		p3==p(1,2)==FP
%		p2==p(2,1)==FN  	p4==p(2,2)==TP
for x=1:B1
    for y=1:B2
        p(A(x,y)+1,B(x,y)+1)=p(A(x,y)+1,B(x,y)+1)+1;
    end
end

ME=1-(p(1)+p(4))/(B1*B2);	% 错误率：原版的
Ao=sum(A(:));	% 查全率 R 的分母 TP+FN
At=sum(B(:));	% 查准率 P 的分母 TP+FP

if beta==1
    F_beta=2.*p(2,2)./(sum(p(:))+p(2,2)-p(1,1));
else
    F_beta=0;
    if p(2,2)~=0
        F_beta=(1+beta^2).*Precision.*Recall./((beta^2)*Precision+Recall);
        %     disp(['计算F1的值为：' num2str(F1)]);
    end
end

Precision=p(2,2)./At;
Recall=p(2,2)./Ao;

% if (Ao>At)
% 	RAE=(Ao-At)/Ao; % 计算 RAE = (FN-FP)/(TP+FN)
% else
% 	RAE=(At-Ao)/At; % 计算 RAE = (FP-FN)/(TP+FP)
% end

end

