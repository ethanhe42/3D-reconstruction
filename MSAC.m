function [f,bestInliers] = MSAC(points1, points2)
%% homography
nPoints = size(points1, 1);
points1homo=points1';
points1homo(3,:)=1.0;
points2homo=points2';
points2homo(3,:)=1.0;
%% 
threshold=0.01;
maxtrails = 20000;
bestDist = realmax('double');

for trails=1:maxtrails
    % estimate f using random 8 points
    sampleIndicies = randperm(nPoints, 8);
    f = eightPoint(points1homo(:, sampleIndicies), points2homo(:, sampleIndicies));
    % reprojection error
    pfp = (points2homo' * f)';
    pfp = pfp .* points1homo;
    d = sum(pfp, 1) .^ 2;

    % find inliers
    inliers = coder.nullcopy(false(1, nPoints));
    inliers(d<=threshold)=true;
    nInliers=sum(inliers);
    
    % MSAC metric
    Dist = cast(sum(d(inliers)),'double') + threshold*(nPoints - nInliers);
    if bestDist > Dist
      bestDist = Dist;
      bestInliers = inliers;
    end
end
f = eightPoint(points1homo(:, bestInliers), points2homo(:, bestInliers));
end