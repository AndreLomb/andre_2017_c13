%% Análise de três medições

valores = [];

for i = 1:1:3
    valor = input("Digite um valor");
    disp(['Você digitou: ', num2str(valor)]);
    valores(end + 1) = valor;
end

mean(valores)
max(valores)
min(valores)

if mean(valores) >= 8
    disp("Resultado Alto");
elseif mean(valores) >=  5 && mean(valores) <= 8
    disp("Resultado intermediário");
elseif mean(valores) < 5
    disp("Resultado Baixo");
end

%% Processamento de um vetor com for
A = [3,8,2,10,5,7,1,6]
B = zeros(1, length(A))

for i = 1:1:length(A)
    if A(i) >= 6
       B(i) = 2*A(i)
    else 
        B(i) = A(i)+3
    end
    disp(B)
end

disp(A)
disp(B)
sum(B)
mean(B)
max(B)
min(B)

%% identificação de pares em um vetor
A2 = [14, 7, 20, 9, 6, 11, 18, 5]
len = length(A2)
count = 0

B2 = zeros(1, len)

for i = 1:1:len
    rem(A2(i), 2)
    if rem(A2(i), 2) == 0
        B2(i) = A2(i)
        count = count + 1
    end
end 

disp(B2)

%% calculadora com menu

%% Acuulador com while
soma = 0
contador = 0
while soma <= 4
    soma = soma + rand()
    contador = contador + 1
    disp(soma)
    disp(contador)
end

if contador > 8
    disp("Muitas repetições")
else 
    disp("Poucas repetições")
end

%% procesamento de matri
A = [2,7,4,9;
    6,1,8,3];
B = zeros(2, length(A))

for i = 1:size(A, 1)
    for j = 1:size(A, 2)
        if A(i,j) > 5
            B(i, j) = A(i, j) * 2
        else
            B(i, j) = A(i, j) + 5;
        end
    end
end

disp("End of for lop")

disp(A)
disp(B)
transpose(B)
B(1,:)
B(:, 3)

%% funcao com duas saidas 
A = [5,12,7,3,9,14]

[m,n]= analisa_vetor(A)
fprintf('m = %.4g\n', m);
fprintf('n = %.4g\n', n);

if m >= 8
    disp("Média elevada")
else 
    disp("Media abaixo de 8")
end

%% transformar uma matriz
A = [1,5,3,8;6,2,7,4];
B = zeros(size(A));

transforma_matriz(A, B)

%% entrada com texto e concvversao numerica
val1 = input("entre com o primeiro valor\n", "s");
val2 = input("entre com o segundo valor\n", "s");

disp(val1)
disp(val2)

val1 = str2num(val1);
val2 = str2num(val2);

soma = val1 + val2;
mult = val1 * val2;

fprintf("soma:%g\n", soma)
fprintf("mult:%g\n", mult)

if soma > 20
    disp("Soma alta")
elseif soma == 20
    disp("Soma igual a 20")
else 
    disp("Soma baixa")
end

%% Desafio integrador

dados =[12, 18,10,25,15];

sum(dados)
mean(dados)
max(dados)
min(dados)

great_avg = [];

for i = 1:length(dados)
    if dados(i) >= mean(dados)
        great_avg(end+1) = dados(i);
    end
end

choose = -1
while choose ~= 0
    disp("1 - Gráfico de barras")
    disp("2 - Gráfico de pizza")
    disp("0 - Sair")
    
    choose = input("Escolha uma opção: ");
    
    switch choose
        case 1
            bar(dados)
            title("Gráfico de barras")
        case 2
            pie3(dados)
            title("Gráfico de pizza")
        case 0 
            disp("Saindo")
        otherwise
            warning ("Nenhum gráfico criado")
    end
end