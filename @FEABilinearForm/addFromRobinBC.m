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

function addFromRobinBC(obj, BilinearFormSettings, varargin)

maxDerivOrder = 1;

relativeKnotVectors = CAGDBoundaryTopology.findRelativeKnotVectors(BilinearFormSettings.RobinConditions.boundaryType, BilinearFormSettings.RobinConditions.boundaryNumber, obj.CAGDDomain.Connectivities.numberOfParametricCoordinates);
knotPatches = 1:prod(obj.CAGDDomain.KnotVectors(relativeKnotVectors).numberOfKnotPatches);

BasisFunctionsSettings = bSplineBasisFunctionsEvaluationSettings.empty(1,0);
for index = 1:length(relativeKnotVectors)
    BasisFunctionsSettings(index) = bSplineBasisFunctionsEvaluationSettings('RepetitiveGivenInKnotPatches', BilinearFormSettings.RobinConditions.IntegrationRule(index).pointsInParentDomain, maxDerivOrder, 1:obj.CAGDDomain.KnotVectors(relativeKnotVectors(index)).numberOfKnotPatches, BilinearFormSettings.RobinConditions.IntegrationRule(index).parentDomain);
end

subFormPosition = length(obj.subFormData)+1;
obj.subFormData(subFormPosition).Settings = BilinearFormSettings;

topologyIndex = obj.CAGDDomain.requestBoundaryTopology(BilinearFormSettings.RobinConditions.boundaryType, BilinearFormSettings.RobinConditions.boundaryNumber, BasisFunctionsSettings);
topology = obj.CAGDDomain.BoundaryTopologies(topologyIndex);
obj.subFormData(subFormPosition).topologyType   = 'Boundary';

obj.subFormData(subFormPosition).topologyIndex  = topologyIndex;

if isempty(topology.parametric2PhysicalInverseJacobians); topology.evaluateAllDomainMappings; end
if isempty(topology.BasisFunctions.tensorBasisFunctions); topology.BasisFunctions.evaluateTensorProducts; end
[numOfFuns, numOfPoints, ~, numOfKnotPatches] = size(topology.BasisFunctions.tensorBasisFunctions);

weightsInParentDomain  = BilinearFormSettings.RobinConditions.IntegrationRule(1).weightsInParentDomain;
for parametricIndex = 2:length(BilinearFormSettings.RobinConditions.IntegrationRule)
    weightsInParentDomain = kron(BilinearFormSettings.RobinConditions.IntegrationRule(parametricIndex).weightsInParentDomain, weightsInParentDomain);
end
weightsInParentDomain   = reshape(weightsInParentDomain, numOfPoints, 1);
weightsInPhysicalDomain = repmat(weightsInParentDomain, 1, numOfKnotPatches).*topology.parent2PhysicalDetOfJacobians;

switch BilinearFormSettings.RobinConditions.domainOfDefinition
    case 'Parametric'
        switch length(BilinearFormSettings.RobinConditions.IntegrationRule)
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

for subFormIndex = 1:BilinearFormSettings.numberOfSubforms
    
    subFormTensorFieldIndices           = BilinearFormSettings.tensorFieldIndices{subFormIndex};
    subFormTensorFieldComponentIndices  = BilinearFormSettings.tensorFieldComponentIndices{subFormIndex};
    subFormFunctionDerivativesOrder     = BilinearFormSettings.functionDerivativesOrder{subFormIndex};
    subFormFunctionDerivativeComponents = BilinearFormSettings.functionDerivativeComponents{subFormIndex};
%     subFormConstitutiveLaw              = BilinearFormSettings.constitutiveLaw(subFormIndex);
    
    funs1 = [];
    componentsLocalDOF1 = [];
    for funIndex = 1:length(subFormFunctionDerivativesOrder{1})
        if subFormFunctionDerivativesOrder{1}(funIndex) == 1
            funs1 = cat(1, funs1, squeeze(topology.topologyGradients(:, subFormFunctionDerivativeComponents{1}(funIndex), :, :)));
        else funs1 = cat(1, funs1, squeeze(topology.BasisFunctions.tensorBasisFunctions(:, :, 1, :)));
        end
        componentsLocalDOF1 = cat(2, componentsLocalDOF1, obj.DOFData.componentsLocalDOF{subFormTensorFieldIndices{1}(funIndex)}(subFormTensorFieldComponentIndices{1}(funIndex)));
    end
    
    funs2 = [];
    componentsLocalDOF2 = [];
    for funIndex = 1:length(subFormFunctionDerivativesOrder{2})
        if subFormFunctionDerivativesOrder{2}(funIndex) == 1
            funs2 = cat(1, funs2, squeeze(topology.topologyGradients(:, subFormFunctionDerivativeComponents{2}(funIndex), :, :)));
        else funs2 = cat(1, funs2, squeeze(topology.BasisFunctions.tensorBasisFunctions(:, :, 1, :)));
        end
        componentsLocalDOF2 = cat(2, componentsLocalDOF2, obj.DOFData.componentsLocalDOF{subFormTensorFieldIndices{2}(funIndex)}(subFormTensorFieldComponentIndices{2}(funIndex)));
    end

    for knotPatchIndex = 1:numOfKnotPatches
        
        subFormValues = zeros(1, size(evaluationPoints, 1));
        switch BilinearFormSettings.RobinConditions.coordSystem
            case 'Global'
                for pointIndex = 1:size(evaluationPoints, 1)
                    points = num2cell(evaluationPoints(pointIndex, :, knotPatchIndex));
%                     direct = zeros(length(subFormTensorFieldComponentIndices), 1);
%                     for index = 1:length(subFormTensorFieldComponentIndices)
                        direct = BilinearFormSettings.RobinConditions.essentialFieldDirection{subFormTensorFieldComponentIndices{2}}(points{:});
%                     end
                    subFormValues(pointIndex) = direct*BilinearFormSettings.RobinConditions.essentialFieldFunction(points{:});
                end
                
            case 'Covariant'
                for pointIndex = 1:size(evaluationPoints, 1)
                    points = num2cell(evaluationPoints(pointIndex, :, knotPatchIndex));
                    direct = zeros(topology.ControlPoints.numberOfCoordinates, length(BilinearFormSettings.RobinConditions.direction));
                    for index = 1:length(BilinearFormSettings.RobinConditions.direction)
                        direct(:, index) = topology.parametric2PhysicalJacobians(index, :, pointIndex, knotPatchIndex)*BilinearFormSettings.RobinConditions.essentialFieldDirection{index}(points{:});
                    end
                    direct = sum(direct, 2);
                    subFormValues(pointIndex) = direct(subFormTensorFieldComponentIndices{2})*BilinearFormSettings.RobinConditions.essentialFieldFunction(points{:});
                end
                
            case 'Contravariant'
                for pointIndex = 1:size(evaluationPoints, 1)
                    points = num2cell(evaluationPoints(pointIndex, :, knotPatchIndex));
                    direct = zeros(topology.ControlPoints.numberOfCoordinates, length(BilinearFormSettings.RobinConditions.direction));
                    for index = 1:length(BilinearFormSettings.RobinConditions.direction)
                        direct(:, index) = topology.parametric2PhysicalInverseJacobians(index, :, pointIndex, knotPatchIndex)*BilinearFormSettings.RobinConditions.essentialFieldDirection{index}(points{:});
                    end
                    direct = sum(direct, 2);
                    subFormValues(pointIndex) = direct(subFormTensorFieldComponentIndices{2})*BilinearFormSettings.RobinConditions.essentialFieldFunction(points{:});
                end
                
        end
        
        knotPatchContribution = funs1(:, :, knotPatchIndex)...
            *(funs2(:, :, knotPatchIndex)'.*repmat(subFormValues'.*weightsInPhysicalDomain(:, knotPatchIndex), 1, numOfFuns*length(componentsLocalDOF2)));
        
        DOFMap1 = reshape(obj.DOFData.globalDOFNum(componentsLocalDOF1, topology.relativeControlPoints(topology.Connectivities.knotPatch2MultiParametricFunctions(knotPatchIndex, :))), [], 1);
        DOFMap2 = reshape(obj.DOFData.globalDOFNum(componentsLocalDOF2, topology.relativeControlPoints(topology.Connectivities.knotPatch2MultiParametricFunctions(knotPatchIndex, :))), [], 1);
        obj.values(DOFMap1, DOFMap2) = obj.values(DOFMap1, DOFMap2) + knotPatchContribution;
        
    end
    
end

end