## Functions Workbook 2 Question 1
 
##This function takes the desired number of KV-Pairs as an input and outputs the respective number of key value pairs. For the generated key value pairs, the keys are integers in ascending order and the values are random numbers. 
function create_KVPairs(n)
    seed = 1235 
    rng = MersenneTwister(seed)
    X = rand(rng, n)
    values = Array{KVPair}(n)
    for i in 1:n
        values[i] = KVPair(i,X[i])
    end
    return values
end

## This function is the answer to Q1 Part 1 and therefore also included in the notebook.
function list_traverse(LList::Nullable{LList})  #the input needs to be of the type "Nullable{LList}"
    L=LList
    k=get(L).data  #k=key value pair of the list
    k1=k.key       # k = key of the list 
    println(k1)    # print the key
    L=get(L).next  # let L be the list that is stored in LList
    if isnull(L)==false # if L is not null, we want to repeat the process (recursive function)
         list_traverse(L)
    end    
end 

## This function is the answer to Q1 Part 2 and therefore also included in the notebook.
function list_search(LList::Nullable{LList}, a::Int64) #the input needs to be of the type "Nullable{LList}", "Int64"
    L=LList
    k=get(L).data #k=key value pair of the list
    k1=k.key      # k1 = key of the list 
    if (k1 == a)  # if the key is the one we're looking for, return the key value pair k
        return(k)
    else
        L=get(L).next # else update the list and repeat the process (recursive function)
        list_search(L,a)    
    end
end



## This function is checking if the previously defined function "list_search" is working correctly. 
function working_search(n::Int64) # takes a desired list size as input value
    values=create_KVPairs(n)  # uses the function "create_KVPairs" to build an array of KV pairs
    L=buildLList(values); # uses the function "buildLList" to turn them into a list
    working=true # set the boolian variable "working" to "true"
    for i=1:length(values)    #search for every possible key
        if (list_search(L,i).key != values[i].key) 
#if "list_search" finds a key (of a KVPair) that doesn't match the original one -> working = false 
            println("The function does not work correctly.")
            working=false
# if "list_search" finds a value (of a KVPair) that doesn't match the original one -> working = false
        elseif (list_search(L,i).value != values[i].value)
            println("The function does not work correctly.")
            working=false
        end
    end
# if "list_search" works correctly this function will display it in the workbook.
    if working==true
        println("The function works correctly.")    
    end
end

## This function takes the maximal list length as input argument. It builds a list for every list length and searches for every key value. The execution time is then the mean of the search times.
function Cost_List_search(n)
Time=zeros(n)
        for i=1:n
            Sub_time=zeros(i)
            values=create_KVPairs(i)
            L=buildLList(values)

            for j=1:i
            Sub_time[j]=(@timed list_search(L,j))[2]
            end
            Time[i]=mean(Sub_time)
        end
    return Time
end

##Functions Workbook 2 Question 2

## This function is the answer to Q2 Part 1 and therefore also included in the notebook.
function create_KVPairs_partial_sums(n) #desired number of intervals
    seed = 1235 
    rng = MersenneTwister(seed)
    X = rand(rng, n)                    #random array of length n
    values = Array{KVPair}(n)           #empty array with n KVPairs
    for i in 1:n                     
        x=sum(X[1:i])                   #compute the cumulative sum of the first i values of X
        values[i]=KVPair(i,x)           # define the KV pair
    end
    return values                       #return the array of KVPairs
end

## This function is the answer to Q2 Part 2 and therefore is also included in the notebook.
function intervalmembership(list::Nullable{LList},x::Float64) #The input has to be a Nullable{LList} and a Float64
    L=list
    k=get(L).data   #k is the key value pair at the top of the list (corresponding to the first interval)
    k2=k.value      #k2 is the upper interval border
    if (x < k2)     #if x is smaller than the interval border, it is in the interval, return the corresponding KVPair
        return(k)  
        else        #if the x is not smaller than the upper interval border, it has to be in one of the higher intervals 
        L=get(L).next #update the list to the next interval
        intervalmembership(L,x) #repeat the process (recursively)
        
    end
end

## This function is the answer to Q2 Part 3 and therefore is also influcded in the notebook.
function intervalmembership_tree(FT::Nullable{FTree},x::Float64) #the input needs to be of the type "Nullable{LList}", "Int64" 
    l=get(FT).left                            #let l be the left subtree
    r=get(FT).right                           #let r be the right subtree
    k=get(FT).data                            #let k be the stored KVPair
    if (isnull(l)==true && isnull(r)==true)   #if both subtrees are empty, we are in a leaf and found the interval
        return(k)                                             
        elseif (isnull(l) ==false && x<get(l).data.value) #if the leftsubtree is not empty and x is smaller than the key value stored there go left
            intervalmembership_tree(l,x)      #repeat the process with the left subtree
        elseif (isnull(r)==false)             # if the rightsubtree is not empty and we're not in one of the previous cases
            x=x-get(l).data.value             #update x to be x-key value of the left subtree  
            intervalmembership_tree(r,x)      #repeat the process with the right subtree
    end
end

# this function takes the desired number of KVPairs as an input and outputs two arrays of KVPairs, one with random numbers as values and one with partial sums of these random values as values. 
function create_list_sumlist(n)
    X = rand(rng, n)
    values = Array{KVPair}(n)
    sum_values= Array{KVPair}(n)
    for i in 1:n
        values[i] = KVPair(i,X[i])
        s=sum(X[1:i])
        sum_values[i]=KVPair(i,s)
    end
    return values,sum_values
end

## Functions Question 3


# This is the adapted code from Question 3.1
function particle_linear(N,D,T)
    L=10
    Nx = 201
    X = dx.*(-(Nx-1)/2:(Nx-1)/2)
    dx = 2.0*L/(Nx-1)
    Y =zeros(Int64,N)
    D = 1.0
    t=0.0

    #draw the rates from an exponential distribution
    Rates=zeros(2*N)
    Rates[1:N]=randexp(N)*D
    Rates[N+1:2N]=Rates[1:N]
    Rates=Rates.*(1/2(dx*dx))
    #calculate the total rate
    totalRate=sum(Rates)
    #scale the time 
    dt = 1.0/totalRate

    #build the list (needed to solve the interval membership problem)
    KV_Rates=Array{KVPair}(2*N)

    for i=1:2*N
        x=sum(Rates[1:i])
        KV_Rates[i]=KVPair(i,x)
    end
    Rates_list=buildLList(KV_Rates)

    #This is the main loop
    while t < T
       # Pick an event from the right range
        k = rand()*totalRate
        #solve the intervalmembership problem
        interval=intervalmembership(Rates_list,k)
        #find the corresponding interval key
          interval=interval.key
        #decide which way to hop and update the particle ID 
        if interval<=N
            hop = 1
            particleId = interval
        else
            hop = -1
            particleId=interval-N
        end
        Y[particleId]+=hop
        t+=dt
    end

    #Calculate the estimated density of particles
    P =zeros(Float64,length(X))
    for i in 1:length(Y)
        P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
    end
    return X,P
end

## adapted code tree

function particle_tree(N)
    L=10.0
    N=1000
    Nx = 201
    dx = 2.0*L/(Nx-1)
    X = dx.*(-(Nx-1)/2:(Nx-1)/2)
    Y =zeros(Int64,N)
    D = 1.0
    t=0.0

    #draw the rates from an exponential distribution
    Rates=zeros(2*N)
    Rates[1:N]=randexp(N)*D
    Rates[N+1:2N]=Rates[1:N]
    Rates=Rates.*(1/2(dx*dx))
    #calculate the total rate
    totalRate=sum(Rates)
    #scale the time 
    dt = 1.0/totalRate

    KV_Rates_tree=Array{KVPair}(2*N)

    for i=1:2*N
        x=Rates[i]
        KV_Rates_tree[i]=KVPair(i,x)
    end
    Tree = Nullable{FTree}(FTree(KVPair(0,0.0)))
    Tree=buildFTree(Tree, KV_Rates_tree)

    # particle=rand()*totalRate

    # intervalmembership(Rates_list,particle)


    T=1.0

    #This is the main loop
    while t < T
    #     # Pick an event
        k = rand()*totalRate
        interval=intervalmembership_tree(Tree,k)
          interval=interval.key
        if interval<=N
            hop = 1
            particleId = interval
        else
            hop = -1
            particleId=interval-N
        end
        Y[particleId]+=hop
        t+=dt
    end

    #Calculate the estimated density of particles
    P =zeros(Float64,length(X))
    for i in 1:length(Y)
        P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
    end
    return X,P
end



## This is the theoretical prediction of the particle density

function normal(x, D, t)
    return (exp(-sqrt(2/D*t)*abs(x))/sqrt(2D*t))
end


###

