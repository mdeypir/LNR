%xT Train data
%yT Train label
%xt Test data
%yt Test label
%NRU (KNN based risk score computation)
function Res = NRU(xT, yT, xt, yt)
    MxT = xT(yT == 1,:);
    BxT = xT(yT == 0,:);
    IdMxT = knnsearch(MxT,xt);% default k =1 
    IdBxT = knnsearch(BxT,xt);
    MD = sqrt(sum(( xt - xT(IdMxT,:)).^2,2));
    BD = sqrt(sum(( xt - xT(IdBxT,:)).^2,2));
    risks = BD ./ MD;
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