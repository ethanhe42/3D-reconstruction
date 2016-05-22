function SfM2(one,two,visualize)
if nargin==3
    visualize=true;
else
    visualize=false;
end
[path,~,~]=fileparts(one);
[~,filename,~]=fileparts(path);
res_dir='result/';
untitle=0;
if strcmp(filename,'')
    while true
        filename=[res_dir,'untitled',untitle];
        if exist(filename,'file')
            untitle=untitle+1;
        else
            break;
        end
    end
end
f=fopen(fullfile(path,'intrinsic.new'));
data=textscan(f,'%f %f %f');
for i=1:3
    col(:,i)=data{i};
end
img0 = imread(one);
img1 = imread(two);
ms=size(img0,2);
ds=1200;
if ms>ds
    img0=imresize(img0,ds/ms);
    img1=imresize(img1,ds/ms);
    col=col*ds/ms;
end
intrinsic=col(1:3,:)';

%% match features
[mp1, mp2]=matchFeaturePoints(img0,img1,0.01);
% figure
% showMatchedFeatures(img0, img1, mp1, mp2);

%% Estimate F R t
[F, inliersIdx] = MSAC(mp1, mp2);
% Find epipolar inliers
inlierPoints1 = mp1(inliersIdx, :);
inlierPoints2 = mp2(inliersIdx, :);
% figure
% showMatchedFeatures(img0, img1, inlierPoints1, inlierPoints2);
[R, t] = motionFromF(F, intrinsic, inlierPoints1, inlierPoints2);
camMat0 = [eye(3); [0 0 0]]*intrinsic;
camMat1 = [R; -t*R]*intrinsic;

%% dense match
[mp1, mp2]=matchFeaturePoints(img0,img1,0.0001);
points3D = mytriangualation(mp1, mp2, camMat0, camMat1);

%% plot
cls = reshape(img0, [size(img0, 1) * size(img0, 2), 3]);
colorIdx = sub2ind([size(img0, 1), size(img0, 2)], round(mp1(:,2)),round(mp1(:, 1)));
ptCloud = pointCloud(points3D, 'Color', cls(colorIdx, :));
pcwrite(ptCloud,[res_dir,filename],'PLYFormat','ascii');
disp(['ply saved to ',res_dir,filename,'.ply']);
if visualize
    figure
    pcshow(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', 'MarkerSize', 45);
end
