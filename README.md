# Structrue From Motion
This code demonstrates how a traditional structure from motion pipeline is done and how to compute a dense point cloud by matching propagation in a simplest way. It is just probably quite slow compared to more optimized system, such as Bundler from Noah Snavely.

### Usage
run SFMedu2.m in Matlab.

### SFM steps  
1. get camera intrinsic matrix.  
2. SIFT descriptor and points matching.  
3. estimate fundamental matrix using feature pairs in two images. Then compute essential matrix using K and F. Decompose E to R and t. Get P using E.  
4. dense SIFT descriptor.  
5. put pairs of points onto 3D.  
6. bundle adjustment.  
 
