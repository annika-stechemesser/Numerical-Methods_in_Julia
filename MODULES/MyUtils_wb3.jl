#FUNCTIONS QUESTION 1

#FUNCTION 1.1

#this is the function defined in Question 1
function f(x)
   y=sin(exp(x))
   return y
end

#FUNCTION 1.2

#this is the derivative of function 1.1 using the formula that was found in Q1.1
function f_prime_num(h)
    x=1
    y=(-(3/2)*f(1)+2*f(x+h)-(1/2)*f(x+2*h))/h
    return y
end

#FUNCTION 1.3

# This is the analytical derivative of function 1.1
function f_prime_ana(x)
    y=cos(exp(x))*exp(x)
    return y
end

#FUNCTION QUESTION 2 AND 3

function bracket_and_bisect(a,b,f,maxstep)
    steps=1:1:maxstep
    estimates=zeros(length(steps))
    for i in steps
        x=(a+b)/2
        if f(a)*f(x)>0 
            a=x
            b=b
        else
            a=a
            b=x
        end
        estimates[i]=x
    end
    return steps,estimates
end

function newton_raphson(x,f,f_prime,maxstep)
    steps=1:1:maxstep
    estimates=zeros(length(steps))
    for i in steps
        d=-f(x)/f_prime(x)
        x=x+d
        estimates[i]=x
    end
    return steps,estimates
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
