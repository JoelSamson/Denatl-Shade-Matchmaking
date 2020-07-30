function [MF,Cent,Obj,res]=FCM_EU(img,ncluster,max_iter,expo)

%Check for RGB image%
if ndims(img)>2
     img = rgb2gray(img);
end
%Intialize the m and termination value%
if nargin<4
    expo=2;
    if nargin<3
        max_iter=100;
    end
end

[rn,cn]=size(img);
imgsiz=rn*cn;
%imgv=reshape(img,imgsiz,1);
%imgv=double(imgv);
imgv=img;
%Initialize the membership value%
MF=initfcm(ncluster,rn);

% Main loop
for i = 1:max_iter,
    [MF, Cent, Obj(i),dist] = stepfcm2dmf(imgv,MF,ncluster,expo);
    
	% check termination condition
	if i > 1,
		if abs(Obj(i) - Obj(i-1)) < 1e-2, break; end,
	end
end
%Calculate Cluster validity Index values%
V_new = sum(Cent)/ncluster;

dist_New = distfcm(Cent, V_new);
dist_n = distfcm(Cent, imgv); 
Vfs = sum(sum((dist_New'.^2)*(MF.^2)));
vxb = sum(sum((dist_n.^2).*(MF.^2))); 

Vfs = vxb-Vfs;
res.Vfs = Vfs;
incr =1;
for index1=1:ncluster
    for index2=1:ncluster
            if index2>index1
                diff_n = ((Cent(index1) - Cent(index2)));               
                center_diff(incr) = diff_n^2;
                incr=incr+1;
            end
    end
end
center_diff = min(center_diff');

vxb = (vxb)/(imgsiz*(center_diff));
res.vxb = vxb;

function [U_new, center, obj_fcn,dist] = stepfcm2dmf(data, U, cluster_n,expo)
%STEPFCM One step in fuzzy c-mean 

mf = U.^expo;   

center = mf*data./((ones(size(data, 2),1)*sum(mf'))'); % new center

dist= distfcm(center,data);

obj_fcn = sum(sum((dist.^2).*mf));  % objective function

tmp = dist.^(-2/(expo-1));      % calculate new U

U_new = tmp./(ones(cluster_n, 1)*sum(tmp));