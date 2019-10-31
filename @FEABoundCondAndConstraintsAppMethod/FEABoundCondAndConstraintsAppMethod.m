%%  OOAnalysis Framework
%
%   Copyright 2014-2015 Evangelos D. Katsavrias, Athens, Greece
%
%   This file is part of the OOAnalysis Framework.
%
%   OOAnalysis Framework is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License version 3 as published by
%   the Free Software Foundation.
%
%   OOAnalysis Framework is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with OOAnalysis Framework.  If not, see <https://www.gnu.org/licenses/>.
%
%   Contact Info:
%   Evangelos D. Katsavrias
%   email/skype: vageng@gmail.com
% -----------------------------------------------------------------------

classdef FEABoundCondAndConstraintsAppMethod
    
    % ----- Methods for Dirichlet boundary conditions and constraints imposition ------
    % the overlapped control points are autoconstrained in all of these methods

    enumeration
        OnlyHomogeneousDirichletBC          (1)
        OnlyDirichletBC                     (2) % (unable to solve with sparse matrices, generally in worse condition matrices)
        LagrangeMultipliers                 (3) % (Not always accurate, ill-conditioning in certain occasions)
        PenaltyMethod                       (4)
        RowColumnEliminationCondensation    (5)
    end
    
    properties
        method
    end
    
    methods
        function obj = FEABoundCondAndConstraintsAppMethod(varargin)
            obj.method = varargin{1};
        end
    end
    
end


function SystemOfEquationsForSolution = constraints(AnalysisData,BasicPack,SystemOfEquations)

switch AnalysisData.boundCondAndConstrMethod
    
    case 1      % Lagrange Multipliers Method
        ConstraintsEquations=...
                     Constraints_Matrix(BasicPack.totalNumberOfDOFinSystem,...
                                        BasicPack.OverlappedControlPoints,...
                                        AnalysisData.BoundaryConditions.Dirichlet,...
                                        AnalysisData.Constraints);
        SystemOfEquationsForSolution=...
            Lagrange_Multipliers_ConstraintsMethod(SystemOfEquations.totalStiffnessMatrix,...
                                                   SystemOfEquations.totalForceVector,...
                                                   ConstraintsEquations.Aeq,...
                                                   ConstraintsEquations.Beq);
    case 2      % Penalty Method
        ConstraintsEquations=Constraints_Matrix(AnalysisData.BoundaryConditions.Dirichlet,...
                                                AnalysisData.Constraints,...
                                                BasicPack.totalNumberOfDOFinSystem,...
                                                BasicPack.OverlappedControlPoints);
        SystemOfEquationsForSolution=...
                        Penalty_ConstraintsMethod(SystemOfEquations.totalStiffnessMatrix,...
                                                  SystemOfEquations.totalForceVector,...
                                                  ConstraintsEquations.Aeq,...
                                                  ConstraintsEquations.Beq);
    case 3      % Row-Column Elimination and condensation of equal DOF
        SystemOfEquationsForSolution=...
             RowColumnEliminationAndCondensation(BasicPack.totalNumberOfDOFinSystem,...
                                                 BasicPack.OverlappedControlPoints,...
                                                 AnalysisData.BoundaryConditions.Dirichlet.OnDOF.dof,...
                                                 AnalysisData.BoundaryConditions.Dirichlet.OnDOF.value,...
                                                 SystemOfEquations.totalStiffnessMatrix,...
                                                 SystemOfEquations.totalForceVector);
    case 4      % Impose to the system only Dirichlet boundary conditions
        if AnalysisData.BoundaryConditions.Dirichlet.OnDOF.flag==1
            
            SystemOfEquationsForSolution=...
                OnlyDirichletBC(BasicPack.totalNumberOfDOFinSystem,...
                AnalysisData.BoundaryConditions.Dirichlet.OnDOF.dof,...
                AnalysisData.BoundaryConditions.Dirichlet.OnDOF.value,...
                SystemOfEquations.totalStiffnessMatrix,...
                SystemOfEquations.totalForceVector);
            
        end
    case 5      % Impose to the system only homogeneous Dirichlet boundary conditions
        SystemOfEquationsForSolution=...
            OnlyDirichletHomogeneous(AnalysisData.BoundaryConditions.Dirichlet.OnDOF.dof,...
                                     BasicPack.totalNumberOfDOFinSystem,...
                                     SystemOfEquations.totalStiffnessMatrix,...
                                     SystemOfEquations.totalForceVector);
        
end

end


function ConstraintsEquations = Constraints_Matrix(Dirichlet,Constraints, totalNumberOfDOFinSystem, OverlappedControlPoints)

identityMatrix=eye(totalNumberOfDOFinSystem,...
                   totalNumberOfDOFinSystem);
ConstraintsEquations.Aeq=[];
ConstraintsEquations.Beq=[];
% Formulating the matrix form of constraints A*u=b, for the method of
% Lagrange multipliers and the pentalty method

% Constructing the matrix form of the constraints with dirichlet b.c.
if Dirichlet.OnDOF.flag==1
    for i=1:length(Dirichlet.OnDOF.dof)
        ConstraintsEquations.Aeq=cat(1,ConstraintsEquations.Aeq,...
                                       identityMatrix(Dirichlet.OnDOF.dof(i),:));
    end
    ConstraintsEquations.Beq=Dirichlet.OnDOF.value;
end

% Constructing the matrix form of the constraints of the conjugate dof due
% to the overlaped control points
if OverlappedControlPoints.flag==1
    for i=1:size(OverlappedControlPoints.matrix,2)
        ConstraintsEquations.Aeq=cat(1,ConstraintsEquations.Aeq,...
                        identityMatrix(OverlappedControlPoints.matrix(1,i),:)-...
                        identityMatrix(OverlappedControlPoints.matrix(2,i),:));
        ConstraintsEquations.Beq=cat(1,ConstraintsEquations.Beq,0);
    end
end

% Constructing the matrix form of the multiparameteric constraints
% may be of the general form a1*ui+a2*uj+a3*uk+...=c
% [ui uj uk.... 1;a1 a2 a3....c]
if Constraints.flag==1
    numberOfConstraints=length(Constraints.coefficients,1);
    for i=1:numberOfConstraints
        constraintEquation=0;
        numberOfDOF=size(Constraints.coefficients{i},2)-1;
        for j=1:numberOfDOF
            constraintEquation=constraintEquation+...
                identityMatrix(Constraints.dof{i}(j),:)*...
                               Constraints.coefficients{i}(j);
        end
        ConstraintsEquations.Aeq=cat(1,ConstraintsEquations.Aeq,constraintEquation);
        ConstraintsEquations.Beq=cat(1,ConstraintsEquations.Beq,...
                                       Constraints.coefficients{i}(end));  % concatenate the rhs c value of the current constraint
    end
end

end


function SystemOfEquationsForSolution = Lagrange_Multipliers_ConstraintsMethod(totalStiffnessMatrix, totalForceVector, Aeq, Beq)

% Lagrange multipliers method
SystemOfEquationsForSolution.totalStiffnessMatrix=[totalStiffnessMatrix            Aeq';
                                                   Aeq   zeros(size(Aeq,1),size(Aeq,1))];

SystemOfEquationsForSolution.totalForceVector=[totalForceVector;
                                               Beq];

SystemOfEquationsForSolution.numberOfLagrangeMultipliers=length(Beq);

end


function SystemOfEquationsForSolution = Penalty_ConstraintsMethod(totalStiffnessMatrix, totalForceVector, Aeq, Beq)

maxx=max(max(totalStiffnessMatrix));  % Implementing the rule for optimal penalty weight
w=10^(log10(maxx)+8);                 % w=10^(log10(k(maxelement))+t/2), t is the accuracy of computations(number of significant digits)
W=w*eye(size(Aeq,1));

SystemOfEquationsForSolution.totalStiffnessMatrix=...
                                        totalStiffnessMatrix+Aeq'*W*Aeq;
SystemOfEquationsForSolution.totalForceVector=...
                                        totalForceVector+Aeq'*W*Beq;

end


function SystemOfEquationsForSolution = RowColumnEliminationAndCondensation(totalNumberOfDOFinSystem, OverlappedControlPoints, dof, value, totalStiffnessMatrix, totalForceVector)

% Classical, row-column elimination and condensation of equal dof

unconstrainedDOF=[];    % the unconstrained dof that will take a value from solver
identityMatrix=eye(totalNumberOfDOFinSystem,...
    totalNumberOfDOFinSystem);

% Constraints can be of the type
% ui=aj*uj+c (not programmed)
% ui=uj     (programmed for the conjugate dof of the overlapped control points)
% ui=0      (homogeneous dirichlet b.c.)
% ui=c      (non homogeneous dirichlet b.c.)
% u=T*u_n+RHSofConstraints    u_n is the condensed u vector

RHSofConstraints=zeros(totalNumberOfDOFinSystem,1);
RHSofConstraints(dof,1)=value;    % RHSofConstraints is the vector with the constants of the constraints
T=[];

if OverlappedControlPoints.flag==1
    
    for i=1:totalNumberOfDOFinSystem
        
        if i~=dof     % the dirichlet b.c. are imposed by eliminating the dof from the system and imposing a value in the RHSofConstraints vector
            if nnz(i==OverlappedControlPoints.matrix(1,:))>0&&nnz(i==OverlappedControlPoints.matrix(2,:))==0
                [j]=find(OverlappedControlPoints.matrix(1,:)==i);
                k=OverlappedControlPoints.matrix(2,j);
                T=cat(1,T,identityMatrix(i,:)+sum(identityMatrix(k,:),1));
                unconstrainedDOF=cat(1,unconstrainedDOF,i);
            elseif nnz(i==OverlappedControlPoints.matrix(2,:))==0
                T=cat(1,T,identityMatrix(i,:));    % importing the free dof
                unconstrainedDOF=cat(1,unconstrainedDOF,i); % identify the free dof
            end
        end

    end
    
else
    
    for i=1:totalNumberOfDOFinSystem
        if i~=dof     % the dirichlet b.c. are imposed by eliminating the dof from the system and imposing a value in the RHSofConstraints vector
            T=cat(1,T,identityMatrix(i,:));
            unconstrainedDOF=cat(1,unconstrainedDOF,i);
        end
    end
    
end

SystemOfEquationsForSolution.totalForceVector=T*(totalForceVector-totalStiffnessMatrix*RHSofConstraints);
SystemOfEquationsForSolution.totalStiffnessMatrix=T*totalStiffnessMatrix*T';
SystemOfEquationsForSolution.unconstrainedDOF=unconstrainedDOF;

end


%     case 3  % Classical, row-column elimination and condensation of equal dof
%
%         % Constraints can be of the type
%                              % ui=a*uj+c (not programmed)
%                              % ui=uj     (programmed for the conjugate dof of the overlapped control points)
%                              % ui=0      (homogeneous dirichlet b.c.)
%                              % ui=c      (non homogeneous dirichlet b.c.)
%         % u=T*u_n+RHSofConstraints    u_n is the condensed u vector
%
%         RHSofConstraints=zeros(totalNumberOfDOFinSystem,1);
%         RHSofConstraints(dof,1)=value;    % RHSofConstraints is the vector with the constants of the constraints
%         T=[];
%         if size(varargin,2)>0
%             for i=1:totalNumberOfDOFinSystem
%                 if ~isempty(overlappedControlPoints)
%                     if i~=dof     % the dirichlet b.c. are imposed by eliminating the dof from the system and imposing a value in the RHSofConstraints vector
%                         if nnz(i==overlappedControlPoints(1,:))>0&&nnz(i==overlappedControlPoints(2,:))==0
%                             [j]=find(overlappedControlPoints(1,:)==i);
%                             k=overlappedControlPoints(2,j);
%                             T=cat(1,T,identityMatrix(i,:)+sum(identityMatrix(k,:),1));
%                             unconstrainedDOF=cat(1,unconstrainedDOF,i);
%                         elseif nnz(i==overlappedControlPoints(2,:))==0
%                             T=cat(1,T,identityMatrix(i,:));    % importing the free dof
%                             unconstrainedDOF=cat(1,unconstrainedDOF,i); % identify the free dof
%                         end
%                     end
%                 else
%                     if i~=dof     % the dirichlet b.c. are imposed by eliminating the dof from the system and imposing a value in the RHSofConstraints vector
%                         T=cat(1,T,identityMatrix(i,:));
%                         unconstrainedDOF=cat(1,unconstrainedDOF,i);
%                     end
%                 end
%             end
%             SystemOfEquationsForSolution.totalForceVector=T*(totalForceVector-totalStiffnessMatrix*RHSofConstraints);
%             SystemOfEquationsForSolution.totalStiffnessMatrix=T*totalStiffnessMatrix*T';
%         end


function SystemOfEquationsForSolution = OnlyDirichletBC(totalNumberOfDOFinSystem, dof,value,totalStiffnessMatrix,totalForceVector)
        
        dirichletBC=zeros(totalNumberOfDOFinSystem,1);
        dirichletBC(dof,1)=value;
        totalForceVector=totalForceVector-totalStiffnessMatrix*dirichletBC;   % modify column using constrained value

        totalStiffnessMatrix(dof,:)=0;
        totalStiffnessMatrix(:,dof)=0;
        for i=1:length(dof)
            totalStiffnessMatrix(dof(i),dof(i))=1;
        end
        totalForceVector(dof)=value;

        SystemOfEquationsForSolution.totalStiffnessMatrix=totalStiffnessMatrix;
        SystemOfEquationsForSolution.totalForceVector=totalForceVector;
        
end


function SystemOfEquationsForSolution = OnlyDirichletHomogeneous(bcdof,sdof,kk,ff)

unconstrainedDOF=[];

bcsorted=sort(bcdof);
sdofflag=0;
if sdof>bcsorted(end)
    bcsorted=cat(1,bcsorted,sdof);
    sdofflag=1;
end
k=1;
for i=1:length(bcsorted)
    for j=k:bcsorted(i)-1
        unconstrainedDOF=cat(1,unconstrainedDOF,j);
    end
    k=bcsorted(i)+1;
end
if sdofflag
    unconstrainedDOF=cat(1,unconstrainedDOF,sdof);
end

SystemOfEquationsForSolution.totalStiffnessMatrix=kk(unconstrainedDOF,unconstrainedDOF);
SystemOfEquationsForSolution.totalForceVector=ff(unconstrainedDOF);
SystemOfEquationsForSolution.unconstrainedDOF=unconstrainedDOF;

end


function Subdomain = searchForOverlappedControlPoints(Subdomain)

matrix = [];
% this loop constructs the conjugate dof due to overlapped control points    
Subdomain.Topology.CAGD.controlPoints = reshape(permute(Subdomain.Topology.CAGD.controlPoints, [Subdomain.NumericalAnalysis.DOFData.dofCountingDirection Subdomain.Topology.CAGD.numberOfParametricCoordinates+1]), Subdomain.Topology.MeshData.totalNumberOfControlPoints, Subdomain.Topology.CAGD.numberOfCoordinates)';

for prescedingCPIndex = 1:Subdomain.Topology.MeshData.totalNumberOfControlPoints-1
    
    for followingCPIndex = prescedingCPIndex+1:Subdomain.Topology.MeshData.totalNumberOfControlPoints
        
        if Subdomain.Topology.CAGD.controlPoints(:, prescedingCPIndex) == Subdomain.Topology.CAGD.controlPoints(:, followingCPIndex)
            
            matrix = cat(2, matrix, [Subdomain.NumericalAnalysis.DOFData.globalDOFNum(prescedingCPIndex, :)
                                     Subdomain.NumericalAnalysis.DOFData.globalDOFNum(followingCPIndex, :)]);
                                 
        end
        
    end
    
end

Subdomain.Topology.CAGD.controlPoints = ipermute(reshape(Subdomain.Topology.CAGD.controlPoints', [Subdomain.Topology.CAGD.numberOfControlPoints(Subdomain.NumericalAnalysis.DOFData.dofCountingDirection) Subdomain.Topology.CAGD.numberOfCoordinates]), [Subdomain.NumericalAnalysis.DOFData.dofCountingDirection Subdomain.Topology.CAGD.numberOfParametricCoordinates+1]);

if ~isempty(matrix)
    Subdomain.NumericalAnalysis.OverlappedControlPoints.flag = 1;
    Subdomain.NumericalAnalysis.OverlappedControlPoints.matrix = matrix;
else
    Subdomain.NumericalAnalysis.OverlappedControlPoints.flag = 0;
end

end


function [Subdomain, Output] = DirichletDOFElimination(Subdomain, Output)

Subdomain.NumericalAnalysis.DOFData.dirichletDOF = removeMultiplicities(Subdomain.NumericalAnalysis.DOFData.dirichletDOF);

if ~isfield(Subdomain.NumericalAnalysis.DOFData, 'unconstrainedDOF')
    Subdomain.NumericalAnalysis.DOFData.unconstrainedDOF = [];
end

for i = 1:Subdomain.NumericalAnalysis.DOFData.totalNumberOfDOFinSystem
    if i~=Subdomain.NumericalAnalysis.DOFData.dirichletDOF
        Subdomain.NumericalAnalysis.DOFData.unconstrainedDOF = cat(1, Subdomain.NumericalAnalysis.DOFData.unconstrainedDOF, i); 
    end
end

for matrixIndex = 1:length(Subdomain.NumericalAnalysis.Matrices.store)
    Subdomain.NumericalAnalysis.Matrices.store{matrixIndex} = Subdomain.NumericalAnalysis.Matrices.store{matrixIndex}(Subdomain.NumericalAnalysis.DOFData.unconstrainedDOF, Subdomain.NumericalAnalysis.DOFData.unconstrainedDOF);    
end

Subdomain.NumericalAnalysis.Matrices.globalRHSVector = Subdomain.NumericalAnalysis.Matrices.globalRHSVector(Subdomain.NumericalAnalysis.DOFData.unconstrainedDOF, 1);

end


function Input = DirichletHomogeneousDOF(Input)

constrainedDOF=[];

for constraint = 1:length(Input.Problem.BoundaryConditions.Dirichlet.dofConstraints)
    
    for DOF = 1:length(Input.Problem.BoundaryConditions.Dirichlet.dofConstraints{constraint}{2})
        
       constrainedDOF=cat(1, constrainedDOF, ...
          Input.AnalysisData.DOFData.nodalDOFindexMapping(Input.Problem.BoundaryConditions.Dirichlet.dofConstraints{constraint}{1}, ...
          Input.Problem.BoundaryConditions.Dirichlet.dofConstraints{constraint}{2}(DOF)));
       
    end
    
end
constraintedVector = zeros(size(constrainedDOF, 1), 1);

unconstrainedDOF=[];

for i = 1:Input.AnalysisData.DOFData.totalNumberOfDOF
    
    if i~=constrainedDOF
        
        unconstrainedDOF = cat(1, unconstrainedDOF, i);
        
    end
    
end

Input.AnalysisData.DOFData.constraintedDOF = constrainedDOF;
Input.AnalysisData.DOFData.unconstraintedDOF = unconstrainedDOF;
Input.AnalysisData.DOFData.constraintedVector = constraintedVector;

end
