function [ Pros, phi ] = evolution_GMM( Pros, image_original, image_processed, Prior0, mu0, Sigma0)
%EVOLUTION_GMM �ݻ�ģ�ͣ���ȫ��ͼ��������Ϊǰ����
%   �˴���ʾ��ϸ˵��



%% initialization
numState = Pros.numOfComponents;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ������
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
data = double(image_original);
data = reshape(data ,[] ,numVar);
data=data.'; % Ҫ�����ͼ�����ݡ�ά����������


%% k��ֵ��ʼ��
% Prior��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
mu = mu0;
Sigma = Sigma0;
Prior = Prior0;

% [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������

%% Initialization of the parameters


% ��ʼ��ͣ������
oldBwData=zeros(numPixels,1);
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;

% while (Pros.elipsedEachTime<=Pros.numTime) % �Ƚ�ͬһʱ���ͣ������
% while (Pros.iteration_outer<=Pros.numIteration_outer) % �Ƚ�ͬһ������ͣ������
while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue) % ��������������ͣ������
	
	% ��ʼ���ε�����ʱ
	tic;
	
	%% E-step
	for i=1:numState
		%Compute probability p(x|i)
		Pxi(:,i) = gaussPDF(data, mu(:,i), Sigma(:,:,i), Pros.smallNumber);
	end
	%Compute posterior probability p(i|x)
	Pix_tmp = repmat(Prior,[numPixels 1]).*Pxi;
	Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 numState]);
	%Compute cumulated posterior probability
	EE = sum(Pix);
	
	%% M-step
	for i=1:numState
		%Update the priors
		Prior(i) = EE(i) / numPixels;
		%Update the centers
		mu(:,i) = data*Pix(:,i) / EE(i);
		%Update the covariance matrices
		Data_tmp1 = data - repmat(mu(:,i),1,numPixels);
		Sigma(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* Data_tmp1*Data_tmp1') / EE(i);
		% Add a tiny variance to avoid numerical instability
		Sigma(:,:,i) = Sigma(:,:,i) + 1E-15.*diag(ones(numVar,1));
	end
	
	%% �������
	% 	for i=1:numState
	% 		Pxi(:,i) = gaussPDF(data, mu(:,i), Sigma(:,:,i));
	% 	end
	
	
	% �������ε�����ʱ
	elipsedTime010 = toc;
	Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
	
	
	%% visualization
	%     if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
	%         % ����\phi �ָ�õ��Ķ�ֵͼ����
	%         bwData=zeros(numPixels,1);
	%         bwData(phi<=0)=1;
	%         bwData = im2bw(bwData);
	%
	%         [Pros]=visualizeContours_GMM_fixedTime(Pros, image_original, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, dirac_phi, L_phi);
	%     end
	%% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
		% ���ɶ�ֵͼ����
		bwData=zeros(numPixels,1);
		bwData(Pix(:,1)-Pix(:,2)>=0)=1;
		bwData = reshape(bwData, numRow, numCol);
		bwData = im2bw(bwData);
		filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
		filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
		imwrite(bwData, filepath_bwData, 'bmp');
		if exist(filepath_bwData,'file')
			disp(['�ѱ���ָ��ֵͼ���� ' filename_bwData]);
		else
			disp(['δ����ָ��ֵͼ���� ' filename_bwData]);
		end
		
		if  strcmp(Pros.isWriteData,'yes')==1
			[Pros ] = writeData_GMM_fixedTime(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
		end
	end
	%%
	bwData=zeros(numPixels,1);
	bwData(Pix(:,1)-Pix(:,2)>=0)=1;
	bwData = im2bw(bwData);
	pixelChanged = xor(bwData, oldBwData);
	numPixelChanged = sum(pixelChanged(:));
	oldBwData = bwData;
	Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
	
end % end loop

% ���� \phi
phi =Pix(:,1)-Pix(:,2);  % ��� phi ����ָˮƽ�����Ƕ�뺯������ָ������֧���������ʵĲ�ֵ��������Ϊ�˷���������ı�������ͳһ���ѡ�


return;

end

