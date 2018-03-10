% Initiating the values. This file is not necessary if you already know how
% to run the program using the mesh_based_warping function.
close all    
sauce = input('Enter path to source image: ','s');
target = input('Enter path to target image: ', 's');
num_points = input('Enter the number of points you want to match: ');
trans = input('Enter the number of intermediate points: ');
mesh_based_warping(sauce, target, num_points, trans);