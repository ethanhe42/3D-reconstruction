function [matchedPoints1,matchedPoints2]=matchFeaturePoints(I1,I2,thresh)
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'MinQuality', thresh);
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);
imagePoints1 = imagePoints1.Location;
initialize(tracker, imagePoints1, I1);
[imagePoints2, validIdx] = step(tracker, I2);
matchedPoints1 = imagePoints1(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);
end