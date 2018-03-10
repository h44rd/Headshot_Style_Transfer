function [output] = mesh_based_warping(srcpath, targetpath, transitions)
    sourceImage = imread(srcpath);
    targetImage = imread(targetpath);
    sourceImage = imresize(sourceImage, [300, 230]);
    [height,width,~]=size(sourceImage);
    targetImage = imresize(targetImage, [300, 230]);
    output = zeros(height,width,3);
    
    d1 = detect(srcpath, 0);
    d2 = detect(targetpath, 0);
    p1 = d1.points;
    p2 = d2.points;
    input_x1 = p1(:,1);
    input_y1 = p1(:,2);
    input_x2 = p2(:,1);
    inputy2 = p2(:,2);
    
%     input_x1 = [input_x1;1;width;width;1];
%     intput_y1 = [input_y1;1;1;height;height];
%     input_x2 = [input_x2;1;width;width;1];
%     inputy2 = [inputy2;1;1;height;height];    
    

    
    
    
    
    border_points = 3;
    new_points1 = zeros((border_points+1)*4, 2);
    new_points2 = zeros((border_points+1)*4, 2);
    
    for i=1:border_points+1
        new_points1(i,1) = 0; new_points1(66+13+i,2) = (i-1)*0/border_points + (border_points-i+1)*300/border_points;
        new_points2(i,1) = 0; new_points2(66+13+i,2) = (i-1)*0/border_points + (border_points-i+1)*300/border_points;
        new_points1((border_points+1)+i,1) = 230; new_points1(66+13+(border_points+1)*1+i,2) = (i-1)*0/border_points + (border_points-i+1)*300/border_points;
        new_points2((border_points+1)+i,1) = 230; new_points2(66+13+(border_points+1)*1+i,2) = (i-1)*0/border_points + (border_points-i+1)*300/border_points;
        new_points1((border_points+1)*2+i,1) = (i-1)*0/border_points + (border_points-i+1)*230/border_points; new_points1((border_points+1)*2+i,2) = 0;
        new_points2((border_points+1)*2+i,1) = (i-1)*0/border_points + (border_points-i+1)*230/border_points; new_points2((border_points+1)*2+i,2) = 0;
        new_points1((border_points+1)*3+i,1) = (i-1)*0/border_points + (border_points-i+1)*230/border_points; new_points1((border_points+1)*3+i,2) = 300;
        new_points2((border_points+1)*3+i,1) = (i-1)*0/border_points + (border_points-i+1)*230/border_points; new_points2((border_points+1)*3+i,2) = 300;
    end
    
    input_x1 = [input_x1;new_points1(:,1)];
    intput_y1 = [input_y1;new_points1(:,2)];
    input_x2 = [input_x2;new_points2(:,1)];
    inputy2 = [inputy2;new_points2(:,2)];
    
%     imshow(targetImage);
%     axis image;
%     hold on;
%     plot(input_x2, inputy2,'b.');

    
    name = 0;    
    for t = 1:-(1/transitions):0
        x_interp = t*input_x1 + (1-t)*input_x2;
        y_interp = t*intput_y1 + (1-t)*inputy2;
        trian = delaunay(x_interp,y_interp);
%         triplot(triC, xC, yC);
        mA = zeros(height,width);
        nA = zeros(height,width);
        mB = zeros(height,width);
        nB = zeros(height,width);
        [X_pts,Y_pts] = meshgrid(1:width,1:height);
        % warp
        for k = 1:size(trian,1)
            [chk, wa, wb, wc] = get_weights(X_pts, Y_pts, x_interp(trian(k,1)), y_interp(trian(k,1)), x_interp(trian(k,2)), y_interp(trian(k,2)), x_interp(trian(k,3)), y_interp(trian(k,3)));
            wa(chk == 0) = 0; 
            wb(chk == 0) = 0; 
            wc(chk == 0) = 0;
            mA = mA + wa.*input_x1(trian(k,1)) + wb.*input_x1(trian(k,2)) + wc.*input_x1(trian(k,3));
            nA = nA + wa.*intput_y1(trian(k,1)) + wb.*intput_y1(trian(k,2)) + wc.*intput_y1(trian(k,3));
            mB = mB + wa.*input_x2(trian(k,1)) + wb.*input_x2(trian(k,2)) + wc.*input_x2(trian(k,3));
            nB = nB + wa.*inputy2(trian(k,1)) + wb.*inputy2(trian(k,2)) + wc.*inputy2(trian(k,3));
        end
        % interpolate and cross-dissolve
        for i = 1:3
            output(:,:,i) = interp2(X_pts,Y_pts,double(sourceImage(:,:,i)),mA,nA);% + (1-t)*interp2(X_pts,Y_pts,double(targetImage(:,:,i)),mB,nB);;
        end                
%         figure, imshow(uint8(output));
        if(name < 10)
            filename = strcat('out40', num2str(name), '.jpg');
        else
            filename = strcat('out4', num2str(name), '.jpg');
        end
        imwrite(uint8(output), filename);
        name = name + 1;
    end
    figure
    subplot(1,3,1)
    imshow(sourceImage);
    subplot(1,3,2);
    imshow(targetImage);
    axis image;
    hold on;
    plot(input_x2, inputy2,'b.');
    subplot(1,3,3)
    imshow(uint8(output))
    output = im2double(output)/255;
end
