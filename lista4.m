%% sistema massa mola amortecedor
M1 = 2;
B = 3;
K = 8;

num1 = 1;
den1 = [M1 B K]

G1 = tf(num1, den1)
figure
step(G1, 15);
title('Sistema massa mola amortecedor - Caixa Branca');
grid on;
xlabel("Tempo(s)")
ylabel("Velocidade (m/s")
legend("F(s)", 'r-', "Location","east")

%% Circuito RC
R = 1000
tau = 2;

%Vc/Vi = 1/(RCs + 1)

C = tau/R

num2 = 1
den2 = [R*C 1]

G2 = tf(num2, den2);
figure
step(G2, 15);
title('Circuito RC - Resposta ao Degrau');
grid on;
xlabel('Tempo (s)');
ylabel('Tensão (V)');

%% sistema massa atrito
% Parâmetros do sistema
M3 = 4;      % massa (kg)
F = 1;       % força aplicada (N) 

v_ss = 0.5;
B = F / v_ss

% Função de transferência: V(s)/F(s) = 1/(M*s + B)
num3 = 1;
den3 = [M3 B];
G3 = tf(num3, den3)

figure
step(G3, 15)
title('Sistema Massa-Atrito - Caixa Cinza')
grid on
xlabel('Tempo (s)')
ylabel('Velocidade (m/s)')
