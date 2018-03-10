function [chk, wa, wb, wc] = get_weights(x, y, x1, y1, x2, y2, x3, y3)
% Checks whether (x, y) are in the triangle based on the 3 vertices 1,
% 2, and 3, and returns the linear combination weight as wa, wb, and wc.
    x1 = repmat(x1, size(x,1), size(x,2));
    y1 = repmat(y1, size(x,1), size(x,2));
    x2 = repmat(x2, size(x,1), size(x,2));
    y2 = repmat(y2, size(x,1), size(x,2));
    x3 = repmat(x3, size(x,1), size(x,2));
    y3 = repmat(y3, size(x,1), size(x,2));
    wa = ((x-x3).*(y2-y3)-(y-y3).*(x2-x3))./((x1-x3).*(y2-y3)-(y1-y3).*(x2-x3)+eps);    
    wb = ((x-x3).*(y1-y3)-(y-y3).*(x1-x3))./((x2-x3).*(y1-y3)-(y2-y3).*(x1-x3)+eps);    
    wc = 1 - wa - wb;
    chk = (wa>=0) & (wa<=1) & (wb<=1) & (wb>=0) & (wc>=0) &  (wc<=1);
end