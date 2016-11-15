% Petr Dvoracek, projekt do iss.
% Zmenit cestu pokud bude potreba..
I = imread('c:\Documents and Settings\root\Plocha\iss\src\xdvora0n.bmp');







% Referencni
%I = imread('c:\Documents and Settings\root\Plocha\iss\src\xlogin00.bmp');

% Zaostreni obrazu
h1 = [-0.5 -0.5 -0.5; -0.5 5.0 -0.5; -0.5 -0.5 -0.5];
I2 = imfilter(I, h1);      % !!!
imwrite(I2, 'step1.bmp'); 

% Otoceni obrazu
I3 = I2;
Iotoc = I;
for (x = 1:512)
  y_def = 512;
  for (y = 1:512)
    I3(x,y)   = I2(x, y_def); 
    Iotoc(x,y)= I(x, y_def);
    y_def = y_def - 1;
  end;
end;
imwrite(I3, 'step2.bmp'); 


% Medianovy filtr 5x5
I4 = medfilt2(I3, [5; 5]);
imwrite(I4, 'step3.bmp'); 

% Rozmazani obrazu
h2 = [1 1 1 1 1; 1 3 3 3 1; 1 3 9 3 1; 1 3 3 3 1; 1 1 1 1 1]/49;
I5 = imfilter(I4, h2);
imwrite(I5, 'step4.bmp');

% Chyba v obraze
chyba=0;
I_v_double=im2uint8(Iotoc);
I5_v_double=im2uint8(I5);
for (x=1:512)
  for (y=1:512)
    chyba=chyba+double(abs(I_v_double(x,y) - I5_v_double(x,y)));
  end;
end;
fprintf('chyba=');
chyba=chyba/512/512


% Roztazeni histogramu
I6 = I5;
I5max = max(max(I5));
I5min = min(min(I5));
I5interval = I5max - I5min;
podil = 255/double(I5interval);
for (x = 1:512)
  for (y = 1:512)
    I6(x,y) = (I5(x,y) - I5min)*podil;
  end;
end;
imwrite(I6, 'step5.bmp');

% Stredni hodnota a smerodatna odchylka
fprintf('mean_no_hist=');
mean2(I5)
fprintf('std_no_hist=');
std2(I5)
fprintf('mean_hist=');
mean2(I6)
fprintf('std_hist=');
std2(I6)

% Kvantizace
I7 = I6;
for (x = 1:512)
  for (y = 1:512)
    %I7(x,y) = my_quantization(double(I6(x,y)), 0, 255, 2);
    %I7(x,y) = my_quantization(double(I6(x,y)), 0, 255, 2);
    a = 0;
    b = 255;
    N = 2;
    I7(x,y) = (round( ((2^N)-1)  * ((double(I6(x,y))-a)/(b-a)) ) * (( b- a)/((2^N)-1))) + a;
  end;
end;
imwrite(I7, 'step6.bmp');



