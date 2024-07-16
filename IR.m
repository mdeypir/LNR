%IRS (instance based risk computation)
function Res = IR(xT,yT,xt,yt) 
    Malwares = xT(yT == 1,:);
    Goodwares = xT(yT == 0,:);
    CB = mean(Goodwares,1);
    CM = mean(Malwares,1);
    DFB = pdist2(xt,CB);
    DFM = pdist2(xt,CM);
    SD = DFB ./ DFM; 
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
