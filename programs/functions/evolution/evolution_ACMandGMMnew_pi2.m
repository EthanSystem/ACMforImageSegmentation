function [Pros, phi] = evolution_ACMandGMMnew_pi2( Pros, image_original ,image_processed, phi0, Prior0, mu0, Sigma0 )
% evolution_ACMandGMM_fixedTime ��������[1]���ݻ�ģ�͵ĸ��졣�õ�������Ϣ��ʽ(25����

%   input:
% Pros��Pros�ṹ�塣
% image_original��Ҫ�����ͼ���Ӧ��ԭʼͼ��
% image_processed��Ҫ�����ͼ��
% phi0: ��ʼ������
% Prior0: ��ʼ���顣
% mu0: ��ʼ��ֵ��
% Sigma0: ��ʼЭ���

% output:
% phi�����յ�Ƕ�뺯����
% Pros���ݻ���������µ�Pros�ṹ�塣

%  �������µ��������������Ľ���
% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and Student's-t mixture model." Pattern Recognition 63: 71-86.


%% initialization
numState =2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol;
image_data = double(image_original);
Pxi = zeros( numPixels,numState); % Pxi���������ʡ�ͼ����������������
phi = reshape(phi0, [], 1); % ��ʼ���� Ƕ�뺯������������1.

% �����ʼ�����ǽ�Ծ��������ô�� phi ���ó�ʼ�Ľ�Ծֵ
if 1==strcmp(Pros.initializeType, 'staircase')
    phi = phi.*Pros.contoursInitValue;
end

% ��ʼ��ͣ������
oldBwData=zeros(numRow, numCol);
oldBwData(phi(:)>=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;


%% ��ʼ�� first iteration
% Prior��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
mu = mu0;
Sigma = Sigma0;
Prior = Prior0;

%% �����ʼ����ʽ�����������
if (strcmp(Pros.initMethod,'kmeans_ACMGMM')==1 || strcmp(Pros.initMethod,'circle_SDF_ACMGMM')==1)
    
    
    
    
    %% generate edge indicator function at color image.
    %     G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    %     image_smooth=imfilter(image_data,G,'same');  % smooth image by Gaussiin convolution
    %     Ix=zeros(numRow,numCol,numVar);
    %     Iy=zeros(numRow,numCol,numVar);
    %     temp_f=zeros(numRow,numCol,numVar);
    %     for k=1:numVar
    %         [Ix(:,:,k),Iy(:,:,k)]=gradient(image_smooth(:,:,k));
    %         temp_f(:,:,k)=Ix(:,:,k).^2+Iy(:,:,k).^2;
    %     end
    %     f=mean(temp_f,3);
    %     g=1./(1+f);  % edge indicator function.
    %     [vx,vy]=gradient(g); % gradient of edge indicator function.
    %     g=reshape(g,[],1);
    %     vx=reshape(vx,[],1);
    %     vy=reshape(vy,[],1);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    %% generate edge indicator function at gray image.
    image_gray=rgb2gray(image_data);
    G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    image_smooth=imfilter(image_gray,G,'same');  % smooth image by Gaussiin convolution
    [Ix,Iy]=gradient(image_smooth);
    f=Ix.^2+Iy.^2;
    g=1./(1+f);  % edge indicator function.
    [vx,vy]=gradient(g); % gradient of edge indicator function.
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    
    %%
    g=reshape(g,[],1);
    vx=reshape(vx,[],1);
    vy=reshape(vy,[],1);
    
    
    
    
    
    
    data = reshape(image_data ,[],numVar);
    data=data.'; % Ҫ�����ͼ�����ݡ�ά����������
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        L_phi = zeros(Pros.numData,1);
        Px = zeros(Pros.numData,1);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, L_phi, bwData, Pix, Px, Pxi, Pi_vis );
    end
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
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
            [Pros ] = writeData_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
        end
    end
    
    %%
    bwData=zeros(numRow,numCol);
    bwData(phi(:)>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
    
    %% ����������ĳ�ʼ�����
else
    
    
    
    %% generate edge indicator function at color image.
    %     G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    %     image_smooth=imfilter(image_data,G,'same');  % smooth image by Gaussiin convolution
    %     Ix=zeros(numRow,numCol,numVar);
    %     Iy=zeros(numRow,numCol,numVar);
    %     temp_f=zeros(numRow,numCol,numVar);
    %     for k=1:numVar
    %         [Ix(:,:,k),Iy(:,:,k)]=gradient(image_smooth(:,:,k));
    %         temp_f(:,:,k)=Ix(:,:,k).^2+Iy(:,:,k).^2;
    %     end
    %     f=mean(temp_f,3);
    %     g=1./(1+f);  % edge indicator function.
    %     [vx,vy]=gradient(g); % gradient of edge indicator function.
    %     g=reshape(g,[],1);
    %     vx=reshape(vx,[],1);
    %     vy=reshape(vy,[],1);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    %% generate edge indicator function at gray image.
    image_gray=rgb2gray(image_data);
    G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    image_smooth=imfilter(image_gray,G,'same');  % smooth image by Gaussiin convolution
    [Ix,Iy]=gradient(image_smooth);
    f=Ix.^2+Iy.^2;
    g=1./(1+f);  % edge indicator function.
    [vx,vy]=gradient(g); % gradient of edge indicator function.
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %%
    g=reshape(g,[],1);
    vx=reshape(vx,[],1);
    vy=reshape(vy,[],1);
    
    
    
    data = reshape(image_data ,[],numVar);
    data=data.'; % Ҫ�����ͼ�����ݡ�ά����������
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    
    %% E�����æ�_k �����˹����p_k
    for i=1:numState
        Pxi(:,i)= gaussPDF(data, mu(:,i) , Sigma(:,:,i), Pros.smallNumber);
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
        Sigma(:,:,i) = Sigma(:,:,i) + Pros.smallNumber.*diag(ones(numVar,1));
    end
    
    %% ���д�GMM��ACM��ͨ�ţ���ʼ������ʽ(16)����z_k ��ʼ������Ƕ�뺯��\phi_0
    phi = Pros.epsilon.*g.*log(Pix(:,1)./Pix(:,2));
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% ���д�GMM��ACM��ͨ�ţ���ʱ֮ǰ�Ѿ���ʼ���� \phi_0������ʽ(20)����\phi_k ��p_k ��z_k ���㲢����\phi_(k+1)��
    phi=reshape(phi, numRow, numCol);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    %%
    phi=NeumannBoundCond(phi); % Neumann �߽�����
    [phi_x,phi_y]=gradient(phi);
    sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
    nx=phi_x./(sqrtOfPhi+Pros.smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfPhi+Pros.smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    curvature=reshape(curvature,[],1);
    nx=reshape(nx,[],1);
    ny=reshape(ny,[],1);
    phi=reshape(phi, [],1);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    L_phi=1./Pros.epsilon*Pix(:,1).*Pix(:,2).*(log(Pxi(:,1)./Pxi(:,2)) + Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - Pros.gamma.*g); % DeltaPhi��Ƕ�뺯���ĸ���ֵ��ͼ����������1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    
    
    %% ���д�ACM��GMM��ͨ�ţ���[1]��ʽ(25)
    % ʽ(25)����\phi_k �����_(k+1)��
    Prior(1)=mean(1./(1+exp(Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon)));
    Prior(2)=1-Prior(1);
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        Pi_vis=zeros(Pros.numData, 2);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, L_phi, bwData, Pix, Px, Pxi, Pi_vis );
    end
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        % 	filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '_bwData.bmp'];
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '.bmp'];
        filepath_bwImage = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwImage, 'bmp');
        if exist(filepath_bwImage,'file')
            disp(['�ѱ���ָ��ֵͼ ' filename_bwData]);
        else
            disp(['δ����ָ��ֵͼ ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Prior, mu, Sigma);
        end
    end
    %%
    bwData=zeros(numRow,numCol);
    bwData(phi(:)>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
    
    
end % end if Pros.initMethod

%% rest iteration

% while (Pros.elipsedEachTime<=Pros.numTime) % �Ƚ�ͬһʱ���ͣ������
% while (Pros.iteration_outer<=Pros.numIteration_outer) % �Ƚ�ͬһ������ͣ������
% while (Pros.iteration_outer<=Pros.numIteration_outer) % ��������������ͣ������
while (Pros.iteration_outer<=Pros.numIteration_outer &&	numPixelChanged>=Pros.numPixelChangedToContinue) % ��������������ͣ������
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    %% E�����æ�_k �����˹����p_k
    for i=1:numState
        Pxi(:,i)= gaussPDF(data, mu(:,i) , Sigma(:,:,i), Pros.smallNumber);
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
    
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% ���д�GMM��ACM��ͨ�ţ���ʱ֮ǰ�Ѿ���ʼ���� \phi_0������ʽ(20)����\phi_k ��p_k ��z_k ���㲢����\phi_(k+1)��
    phi=reshape(phi, numRow, numCol);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    %%
    phi=NeumannBoundCond(phi); % Neumann �߽�����
    [phi_x,phi_y]=gradient(phi);
    sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
    nx=phi_x./(sqrtOfPhi+Pros.smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfPhi+Pros.smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    curvature=reshape(curvature,[],1);
    nx=reshape(nx,[],1);
    ny=reshape(ny,[],1);
    phi=reshape(phi, [],1);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    L_phi=1./Pros.epsilon*Pix(:,1).*Pix(:,2).*(log(Pxi(:,1)./Pxi(:,2)) + Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - Pros.gamma.*g); % DeltaPhi��Ƕ�뺯���ĸ���ֵ��ͼ����������1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    
    
    %% ���д�ACM��GMM��ͨ�ţ���[1]��ʽ(25)
    % ʽ(25)����\phi_k �����_(k+1)��
    Prior(1)=mean(1./(1+exp(Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon)));
    Prior(2)=1-Prior(1);
    
    
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        Pi_vis(:,1)=1./(1+exp(Pros.gamma-Pros.beta.*g.*curvature-phi./Pros.epsilon));
        Pi_vis(:,2)=1-Pi_vis(:,1);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, L_phi, bwData, Pix, Px, Pxi, Pi_vis );
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
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
            [Pros ] = writeData_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
        end
    end
    %%
    bwData=zeros(numRow,numCol);
    bwData(phi(:)>=0)=1;
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

