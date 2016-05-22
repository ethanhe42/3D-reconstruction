function [R, location] = motionFromF(F, intrinsic,inliers1, inliers2)
E = intrinsic * F * intrinsic';
%% decompose E
[U, D, V] = svd(E);
e = (D(1,1) + D(2,2)) / 2;
D(1,1) = e;
D(2,2) = e;
D(3,3) = 0;
E = U * D * V';
[U, ~, V] = svd(E);
W=[0 -1 0;
    1 0 0;
    0 0 1];
Z = [0 1 0;
    -1 0 0;
     0 0 0];
R1 = U * W * V';
R2 = U * W' * V';
if det(R1) < 0
    R1 = -R1;
end
if det(R2) < 0
    R2 = -R2;
end
Tx = U * Z * U';
t = -[Tx(3, 2), Tx(1, 3), Tx(2, 1)];
R=R1';
%% choose solution
negs = zeros(1, 4);
nInliers=size(inliers1, 1);
camMat0 = ([eye(3);[0 0 0]]*intrinsic)';
M1 = camMat0(1:3, 1:3);
c1 = -M1 \ camMat0(:,4);
for i = 1:4
    if i>2
        R=R2';
    end
    t=-t;
    camMat1 = ([R; t]*intrinsic)';
    M2 = camMat1(1:3, 1:3);
    c2 = -M2 \ camMat1(:,4);
    for j = 1:nInliers
        a1 = M1 \ [inliers1(j, :), 1]';
        a2 = M2 \ [inliers2(j, :), 1]';
        A = [a1, -a2];
        alpha = (A' * A) \ A' * (c2 - c1);
        p = (c1 + alpha(1) * a1 + c2 + alpha(2) * a2) / 2;
        m1(j, :) = p';
    end
    m2 = bsxfun(@plus, m1 * R, t);
    negs(i) = sum((m1(:,3) < 0) | (m2(:,3) < 0));
end
[~, idx] = min(negs);
if idx<3
    R=R1';
end
if idx==1 || idx ==3
    t=-t;
end
t = t ./ norm(t);

location = -t * R';
end