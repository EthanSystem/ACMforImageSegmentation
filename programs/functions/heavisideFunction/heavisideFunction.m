function [ heaviside_phi ] = heavisideFunction( phi, epsilon, type )
%HEAVISIDEFUNCTION 存放各种Heaviside函数的文件夹。
% input:
% phi：嵌入函数：图像宽×图像高
% epsilon：带宽参数
% heavisideFunctionType：heaviside 函数类型。取值 '1' '2' '3' '4' 等
% output:
% heaviside_phi：heaviside 函数的计算值：图像宽×图像高

switch type
	case '1' % sigmoid函数
		% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and Student's-t mixture model." Pattern Recognition 63: 71-86.
		expphi=exp(-phi./epsilon);
		heaviside_phi=1./(1+expphi);
		
		
	case '2'
		% Chan, T.F. and L.A. Vese, Active contours without edges. IEEE Transactions on Image Processing, 2001. 10(2): p. 266-77.
		heaviside_phi = 0.5*(1+ (2./pi).*atan(phi./epsilon));
		
	case '3'
		% Li, C. and C. Xu, et al. (2010). "Distance Regularized Level Set Evolution and Its Application to Image Segmentation." IEEE Transactions on Image Processing A Publication of the IEEE Signal Processing Society 19 (12): 3243-3254.
		heaviside_phi = 0.5*(1+ phi./epsilon + (1./pi).*sin(pi.*phi./epsilon));
		b1 = (phi>=-epsilon) & (phi<=epsilon);
		b2 = (phi>epsilon);
		heaviside_phi = heaviside_phi.*b1+b2;
		
	otherwise
		error('error at choose heaviside function type !');
		
end


end

