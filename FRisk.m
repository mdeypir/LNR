%xT Train data
%yT Train label
%xt Test data
%yt Test label
% FRU (Feature based risk score computation)
function Res = FRisk(xT, yT, xt, yt)
    mxT = max(xT,[],1); %finding maximum of each feature
    mxTu=repmat(mxT,size(xT,1),1); 
    xT_normalize = xT./mxTu; % dividing each feature by maximum of that feature
    mxtu=repmat(mxT,size(xt,1),1); 
    xt_normalize = xt./mxtu; % dividing each feature by maximum of that feature
    benign = xT_normalize(yT==0,:); % finding benign training urls
    malicious = xT_normalize(yT==1,:); % finding malicious training urls
    mb = mean(benign,1);   %finding mean of each feature for benign urls
    mm = mean(malicious,1); % finding mean of each feature for malicious urls
    direct = mm>mb;
    directu = repmat(direct,size(xt,1),1);
    indirect = mb >mm;
    indirectu = repmat(indirect,size(xt,1),1);
    MMX = repmat(mm,size(xt_normalize,1),1);
    MBX = repmat(mb,size(xt_normalize,1),1);
    % next line is FRU
    wurls = xt_normalize.*MMX .* directu + (1./(xt_normalize.*MBX+eps)) .* indirectu;
    risks = sum(wurls,2);
    [V,IX] = sort(risks,'descend'); %sorting all risk score in descending order to find top score apps
    lab =yt(IX);       % finding label of sorted apps
    N = size(xt,1);    % N is the number of all tested apps
    j =0;
    for i=0.01:0.01:1
        topip =  round(N*i);   % finding the number of top i prescent apps
        j = j+1;
        DetMals(j) = sum(lab(1:topip)); 
        AUC(j) = sum(lab(1:topip))/ topip; % finding area under curve for topi
    end
    Res(2:101) = DetMals/size(xt(yt == 1,:),1); 
    Res(1)=0;
    
    