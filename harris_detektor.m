% Mike Schreiber, tum.mike@googlemail.com, Matrikelnummer: 3021909
% Philipp Tiefenbacher, philtief@googlemail.com, Matrikelnummer:
% Clemens Horch, ch@tum.de, Matrikelnummer: 3013692
% Kinan Mahdi, kinan.mahdi@tum.de, Matrikelnummer:

%HARRIS_DETEKTOR
%function Merkmale=harris_detektor(Bild, W, k, tau, do_plot)
function Merkmale=harris_detektor(Bild, W, k, tau, tile_size, N, min_dist, do_plot)
% Check: Bild = Grauwertbild?
if size(Bild,3) == 3
    Bild = rgb_to_gray(Bild);
end

% Check: tile_size quadratisch?
if size(tile_size,2) == 2
    tile_width=tile_size(1);
    tile_height=tile_size(2);
else
    tile_width=tile_size;
    tile_height=tile_size;
end

% Sobelfilter auf Bild anwenden
[Fx,Fy]=sobel_xy(Bild);

% Speicherplatz reservieren, MEHR SPEED! Yeah!
G=zeros(2,2);
windowX=zeros(W,W);
windowY=zeros(W,W);
windowXY=zeros(W,W);
i=1;

% Kantenbilder schon vorher quadrieren und nicht innerhalb der for-Schleife, MEHR SPEED! Yeah!
Fx2=Fx.^2;
Fy2=Fy.^2;
FxFy=Fx.*Fy;

W=(W-1)/2;

for r=W+1:size(Bild,1)-W
    for c=W+1:size(Bild,2)-W
        % W*W Fenster aus quadriertem Kantenbild "ausschneiden"
        windowX=Fx2(r-W:r+W,c-W:c+W);
        windowY=Fy2(r-W:r+W,c-W:c+W);
        windowXY=FxFy(r-W:r+W,c-W:c+W);
        
        % G-Matrix berechnen
        G(1,1)=sum(windowX(:));
        G(1,2)=sum(windowXY(:));
        G(2,1)=G(1,2);
        G(2,2)=sum(windowY(:));

        % Option 1: Singulärwertbetrachtung
        d=eig(G);
        C=sqrt(min(d(:)));        
        
        % Option 2: alternative Kostenfunktion
        %C=det(G)-k*(trace(G))^2;
        
        if C > tau
            Merkmale(i,:)=[r c C];
            i=i+1;
        end
    end
end


n=floor(size(Bild,1)/tile_height); % ganzzahlige Anzahl der Fenster, die in die Bildhöhe passen
%rest_height=mod(size(Bild,1),tile_height)-1; % Bildhöhe - i*(Anzahl Fester)
m=floor(size(Bild,2)/tile_width);
%rest_width=mod(size(Bild,2),tile_width)-1; 

for r=1:tile_height:n*tile_height
    for c=1:tile_width:m*tile_width
        [v]=find((Merkmale(:,1) >= r) & (Merkmale(:,1) < r+tile_height) & (Merkmale(:,2) >= c) & (Merkmale(:,2) < c+tile_width));
        if size(v,1) == 0 % keine Merkmalspunkte innerhalb des Fensters gefunden
            fprintf('Keine Merkmalspunkte innerhalb des Fensters!\n')   
        else
            fprintf('Merkmalspunkt: %i %i in Fenster %i bis %i und %i bis %i gefunden\n', Merkmale(v(1),1), Merkmale(v(1),2), r, r+tile_height, c, c+tile_width)
        end
        
    end
end



fprintf('Anzahl gefundener Merkmale: %i\n',size(Merkmale,1))

% Bild mit gefundenen Merkmalen plotten
if do_plot==1
    %size(Merkmale)
    imshow(Bild)
    hold on

    x=Merkmale(:,2);
    y=Merkmale(:,1);
    
    plot(x,y,'bx');

    hold off

end

end