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

function addBilinearForm(obj, BilinearFormSettings, varargin)

% if nargin > 2
%     knotPatches = varargin{1};
%     if isempty(knotPatches); knotPatches = obj.CAGDDomain.Connectivities.numberOfKnotPatches; end
% else knotPatches = obj.CAGDDomain.Connectivities.numberOfKnotPatches;
% end

maxDerivOrder = 1;
for index = 1:BilinearFormSettings.numberOfSubforms; maxDerivOrder = max([maxDerivOrder cell2mat(BilinearFormSettings.functionDerivativesOrder{index})]); end
BasisFunctionsSettings = bSplineBasisFunctionsEvaluationSettings.empty(1,0);
for index = 1:obj.CAGDDomain.GeneralInfo.totalNumberOfParametricCoordinates
    BasisFunctionsSettings(index) = bSplineBasisFunctionsEvaluationSettings('RepetitiveGivenInKnotPatches', BilinearFormSettings.numericalIntegration(index).pointsInParentDomain, maxDerivOrder, 1:obj.CAGDDomain.KnotVectors(index).numberOfKnotPatches, BilinearFormSettings.numericalIntegration(index).parentDomain);
end

closureTopologyIndex = obj.CAGDDomain.requestClosureTopology(BasisFunctionsSettings);

subFormPosition = length(obj.subFormData)+1;
obj.subFormData(subFormPosition).Settings               = BilinearFormSettings;
obj.subFormData(subFormPosition).closureTopologyIndex   = closureTopologyIndex;

if maxDerivOrder
    if isempty(obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).parametric2PhysicalInverseJacobians); obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).evaluateAllDomainMappings; end
    if isempty(obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).topologyGradients); obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).evaluateTopologyGradients; end
end

if isempty(obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).BasisFunctions.tensorBasisFunctions); obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).BasisFunctions.evaluateTensorProducts; end
[numOfFuns, numOfPoints, ~, numOfKnotPatches] = size(obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).BasisFunctions.tensorBasisFunctions);

weightsInParentDomain  = BilinearFormSettings.numericalIntegration(1).weightsInParentDomain;
for pointIndex = 2:length(BilinearFormSettings.numericalIntegration)
    weightsInParentDomain = kron(BilinearFormSettings.numericalIntegration(pointIndex).weightsInParentDomain, weightsInParentDomain);
end
weightsInParentDomain   = reshape(weightsInParentDomain, numOfPoints, 1);
weightsInPhysicalDomain = repmat(weightsInParentDomain, 1, numOfKnotPatches).*obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).parent2PhysicalDetOfJacobians;

if isempty(obj.DOFData.mapOfDOFLocal2Global); obj.DOFData.constructLocalElementalDOF2GlobalDOF('EachComponent'); end

for subFormIndex = 1:BilinearFormSettings.numberOfSubforms
    
    subFormTensorFieldIndices           = BilinearFormSettings.tensorFieldIndices{subFormIndex};
    subFormTensorFieldComponentIndices  = BilinearFormSettings.tensorFieldComponentIndices{subFormIndex};
    subFormFunctionDerivativesOrder     = BilinearFormSettings.functionDerivativesOrder{subFormIndex};
    subFormFunctionDerivativeComponents = BilinearFormSettings.functionDerivativeComponents{subFormIndex};
    subFormConstitutiveLaw              = BilinearFormSettings.constitutiveLaw(subFormIndex);
    
    funs1 = [];
    componentsLocalDOF1 = [];
    for funIndex = 1:length(subFormFunctionDerivativesOrder{1})
        if subFormFunctionDerivativesOrder{1}(funIndex) == 1
            funs1 = cat(1, funs1, squeeze(obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).topologyGradients(:, subFormFunctionDerivativeComponents{1}(funIndex), :, :)));
        else funs1 = cat(1, funs1, squeeze(obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).BasisFunctions.tensorBasisFunctions(:, :, 1, :)));
        end
        componentsLocalDOF1 = cat(2, componentsLocalDOF1, obj.DOFData.componentsLocalDOF{subFormTensorFieldIndices{1}(funIndex)}(subFormTensorFieldComponentIndices{1}(funIndex)));
    end
    
    funs2 = [];
    componentsLocalDOF2 = [];
    for funIndex = 1:length(subFormFunctionDerivativesOrder{2})
        if subFormFunctionDerivativesOrder{2}(funIndex) == 1
            funs2 = cat(1, funs2, squeeze(obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).topologyGradients(:, subFormFunctionDerivativeComponents{2}(funIndex), :, :)));
        else funs2 = cat(1, funs2, squeeze(obj.CAGDDomain.ClosureTopologies(closureTopologyIndex).BasisFunctions.tensorBasisFunctions(:, :, 1, :)));
        end
        componentsLocalDOF2 = cat(2, componentsLocalDOF2, obj.DOFData.componentsLocalDOF{subFormTensorFieldIndices{2}(funIndex)}(subFormTensorFieldComponentIndices{2}(funIndex)));
    end

    for knotPatchIndex = 1:numOfKnotPatches
        knotPatchContribution = funs1(:, :, knotPatchIndex)...
            *(funs2(:, :, knotPatchIndex)'.*repmat(subFormConstitutiveLaw*weightsInPhysicalDomain(:, knotPatchIndex), 1, numOfFuns*length(componentsLocalDOF2)));
        
        DOFMap1 = obj.DOFData.mapOfDOFLocal2Global(reshape(repmat(numOfFuns*(componentsLocalDOF1-1), numOfFuns, 1) +repmat((1:numOfFuns)', 1, length(componentsLocalDOF1)), 1, []), knotPatchIndex);
        DOFMap2 = obj.DOFData.mapOfDOFLocal2Global(reshape(repmat(numOfFuns*(componentsLocalDOF2-1), numOfFuns, 1) +repmat((1:numOfFuns)', 1, length(componentsLocalDOF2)), 1, []), knotPatchIndex);
        obj.values(DOFMap1, DOFMap2) = obj.values(DOFMap1, DOFMap2) + knotPatchContribution;
        
    end
    
end

end