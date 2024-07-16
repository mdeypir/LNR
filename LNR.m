%LDA and NN Based Risk computation
function Res = LNR(xT,yT,xt,yt)
    dd=35;
    [V,D] = eig(cov(xT));
    [d,ix] = sort(diag(D),'descend');
    X1_x =  xT(yT==0,ix(1:dd));
    X2_x = xT(yT==1,ix(1:dd));

    %Calculate the mean value of X1,X2
    meanX1 = mean(X1_x,1);
    meanX2 = mean(X2_x,1);

    %Calculate scatter matrices Si
    SX1 = (X1_x - meanX1)' * (X1_x - meanX1);
    SX2 = (X2_x - meanX2)' * (X2_x - meanX2);

    %Calculate the within-class scattering matrix Sw
    Sw = SX1 + SX2;

    %Calculate the Matrix inverse of Sw
    %SwP = pinv(Sw);
    %Calculate the projection vector for LDA
   % w = SwP * (meanX1 - meanX2)';
    w = Sw \ (meanX1 - meanX2)';
    %Calculate the projection value
    Y1 = X1_x * w;
    Y2 = X2_x * w;
    Y = xt(:,ix(1:dd)) * w;
    %Calculate the mean of the projected samples of each class
    meanY1 = mean(Y1,1);
    meanY2 = mean(Y2,1);
    XD1 = abs(Y-meanY1);
    XD2 = abs(Y-meanY2);
    
    BxT = xT(yT==0,ix(dd+1:end));
    MxT = xT(yT==1,ix(dd+1:end));
    [IdMxT,MD] = knnsearch(MxT,xt(:,ix(dd+1:end)),'K',10);% default k =1 
    [IdBxT,BD] = knnsearch(BxT,xt(:,ix(dd+1:end)),'K',10);
    MD = mean(MD,2);
    BD = mean(BD,2);

    MxTF = xT(yT==1,:);
    BxTF = xT(yT==0,:);
    [IdMxT,MD] = knnsearch(MxTF,xt,'K',10);% default k =1 
    [IdBxT,BD] = knnsearch(BxTF,xt,'K',10);
    MDF = mean(MD,2);
    BDF = mean(BD,2);

    risks = (BD+XD1+BDF) ./ (MD+XD2+MDF); 
    [B,IX] = sort(risks,'descend'); % sorting all risk score in descending order to find top score apps
    lab =yt(IX);       % finding label of sorted apps
    N = size(xt,1);    % N is the number of all apps
    j =0;
    for i=0.01:0.01:1
        topip =  round(N*i);   % finding the number of top i prescent apps
        j = j+1;
        DetMals(j) = sum(lab(1:topip)); 
    end
    Res = [0,DetMals/size(xt(yt == 1,:),1)];
    




