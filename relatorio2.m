%% Sistema massa-atrito e comparação gráfica
clear; clc; close all;

%% Parâmetros dos sistemas
M1 = 2;  B1 = 3;
M2 = 4;  B2 = 6;

num = 1;
den1 = [M1 B1];
den2 = [M2 B2];

Gs1 = tf(num, den1)
Gs2 = tf(num, den2)

t = 0:0.01:20;

[y1, t1] = step(Gs1, t);
[y2, t2] = step(Gs2, t);

% Vetor da força unitária aplicada (entrada degrau unitário)
forca = ones(size(t));

% Figura 1 - As duas respostas juntas + força aplicada
figure(1)
plot(t1, y1, 'b', 'LineWidth', 1.5); hold on
plot(t2, y2, 'r', 'LineWidth', 1.5);
plot(t, forca, 'k--', 'LineWidth', 1.2);
grid on
title('Resposta ao Degrau - Comparação entre Sistemas Massa-Atrito')
xlabel('Tempo (s)')
ylabel('Amplitude')
legend('Sistema 1 (M=2, B=3)', 'Sistema 2 (M=4, B=6)', ...
       'Força unitária aplicada', 'Location', 'southeast')

% Zoom (janela dentro do gráfico) - primeiros 5 segundos

axes('Position', [0.55 0.25 0.3 0.3]) 
box on
idx = t <= 5;
plot(t(idx), y1(idx), 'b', 'LineWidth', 1.2); hold on
plot(t(idx), y2(idx), 'r', 'LineWidth', 1.2);
plot(t(idx), forca(idx), 'k--', 'LineWidth', 1);
grid on
title('Zoom: 0 a 5 s')
xlabel('Tempo (s)')
ylabel('Amplitude')

% Figura 2 - Respostas separadas (um gráfico acima do outro)
figure(2)

subplot(2,1,1)
plot(t1, y1, 'b', 'LineWidth', 1.5); hold on
plot(t, forca, 'k--', 'LineWidth', 1);
grid on
title('Sistema Massa-Atrito 1 (M = 2 kg, B = 3)')
xlabel('Tempo (s)')
ylabel('Amplitude')
legend('Resposta ao degrau', 'Força unitária', 'Location', 'southeast')

subplot(2,1,2)
plot(t2, y2, 'r', 'LineWidth', 1.5); hold on
plot(t, forca, 'k--', 'LineWidth', 1);
grid on
title('Sistema Massa-Atrito 2 (M = 4 kg, B = 6)')
xlabel('Tempo (s)')
ylabel('Amplitude')
legend('Resposta ao degrau', 'Força unitária', 'Location', 'southeast')

%% Circuito RC
R = 2000;
tau = 2.5;

% Cálculo da capacitância
C = tau/R

% Cálculo degrau
numRC = 1;
denRC = [R*C 1];
GsRC = tf(numRC, denRC);

figure
step(GsRC, 15)
title('Resposta ao Degrau - Circuito RC')
xlabel('Tempo (s)')
ylabel('Tensão no capacitor (V)')
grid on

Rteste = 100:100:1000;
tau_teste = Rteste * C;

figure(2)

subplot(2, 2, 1)
plot(Rteste, tau_teste, 'b', 'LineWidth', 1.5)
title('Escala Linear (R x \tau)')
xlabel('Resistência (\Omega)')
ylabel('Constante de tempo \tau (s)')
grid on

subplot(2, 2, 2)
semilogy(Rteste, tau_teste, 'r', 'LineWidth', 1.5)
title('Escala Log no Eixo Y')
xlabel('Resistência (\Omega)')
ylabel('Constante de tempo \tau (s) [log]')
grid on

subplot(2,2,3)
semilogx(Rteste, tau_teste, 'g', 'LineWidth', 1.5)
title('Escala Log no Eixo X')
xlabel('Resistência (\Omega) [log]')
ylabel('Constante de tempo \tau (s)')
grid on

subplot(2,2,4)
loglog(Rteste, tau_teste, 'm', 'LineWidth', 1.5)
title('Escala Log-Log')
xlabel('Resistência (\Omega) [log]')
ylabel('Constante de tempo \tau (s) [log]')
grid on

%% dados experimentais caixa preta
t = (0:25)';
u = [0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
y = [0.008 0.012 0.006 0.010 0.020 0.382 0.671 0.903 1.082 1.226 1.335 1.425 ...
     1.492 1.547 1.587 1.618 1.642 1.660 1.674 1.684 1.692 1.698 1.702 1.706 ...
     1.709 1.711];

u = u(:);
y = y(:);
 
figure(1)
 
subplot(2,1,1)
plot(t, u, 'b', 'LineWidth', 1.5)
title('Sinal de Entrada')
xlabel('Tempo (s)')
ylabel('Entrada u(t)')
grid on
 
subplot(2,1,2)
plot(t, y, 'r', 'LineWidth', 1.5)
title('Sinal de Saída')
xlabel('Tempo (s)')
ylabel('Saída y(t)')
grid on
 
%Figura 2 - Representação 3D (tempo, entrada, saída)
figure(2)
plot3(t, u, y, 'b', 'LineWidth', 1.5)
view(45, 30)
title('Relação entre Tempo, Entrada e Saída')
xlabel('Tempo (s)')
ylabel('Entrada u(t)')
zlabel('Saída y(t)')
grid on
 
Ts = 1; % Tempo de amostragem (s)
 
dados = iddata(y, u, Ts);
 
% Estimando a função de transferência (1 polo, 0 zeros)
modelo = tfest(dados, 1, 0)

%Comparação 
figure(3)
compare(dados, modelo)
grid on

% Resposta ao degrau do modelo identificado (25 segundos)
figure(4)
step(modelo, 25)
title('Resposta ao Degrau - Modelo Identificado')
xlabel('Tempo (s)')
ylabel('Amplitude')
grid on

%% Análise de diferentes circuitos RC

R1 = 1000;  tau1 = 1.2;
R2 = 2000;  tau2 = 2.8;
R3 = 3000;  tau3 = 3.9;
R4 = 5000;  tau4 = 7.0;

% Capacitância de cada experimento (C = tau/R)
C1 = tau1 / R1
C2 = tau2 / R2
C3 = tau3 / R3
C4 = tau4 / R4

R   = [R1 R2 R3 R4];
tau = [tau1 tau2 tau3 tau4];
C   = [C1 C2 C3 C4];

% Figura 1 - plot3 dos quatro experimentos
figure(1)
plot3(R, tau, C, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerFaceColor', 'b')
title('Relação entre Resistência, Constante de Tempo e Capacitância')
xlabel('Resistência (\Omega)')
ylabel('Constante de tempo \tau (s)')
zlabel('Capacitância C (F)')
grid on

% Experimento 3 - função de transferência
% G(s) = 1 / (tau3*s + 1)
num = 1;
den = [tau3 1];
Gs3 = tf(num, den)

% Resposta ao degrau do Experimento 3 (20 segundos) com zoom 
t= 0:0.01:20;
[y3, t3] = step(Gs3, t);

figure(2)
plot(t3, y3, 'b', 'LineWidth', 1.5)
title('Resposta ao Degrau - Experimento 3 (R = 3000 \Omega, \tau = 3,9 s)')
xlabel('Tempo (s)')
ylabel('Amplitude')
grid on

axes('Position', [0.55 0.25 0.3 0.3]) 
box on
idx = t3 <= 5;
plot(t3(idx), y3(idx), 'b', 'LineWidth', 1.2)
title('Zoom: 0 a 5 s')
xlabel('Tempo (s)')
ylabel('Amplitude')
grid on

%% Análise completa de três tipos de modelagem
clear; clc; close all;

% ===================== SISTEMA A - Caixa Branca =====================
% Sistema massa-atrito (modelo obtido a partir das leis físicas conhecidas)
M = 3;
B = 5;

numA = 1;
denA = [M B];
GsA = tf(numA, denA)

% ===================== SISTEMA B - Caixa Cinza =====================
% Circuito RC (modelo físico conhecido, mas com parâmetro C obtido
% experimentalmente a partir da constante de tempo medida)
R = 1500;
tau = 3;

% C = tau/R
C = tau / R

numB = 1;
denB = [tau 1];
GsB = tf(numB, denB)

% ===================== SISTEMA C - Caixa Preta =====================
% Sistema totalmente desconhecido, identificado apenas a partir de
% dados experimentais de entrada e saída
t = (0:20)';

u = [0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
y = [0.010 0.006 0.012 0.018 0.408 0.706 0.934 1.103 1.229 1.322 1.391 1.441 ...
     1.479 1.505 1.526 1.540 1.551 1.558 1.564 1.568 1.571];

u = u(:);
y = y(:);

Ts = 1; % tempo de amostragem (s)

dados = iddata(y, u, Ts);
GsC = tfest(dados, 1, 0)

% ===================== Figura 1 - Respostas ao degrau (20s) =====================
figure(1)

subplot(3,1,1)
step(GsA, 20)
title('Sistema A - Massa-Atrito (Caixa Branca)')
xlabel('Tempo (s)')
ylabel('Amplitude')
grid on

subplot(3,1,2)
step(GsB, 20)
title('Sistema B - Circuito RC (Caixa Cinza)')
xlabel('Tempo (s)')
ylabel('Amplitude')
grid on

subplot(3,1,3)
step(GsC, 20)
title('Sistema C - Modelo Identificado (Caixa Preta)')
xlabel('Tempo (s)')
ylabel('Amplitude')
grid on

% ===================== Figura 2 - Entrada e saída do Sistema C =====================
figure(2)

subplot(2,1,1)
plot(t, u, 'b', 'LineWidth', 1.5)
title('Sistema C - Sinal de Entrada')
xlabel('Tempo (s)')
ylabel('Entrada u(t)')
grid on

subplot(2,1,2)
plot(t, y, 'r', 'LineWidth', 1.5)
title('Sistema C - Sinal de Saída')
xlabel('Tempo (s)')
ylabel('Saída y(t)')
grid on

% ===================== Comparação: dados experimentais x modelo (Sistema C) =====================
figure(3)
compare(dados, GsC)
grid on

% ===================== Classificação dos sistemas =====================
% Sistema A (Caixa Branca): o modelo foi construído inteiramente a partir
% das leis físicas conhecidas do sistema massa-atrito (segunda lei de
% Newton), com todos os parâmetros (M e B) conhecidos previamente. Não
% houve necessidade de nenhum dado experimental para obter a função de
% transferência, o que facilitou muito a modelagem do gráfico.

% Sistema B (Caixa Cinza): a estrutura do modelo também é conhecida
% (relação física do circuito RC, G(s) = 1/(RC*s+1)), porém um dos
% parâmetros (a constante de tempo tau, e consequentemente C) precisou
% ser obtido a partir de medições.

% Sistema C (Caixa Preta): não se conhece nenhuma informação sobre a
% estrutura interna ou os parâmetros físicos do sistema. O modelo foi
% obtido unicamente a partir dos dados de entrada e saída medidos
% experimentalmente, por meio de um processo de identificação (tfest).