function [ dirac_phi ] = diracFunction( phi, epsilon, heavisideFunctionType)
%DIRACFUNCTION 存放各种Dirac函数的函数。
% input:
% phi：嵌入函数：图像宽×图像高
% epsilon：带宽参数
% heavisideFunctionType：heaviside 函数类型。取值 '1' '2' '3' '4' 等
% output:
% dirac_phi：heaviside 函数的计算值：图像宽×图像高
switch heavisideFunctionType
	case '1' % sigmoid函数
		% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and Student's-t mixture model." Pattern Recognition 63: 71-86.
		expphi=exp(-phi./epsilon);
		expphi(expphi>=1E+15)=1E+15;
		dirac_phi=1./epsilon.*(expphi./(1+expphi).^2);
		
	case '2'
		% Chan, T.F. and L.A. Vese, Active contours without edges. IEEE Transactions on Image Processing, 2001. 10(2): p. 266-77.
		dirac_phi=(epsilon./pi).*(1./(epsilon.^2+ phi.^2));
		
	case '3'
		% Li, C. and C. Xu, et al. (2010). "Distance Regularized Level Set Evolution and Its Application to Image Segmentation." IEEE Transactions on Image Processing A Publication of the IEEE Signal Processing Society 19 (12): 3243-3254.
		dirac_phi=(1/2/epsilon)*(1+cos(pi.*phi./epsilon));
		b = (phi>=-epsilon) & (phi<=epsilon);
		dirac_phi = dirac_phi.*b;
		
	otherwise
		error('error at choose heaviside function type !');
		
end

end

