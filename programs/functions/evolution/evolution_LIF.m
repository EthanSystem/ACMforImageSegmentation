function [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LIF( Pros, image_original, image_processed, phi0 )
%EVOLUTION_LIF  Zhang Kaihua �� LIF ģ�ͣ���ɫͼ�汾��
% ref:
% Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.

%% initialization
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
phi= -phi0; % ��תphi��Ϊǰ��С��0����������0������Ӧ�ڸ÷�����ԭʼ����
image_data=im2double(image_original);

% �����ʼ�����ǽ�Ծ��������ô�� phi ���ó�ʼ�Ľ�Ծֵ
if 1==strcmp(Pros.initializeType, 'staircase')
    phi = phi.*Pros.contoursInitValue;
end


%% ��ʼ��ͣ������
oldBwData=zeros(numRow, numCol);
oldBwData(phi<=0)=1;
oldBwData = imbinarize(oldBwData);
numPixelChanged = numPixels;

% %% ������ģ�����ƽ��ʱ�����ģ�k��ֵ��ʼ��
% % �����ʼ���������CVģ���Ƕ���ġ���Ŀ�����ڼ���������ͬ����ʼ����ģ�͵�����ʱ��Ĳ��졣
% numState =2;
% temp = data.';
% [Prior, mu,Sigma ]= EM_init_kmeans(temp, numState, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
% clear Prior mu Sigma


%% evolution
% Ksigma = fspecial('gaussian', Pros.hsize, Pros.sigma);
% K_phi = fspecial('gaussian', Pros.hsize_phi, Pros.sigma_phi);

Ksigma = fspecial('gaussian', 2 * round(2 * Pros.sigma)+1, Pros.sigma);
K_phi = fspecial('gaussian', Pros.hsize_phi, Pros.sigma_phi);

% while (Pros.elipsedEachTime<=Pros.numTime) % �Ƚ�ͬһʱ���ͣ������
% while (Pros.iteration_outer<=Pros.numIteration_outer) % �Ƚ�ͬһ������ͣ������
while (Pros.iteration_outer<=Pros.numIteration_outer) % ��������������ͣ������
% while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue) % ��������������ͣ������
    
    
    % ��ʼ���ε�����ʱ
    tic;
    
    
    phi = NeumannBoundCond(phi);
    
    heaviside_phi = heavisideFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
    dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
    
    sumxxa_1= repmat(heaviside_phi, 1,1,numVar).*image_data;
    sumxxb_1=repmat(heaviside_phi, 1,1,numVar);
    f1 = imfilter(sumxxa_1, Ksigma)./imfilter(sumxxb_1, Ksigma);
    sumxxa_2=(1-repmat(heaviside_phi, 1,1,numVar)).*image_data;
    sumxxb_2=1-sumxxb_1;
    f2 = imfilter(sumxxa_2, Ksigma)./imfilter(sumxxb_2, Ksigma);
    I_LFI =  f1.*sumxxb_1 + f2.*sumxxb_2;
    
    % 	f1 = conv2(data.*heaviside_phi,Ksigma,'same')./conv2(heaviside_phi,Ksigma,'same');
    % 	f2 = conv2(data.*(1-heaviside_phi),Ksigma,'same')./ conv2(1-heaviside_phi,Ksigma,'same');
    
    
    % ������ģ���reshape������������������ʱ����죬�Ա�ﵽ��ƽ��Ч����
    %     phi = reshape(phi, [], 1);
    %     phi = reshape(phi, numRow, numCol);
    
    
    % �ı���
    L_phi = dirac_phi.*mean((image_data - I_LFI).*(f1 - f2) ,3);
    phi = phi + Pros.timestep*L_phi;
    phi = conv2(phi,K_phi,'same');
    
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
    %         [Pros]=visualizeContours_LIF_fixedTime(Pros, image_original, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, dirac_phi, L_phi);
    %     end
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % ���ɶ�ֵͼ����
        bwData=zeros(numRow,numCol);
        bwData(phi<=0)=1;
        bwData = imbinarize(bwData);
        filename_bwImage = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
        filepath_bwImage = fullfile(Pros.folderpath_bwData, filename_bwImage);
        imwrite(bwData, filepath_bwImage, 'bmp');
        if exist(filepath_bwImage,'file')
            disp(['�ѱ���ָ��ֵͼ ' filename_bwImage]);
        else
            disp(['δ����ָ��ֵͼ ' filename_bwImage]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_LIF_new_fixedTime(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Prior, mu, Sigma);
        end
    end
    
    %%
    bwData=zeros(numRow,numCol);
    bwData(phi<=0)=1;
    bwData = imbinarize(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
end % end loop

phi=-phi; % ��ת phi �Ա��ǰ������0������С��0������Ӧ�������д���ݡ�


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

