function cl_costing

% initial costs
% computer design costs
% films + plates
% blocks (foil stamping + emboss)
% cutting dies

% 
qty = 30000;
act_qty = max([round(qty/1000),1, qty/1000])*1000;

% color configs
color_rate	  = 310;    % Rs per color per thousand
num_of_colors = 3;

% foil configs
foil_rate = 3;   % paisas per square inch

foil_l=3;
foil_w=5;
foil_area = foil_l*foil_w;

% emboss
emboss_rate = 400; % PKR per thousand
emboss = 1;

% lamination
lamination_rate = 1; % PKR  per square foot

lamination_l = 12;   % Inches
lamination_w = 9;    % Inches
lamination_area = lamination_l*lamination_w;

% cutting
cutting = 1;
cutting_rate = 400; % PKR per thousand

% pasting cost
pasting = 1;
pasting_rate = 300; % PKR per thousand

% product vector
prod_vec = [num_of_colors, foil_area, lamination_area, emboss, cutting, pasting];

% price vector
price_vec = [(color_rate/1000)  (foil_rate/100)  (lamination_rate/144) (emboss_rate/1000) (cutting_rate/1000) (pasting_rate/1000)];




end