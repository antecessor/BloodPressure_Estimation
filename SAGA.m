function [c,test,pos,cost]=SAGA(xtrain,ytrain,xtest,ytest)
%% Problem Definition

CostFunction=@(x) Cost(x,xtrain,ytrain,xtest,ytest);        % Cost Function

nVar=10;             % Number of Decision variables

VarSize=[1 nVar];   % Variables Martix Size

VarMin=-1;         % Variables Lower Bound
VarMax=1;         % Variables Upper Bound

if numel(VarMin)==1                 % If VarMin is Scalar
    VarMin=repmat(VarMin,VarSize);  % Convert VarMin to Vector
end

if numel(VarMax)==1                 % If VarMax is Scalar
    VarMax=repmat(VarMax,VarSize);  % Convert VarMax to Vector
end

%% GA Parameters

MaxIt=5;        % Maximum Number of Iterations

MaxSubIt=2;       % Maimum Number of Sub-iterations

T0=10;             % Initial Temp.

alpha=0.99;        % Temp. Reduction Rate

nPop=10;           % Population Size

pc=2;                   % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number fo Parents (Offsprings)

pm=1;                   % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

gamma=0.2;              % Crossover Inflation Rate

mu=0.1;                 % Mutation Rate

MutationMode='rand';    % Mutation Mode

eta=0.1;                    % Mutation Step Size Ratio
sigma=eta*(VarMax-VarMin);  % Mutation Step Size

%% Initialization

global NFE;
NFE=0;

% Create Empty Structure
empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Output=[];

% Create Structre Array to Save Population Data
pop=repmat(empty_individual,nPop,1);

% Initilize Population
for i=1:nPop
    % Create Random Solution (Position)
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Evaluate Solutions
    [pop(i).Cost,pop(i).Output]=CostFunction(pop(i).Position);
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution Ever Found
BestSol=pop(1);

% Create Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Create Array to Hold NFEs
nfe=zeros(MaxIt,1);

% Initialize Temp.
T=T0;


%% GA Main Loop

for it=1:MaxIt
    
    for subit=1:MaxSubIt

        % Perform Crossover
        popc=repmat(empty_individual,nc/2,2);
        for k=1:nc/2

            % Select First Parent
            i1=randi([1 nPop]);
            p1=pop(i1);

            % Select Second Parent
            i2=randi([1 nPop]);
            p2=pop(i2);

            % Perform Crossover
            [popc(k,1).Position, popc(k,2).Position]=...
                ArithmeticCrossover(p1.Position,p2.Position,gamma,VarMin,VarMax);

            % Evaluate Offsprings
            [popc(k,1).Cost,popc(k,1).Output]=CostFunction(popc(k,1).Position);
            [popc(k,2).Cost,popc(k,2).Output]=CostFunction(popc(k,2).Position);

        end
        popc=popc(:);

        % Perform Mutation
        popm=repmat(empty_individual,nm,1);
        for l=1:nm

            % Select Parent
            i=randi([1 nPop]);
            p=pop(i);

            % Perform Mutation
            popm(l).Position=...
                Mutate(p.Position,mu,MutationMode,sigma,VarMin,VarMax);

            % Evaluate Mutatnt
            [popm(l).Cost,popm(l).Output]=CostFunction(popm(l).Position);

        end
        
        % Merge Offsprings Population
        newpop=[popc
                popm];
        
        % Sort NEWPOP
        [~, SortOrder]=sort([newpop.Cost]);
        newpop=newpop(SortOrder);
        
        % Compare using SA Rule
        for i=1:nPop
            
            if newpop(i).Cost<=pop(i).Cost
                pop(i)=newpop(i);
                
            else
                DELTA=(newpop(i).Cost-pop(i).Cost)/pop(i).Cost;
                P=exp(-DELTA/T);
                if rand<=P
                    pop(i)=newpop(i);
                end
            end
        
            % Update Best Solution Ever Found
            if pop(i).Cost<=BestSol.Cost
                BestSol=pop(i);
            end
            
        end
        
    end
    
    % Store Best Cost
    BestCost(it)=BestSol.Cost;
    
    % Store NFE
    nfe(it)=NFE;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ...
          ': Best Cost = ' num2str(BestCost(it)) ...
          ', NFE = ' num2str(nfe(it))]);
    
    % Temp. Reduction
    T=alpha*T;
      
end

% %% Results
cost=BestSol.Cost;
c=BestSol.Output.c;
test=BestSol.Output.test;
pos=BestSol.Position;
% figure;
% semilogy(BestCost,'LineWidth',2);
% xlabel('Iteration');
% ylabel('Best Cost');
% 
% figure;
% semilogy(nfe,BestCost,'LineWidth',2);
% xlabel('NFE');
% ylabel('Best Cost');
