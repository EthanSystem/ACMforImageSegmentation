function [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF( Pros, image_original, image_processed, phi0 )
%EVOLUTION_LBF  Li Chunming �� LBF ģ�ͣ���ɫ�ռ�汾��
%   ref:
% Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.

%% initialization
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
phi= phi0;
data=double(rgb2gray(image_original));

% ͣ������
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;

%% evolution
Ksigma=fspecial('gaussian', Pros.hsize, Pros.sigma); %��˹�˺���
while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	phi = NeumannBoundCond(phi);
	curvature=find_curvature(phi); %����������k
	dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	heaviside_phi = heavisideFunction( phi, Pros.epsilon, Pros.heavisideFunctionType );

	[f1, f2] = localBinaryFit(data, phi, Ksigma, Pros.epsilon);% ����f1��f2
	Kone=conv2(ones(size(data)),Ksigma,'same');
	e1=Kone.*data.*data-2*conv2(f1,Ksigma,'same').*data+conv2(f1.^2,Ksigma,'same');%����e1
	e2=Kone.*data.*data-2*conv2(f2,Ksigma,'same').*data+conv2(f2.^2,Ksigma,'same');%����e2
	dataForce=Pros.lambda1*e1 - Pros.lambda2*e2;
	
	%������
	dataTerm=-dirac_phi .*dataForce;
	%���ž��뺯����
	SDFTerm=Pros.mu*(4*del2(phi)-curvature);
	%������
	edgeTerm=Pros.beta*dirac_phi .*curvature;
	% �ı���
	phi=phi+Pros.timestep*(edgeTerm+SDFTerm+dataTerm);
	
	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% ����\phi �ָ�õ��Ķ�ֵͼ����
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_LBF_gray(Pros, data, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, dirac_phi, L_phi);
	end
	
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% ����\phi �ָ�õ��Ķ�ֵͼ����
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
% ����f1��f2
H=0.5*(1+(2/pi)*atan(phi./epsilon)); %��Ծ����
IH=Image.*H;
t1=conv2(IH,Ksigma,'same');%��f1�ķ���
t2=conv2(H,Ksigma,'same');%��f1�ķ�ĸ
f1=t1./(t2);
KI=conv2(Image,Ksigma,'same');
Kone=conv2(ones(size(Image)),Ksigma,'same');
f2=(KI-t1)./(Kone-t2);
return;
end


function g = NeumannBoundCond(f)
% �Ա߽���д���phiΪˮƽ������
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
return;
end


function curvature=find_curvature(phi)
%���������ʣ�phiΪˮƽ������
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

