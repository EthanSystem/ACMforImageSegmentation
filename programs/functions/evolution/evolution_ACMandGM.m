function [ Pros, phi] = evolution_ACMandGM( Pros, image_original ,image_processed, phi0)
% evolution_ACMandGM ����[5].Chapter2 ��˼·
%   input:
% Pros��Pros�ṹ��
% image_original��Ҫ�����ͼ���Ӧ��ԭʼͼ��
% image_processed��Ҫ�����ͼ��
% phi0����ʼ��Ƕ�뺯��
% output:
% phi�����յ�Ƕ�뺯��
% Pros���ݻ���������µ�Pros�ṹ�塣
%
%


%% initialization
numState = Pros.numOfComponents;	% ��֦��==1�ȼ��� GM ģ�͡�
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
image_data = double(image_original);
data = reshape(image_data ,[] ,numVar);
data=data.'; % Ҫ�����ͼ�����ݡ�ά����������

%% evolution

%% ��ʼ��������Ƕ�뺯����phi
% ��ʼ��������
phi = phi0;
% ͣ������
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;
%% evolution
while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	
	%% ���� phi ����ǰ���ͱ��� GM �Ĳ���ֵ��_i^(k=0)����_i^k ���Լ�дΪ��_^k ����
	% ǰ�������� GM ģ�͡���ֵ��ά����Э���ά����ά��
	
	% [~, mu_foreground, Sigma_foreground ] = EM_init_kmeans(data, numState);
	% [~, mu_background, Sigma_background ] = EM_init_kmeans(data, numState);
	
	data_foreground = data(:,phi<=0);	% data_foreground������ǰ�������ݵļ��ϡ�ά����ǰ��������������ͬ�¡�
	data_background = data(:,phi>0);
	sumX1 = sum(data_foreground,2);		% sumX1�� ����ǰ�������е����ص�ֱ�Ը�ά����͡�ά����1.
	sumX2 = sum(data_background,2);
	N1=size(data_foreground, 2); % N1 ������ǰ�������ص�ĸ���
	N2=numPixels - N1;
	mu_foreground = sumX1./N1; % mu_foreground��ǰ��GMģ�͵ľ�ֵ��ά����1
	mu_background = sumX2./N2;
	sumXX1 = data_foreground-repmat(mu_foreground, 1, N1); % ǰ��GMģ�͵�Э�����(x-mu)���֡�ά����ά��
	sumXX2 = data_background-repmat(mu_background, 1, N2);
	Sigma_foreground = (sumXX1*sumXX1')./N1 ; % ǰ��GMģ�͵�Э���ά����ά��
	Sigma_background  = (sumXX2*sumXX2')./N2 ;
	
	
	
	
	
	%% Step 1 ˮƽ�������ݻ�����(14)�ͣ�11����
	% ��ˮƽ��\phi �����������˺���(12)
	dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	dirac_phi = reshape(dirac_phi, [],1);
	
	% ���ݲ���ֵ���������������ʣ�
	% Px_foreground��Ϊ�õ���ǰ��ģ���е��ܶ�
	Px_foreground = gaussPDF(data, mu_foreground , Sigma_foreground);
	% Px_background ��Ϊ�õ��ڱ���ģ���е��ܶ�
	Px_background = gaussPDF(data, mu_background , Sigma_background);
	
	% ������
	probabilityTerm = log(Px_foreground./Px_background);
	
	% �������������
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
	% ������
	edgeTerm=curvature;
	
	% �����
	areaTerm=repmat(-1,numPixels,1);
	
	
	% [5](11)�ı�������������ȥ�������
	L_phi = dirac_phi.*(Pros.mu.*probabilityTerm + Pros.beta.*edgeTerm - Pros.gamma.*areaTerm);
	
	% update \phi . (14)
	phi=phi + Pros.timestep.*L_phi;
	
	
	
	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% ����\phi �ָ�õ��Ķ�ֵͼ����
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_ACMandGM(Pros, image_original, image_processed, phi, bwData, Px_foreground, Px_background ,probabilityTerm, edgeTerm, dirac_phi, L_phi);
	end
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% ����\phi �ָ�õ��Ķ�ֵͼ����
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros ] = writeData_ACMandGM(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi, mu, Sigma);
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







function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
end



