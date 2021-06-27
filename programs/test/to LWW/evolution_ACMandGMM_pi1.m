function [Pros, phi] = evolution_ACMandGMM_pi1( Pros, image_original ,image_processed)
% evolution_ACMandGMM ��������[1]���ݻ�ģ�͵ĸ��졣�õ�������Ϣ��ʽ(23)��
%   input:
% Pros��Pros�ṹ��
% image_original��Ҫ�����ͼ���Ӧ��ԭʼͼ��
% image_processed��Ҫ�����ͼ��
% output:
% phi�����յ�Ƕ�뺯��
% Pros���ݻ���������µ�Pros�ṹ�塣

%  �������µ��������������Ľ���
% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and Student's-t mixture model." Pattern Recognition 63: 71-86.
%

%% initialization
numState =2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol;
image_data = double(image_original);
data = reshape(image_data ,[],numVar);
data=data.'; % Ҫ�����ͼ�����ݡ�ά����������
Pxi = zeros( numPixels,numState); % Pxi���������ʡ�ͼ����������������
phi = zeros(numPixels, 1); % ��ʼ���� Ƕ�뺯������������1.

% ͣ������
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;
%% evolution

%% k��ֵ��ʼ��
[Prior, mu,Sigma ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������

while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	
	%% E�����æ�_k �����˹����p_k
	for i=1:numState
		Pxi(:,i)= gaussPDF(data, mu(:,i) , Sigma(:,:,i));
	end
	
	%% E������p_k �ͦ�_k �����˹��֧�ĺ�������z_k
	P_x_and_i = repmat(Prior, [numPixels 1]).*Pxi;		% P_x_and_i��ͬʱ����x��i�ĸ��ʡ�ͼ����������������
	Px = sum(P_x_and_i,2); % Px����˹�����ܶȡ�ͼ����������1
	Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix��������ʡ�ͼ����������������
	
	
	%% M������z_k ���㦨_(k+1)��
	sumPix = sum(Pix);
	for i=1:numState
		% Update the centers
		mu(:,i) = data*Pix(:,i) / sumPix(i);
		% Update the covariance matrices
		temp_mu = data - repmat(mu(:,i),1,numPixels);
		Sigma(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* temp_mu*temp_mu') / sumPix(i);
		% Add a tiny variance to avoid numerical instability
		Sigma(:,:,i) = Sigma(:,:,i) + 1E-15.*diag(ones(numVar,1));
	end
	
	%% ���д�GMM��ACM��ͨ�ţ���ʼ������ʽ(16)����z_k ��ʼ������Ƕ�뺯��\phi_k
	if Pros.iteration_outer ==1
		phi = Pros.epsilon.*log(Pix(:,1)./Pix(:,2));
	end
	
	%% ���д�ACM��GMM��ͨ�ţ���[1]��ʽ(23)
	% ʽ(23)����\phi_k ��p_k �����_(k+1)��
	Pi_vis(:,1)=1./(1+exp(log(Pix(:,1)./Pix(:,2))-phi./Pros.epsilon)); % Pi_vis������̯��ÿ�����ص��ϵ�������ʣ����ڿ��ӻ���ͼ����������������
	Pi_vis(:,2)=1-Pi_vis(:,1);
	Prior(1) = mean(Pi_vis(:,1)); % Pi��������ʡ�1��������
	Prior(2) = 1-Prior(1);
	
	%% ���д�GMM��ACM��ͨ�ţ���ʱ֮ǰ�Ѿ���ʼ���� \phi_0������ʽ(20)����\phi_k ��p_k ��z_k ���㲢����\phi_(k+1)��
	phi=reshape(phi, numRow, numCol);	% reshape \phi
	phi=NeumannBoundCond(phi);
	[phi_x,phi_y]=gradient(phi);
	sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
	smallNumber=1E-15;
	nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
	ny=phi_y./(sqrtOfPhi+smallNumber);
	[nxx,~]=gradient(nx);
	[~,nyy]=gradient(ny);
	curvature=nxx+nyy;
	curvature=reshape(curvature,[],1);	% reshape curvature
	phi =reshape(phi, [],1);	% reshape \phi
	L_phi=1./Pros.epsilon*Pix(:,1).*Pix(:,2).*(log(Pxi(:,1)./Pxi(:,2)) + Pros.beta.*curvature - Pros.gamma); % DeltaPhi��Ƕ�뺯���ĸ���ֵ��ͼ����������1
	
	% update \phi .
	phi=phi + Pros.timestep.*L_phi;
	
	
	
	
	
	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% ���ɶ�ֵͼ����
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_ACMandGMM(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, Pi_vis );
	end
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% ���ɶ�ֵͼ����
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros ] = writeData_ACMandGMM(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Prior, mu, Sigma);
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

return ;
end

function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
end

