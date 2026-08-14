function res = transforma_matriz(A,B)
    [l, c] = size(A)
    for i = 1:l
        for j = 1:c
            if A(i,j) >= 5
                B(i,j) = A(i,j)*2*exp(1);
            else
                B(i,j) = A(i,j)*2;
            end
        end
    end
end