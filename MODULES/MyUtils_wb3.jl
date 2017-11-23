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

function golden_section(a,c,f,maxstep)
    steps=1:1:maxstep
    estimates=zeros(length(steps))
    w=(sqrt(5)-1)/2
    b=a+w*(c-a)
    for i in steps
        if abs(c-b)>abs(b-a)
            x=b+(1-w)*(c-b)
            if f(b)<f(x)
                a,b,c=a,b,x
            else
                a,b,c=b,x,c
            end
        else
            x=b-(1-w)*(b-a)
            if f(b)<f(x)
                a,b,c=x,b,c
            else
                a,b,c=a,x,b
            end
        end
        estimates[i]=0.5*(c+a)
    end
    return steps,estimates
end
