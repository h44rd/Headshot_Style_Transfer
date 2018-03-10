function out = energy_transfer(img1, img2, nlvls, x)
% Gives the output after energy transfer
    img1 = imresize(img1,[300,230]);
    img2 = imresize(img2,[300,230]);
    img1b = img1;
    img2b = img2;
    figure, imshow(img1);
    figure, imshow(img2);
    img1 = RGB2Lab(img1);
    img2 = RGB2Lab(img2);
    lap1 = zeros(size(img1, 1), size(img1, 2), size(img1, 3), nlvls);
    lap2 = zeros(size(img2, 1), size(img2, 2), size(img2, 3), nlvls);

    lap1(:,:,:,1) = img1 - imgaussfilt(img1, x);   
    lap2(:,:,:,1) = img2 - imgaussfilt(img2, x);
    lap1(:,:,:,nlvls) = imfilter(img1, fspecial('gaussian', round(x^(nlvls-1)+1), x^(nlvls-1)));%imgaussfilt(img1, x^(nlvls-1));
    lap2(:,:,:,nlvls) = imfilter(img2, fspecial('gaussian', round(x^(nlvls-1)+1), x^(nlvls-1)));%imgaussfilt(img2, x^(nlvls-1));    
    for i = 2:nlvls-1
        lap1(:,:,:,i) = imfilter(img1, fspecial('gaussian', round(x^(i-1)+1), x^(i-1))) - imfilter(img1, fspecial('gaussian', round(x^(i)+1), x^(i)));%imgaussfilt(img1, x^(i-1)) - imgaussfilt(img1, x^i);
        lap2(:,:,:,i) = imfilter(img2, fspecial('gaussian', round(x^(i-1)+1), x^(i-1))) - imfilter(img2, fspecial('gaussian', round(x^(i)+1), x^(i)));%imgaussfilt(img2, x^(i-1)) - imgaussfilt(img2, x^i);        
    end
    
    lap12 = lap1.*lap1;
    lap22 = lap2.*lap2;
    s1 = lap12;
    s2 = lap22;
    gain = lap22;
    lapout = lap22;
    out = zeros(size(img1, 1), size(img1, 2), size(img1,3));
    for i = 1:nlvls
        s1(:,:,:,i) = imfilter(lap12(:,:,:,i), fspecial('gaussian', round(x^(nlvls)+1), x^(nlvls)));%imgaussfilt(lap12(:,:,:,i), x^(nlvls+1));
        s2(:,:,:,i) = imfilter(lap22(:,:,:,i), fspecial('gaussian', round(x^(nlvls)+1), x^(nlvls)));%imgaussfilt(lap22(:,:,:,i), x^(nlvls+1));
        gain(:,:,:,i) = sqrt(s2(:,:,:,i)./(s1(:,:,:,i) + 0.0001));
        gain(gain>2.8)=2.8;
        gain(gain<0.9)=0.9;
        lapout(:,:,:,i) = lap1(:,:,:,i).*gain(:,:,:,i);
        out = out + lapout(:,:,:,i);
%         figure,imshow(uint8(255*lapout(:,:,:,i)));
    end    
    out = Lab2RGB(out);
%     size(out)
%     figure, imshow(uint8(out*255));
    montage([img1b, img2b, uint8(out*255)]);
end

