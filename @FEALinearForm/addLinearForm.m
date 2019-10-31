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

function addLinearForm(obj, LinearFormSettings, varargin)

maxDerivOrder = 1;
for index = 1:LinearFormSettings.numberOfSubforms
    maxDerivOrder = max([maxDerivOrder LinearFormSettings.functionDerivativesOrder{index}]);
end

if isa(LinearFormSettings.DomainConditions, 'InteriorConditions')
    relativeKnotVectors = 1:obj.CAGDDomain.Connectivities.numberOfParametricCoordinates;
    knotPatches = 1:obj.CAGDDomain.Connectivities.numberOfKnotPatches;

elseif isa(LinearFormSettings.DomainConditions, 'BoundaryConditions')
    relativeKnotVectors = CAGDBoundaryTopology.findRelativeKnotVectors(LinearFormSettings.DomainConditions.boundaryType, LinearFormSettings.DomainConditions.boundaryNumber, obj.CAGDDomain.Connectivities.numberOfParametricCoordinates);
    knotPatches = 1:prod(obj.CAGDDomain.KnotVectors(relativeKnotVectors).numberOfKnotPatches);

    switch LinearFormSettings.DomainConditions.boundaryType
        case 'FaceBoundary'; numberOfParametricCoordinates = 2;
        case 'EdgeBoundary'; numberOfParametricCoordinates = 1;
        case 'VertexBoundary'; numberOfParametricCoordinates = 0;
    end
    
end

% firstLeftKnotSpan   = find(obj.CAGDDomain.BoundaryTopology(boundaryNumber).KnotVector.knotsWithoutMultiplicities>boundaryCondition.domainInterval(1), 1, 'first')-1;
% LastLeftKnotSpan    = find(obj.CAGDDomain.BoundaryTopology(boundaryNumber).KnotVector.knotsWithoutMultiplicities<boundaryCondition.domainInterval(2), 1, 'last');
% 
% knotPatches = (firstLeftKnotSpan:LastLeftKnotSpan);

BasisFunctionsSettings = bSplineBasisFunctionsEvaluationSettings.empty(1,0);
for index = 1:length(relativeKnotVectors)
    BasisFunctionsSettings(index) = bSplineBasisFunctionsEvaluationSettings('RepetitiveGivenInKnotPatches', LinearFormSettings.numericalIntegration(index).pointsInParentDomain, maxDerivOrder, 1:obj.CAGDDomain.KnotVectors(relativeKnotVectors(index)).numberOfKnotPatches, LinearFormSettings.numericalIntegration(index).parentDomain);
end

subFormPosition = length(obj.subFormData)+1;
obj.subFormData(subFormPosition).Settings = LinearFormSettings;

if isa(LinearFormSettings.DomainConditions, 'InteriorConditions')
     topologyIndex = obj.CAGDDomain.requestClosureTopology(BasisFunctionsSettings);
     topology = obj.CAGDDomain.ClosureTopologies(topologyIndex);
     obj.subFormData(subFormPosition).topologyType   = 'Closure';

else
    topologyIndex = obj.CAGDDomain.requestBoundaryTopology(LinearFormSettings.DomainConditions.boundaryType, LinearFormSettings.DomainConditions.boundaryNumber, BasisFunctionsSettings);
    topology = obj.CAGDDomain.BoundaryTopologies(topologyIndex);
    obj.subFormData(subFormPosition).topologyType   = 'Boundary';

end
obj.subFormData(subFormPosition).topologyIndex  = topologyIndex;

if isempty(topology.parametric2PhysicalInverseJacobians); topology.evaluateAllDomainMappings; end
if isempty(topology.BasisFunctions.tensorBasisFunctions); topology.BasisFunctions.evaluateTensorProducts; end
[numOfFuns, numOfPoints, ~, numOfKnotPatches] = size(topology.BasisFunctions.tensorBasisFunctions);

weightsInParentDomain  = LinearFormSettings.numericalIntegration(1).weightsInParentDomain;
for parametricIndex = 2:length(LinearFormSettings.numericalIntegration)
    weightsInParentDomain = kron(LinearFormSettings.numericalIntegration(parametricIndex).weightsInParentDomain, weightsInParentDomain);
end
weightsInParentDomain   = reshape(weightsInParentDomain, numOfPoints, 1);
weightsInPhysicalDomain = repmat(weightsInParentDomain, 1, numOfKnotPatches).*topology.parent2PhysicalDetOfJacobians;

switch LinearFormSettings.DomainConditions.domainOfDefinition
    case 'Parametric'
        switch length(LinearFormSettings.numericalIntegration)
            case 1
                evaluationPoints = permute(shiftdim(topology.BasisFunctions.MonoParametricBasisFunctions.evaluationPoints, -1), [2 1 3]);
            case 2
                evaluationPoints = zeros(numOfPoints, 2, numOfKnotPatches);
                for knotPatchIndex = knotPatches
                    [A, B] = meshgrid(topology.BasisFunctions.MonoParametricBasisFunctions(1).evaluationPoints(:, knotPatchIndex), topology.BasisFunctions.MonoParametricBasisFunctions(2).evaluationPoints(:, knotPatchIndex));
                    evaluationPoints(:, :, knotPatchIndex) = [B(:), A(:)];
                end
            case 3
                evaluationPoints = zeros(numOfPoints, 3, numOfKnotPatches);
                for knotPatchIndex = knotPatches
                    [A, B, C] = meshgrid(topology.BasisFunctions.MonoParametricBasisFunctions(1).evaluationPoints(:, knotPatchIndex), topology.BasisFunctions.MonoParametricBasisFunctions(2).evaluationPoints(:, knotPatchIndex), topology.BasisFunctions.MonoParametricBasisFunctions(3).evaluationPoints(:, knotPatchIndex));
                    evaluationPoints(:, knotPatchIndex) = [C(:), B(:), A(:)];
                end
        end
        
    case 'Physical'
        evaluationPoints = topology.pointsInPhysicalCoordinates;
        
end

if isempty(obj.DOFData.mapOfDOFLocal2Global); obj.DOFData.constructLocalElementalDOF2GlobalDOF('EachComponent'); end

if maxDerivOrder
    if isempty(topology.topologyGradients); topology.evaluateTopologyGradients; end
end

for subFormIndex = 1:LinearFormSettings.numberOfSubforms
    
    subFormTensorFieldIndices           = LinearFormSettings.tensorFieldIndices{subFormIndex};
    subFormTensorFieldComponentIndices  = LinearFormSettings.tensorFieldComponentIndices{subFormIndex};
    subFormFunctionDerivativesOrder     = LinearFormSettings.functionDerivativesOrder{subFormIndex};
    subFormFunctionDerivativeComponents = LinearFormSettings.functionDerivativeComponents{subFormIndex};
    
    funs1 = [];
    componentsLocalDOF1 = [];
    for funIndex = 1:length(subFormTensorFieldComponentIndices)
        if subFormFunctionDerivativesOrder == 1
             funs1 = cat(1, funs1, squeeze(topology.topologyGradients(:, subFormFunctionDerivativeComponents(funIndex), :, :)));
        else funs1 = cat(1, funs1, squeeze(topology.BasisFunctions.tensorBasisFunctions(:, :, 1, :)));
        end
        componentsLocalDOF1 = cat(2, componentsLocalDOF1, obj.DOFData.componentsLocalDOF{subFormTensorFieldIndices(funIndex)}(subFormTensorFieldComponentIndices(funIndex)));
    end
    
    for knotPatchIndex = 1:numOfKnotPatches

        subFormValues = zeros(length(LinearFormSettings.DomainConditions(subFormIndex).direction), size(evaluationPoints, 1));
        switch LinearFormSettings.DomainConditions.coordSystem
            case 'Global'
                for pointIndex = 1:size(evaluationPoints, 1)
                    points = num2cell(evaluationPoints(pointIndex, :, knotPatchIndex));
                    direct = zeros(length(subFormTensorFieldComponentIndices), 1);
                    for index = 1:length(subFormTensorFieldComponentIndices)
                        direct(index) = LinearFormSettings.DomainConditions(subFormIndex).direction{index}(points{:});
                    end
                    subFormValues(:, pointIndex) = direct*LinearFormSettings.DomainConditions(subFormIndex).fieldFunction(points{:});
                end
                
            case 'Covariant'
                for pointIndex = 1:size(evaluationPoints, 1)
                    points = num2cell(evaluationPoints(pointIndex, :, knotPatchIndex));
                    direct = zeros(topology.ControlPoints.numberOfCoordinates, length(LinearFormSettings.DomainConditions(subFormIndex).direction));
                    for index = 1:length(LinearFormSettings.DomainConditions(subFormIndex).direction)
                        direct(:, index) = topology.parametric2PhysicalJacobians(index, :, pointIndex, knotPatchIndex)*LinearFormSettings.DomainConditions(subFormIndex).direction{index}(points{:});
                    end
                    direct = sum(direct, 2);
                    subFormValues(:, pointIndex) = direct*LinearFormSettings.DomainConditions(subFormIndex).fieldFunction(points{:});
                end
                
            case 'Contravariant'
                for pointIndex = 1:size(evaluationPoints, 1)
                    points = num2cell(evaluationPoints(pointIndex, :, knotPatchIndex));
                    direct = zeros(topology.ControlPoints.numberOfCoordinates, length(LinearFormSettings.DomainConditions(subFormIndex).direction));
                    for index = 1:length(LinearFormSettings.DomainConditions(subFormIndex).direction)
                        direct(:, index) = topology.parametric2PhysicalInverseJacobians(index, :, pointIndex, knotPatchIndex)*LinearFormSettings.DomainConditions(subFormIndex).direction{index}(points{:});
                    end
                    direct = sum(direct, 2);
                    subFormValues(:, pointIndex) = direct*LinearFormSettings.DomainConditions(subFormIndex).fieldFunction(points{:});
                end
                
        end

        knotPatchContribution = zeros(numOfFuns, length(subFormTensorFieldComponentIndices));
        for index = 1:length(subFormTensorFieldComponentIndices)
            knotPatchContribution(:, index) = funs1((1:numOfFuns)+(index-1)*numOfFuns, :, knotPatchIndex)*(subFormValues(index, :)'.*weightsInPhysicalDomain(:, knotPatchIndex));
        end
        knotPatchContribution = reshape(knotPatchContribution', [], 1);
        
        DOFMap1 = reshape(obj.DOFData.globalDOFNum(componentsLocalDOF1, topology.relativeControlPoints(topology.Connectivities.knotPatch2MultiParametricFunctions(knotPatchIndex, :))), [], 1);
        if isa(LinearFormSettings.DomainConditions, 'BoundaryConditions')
            if strcmp(LinearFormSettings.DomainConditions.boundaryConditionType, 'Dirichlet')
                obj.values = obj.values + LinearFormSettings.DomainConditions.relativeBilinearForm.values(:, DOFMap1)*knotPatchContribution;
                LinearFormSettings.DomainConditions.relativeConstraintDOF = cat(1, LinearFormSettings.DomainConditions.relativeConstraintDOF, DOFMap1);

            elseif strcmp(LinearFormSettings.DomainConditions.boundaryConditionType, 'HomogeneousDirichlet')
                LinearFormSettings.DomainConditions.relativeConstraintDOF = cat(1, LinearFormSettings.DomainConditions.relativeConstraintDOF, DOFMap1);

            else
                obj.values(DOFMap1) = obj.values(DOFMap1) + knotPatchContribution;

            end

        else
            obj.values(DOFMap1) = obj.values(DOFMap1) + knotPatchContribution;

        end
        
    end
    
end

end