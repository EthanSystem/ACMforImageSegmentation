function [ Pros, phi] = evolution_ACMandGMMtoEq18( Pros, image_original ,image_processed)
% evolution_ACMandGMMtoEq18 ����[1]���ݻ�ģ�͵ĸ��졣��ʽ��(18)Ϊֹ��
%   input:
% Pros��Pros�ṹ��
% image_original��Ҫ�����ͼ���Ӧ��ԭʼͼ��
% image_processed��Ҫ�����ͼ��
% output:
% phi�����յ�Ƕ�뺯��
% Pros���ݻ���������µ�Pros�ṹ�塣
%
%   [ phi, Pros ] = evolution_ACMandGMMtoEq18( Pros, image_original ,image_processed)
%  �������µ��������������Ľ���
% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and
% Student's-t mixture model." Pattern Recognition 63: 71-86.
% ����ֻʵ��(18)ʽ����֮ǰ�����ݡ�
%


%% initialization
numState =Pros.numOfComponents;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
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

%% ��һ�ε�����ͨ��k-means��ʼ������ֵ��_i^(k=0) �ͦ�_i^(k=0) ����_i^k ����_i^k ���Լ�дΪ��_^k ����_^k����

% 			% MATLAB�Դ�����
% 			   objGMM_foreground=fitgmdist(data_foreground,Pros.numMMcomponents);
% ����������
[Pi, mu,Sigma ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������

while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	
	%% ������ǵ�һ�ε��������õ���������GMM-EM�㷨���²���ֵ\Tetha_i, \pi_i
	%% E�����æ�_k �����˹����p_k
	for i=1:numState
		Pxi(:,i)= gaussPDF(data, mu(:,i) , Sigma(:,:,i));
	end
	
	%% E������p_k �ͦ�_k �����˹��֧�ĺ�������z_k
	P_x_and_i = repmat(Pi, [numPixels 1]).*Pxi; % P_x_and_i��ͬʱ����x��i�ĸ��ʡ�ͼ����������������
	Px = sum(P_x_and_i, 2); % Px����˹�����ܶȡ�ͼ����������1
	Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix��������ʡ�ͼ����������������
	
	%% M������z_k ���㦨_(k+1)��
	sumPix = sum(Pix);
	for i=1:numState
		%Update the priors
		Pi(i) = sumPix(i) / numPixels;
		% Update the centers
		mu(:,i) = data*Pix(:,i) / sumPix(i);
		% Update the covariance matrices
		temp_mu = data - repmat(mu(:,i),1,numPixels);
		Sigma(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* temp_mu*temp_mu') / sumPix(i);
		% Add a tiny variance to avoid numerical instability
		Sigma(:,:,i) = Sigma(:,:,i) + 1E-15.*diag(ones(numVar,1));
	end
	
	if Pros.iteration_outer==1
		%% ��ʼ��\phi_0����ʽ(16)����z_k ��ʼ������\phi_k
		phi = Pros.epsilon.*log(Pix(:,1)./Pix(:,2));
	end
	
	% ������
	probabilityTerm=log(Pxi(:,1)./Pxi(:,2));
	
	%% 5. ��ˮƽ��\phi�����������˺���(19)
	dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	dirac_phi = reshape(dirac_phi, [],1);
	
	%% �������������
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
	
	% �����
	areaTerm=repmat(-1,numPixels,1);
	
	% ������
	edgeTerm=curvature;
	
	% [1](18) ����������ȥ�������
	L_phi = dirac_phi.*(Pros.mu.*probabilityTerm + Pros.beta.*edgeTerm + Pros.gamma.*areaTerm);
	
	% update \phi .
	phi=phi + Pros.timestep.*L_phi;
	
	
	
% 	%% ����\phi �ָ�õ��Ķ�ֵͼ����
% 	bwData=zeros(numData,1);
% 	bwData(phi<=0)=1;
% 	bwData = im2bw(bwData);
% 	
	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% ����\phi �ָ�õ��Ķ�ֵͼ����
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_ACMandGMMtoEq18(Pros, image_original, image_processed, phi, bwData, Pix, Pxi, Pi ,probabilityTerm, edgeTerm, dirac_phi, L_phi);
	end
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% ����\phi �ָ�õ��Ķ�ֵͼ����
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros ] = writeData_ACMandGMMtoEq18(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi, mu, Sigma);
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

end


function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
end



