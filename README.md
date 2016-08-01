# 2 view structure from motion (From scratch)
![h](result/Screenshot%20from%202016-05-20%2022-02-50.png)
![h](result/selfff.png)
### How to run  
1. You can directly go to result folder to see all results  
2. To make it easier to view all results , I selected two images for each imageset. You can reproduce all 3D models using main.m. All 8 pclouds will show up together after program finished. `.ply` files will be saved to result folder, which you can be opened with meshlab.  
`main;`    
3. You can specify two images(**intrinsic.new must be in the same folder**):  
` SfM2('imgFolder/img1.JPG','imgFolder/img2.JPG');`  
will not show model after finished, only save .ply to result.  
` SfM2('imgFolder/img1.JPG','imgFolder/img2.JPG',true);`  
will show model after finished, and save .ply to result.  

###### This system has been tested under Matlab 2016a and Ubuntu 16.04. please make sure your matlab have vision toolkit  

### Features  
- dense matching.  
- MSAC instead of RANSAC.  

### main steps of my code
1. get camera intrinsic matrix.  
2. features detection and points matching.  
3. estimate fundamental matrix using feature pairs in two images. Then compute essential matrix using K and F. Decompose E to R and t. Get P using E.  
4. dense matching.  
5. put pairs of points onto 3D(triangulate).  

### How to use your own images
- prepare 2 images taken from two different views  
- get the [intrinsic matrix](https://en.wikipedia.org/wiki/Camera_resectioning) and write it to `intrinsic.new`  

![a](https://wikimedia.org/api/rest_v1/media/math/render/svg/a73c022621ea3e7546d2a95c22a74fb22a3b3b7c)  
You can set parameters except \alpha_x and \alpha_y can be default value: zero,  
![b](https://wikimedia.org/api/rest_v1/media/math/render/svg/3f0b99ce362b84c94a603bca45c11454cb95f6f1), ![c](https://wikimedia.org/api/rest_v1/media/math/render/svg/eb5fb4f7aef1abe7c21500f0486677fec1e2ceca), represent focal length in terms of pixels, where m_x, m_y are the scale factors relating pixels to distance and f is the focal length in terms of distance. They can be obtained by looking into your camera info or the jpeg meta info. You can google the way to get them.

- Put them into the same folder, then modify `main.m` to point to the images  
