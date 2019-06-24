% Matt Ryerkerk - Michigan State University - June 2019
%  
% This is an n-pt crossover where the crossover points match between both
% parents. This operator will always exchanged an equal number of
% metavariables, and is only intended to be used when a hidden- or static-
% metavariable representation is employed.
%
% inputs: (blank indicates the parameter is not used by this function)
%   parent1, parent2: The two parent solutions. 
%
% Outputs:
%   params, outputs: Unchanged by this function
%   child1, child2: The unevaluated children generated by this function.

function [params, outputs, child1, child2] = Crossover_nPt(params, outputs, parent1, parent2)

nPt = 2; % Number of crossover points to use
         
g1 = parent1.genome; 
g2 = parent2.genome;

if (size(g1, 1) ~= size(g2, 1))
  disp('WARNING: Crossover_nPt: Parents have different length genomes, this operator should only be used with parents of the same genome length')
end

L = size(g1,1); % It's expected that both parents are the same length

nPt = min([nPt, L]); % Doesn't make sense to use more crossover points than the length of either solution
pt = sort(randperm(L, nPt) - 1); % Crossover points in first parent

% Start with front segments
c1 = g1(1:pt(1),:);
c2 = g2(1:pt(1),:);

S = 1; % Will flip back and forth to determine which child gets metavariables from which parent
for i = 1:nPt-1 % For each resulting genotype segment
  if (S==0) % child 1 receives metavariables from parent 1, child 2 from parent 2. 
    c1 = [c1; g1(pt(i)+1:pt(i+1),:)];
    c2 = [c2; g2(pt(i)+1:pt(i+1),:)];
    S = 1;
  else % child 1 receives metavariables from parent 2, child 2 from parent 1
    c1 = [c1; g2(pt(i)+1:pt(i+1),:)];
    c2 = [c2; g1(pt(i)+1:pt(i+1),:)];
    S = 0;    
  end  
end

% End with tail segments
if (S == 0)
  c1 = [c1; g1(pt(end)+1:end,:)];
  c2 = [c2; g2(pt(end)+1:end,:)];
else  
  c1 = [c1; g2(pt(end)+1:end,:)];
  c2 = [c2; g1(pt(end)+1:end,:)];
end

% Create child individuals and compare to parents
[params, outputs, child1, child2] = SetChildrenCrossover(params, outputs, c1, c2, parent1, parent2);
