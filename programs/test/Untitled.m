while  iteration_outer<=numIteration_outer%水平集的迭代终止条件
	%% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	for i=1:nbStates
		%Compute probability p(x|i)
		Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
		phi = epsilon.*log(Pxi(:,1)./Pxi(:,1));%初始化phi
	end
	%Compute posterior probability p(i|x)
	Pix_tmp = repmat(Priors,[nbData 1]).*Pxi;
	Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 nbStates]);
	%Compute cumulated posterior probability
	E = sum(Pix);
	%% M-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%用phi来计算pi,即更新先验
	phi=reshape(phi, nbVar, nbData);     % 运行报错的地方
	[phi_x,phi_y]=gradient(phi);
	sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
	smallNumber=1e-10;
	nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
	ny=phi_y./(sqrtOfPhi+smallNumber);
	[nxx,~]=gradient(nx);
	[~,nyy]=gradient(ny);
	curvature=nxx+nyy;
	curvature=reshape(curvature,[],1);
	phi = reshape(phi, [],1);
	Priors(:,1)=1./(1+exp(gamma-beta.*curvature-phi./epsilon));
	Priors(:,2)=1-Priors(:,1);
	Pi(1)=mean(Priors(:,1));
	Pi(2)=1-Pi(1);
	
	%?更新phi
	phi=reshape(phi, nbVar, nbData);    % reshape \phi
	phi=NeumannBoundCond(phi);
	[phi_x,phi_y]=gradient(phi);
	sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
	smallNumber=1e-10;
	nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
	ny=phi_y./(sqrtOfPhi+smallNumber);
	[nxx,~]=gradient(nx);
	[~,nyy]=gradient(ny);
	curvature=nxx+nyy;
	curvature=reshape(curvature,[],1);  % reshape curvature
	phi =reshape(phi, [],1);    % reshape \phi
	DeltaPhi=1./Pros.epsilon*Pix(:,1).*Pix(:,2).*(log(Pxi(:,1)./Pxi(:,2)) + Pros.beta.*curvature - Pros.gamma);
	% update \phi .
	phi=phi + Pros.timestep.*DeltaPhi;
end


%%生成phi得到的二值图数据
bwData=zeros(numData,1);
bwData(phi>=0)=1;

iteration_outer = iteration_outer+1;

for i=1:nbStates
	%Update the priors
	% Priors(i) = E(i) / nbData;
	%Update the centers
	Mu(:,i) = Data*Pix(:,i) / E(i);
	%Update the covariance matrices
	Data_tmp1 = Data - repmat(Mu(:,i),1,nbData);
	Sigma(:,:,i) = (repmat(Pix(:,i)',nbVar, 1) .* Data_tmp1*Data_tmp1') / E(i);
	%% Add a tiny variance to avoid numerical instability
	Sigma(:,:,i) = Sigma(:,:,i) + 1E-5.*diag(ones(nbVar,1));
end
