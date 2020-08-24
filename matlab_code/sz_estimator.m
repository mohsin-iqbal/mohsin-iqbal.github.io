function sz_estimator

% %%%%%%%%%%%%%%%%%%%%%%%%%%
% l = input('What is the length in inches? ');
% w = input('What is the width in inches? ');
% qty = input('desired quantity: ');
% 
% boxes_per_lw = input('number of pieces on the the plate (1 up, 2 up etc.): ');
% gsm = input('grams per square meter (gsm): ');
% pkr_per_kg = input('rate per kg: ');       


l=8.3;          % length
w=4.5;          % width
qty = 1000;     % quantity

boxes_per_lw = 1;           % 1 up or 2 up
pkr_per_kg = 210;           % rate
gsm = 300;                  % grams per square meter

sheets_per_packet = 100;        

%%%%%%%%%%%%%%%%%%%%%%%%%%
szs=[
20 30
22 28
23 36
25 30
25 36
31 43
30 50
];
%%%%%%%%%%%%%%%%%%%%%%%%%%

if max(l,w)>max(szs(:))
    fprintf('Input size is too big.\n');
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n**********\n');
fprintf('size\t = %.2f" x %.2f", \n', l, w);
fprintf('gsm\t = %d gm, \n', gsm);
fprintf('rate\t = %d  PKR per Kg \n\n', pkr_per_kg);

szs = [szs; szs(:,2) szs(:,1)];

[ind,ns,sz, minima, req_pckt_num, output_qty, output_qty_per_pckt, cost_per_pckt, total_cost, cost_per_piece] = cost_eval(szs, l,w,boxes_per_lw, sheets_per_packet, gsm, pkr_per_kg, qty);   %#ok
%%%%
if round(minima)<=250
    fprintf('Wastage cost for [%.2f" x %.2f"]\nis %.2f PKR :)\n\n\n',l, w, round(minima*output_qty,2));
elseif round(minima)>3000
    fprintf('Wastage cost for [%.2f" x %.2f"]\nis %.2f PKR.\n',l, w, round(minima*output_qty,2));
    fprintf('Caution: wastage cost is high :(\n\n\n');
else
    fprintf('Wastage cost for [%.2f" x %.2f"]\nis %.2f PKR\n\n\n',l, w, round(minima*output_qty,2));

end

fprintf('packet size \t\t= [%.2f" x %.2f"],\n', sz(1), sz(2) );

%%% 
fprintf('number of packets \t= %d,\noutput quantity \t= %d,\noutput qty. per packet \t= %d,\ncost per packet \t= %d PKR, \ntotal est. cost \t= %d PKR,\ncost per piece \t\t= %.4f PKR \n', req_pckt_num, output_qty, output_qty_per_pckt,round(cost_per_pckt), round(total_cost), cost_per_piece);
fprintf('**********\n');

close all;
hold on;

plot([0 sz(1)],[0 sz(2)],'.'); box on;%grid on;
xlim([0 sz(1)]);
ylim([0 sz(2)]);

for it=1:(ns(1))
    plot(it*[l l],ylim,'color',[1 1 1]*0.5);
end
h=fill([it*l,sz(1),sz(1),it*l],[0,0,sz(2),sz(2)],'red');
h.FaceAlpha=0.3;
xEnd = it*l;


for it=1:(ns(2))
    plot(xlim,it*[w w],'color',[1 1 1]*0.5);
end
h=fill([0 0 sz(1) sz(1)],[it*w,sz(2),sz(2) it*w],'green');
h.FaceAlpha=0.3;
yEnd = it*w;


xlabel('L');
ylabel('W');
set(gca,'XMinorTick','on','YMinorTick','on', 'ticklength',[0.01 0.001]*2)

text(1,4,sprintf('sheet size: %.2f" x %.2f" ', sz(1),sz(2))); %, 'interprw   eter', 'latex');
text(1,2,sprintf('piece size: %.2f" x %.2f" ', l,w)); %, 'interpreter', 'latex' );

if abs(sz(2)-yEnd)>1e-08;
    text(1,yEnd-1,sprintf('L wstg.: %.2f" x %.2f" '  , sz(1),sz(2)-yEnd)); %, 'interpreter', 'latex' );
end
if abs(sz(1)-xEnd)>1e-08;
    h=text(xEnd-1,1,sprintf('W wstg.: %.2f" x %.2f" ', sz(1)-xEnd, sz(2) )); %, 'interpreter', 'latex' );
    set(h,'Rotation',90);
end
grd_sz = 41;
ls = (l-1.0):0.04:(l+0.5);%linspace(l-1.0,l+1.0,grd_sz);
ws = (w-1.0):0.04:(w+0.5);%linspace(w-1.0,w+1.0,grd_sz);

grd_sz = length(ls);


% ls = linspace(1,20,grd_sz);
% ws = linspace(1,20,grd_sz);

cs    = nan*(zeros(grd_sz));
wstgs = nan*(zeros(grd_sz));

for l_it = 1:grd_sz
    for w_it = 1:grd_sz
        l_temp=ls(l_it); w_temp=ws(w_it);
        [ind, ns,sz, minima, req_pckt_num, output_qty, output_qty_per_pckt, cost_per_pckt, total_cost, card_p] = cost_eval(szs, l_temp,w_temp, boxes_per_lw, sheets_per_packet, gsm, pkr_per_kg, qty);   %#ok
        cs(w_it,l_it) = card_p;
        wstgs(l_it,w_it) = minima/output_qty;

    end
end

[X,Y] = meshgrid(ls,ws);
figure;surf(X,Y,cs);
hold on;plot3(l,w,max(cs)+2,'kd','Markerfacecolor','k','Markersize',8);
view([0 90]);        

% [X,Y] = meshgrid(ls,ws);
% figure;surf(X,Y,wstgs);
% hold on;plot3(l,w,max(wstgs)+2,'kd','Markerfacecolor','k','Markersize',8);
% view([0 90]);

% hold on;
% plot([1 20],[1 20],'.');
% for it=1:length(X(:))
%     x=X(it);
%     y=Y(it);
%     c=cs(it);
%     dx=0;dy=0;
%     plot(x,y,'.');
%     text(x+dx, y+dy, sprintf('(%d,%d)',szs(c,1),szs(c,2)) );
% end
% set(gca,'XMinorTick','on','YMinorTick','on', 'ticklength',[0.01 0.001]*2);
% 


end

function [ind, ns,sz, minima, req_pckt_num, output_qty, output_qty_per_pckt, cost_per_pckt, total_cost, cost_per_piece] = cost_eval(szs, l,w,boxes_per_lw, sheets_per_packet,gsm, pkr_per_kg, qty)

    ns = nan*zeros(length(szs),2);
    wastage = nan*zeros(length(szs),3);
    pck_cnt = nan*zeros(length(szs),1);
    for it=1:length(szs)
        ns(it,:) = szs(it,:)./[l w];

        %%% wastage per sheet
        l_wastage = szs(it,1)-floor(ns(it,1)).*l;
        w_wastage = szs(it,2)-floor(ns(it,2)).*w;

        e_L = l_wastage*szs(it,2);
        e_R = w_wastage*szs(it,1);

        wastage(it,:)=[e_L e_R -0*l_wastage*w_wastage];

        pck_cnt(it) = qty/(prod(floor(ns(it,:)))*boxes_per_lw*sheets_per_packet);  
        
        req_pckt_num = ceil(pck_cnt(it));
        output_qty = req_pckt_num*sheets_per_packet*prod(floor(ns(it,:)))*boxes_per_lw;

        wastage(it,:) = wastage(it,:)/output_qty;

    end
    [minima,ind] = min((sum(wastage,2).*pck_cnt)*sheets_per_packet*(1/1550.00310)*(gsm/1000)*pkr_per_kg);

    %%% 
    sz=szs(ind,:);
    ns = ns(ind,:);    


    req_pckt_num = ceil(pck_cnt(ind));
    output_qty = req_pckt_num*sheets_per_packet*prod(floor(ns(:)))*boxes_per_lw;
    output_qty_per_pckt = output_qty/req_pckt_num;

    cost_per_pckt = pkr_per_kg*sheets_per_packet*(gsm/1000)*prod(sz(:))*(1/1550.00310);
    total_cost = req_pckt_num*cost_per_pckt;
    cost_per_piece = round(total_cost/output_qty,8);
end