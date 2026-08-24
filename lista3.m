%% funcoes 2d
tempo = 0:0.1:10
graf1 = 2*sin(3*tempo);
graf2 = 2*cos(3*tempo);

figure
plot(tempo, graf1, 'b-.');
hold on
plot(tempo, graf2, 'r.-');
xlabel("Tempo")
ylabel("Amplitude")
title("Senóide e Cossenoide")
legend("graf1", 'graf2', "Location","northeast")
grid(true)

%% entrada condição e gráfico
a = str2num(input("Entre com um valor", "s"));
x = -10:1:10;
y = a * x + 2;

if a > 0
    disp("positivo")
elseif a == 0
    disp("igual a zero")
else
    disp("negativo")
end

figure
plot(y, 'g-', LineWidth=0.2)
legend("y", "Location","southeast")
grid on
axes("Position",[0.2,0.3,0.2,0.4]);
box on
plot(y, 'r-', LineWidth=0.2)
xlim([-2 2]);
legend("y", "Location","southeast")
grid on

%% repeticao graficos
mult_3 = 0;
for i = 1:1:5
    a = i*3
    mult_3(end + 1) = mult_3(end) + a
end
disp(mult_3)

double_mult = mult_3 * 2; 

figure 
subplot(2, 1, 1)
plot(mult_3, 'g-')
xlabel("cinco primeiros múltiplos")
ylabel("Valor")
ylim([0 5])
title("Múltiplos de 3")
grid on
subplot(2,1,2)
plot(double_mult, 'r*')
xlabel("Índices")
ylabel("Dobro dos Múltiplos")
title("Dobro dos Múltiplos de 3")
grid on

%% comparação de escalas
t = 1:1:1000;
y = 50000*exp(-0.05*t);


figure;

% Gráfico 1 - escala linear nos dois eixos
subplot(2,1,1);
plot(t, y, 'b', 'LineWidth', 1.5);
title('Escala Linear');
xlabel('t');
ylabel('y');
grid on;

% Gráfico 2 - escala logarítmica no eixo vertical
subplot(2,1,2);
semilogy(t, y, 'r', 'LineWidth', 1.5);
title('Escala Semilogarítmica (eixo Y em log)');
xlabel('t');
ylabel('y (log)');
grid on;

title('Comparação: y = 50000e^{-0.05t}');

%% gráficos 3D
x = 1:1:10;
y = 1:1:20;

[X, Y] = meshgrid(x,y);
z = sin(X) + cos(Y);

z_peaks = peaks(z);

figure
subplot(2, 1, 1)
surfl(z_peaks)
colormap("autumn")
shading interp
title('Superfície iluminada (surfl) - peaks(z)')
xlabel('Eixo X')
ylabel('Eixo Y')
zlabel('Z')
colorbar

subplot(2, 1, 2)
plot3(X, Y, z, 'LineWidth', 2)
title('Curva 3D: z = sin(X) + cos(Y)')
xlabel('Eixo X')
ylabel('Eixo Y')
zlabel('Eixo Z')
legend('z = sin(X) + cos(Y)', 'Location', 'best')
grid on
