function [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF( Pros, image_original, image_processed, phi0 )
%EVOLUTION_LBF  Li Chunming 的 LBF 模型（彩色空间版本）
%   ref:
% Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.

%% initialization
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
phi= phi0;
data=double(rgb2gray(image_original));

% 停机条件
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;

%% evolution
Ksigma=fspecial('gaussian', Pros.hsize, Pros.sigma); %高斯核函数
while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	phi = NeumannBoundCond(phi);
	curvature=find_curvature(phi); %求函数的曲率k
	dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	heaviside_phi = heavisideFunction( phi, Pros.epsilon, Pros.heavisideFunctionType );

	[f1, f2] = localBinaryFit(data, phi, Ksigma, Pros.epsilon);% 计算f1和f2
	Kone=conv2(ones(size(data)),Ksigma,'same');
	e1=Kone.*data.*data-2*conv2(f1,Ksigma,'same').*data+conv2(f1.^2,Ksigma,'same');%计算e1
	e2=Kone.*data.*data-2*conv2(f2,Ksigma,'same').*data+conv2(f2.^2,Ksigma,'same');%计算e2
	dataForce=Pros.lambda1*e1 - Pros.lambda2*e2;
	
	%数据项
	dataTerm=-dirac_phi .*dataForce;
	%符号距离函数项
	SDFTerm=Pros.mu*(4*del2(phi)-curvature);
	%长度项
	edgeTerm=Pros.beta*dirac_phi .*curvature;
	% 改变量
	phi=phi+Pros.timestep*(edgeTerm+SDFTerm+dataTerm);
	
	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% 生成\phi 分割得到的二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_LBF_gray(Pros, data, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, dirac_phi, L_phi);
	end
	
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% 生成\phi 分割得到的二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros ] = writeData_LBF_gray(Pros, data, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
	end
	
	%%
	bwData=zeros(numPixels,1);
	bwData(phi<=0)=1;
	bwData = im2bw(bwData);
	pixelChanged = xor(bwData, oldBwData);
	numPixelChanged = sum(pixelChanged(:));
	oldBwData = bwData;
	Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
end % end loop




return;
end

function [f1, f2]= localBinaryFit(Image, phi, Ksigma, epsilon)
% 计算f1和f2
H=0.5*(1+(2/pi)*atan(phi./epsilon)); %阶跃函数
IH=Image.*H;
t1=conv2(IH,Ksigma,'same');%求到f1的分子
t2=conv2(H,Ksigma,'same');%求到f1的分母
f1=t1./(t2);
KI=conv2(Image,Ksigma,'same');
Kone=conv2(ones(size(Image)),Ksigma,'same');
f2=(KI-t1)./(Kone-t2);
return;
end


function g = NeumannBoundCond(f)
% 对边界进行处理，phi为水平集函数
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
return;
end


function curvature=find_curvature(phi)
%求函数的曲率，phi为水平集函数
[phi_x, phi_y]=gradient(phi);
norm_phi=sqrt(phi_x.^2+phi_y.^2+1e-10);
phi_x=phi_x./norm_phi;
phi_y=phi_y./norm_phi;
[phi_xx , ~]=gradient(phi_x);
[~, phi_yy]=gradient(phi_y);
curvature=phi_xx+phi_yy;
return;
end

end

