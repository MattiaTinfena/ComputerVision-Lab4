%% Lab 4
%% Color-based segmentation.1

image_files = {"ur_c_s_03a_01_L_0376.png", "ur_c_s_03a_01_L_0377.png", "ur_c_s_03a_01_L_0378.png", ...
               "ur_c_s_03a_01_L_0379.png", "ur_c_s_03a_01_L_0380.png", "ur_c_s_03a_01_L_0381.png"};

images_gray = cell(1, 6); % Per immagini in scala di grigi
images_red = cell(1, 6);  % Per il canale rosso
images_green = cell(1, 6);% Per il canale verde
images_blue = cell(1, 6); % Per il canale blu
images_h = cell(1, 6);  % Per il canale h
images_s = cell(1, 6);% Per il canale s
images_v = cell(1, 6); % Per il canale v
images_seg = cell(1, 6); 
images_seg1 = cell(1, 6);

for k = 1:length(image_files)
    img_k = imread(image_files{k});  % Legge l'immagine originale
    
    % Converti in scala di grigi e salva
    images_gray{k} = rgb2gray(img_k);
    
    % Estrai e salva i singoli canali
    images_red{k} = img_k(:,:,1);   % Canale Rosso
    images_green{k} = img_k(:,:,2); % Canale Verde
    images_blue{k} = img_k(:,:,3);  % Canale Blu

    img_hsv = rgb2hsv(img_k);

    images_h{k} = img_hsv(:,:,1);   % Canale H
    images_s{k} = img_hsv(:,:,2); % Canale S
    images_v{k} = img_hsv(:,:,3);  % Canale V

end

% figure;
% imshow(images_h{1});
% title('Prima Immagine in Scala di Grigi');

%% Color-based segmentation.2

%ABBIAMO NOTATO CHE NON CI IMPORTA UN CAZZO

%% Color-based segmentation.3/4

img = images_h{1};
T=img(390:400, 575:595);
T1=img(350:430, 680:780);

m = mean2(T);
s = std2(T);

m1 = mean2(T1);
s1 = std2(T1);

[r,c] = size(img);

%figure
for k = 1:length(image_files)

    mask = (images_h{k} > (m - s)) & (images_h{k} < (m + s));  
    mask1 = (images_h{k} > (0.97)) & (images_h{k} < (1));
    images_seg{k} = bwlabel(mask);
    images_seg1{k} = bwlabel(mask1);
    % subplot(2,3,k)
    % imshow(images_seg{k});
end

%% Color-based segmentation.5
figure 
for k = 1:length(images_seg)

    prop = regionprops(images_seg{k}, 'Area','Centroid','BoundingBox');
    prop1 = regionprops(images_seg1{k}, 'Area','Centroid','BoundingBox');

    % Find the largest blob (dark car)    
    [~, largest_idx] = max([prop.Area]);
    centroid = prop(largest_idx).Centroid;    
    bounding_box = prop(largest_idx).BoundingBox;
    
    % Find the largest blob (red car)    
    [~, largest_idx1] = max([prop1.Area]);
    centroid1 = prop1(largest_idx1).Centroid;
    bounding_box1 = prop1(largest_idx1).BoundingBox;
   
    % subplot(2,3,k)
    % imshow(images_seg{k})
    % hold on
    % plot(centroid(1), centroid(2),'*r')
    % rectangle('Position',bounding_box,'EdgeColor','r')
    % hold off

    subplot(2,3,k)
    imshow(image_files{k})
    hold on
    plot(centroid1(1), centroid1(2),'*r')
    rectangle('Position',bounding_box1,'EdgeColor','r')
    hold off

end
