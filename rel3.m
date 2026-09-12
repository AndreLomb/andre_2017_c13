

clear; clc; close all;

t8 = 0:0.001:8;   % vetor de tempo padrão (0 a 8 s) usado nas comparações

%% Exercício 1 - Identificação de um sistema de primeira ordem a partir de um ensaio

fprintf("=====EXERCÍCIO 1======/n")
y_final_ensaio = 1.8;   % valor final observado da saída
t_63pct        = 1.2;   % instante em que a saída atinge ~63% do valor final [s]

% Como a entrada é um degrau unitário, o valor final da resposta é, por
% definição, o próprio ganho estático do sistema. E, por definição de
% sistema de 1a ordem, o tempo para atingir 63,2% do valor final é a
% própria constante de tempo tau.
K1   = y_final_ensaio;      % ganho
tau1 = t_63pct;              % constante de tempo [s]

G1 = tf(K1, [tau1 1]);
disp('Função de transferência G1(s):');
G1

% Polo do sistema
polo1 = pole(G1);
fprintf('Ganho K = %.4f\n', K1);
fprintf('Constante de tempo tau = %.4f s\n', tau1);
fprintf('Polo do sistema: %.4f\n', polo1);

% Tempo de subida (10%%-90%%) e tempo de acomodação (2%%) - fórmulas de 1a ordem
tr1 = 2.2*tau1;      % tempo de subida (10% a 90%)
ts1 = 4*tau1;        % tempo de acomodação (critério de 2%)
fprintf('Tempo de subida (10%%-90%%): %.4f s\n', tr1);
fprintf('Tempo de acomodação (2%%): %.4f s\n', ts1);

% Ganho em regime permanente
Kdc1 = dcgain(G1);
fprintf('Ganho em regime permanente: %.4f\n', Kdc1);

% Gráfico da resposta ao degrau unitário durante 8 s
figure;
step(G1, t8);
title('Exercício 1 - Resposta ao degrau unitário');
xlabel('Tempo (s)'); ylabel('Saída y(t)');
grid on;

% --- Entrada em degrau de amplitude 2,5 ---
amplitude2 = 2.5;
y_final2 = Kdc1*amplitude2;
fprintf('Novo valor final da saída p/ degrau de amplitude %.2f: %.4f\n', ...
    amplitude2, y_final2);

figure;
step(amplitude2*G1, t8);
title('Exercício 1 - Resposta ao degrau de amplitude 2,5');
xlabel('Tempo (s)'); ylabel('Saída y(t)');
grid on;

% 1) Quanto menor a constante de tempo tau, mais negativo (mais à
%    esquerda no plano s) fica o polo do sistema (polo = -1/tau); isso
%    torna a resposta transitória mais rápida.
% 2) A rapidez da resposta é inversamente proporcional a tau: tanto o
%    tempo de subida (2,2*tau) quanto o tempo de acomodação (4*tau)
%    diminuem quando tau diminui (polo mais afastado da origem).


%% Exercício 2 - Escolha entre três sistemas de segunda ordem

fprintf('\n========== EXERCÍCIO 2 ==========\n');

GA = tf(25, [1 3  25]);
GB = tf(25, [1 10 25]);
GC = tf(25, [1 16 25]);

sistemas2 = {GA, GB, GC};
nomes2    = {'Sistema A', 'Sistema B', 'Sistema C'};

wn2    = zeros(1,3);
zeta2  = zeros(1,3);
Kdc2   = zeros(1,3);
tipos2 = cell(1,3);

for k = 1:3
    [~, den] = tfdata(sistemas2{k}, 'v');   % den = [1 a1 a0]
    [wn2(k), zeta2(k)] = parametros_2a_ordem(den);
    Kdc2(k) = dcgain(sistemas2{k});

    if zeta2(k) < 1 - 1e-9
        tipos2{k} = 'subamortecido';
    elseif abs(zeta2(k) - 1) <= 1e-9
        tipos2{k} = 'criticamente amortecido';
    else
        tipos2{k} = 'superamortecido';
    end

    fprintf('%s:\n', nomes2{k});
    fprintf('  Polos: %s\n', mat2str(pole(sistemas2{k}), 4));
    fprintf('  Frequência natural (wn): %.4f rad/s\n', wn2(k));
    fprintf('  Coeficiente de amortecimento (zeta): %.4f\n', zeta2(k));
    fprintf('  Tipo de resposta: %s\n', tipos2{k});
    fprintf('  Ganho em regime permanente: %.4f\n', Kdc2(k));
end

% Resposta ao degrau unitário dos três sistemas em uma mesma figura
figure;
step(GA, t8); hold on;
step(GB, t8);
step(GC, t8);
title('Exercício 2 - Resposta ao degrau unitário (Sistemas A, B e C)');
xlabel('Tempo (s)'); ylabel('Saída y(t)');
legend(nomes2, 'Location', 'best');
grid on;
hold off;

% Posição dos polos dos três sistemas
figure;
pzmap(GA, GB, GC);
title('Exercício 2 - Posição dos polos (Sistemas A, B e C)');
legend(nomes2, 'Location', 'best');
grid on;

% Escolha do sistema mais adequado: sem sobressinal e resposta mais rápida
% Sistemas sem sobressinal são aqueles com zeta >= 1 (B e C). Entre eles,
% comparamos o tempo de acomodação obtido numericamente pela função stepinfo.
info_B = stepinfo(GB);
info_C = stepinfo(GC);
fprintf('Tempo de acomodação (2%%) - Sistema B: %.4f s\n', info_B.SettlingTime);
fprintf('Tempo de acomodação (2%%) - Sistema C: %.4f s\n', info_C.SettlingTime);

if info_B.SettlingTime < info_C.SettlingTime
    escolhido2 = 'Sistema B';
else
    escolhido2 = 'Sistema C';
end
fprintf('Sistema mais adequado (sem sobressinal e mais rápido): %s\n', escolhido2);

% Comentário:
% O Sistema A é subamortecido (zeta = 0,3 < 1) e portanto apresenta
% sobressinal, sendo descartado pela exigência da aplicação. Entre os
% Sistemas B (criticamente amortecido) e C (superamortecido), ambos sem
% sobressinal, o Sistema B é mais rápido porque, para uma mesma wn, o
% amortecimento crítico é o menor amortecimento que ainda evita
% oscilação — no Sistema C o polo dominante fica mais próximo da origem,
% tornando a resposta mais lenta.


%% Exercício 3 - Avaliação de desempenho de dois sistemas de segunda ordem

fprintf('\n========== EXERCÍCIO 3 ==========\n');

G_1 = tf(16, [1 2.8 16]);
G_2 = tf(25, [1 6.5 25]);

sistemas3 = {G_1, G_2};
nomes3    = {'Sistema 1', 'Sistema 2'};

for k = 1:2
    [~, den] = tfdata(sistemas3{k}, 'v');
    [wn, zeta] = parametros_2a_ordem(den);
    p        = pole(sistemas3{k});
    yfinal   = dcgain(sistemas3{k});      % entrada é degrau unitário
    td       = tempo_atraso(zeta, wn);
    tr       = tempo_subida_2ordem(zeta, wn);
    tp       = tempo_pico(zeta, wn);
    Mp       = sobressinal_max(zeta);              % em %
    picoVal  = yfinal*(1 + Mp/100);
    ts       = tempo_acomodacao_2ordem(zeta, wn);

    fprintf('%s:\n', nomes3{k});
    fprintf('  Valor final da resposta: %.4f\n', yfinal);
    fprintf('  Tempo de atraso (50%%): %.4f s\n', td);
    fprintf('  Tempo de subida: %.4f s\n', tr);
    fprintf('  Tempo de pico: %.4f s\n', tp);
    fprintf('  Valor do primeiro pico: %.4f\n', picoVal);
    fprintf('  Máximo sobressinal: %.2f %%\n', Mp);
    fprintf('  Tempo de acomodação (2%%): %.4f s\n', ts);
    fprintf('  Frequência natural (wn): %.4f rad/s\n', wn);
    fprintf('  Coeficiente de amortecimento (zeta): %.4f\n', zeta);
    fprintf('  Polos: %s\n', mat2str(p, 4));
end

figure;
step(G_1, t8); hold on;
step(G_2, t8);
title('Exercício 3 - Resposta ao degrau unitário (Sistemas 1 e 2)');
xlabel('Tempo (s)'); ylabel('Saída y(t)');
legend(nomes3, 'Location', 'best');
grid on;
hold off;

% Verificação dos requisitos: Mp < 10% e ts < 1,5 s
[~, den_1] = tfdata(G_1, 'v');
[~, den_2] = tfdata(G_2, 'v');
[wn1_, zeta1_] = parametros_2a_ordem(den_1);
[wn2_, zeta2_] = parametros_2a_ordem(den_2);
Mp1_ = sobressinal_max(zeta1_);
Mp2_ = sobressinal_max(zeta2_);
ts1_ = tempo_acomodacao_2ordem(zeta1_, wn1_);
ts2_ = tempo_acomodacao_2ordem(zeta2_, wn2_);

atende1 = (Mp1_ < 10) && (ts1_ < 1.5);
atende2 = (Mp2_ < 10) && (ts2_ < 1.5);
fprintf('Sistema 1 atende aos requisitos? %d (Mp=%.2f%%, ts=%.4fs)\n', atende1, Mp1_, ts1_);
fprintf('Sistema 2 atende aos requisitos? %d (Mp=%.2f%%, ts=%.4fs)\n', atende2, Mp2_, ts2_);

% Comentários:
% 1) O Sistema 1 (zeta = 0,35) apresenta menor amortecimento que o
%    Sistema 2 (zeta = 0,65); por isso seu sobressinal é bem maior
%    (~31% contra ~7%), embora seu tempo de pico seja um pouco maior.
% 2) Apenas o Sistema 2 satisfaz simultaneamente os requisitos de
%    sobressinal inferior a 10% e tempo de acomodação inferior a 1,5 s;
%    o Sistema 1 viola as duas condições, sendo portanto reprovado para
%    essa aplicação.


%% Exercício 4 - Seleção de parâmetros para um sistema de segunda ordem

fprintf('\n========== EXERCÍCIO 4 ==========\n');

zetas4 = [0.35, 0.55, 0.70, 0.80];
wns4   = [6, 5, 4, 3.2];
nomes4 = {'Configuração A', 'Configuração B', 'Configuração C', 'Configuração D'};

sistemas4 = cell(1,4);
Mp4  = zeros(1,4);
tr4  = zeros(1,4);
tp4  = zeros(1,4);
ts4  = zeros(1,4);
yf4  = zeros(1,4);

for k = 1:4
    zeta = zetas4(k);
    wn   = wns4(k);

    % Forma padrão de 2a ordem: G(s) = wn^2 / (s^2 + 2*zeta*wn*s + wn^2)
    G = tf(wn^2, [1 2*zeta*wn wn^2]);
    sistemas4{k} = G;

    p       = pole(G);
    Mp4(k)  = sobressinal_max(zeta);
    tr4(k)  = tempo_subida_2ordem(zeta, wn);
    tp4(k)  = tempo_pico(zeta, wn);
    ts4(k)  = tempo_acomodacao_2ordem(zeta, wn);
    yf4(k)  = dcgain(G);

    fprintf('%s (zeta=%.2f, wn=%.2f rad/s):\n', nomes4{k}, zeta, wn);
    fprintf('  Polos: %s\n', mat2str(p, 4));
    fprintf('  Máximo sobressinal: %.2f %%\n', Mp4(k));
    fprintf('  Tempo de subida: %.4f s\n', tr4(k));
    fprintf('  Tempo de pico: %.4f s\n', tp4(k));
    fprintf('  Tempo de acomodação (2%%): %.4f s\n', ts4(k));
    fprintf('  Valor final da resposta ao degrau unitário: %.4f\n', yf4(k));
end

figure;
hold on;
for k = 1:4
    step(sistemas4{k}, t8);
end
title('Exercício 4 - Resposta ao degrau unitário das quatro configurações');
xlabel('Tempo (s)'); ylabel('Saída y(t)');
legend(nomes4, 'Location', 'best');
grid on;
hold off;

% Requisitos: sobressinal < 10% e tempo de acomodação < 1,5 s
atende4 = (Mp4 < 10) & (ts4 < 1.5);
fprintf('\nAtendimento aos requisitos (1 = atende, 0 = não atende):\n');
for k = 1:4
    fprintf('  %s: %d  (Mp=%.2f%%, ts=%.4fs)\n', nomes4{k}, atende4(k), Mp4(k), ts4(k));
end

idx_validas = find(atende4);
[~, imin] = min(tr4(idx_validas));
idx_escolhida = idx_validas(imin);
fprintf('Configuração selecionada (menor tempo de subida entre as válidas): %s\n', ...
    nomes4{idx_escolhida});

% Comentários:
% 1) As Configurações A e B apresentam sobressinal acima de 10% (31% e
%    ~13%, respectivamente) nos gráficos, sendo descartadas; a
%    Configuração D, apesar de não ter sobressinal relevante, tem tempo
%    de acomodação pouco acima de 1,5 s, também sendo descartada.
% 2) Somente a Configuração C atende simultaneamente aos dois
%    requisitos (sobressinal < 10% e ts < 1,5 s) observados na resposta
%    temporal, sendo portanto a escolha que melhor equilibra
%    velocidade de resposta e ausência de oscilação excessiva.


%% Exercício 5 - Comparação entre sistemas de primeira e segunda ordem

fprintf('\n========== EXERCÍCIO 5 ==========\n');

G_A5 = tf(2, [1.2 1]);           % Equipamento A - 1a ordem
G_B5 = tf(32, [1 5.6 16]);       % Equipamento B - 2a ordem

% --- Equipamento A (1a ordem) ---
tauA = 1.2;
poloA = pole(G_A5);
KdcA  = dcgain(G_A5);
yfinalA = KdcA*1;                % degrau unitário
trA = 2.2*tauA;
tsA = 4*tauA;

fprintf('Equipamento A (1a ordem):\n');
fprintf('  Polo: %.4f\n', poloA);
fprintf('  Ganho em regime permanente: %.4f\n', KdcA);
fprintf('  Valor final da resposta: %.4f\n', yfinalA);
fprintf('  Tempo de subida (10%%-90%%): %.4f s\n', trA);
fprintf('  Tempo de acomodação (2%%): %.4f s\n', tsA);

% --- Equipamento B (2a ordem) ---
[~, denB] = tfdata(G_B5, 'v');
[wnB, zetaB] = parametros_2a_ordem(denB);
poloB = pole(G_B5);
KdcB  = dcgain(G_B5);
yfinalB = KdcB*1;
trB = tempo_subida_2ordem(zetaB, wnB);
tsB = tempo_acomodacao_2ordem(zetaB, wnB);
tpB = tempo_pico(zetaB, wnB);
MpB = sobressinal_max(zetaB);
picoB = yfinalB*(1 + MpB/100);

fprintf('Equipamento B (2a ordem):\n');
fprintf('  Polos: %s\n', mat2str(poloB, 4));
fprintf('  Ganho em regime permanente: %.4f\n', KdcB);
fprintf('  Valor final da resposta: %.4f\n', yfinalB);
fprintf('  Tempo de subida: %.4f s\n', trB);
fprintf('  Tempo de acomodação (2%%): %.4f s\n', tsB);
fprintf('  Frequência natural (wn): %.4f rad/s\n', wnB);
fprintf('  Coeficiente de amortecimento (zeta): %.4f\n', zetaB);
fprintf('  Tempo de pico: %.4f s\n', tpB);
fprintf('  Valor do primeiro pico: %.4f\n', picoB);
fprintf('  Máximo sobressinal: %.2f %%\n', MpB);

figure;
step(G_A5, t8); hold on;
step(G_B5, t8);
title('Exercício 5 - Resposta ao degrau unitário (Equipamentos A e B)');
xlabel('Tempo (s)'); ylabel('Saída y(t)');
legend('Equipamento A', 'Equipamento B', 'Location', 'best');
grid on;
hold off;

% --- Repetição com degrau de amplitude 1,5 ---
amplitude5 = 1.5;
yfinalA_15 = KdcA*amplitude5;
yfinalB_15 = KdcB*amplitude5;
fprintf('Valor final p/ degrau de amplitude %.1f - Equipamento A: %.4f\n', amplitude5, yfinalA_15);
fprintf('Valor final p/ degrau de amplitude %.1f - Equipamento B: %.4f\n', amplitude5, yfinalB_15);

figure;
step(amplitude5*G_A5, t8); hold on;
step(amplitude5*G_B5, t8);
title('Exercício 5 - Resposta ao degrau de amplitude 1,5 (Equipamentos A e B)');
xlabel('Tempo (s)'); ylabel('Saída y(t)');
legend('Equipamento A', 'Equipamento B', 'Location', 'best');
grid on;
hold off;

% Comentários:
% 1) Quanto à rapidez: o Equipamento B atinge a região de regime
%    permanente mais rapidamente (ts ≈ 1,43 s) do que o Equipamento A
%    (ts = 4,8 s), pois seus polos estão mais afastados do eixo
%    imaginário (parte real mais negativa).
% 2) Quanto ao sobressinal: o Equipamento A, por ser de 1a ordem, nunca
%    apresenta sobressinal; já o Equipamento B, por ser subamortecido
%    (zeta = 0,7 < 1), apresenta um sobressinal de aproximadamente 4,6%.
% 3) Quanto ao regime permanente: como os dois equipamentos possuem o
%    mesmo ganho estático (K = 2), ambos convergem para o mesmo valor
%    final em regime permanente, seja para o degrau unitário (valor 2)
%    seja para o degrau de amplitude 1,5 (valor 3) — a diferença entre
%    eles está apenas no comportamento transitório, não no valor final.


%% ==================== Funções locais ====================

function [wn, zeta] = parametros_2a_ordem(den)
    % Extrai wn e zeta de um denominador na forma padrão
    % den = [1 2*zeta*wn  wn^2]  (den(1) deve ser 1)
    den = den/den(1);
    wn   = sqrt(den(3));
    zeta = den(2)/(2*wn);
end

function td = tempo_atraso(zeta, wn)
    % Aproximação usual para o tempo de atraso (50% do valor final)
    td = (1 + 0.7*zeta)/wn;
end

function tr = tempo_subida_2ordem(zeta, wn)
    % Tempo de subida (0% a 100%) para sistemas subamortecidos (0<zeta<1)
    beta = acos(zeta);
    wd   = wn*sqrt(1 - zeta^2);
    tr   = (pi - beta)/wd;
end

function tp = tempo_pico(zeta, wn)
    wd = wn*sqrt(1 - zeta^2);
    tp = pi/wd;
end

function Mp = sobressinal_max(zeta)
    % Máximo sobressinal, em percentual
    Mp = exp(-zeta*pi/sqrt(1 - zeta^2))*100;
end

function ts = tempo_acomodacao_2ordem(zeta, wn)
    % Tempo de acomodação, critério de 2%
    ts = 4/(zeta*wn);
end
