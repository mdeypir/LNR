%xT Train data
%yT Train label
%xt Test data
%yt Test label
function Res = RSS(xT,yT,xt,yt)
 CM=sum(xT(yT==0,:),1);
 N= size(xT(yT==0,:),1);
 sc = log(N./(CM+eps));
 SX = repmat(sc,size(xt,1),1); % preparing multiplication for next line
 XW = xt .* SX; % Mul each permissin of app(benign and malware) to each permission's info gain
 SXW = sum(XW,2);   % summation of risk score for app(benign and malware)
 [B,IX] = sort(SXW,'descend');  % sorting all risk score in descending order to find top score apps
 lab =yt(IX);       % finding label of sorted apps
 N = size(xt,1);    % N is the number of all apps
 j =0;
 for(i=0.01:0.01:1)
    topip =  round(N*i);   % finding the number of top 5 prescent apps
    sum(lab(1:topip));        % finding the label of top 5 prescent apps and then counting the number of malware within top 5(by summation of label 1)  
    j = j+1;
    DetMals(j) = sum(lab(1:topip)); 
    AUC(j) = sum(lab(1:topip))/ topip; % finding area under curve for topi
 end
 Res= [0,DetMals/size(xt(yt == 1,:),1)];  % size(xt(yt == 1,:),1) =808

 