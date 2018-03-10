close all
origFace = 'face34.png';
styleFace = 'face40.png';
morphed = 'out405.jpg';
im1 = imread(origFace);
mesh_based_warping(styleFace, origFace,5);
im2 = imread(morphed);%uint8(mesh_based_warping(styleFace, origFace,5)*255);
energy_transfer(im1, im2, 6, 3);
