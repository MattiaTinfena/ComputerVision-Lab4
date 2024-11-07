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

m = mean2(T);
s = std2(T);

[r,c] = size(img);

%figure
for k = 1:length(image_files)
    seg = zeros(r,c);
    mask = (images_h{k} > (m - s)) & (images_h{k} < (m + s));
    
    images_seg{k} = seg + mask;
  
    % subplot(2,3,k)
    % imshow(images_seg{k});
end

%% Color-based segmentation.5
figure 
for k = 1:length(images_seg)

    prop = regionprops(images_seg{k}, 'Area','Centroid','BoundingBox');
    xc = floor(prop(1).Centroid(1));
    yc = floor(prop(1).Centroid(2));
    disp(yc)
    ul_corner_width = prop(1).BoundingBox;
    
    subplot(2,3,k)
    imshow(images_seg{k})
    hold on
    plot(xc,yc,'*r')
    rectangle('Position',ul_corner_width,'EdgeColor',[1,0,0])

end
