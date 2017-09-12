% Homework 1. Due before class on 9/5/17

%% Problem 1 - addition with strings

% Fill in the blank space in this section with code that will add 
% the two numbers regardless of variable type. Hint see the matlab
% functions ischar, isnumeric, and str2num. 

%your code should work no matter which of these lines is uncommented. 
x = 3; y = 5; % integers
%x = '3'; y= '5'; %strings
% x = 3; y = '5'; %mixed

%your code goes here

if isnumeric(x) == 1 & isnumeric(y) == 1
   disp(x+y);
elseif ischar(x) == 1 & ischar(y) == 1
    disp(str2num(x) + str2num(y));
elseif isnumeric(x) == 1 & ischar(y) == 1
    disp(x+str2num(y));
else ischar(x) == 1 & isnumeric(y) == 1
    disp(str2num(x)+y);
end
    
%output your answer
x = 3; y =5;
     8
x='3'; y='5';
     8
x = 3; y = '5';
     8
%% Problem 2 - our first real biology problem. Open reading frames and nested loops.

%part 1: write a piece of code that creates a random DNA sequence of length
% N (i.e. consisting of the letters ATGC) where we will start with N=500 base pairs (b.p.).
% store the output in a variable
% called rand_seq. Hint: the function randi may be useful. 
% Even if you have access to the bioinformatics toolbox, 
% do not use the builtin function randseq for this part. 

N = 500; % define sequence length
DNAbases = randi(4,1,N);
x=1;
while x < N+1
    if DNAbases(x)==1;
        rand_seq(1,x) = ['A'];
    elseif DNAbases(x)==2;
        rand_seq(1,x) = ['T'];
    elseif DNAbases(x)==3;
        rand_seq(1,x) = ['G'];
    elseif DNAbases(x)==4;
        rand_seq(1,x) = ['C'];
    end
    x=x+1;
end

%part 2: open reading frames (ORFs) are pieces of DNA that can be
% transcribed and translated. They start with a start codon (ATG) and end with a
% stop codon (TAA, TGA, or TAG). Write a piece of code that finds the longest ORF 
% in your seqeunce rand_seq. Hint: see the function strfind.

start_codon = sort(strfind(rand_seq, 'ATG')); % five start codons
stop_codonTAA = sort(strfind(rand_seq, 'TAA')); % six stop codons
stop_codonTGA = sort(strfind(rand_seq, 'TGA')); % fourteen stop codons
stop_codonTAG = sort(strfind(rand_seq, 'TAG')); % nine stop codons

%Make stop codon vectors same length (add 78s to attain 0s after loop)
stop_codonTAA = [stop_codonTAA (ones(1,8)*74)];
stop_codonTAG = [stop_codonTAG (ones(1,5)*74)];

%Find most upstream start codon(this codon will start longest ORF)
start_codon = start_codon(1); 

%Within loop add 2 to stop codons to account for last two nucleotides of
%stop codon (initially excluded because strfind looks for indeces)
for ii=1:14
    disstartTAA(ii) = (stop_codonTAA(ii)+2)-start_codon;
    disstartTGA(ii) = (stop_codonTGA(ii)+2)-start_codon;
    disstartTAG(ii) = (stop_codonTAG(ii)+2)-start_codon;
end

% Use a loop to find only multiples of 3 in resulting vectors; anything
% that isn't a multiple of 3 is made a 0
for ii=1:14
    if mod((disstartTAA(ii)./3),1) ~= 0
        disstartTAA(ii)=0
    end
    if mod((disstartTGA(ii)./3),1) ~= 0
        disstartTGA(ii)=0
    end
    if mod((disstartTAG(ii)./3),1) ~= 0
        disstartTAG(ii)=0
    end
end

disstartTAA = max(disstartTAA); %MAX=258
disstartTGA = max(disstartTGA); %MAX=396
disstartTAG = max(disstartTAG); %MAX=402

% The longest ORF in rand_seq is thus 402 base pairs long; it begins with a
% start codon at position 76 and ends at the last nucleotide of stop codon
% TAG at position 478

%part 3: copy your code in parts 1 and 2 but place it inside a loop that
% runs 1000 times. Use this to determine the probability
% that an sequence of length 500 has an ORF of greater than 50 b.p.

%N.B. This code was modified slightly from code in parts 1 and 2 to apply
%more generally to any randomly generated DNA sequence

N = 500;
rand_seq_mat = zeros(1000,500);
for ii=1:1000
    DNAbases = randi(4,1,N);
    x=1;
    while x < N+1
        if DNAbases(x)==1;
            rand_seq(1,x) = ['A'];
        elseif DNAbases(x)==2;
            rand_seq(1,x) = ['T'];
        elseif DNAbases(x)==3;
            rand_seq(1,x) = ['G'];
        elseif DNAbases(x)==4;
            rand_seq(1,x) = ['C'];
        end
        x=x+1;
    end
    rand_seq_mat(ii,:)=rand_seq;
end

for jj=1:1000
    start_codon = sort(strfind(rand_seq_mat(ii,:), 'ATG')); 
    stop_codonTAA = sort(strfind(rand_seq_mat(ii,:), 'TAA')); 
    stop_codonTGA = sort(strfind(rand_seq_mat(ii,:), 'TGA')); 
    stop_codonTAG = sort(strfind(rand_seq_mat(ii,:), 'TAG')); 

    start_codon = start_codon(1);

    if length(stop_codonTAA)>length(stop_codonTGA) & length(stop_codonTAA)>length(stop_codonTAG)
       longest=length(stop_codonTAA);
    elseif length(stop_codonTGA)>length(stop_codonTAG)
        longest=length(stop_codonTGA);
    else longest=length(stop_codonTAG)
    end


    if longest==length(stop_codonTAA)
        stop_codonTGA = [stop_codonTGA (ones(1,(longest-length(stop_codonTGA)))*(start_codon-2))];
        stop_codonTAG = [stop_codonTAG (ones(1,(longest-length(stop_codonTAG)))*(start_codon-2))];
    elseif longest==length(stop_codonTGA)
        stop_codonTAA = [stop_codonTAA (ones(1,(longest-length(stop_codonTAA)))*(start_codon-2))];
        stop_codonTAG = [stop_codonTAG (ones(1,(longest-length(stop_codonTAG)))*(start_codon-2))];
    else stop_codonTAA = [stop_codonTAA (ones(1,(longest-length(stop_codonTAA)))*(start_codon-2))];
         stop_codonTGA = [stop_codonTGA (ones(1,(longest-length(stop_codonTGA)))*(start_codon-2))];
    end 

    for ii=1:longest
        disstartTAA(ii) = (stop_codonTAA(ii)+2)-start_codon;
        disstartTGA(ii) = (stop_codonTGA(ii)+2)-start_codon;
        disstartTAG(ii) = (stop_codonTAG(ii)+2)-start_codon;
    end

    for ii=1:longest
        if mod((disstartTAA(ii)./3),1) ~= 0
            disstartTAA(ii)=0;
        end
        if mod((disstartTGA(ii)./3),1) ~= 0
            disstartTGA(ii)=0;
        end
        if mod((disstartTAG(ii)./3),1) ~= 0
            disstartTAG(ii)=0;
        end
    end
    disstartTAA = max(disstartTAA);
    disstartTGA = max(disstartTGA); 
    disstartTAG = max(disstartTAG); 

    if disstartTAA>disstartTGA & disstartTAA>disstartTAG
        ORFanalysis(jj,1)=disstartTAA;
    elseif disstartTGA>disstartTAG 
        ORFanalysis(jj,1)=disstartTGA;
    else ORFanalysis(jj,1)=disstartTAG;
    end
    ORFanalysis;
end

for ii=1:1000
    ORFgreater50(ii,1)=ORFanalysis(ii,1)>50;
end

ORFprob=sum(ORFgreater50)/(1000); 
%ORFprob=1 meaning that for a sequence length of 500 b.p., the probability
%the sequence has an ORF > 50 b.p. is 100%
        
%part 4: copy your code from part 3 but put it inside yet another loop,
% this time over the sequence length N. Plot the probability of having an
% ORF > 50 b.p. as a funciton of the sequence length. 

for N = 1:500
    M=N
    rand_seq_mat = zeros(1000,500);
    for ii=1:1000
        DNAbases = randi(4,1,M);
        x=1;
        while x < M+1
            if DNAbases(x)==1;
                rand_seq(1,x) = ['A'];
            elseif DNAbases(x)==2;
                rand_seq(1,x) = ['T'];
            elseif DNAbases(x)==3;
                rand_seq(1,x) = ['G'];
            elseif DNAbases(x)==4;
                rand_seq(1,x) = ['C'];
            end
            x=x+1;
        end
        rand_seq_mat(ii,:)=rand_seq;
    end

    for jj=1:1000
        start_codon = sort(strfind(rand_seq_mat(ii,:), 'ATG')); 
        stop_codonTAA = sort(strfind(rand_seq_mat(ii,:), 'TAA')); 
        stop_codonTGA = sort(strfind(rand_seq_mat(ii,:), 'TGA')); 
        stop_codonTAG = sort(strfind(rand_seq_mat(ii,:), 'TAG')); 

        start_codon = start_codon(1);

        if length(stop_codonTAA)>length(stop_codonTGA) & length(stop_codonTAA)>length(stop_codonTAG)
           longest=length(stop_codonTAA);
        elseif length(stop_codonTGA)>length(stop_codonTAG)
            longest=length(stop_codonTGA);
        else longest=length(stop_codonTAG)
        end


        if longest==length(stop_codonTAA)
            stop_codonTGA = [stop_codonTGA (ones(1,(longest-length(stop_codonTGA)))*(start_codon-2))];
            stop_codonTAG = [stop_codonTAG (ones(1,(longest-length(stop_codonTAG)))*(start_codon-2))];
        elseif longest==length(stop_codonTGA)
            stop_codonTAA = [stop_codonTAA (ones(1,(longest-length(stop_codonTAA)))*(start_codon-2))];
            stop_codonTAG = [stop_codonTAG (ones(1,(longest-length(stop_codonTAG)))*(start_codon-2))];
        else stop_codonTAA = [stop_codonTAA (ones(1,(longest-length(stop_codonTAA)))*(start_codon-2))];
             stop_codonTGA = [stop_codonTGA (ones(1,(longest-length(stop_codonTGA)))*(start_codon-2))];
        end 

        for ii=1:longest
            disstartTAA(ii) = (stop_codonTAA(ii)+2)-start_codon;
            disstartTGA(ii) = (stop_codonTGA(ii)+2)-start_codon;
            disstartTAG(ii) = (stop_codonTAG(ii)+2)-start_codon;
        end

        for ii=1:longest
            if mod((disstartTAA(ii)./3),1) ~= 0
                disstartTAA(ii)=0;
            end
            if mod((disstartTGA(ii)./3),1) ~= 0
                disstartTGA(ii)=0;
            end
            if mod((disstartTAG(ii)./3),1) ~= 0
                disstartTAG(ii)=0;
            end
        end
        disstartTAA = max(disstartTAA);
        disstartTGA = max(disstartTGA); 
        disstartTAG = max(disstartTAG); 

        if disstartTAA>disstartTGA & disstartTAA>disstartTAG
            ORFanalysis(jj,1)=disstartTAA;
        elseif disstartTGA>disstartTAG 
            ORFanalysis(jj,1)=disstartTGA;
        else ORFanalysis(jj,1)=disstartTAG;
        end
        ORFanalysis;
    end

    for ii=1:1000
        ORFgreater50(ii,1)=ORFanalysis(ii,1)>50;
    end

    ORFprob=sum(ORFgreater50)/(1000); 
    ORFprobN(M,1)=ORFprob;
end

plot(ORFprobN, N);

%part 5: Make sure your results from part 4 are sensible. What features
% must this curve have (hint: what should be the value when N is small or when
% N is very large? how should the curve change in between?) Make sure your
% plot looks like this. 

%% problem 3 data input/output and simple analysis

%The file qPCRdata.txt is an actual file that comes from a Roche
%LightCycler qPCR machine. The important columns are the Cp which tells
%you the cycle of amplification and the position which tells you the well
%from the 96 well plate. Each column of the plate has a different gene and
%each row has a different condition. Each gene is done in triplicates so
%columns 1-3 are the same gene, columns 4-6 the same, etc.
%so A1-A3 are gene 1 condition 1, B1-B3 gene 1 condition 2, A4-A6 gene 2
%condition 1, B4-B6 gene2 condition 2 etc. 

% part1: write code to read the Cp data from this file into a vector. You can ignore the last two
% rows with positions beginning with G and H as there were no samples here. 

fid=fopen('qPCRdata.txt', 'r');
formatSpec = '%*s%*s%s%*s%f%*s%*s%*s[^\n]';
n_rows = 72;
Cp_data = textscan(fid, formatSpec, 72,'Delimiter', '\t', 'HeaderLines', 2);
cpvector = cell2mat(Cp_data(1,2));


% Part 2: transform this vector into an array representing the layout of
% the plate. e.g. a 6 row, 12 column array should that data(1,1) = Cp from
% A1, data(1,2) = Cp from A2, data(2,1) = Cp from B1 etc. 

plate=zeros(6,12);
y=1;
z=12;
for ii = 1:6
    plate(ii,:) = cpvector(y:z);
    y=y+12;
    z=z+12;
end


% Part 3. The 4th gene in columns 10 - 12 is known as a normalization gene.
% That is, it's should not change between conditions and it is used to normalize 
% the expression values for the others. For the other three
% genes, compute their normalized expression in all  conditions, normalized to condition 1. 
% In other words, the fold change between these conditions and condition 1. The
% formula for this is 2^[Cp0 - CpX - (CpN0 - CpNX)] where Cp0 is the Cp for
% the gene in the 1st condition, CpX is the value of Cp in condition X and
% CpN0 and CpNX are the same quantitites for the normalization gene.
% Plot this data in an appropriate way. 

norm_express = zeros(6,3);
gene1Cp0 = mean(plate(1,1:3));
gene2Cp0 = mean(plate(1,4:6));
gene3Cp0 = mean(plate(1,7:9));
CpN0 = mean(plate(1,10:12));
% Six different conditions
for ii=1:6 
    norm_express(ii,1) = 2^(gene1Cp0-mean(plate(ii,1:3))-CpN0-mean(plate(ii,10:12)));
    norm_express(ii,2) = 2^(gene2Cp0-mean(plate(ii,4:6))-CpN0-mean(plate(ii,10:12)));
    norm_express(ii,3) = 2^(gene1Cp0-mean(plate(ii,7:9))-CpN0-mean(plate(ii,10:12)));
end

%Plot
plot(1:18, [norm_express(1,:) norm_express(2,:) norm_express(3,:) norm_express(4,:) norm_express(5,:) norm_express(6,:)]);
%% Challenge problems that extend the above (optional)

% 1. Write a solution to Problem 2 part 2 that doesn't use any loops at
% all. Hint: start by using the built in function bsxfun to make a matrix of all distances
% between start and stop codons. 

% 2. Problem 2, part 4. Use Matlab to compute the exact solution to this
% problem and compare your answer to what you got previously by testing
% many sequences. Plot both on the same set of axes. Hint: to get started 
% think about the following:
% A. How many sequences of length N are there?
% B. How many ways of making an ORF of length N_ORF are there?
% C. For each N_ORF how many ways of position this reading frame in a
% sequence of length N are there?

% 3. Problem 3. Assume that the error in each Cp is the standard deviation
% of the three measurements. Add a section to your code that propogates this
% uncertainty to the final results. Add error bars to your plot. (on
% propagation of error, see, for example:
% https://en.wikipedia.org/wiki/Propagation_of_uncertainty


