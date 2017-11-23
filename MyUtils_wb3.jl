function f(x)
   y=sin(exp(x))
   return y
end

function f_prime_num(h)
    x=1
    y=(-(3/2)*f(1)+2*f(x+h)-(1/2)*f(x+2*h))/h
    return y
end

function f_prime_ana(x)
    y=cos(exp(x))*exp(x)
    return y
end
