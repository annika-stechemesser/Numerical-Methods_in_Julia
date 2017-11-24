
#### Functions Workbook 1, Question 1

## This function takes an array as an input, sorts it and compares this with the result of the function "mergepresorted". It is build to verify that the mergepresorted function works.

function check(C)
    D=sort(C)
    if D==C
        println("The array is in correct order")
    else 
        println("The array is not in corret order")
    end
    
end



#### Functions Workbook 1, Question 2

## This function measures the execution time of the function "my_mergesort". The input is the highest power of two which we want to consider as our array length. The function returns a vector x of the powers of two at which we evaluate and a vector of execution times. 

function Execution_time(steps)
Time=zeros(steps)
x=zeros(steps)
    for i=1:steps
        n=2^i
        x[i]=n
        A=rand(1:10000,n)
        Time[i]=(@timed my_mergesort(A))[2]
    end
    return x,Time
end
## This function is the theoretical prediction of the running time for the mergesort. The input is the highest power of two which we want to consider as our array length.The function returns a vector x of the powers of two at which we evaluate and a vector of execution times. 

function Time_Theo(steps)
Theo=zeros(steps)
x=zeros(steps)
	for i=1:steps
	    n=2^i
	    x[i]=n
	   Theo[i]=n*log(n)
	end
	return x,Theo
end
