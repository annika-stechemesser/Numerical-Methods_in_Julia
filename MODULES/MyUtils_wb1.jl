
#### Functions Workbook 1, Question 1

#Function 1.1

# This function computes the theoretical solution to the recursion given in the question, using the solution from before.
#Input: Number of steps
#Output: value at each step
function recursion_theo(N)

rec=Array{BigFloat}(N)
rec[1]=1
rec[2]=2/3
C_1=0
C_2=3/2
λ_1=4/3
λ_2=2/3
for i=3:N
    rec[i]=C_1*(λ_1)^i+C_2*(λ_2)^i
end
    return rec
end


#### Functions Workbook 1, Question 2


#FUNCTION 2.0 (was given, just for completeness)
function mergepresorted(A::Array{Int64,1}, B::Array{Int64,1})
    if length(A) == 0
        return B
    elseif length(B) == 0
        return A
    elseif A[1] < B[1]
        return vcat([A[1]], mergepresorted(A[2:end], B))
    else
        return vcat([B[1]], mergepresorted(A, B[2:end]))
    end    
end

#FUNCTION 2.1

## This function verifies that the function "mergepresorted" works
#Input: Array to check
#Output: Statement about order of the array

function check(C)
    D=sort(C) #build in julia function
    if D==C
        println("The array is in correct order")
    else 
        println("The array is not in corret order")
    end
    
end

#FUNCTION 2.2

#This function is the solution to Question 2 Part 2 and therefore also included in the notebook. 
#Input: array
#Output: sorted array

function my_mergesort(A)   
    n=length(A)
    if n == 1
        return A 
    else m=n/2
        m=Int(m)
        return mergepresorted(my_mergesort(A[1:m]),my_mergesort(A[m+1:n]))
    end    
end 


#FUNCTION 2.3

## This function measures the execution time of the function "my_mergesort".  
#Input: highest power of two to which we want to consider our array length
#Output: vector of execution times
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


#FUNCTION 2.4
## This function is the theoretical prediction of the running time for the mergesort. 
#Input:  highest power of two to which we want to consider our array length
#Output: Execution times

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
