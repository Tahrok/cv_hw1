% Mike Schreiber, tum.mike@googlemail.com, Matrikelnummer: 3021909
% Philipp Tiefenbacher, philtief@googlemail.com, Matrikelnummer: 
% Clemens Horch, ch@tum.de, Matrikelnummer: 3013692
% Kinan Mahdi, kinan.mahdi@tum.de, Matrikelnummer: 

%F�r die letztendlich Abgabe bitte das folgende auskommentieren, und korrekte
%Parameter Ihres Harris Detektors �bergeben
Image = imread('Bilder/haus.png');
IGray = rgb_to_gray(Image);
[Fx,Fy]=sobel_xy(IGray);

% Werte initialisieren
tile_size=30;
N=5;
min_dist=5;

tic
%Merkmale = harris_detektor(IGray,7,0.04,1000,1);
%Merkmale=harris_detektor(Bild,W,k,tau,tile_size,N,min_dist,do_plot)
Merkmale = harris_detektor(IGray,7,0.04,1500,tile_size,N,min_dist,1);
t=toc;

% Rechenzeit ausgeben
fprintf('Harris Berechnungszeit: %.2fs\n', t)
