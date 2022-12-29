%% Esta función calcula la divergencia de una imagen dado su gradiente
function divergencia = div(ux,uy)
divergencia = gradx(ux,'backward') + grady(uy,'backward');
end