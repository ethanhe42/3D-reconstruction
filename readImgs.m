function frames=readImgs(path)
s=imageSet(path);
frames.length=s.Count;%3;%
maxSize = 1000;


f=fopen(fullfile(path,'intrinsic.new'));
data=textscan(f,'%f %f %f');
for i=1:3
    col(:,i)=data{i};
end
frames.focal_length=col(1,1);
frames.K=col(1:3,:);
disp(frames.K)
img=read(s,1);
frames.imsize = size(img);
if max(frames.imsize)>maxSize
    scale = maxSize/max(frames.imsize);
    frames.focal_length = frames.focal_length * scale;
    frames.imsize = size(imresize(img,scale));
    frames.K=frames.K.*scale;
    frames.K(3,3)=1;
else
    scale=1;
end

for i=1:2   
    frames.K(i,3)=frames.K(i,3)-frames.imsize(3-i)/2;
    
end

for i=1:frames.length
    img=read(s,i);
    if scale==1
        frames.images{i}=img;
    else
        frames.images{i}=imresize(img,scale);
    end
    
end

end