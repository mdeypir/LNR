%LDA Based Risk computation
function Res = LDR(xT,yT,xt,yt)
    X1_x =  xT(yT==0,:);
    X2_x = xT(yT==1,:);

    %Calculate the mean value of X1,X2
    meanX1 = mean(X1_x,1);
    meanX2 = mean(X2_x,1);

    %Calculate scatter matrices Si
    SX1 = (X1_x - meanX1)' * (X1_x - meanX1);
    SX2 = (X2_x - meanX2)' * (X2_x - meanX2);

    %Calculate the within-class scattering matrix Sw
    Sw = SX1 + SX2;

    %Calculate the Matrix inverse of Sw
    SwP = pinv(Sw);
    %Calculate the projection vector for LDA
    w = SwP * (meanX1 - meanX2)';
    %w = Sw \ (meanX1 - meanX2)';
    %Calculate the projection value
    Y1 = X1_x * w;
    Y2 = X2_x * w;
    Y = xt * w;
    %Calculate the mean of the projected samples of each class
    meanY1 = mean(Y1,1);
    meanY2 = mean(Y2,1);
    XD1 = abs(Y-meanY1);
    XD2 = abs(Y-meanY2);
    SD = XD1 ./ XD2;
    [B,IX] = sort(SD,'descend'); % sorting all risk score in descending order to find top score apps
    lab =yt(IX);       % finding label of sorted apps
    N = size(xt,1);    % N is the number of all apps
    j =0;
    for i=0.01:0.01:1
        topip =  round(N*i);   % finding the number of top i prescent apps
        sum(lab(1:topip));        % finding the label of top i prescent apps and then counting the number of malware within top 5(by summation of label 1)  
        j = j+1;
        DetMals(j) = sum(lab(1:topip)); 
        AUC(j) = sum(lab(1:topip))/ topip; % finding area under curve for topi
    end
    Res= [0,DetMals/size(xt(yt == 1,:),1)];




