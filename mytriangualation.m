function points3d = mytriangualation(matchedPoints1,matchedPoints2,cam1, cam2)
points2d(:,:,1)=matchedPoints1;
points2d(:,:,2)=matchedPoints2;
cam(:,:,1)=cam1;
cam(:,:,2)=cam2;
nPoints = size(points2d, 1);
points3d = zeros(nPoints, 3, 'like', points2d);

for i = 1:nPoints
    pairs=squeeze(points2d(i, :, :))';
    A = zeros(4, 4);
    for j = 1:2
        P = cam(:,:,j)';
        A(2*j-1,:)=pairs(j, 1)*P(3,:)-P(1,:);
        A(2*j,:)=pairs(j, 2)*P(3,:)-P(2,:);
    end
    [~,~,V] = svd(A);
    X = V(:, end);
    X = X/X(end);
    points3d(i, :) = X(1:3)';
end

