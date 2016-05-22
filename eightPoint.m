function f = eightPoint(points1homo, points2homo)
% Normalize the points
num = size(points1homo, 2);
[points1homo, t1] = vision.internal.normalizePoints(points1homo, 2, 'double');
[points2homo, t2] = vision.internal.normalizePoints(points2homo, 2, 'double');
% unravel
m = coder.nullcopy(zeros(num, 9, 'double'));
m(:,1)=(points1homo(1,:).*points2homo(1,:))';
m(:,2)=(points1homo(2,:).*points2homo(1,:))';
m(:,3)=points2homo(1,:)';
m(:,4)=(points1homo(1,:).*points2homo(2,:))';
m(:,5)=(points1homo(2,:).*points2homo(2,:))';
m(:,6)=points2homo(2,:)';
m(:,7)=points1homo(1,:)';
m(:,8)=points1homo(2,:)';
m(:,9)=1;
% last eigen vector
[~, ~, vm] = svd(m, 0);
f = reshape(vm(:, end), 3, 3)';
[u, s, v] = svd(f);
s(end) = 0;
f = u * s * v';
% denormalize
f = t2' * f * t1;
f = f / norm(f);
if f(end) < 0
  f = -f;
end