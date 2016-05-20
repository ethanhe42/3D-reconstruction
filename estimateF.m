function pair = estimateF(pair)

t = .002;  % Distance threshold
[F, inliers] = ransacfitfundmatrix(pair.matches(1:2,:), pair.matches(3:4,:), t, 0);
fprintf('%d inliers / %d SIFT matches = %.2f%%\n', length(inliers), size(pair.matches,2), 100*length(inliers)/size(pair.matches,2));
pair.matches = pair.matches(:,inliers);
pair.F = F;