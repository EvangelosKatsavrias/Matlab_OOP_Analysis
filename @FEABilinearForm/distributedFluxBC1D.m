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

function distributedFluxBC1D(obj, boundaryNumber, boundaryCondition, numericalIntegration)

if ~strcmp(boundaryCondition.boundaryType, 'EdgeBoundary'); throw(MException('FEALinearForm:distributedBC1D', 'The provided boundary condition does not correspond to a 1D boundary.')); end

maxDerivOrder = BilinearFormSettings.functionDerivativesOrder;
BasisFunctionsSettings = bSplineBasisFunctionsEvaluationSettings('RepetitiveGivenInKnotPatches', numericalIntegration.pointsInParentDomain, maxDerivOrder, knotPatches, numericalIntegration.parentDomain);

boundaryTopologyIndex = obj.CAGDDomain.requestBoundaryTopology('EdgeBoundary', boundaryNumber, BasisFunctionsSettings);

subFormPosition = length(obj.subFormData)+1;
obj.subFormData(subFormPosition).Settings               = BilinearFormSettings;
obj.subFormData(subFormPosition).closureTopologyIndex   = boundaryTopologyIndex;

if isempty(obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).parametric2PhysicalInverseJacobians); obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).evaluateAllDomainMappings; end
if isempty(obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).BasisFunctions.tensorBasisFunctions); obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).BasisFunctions.evaluateTensorProducts; end
[numOfFuns, numOfPoints, ~, numOfKnotPatches] = size(obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).BasisFunctions.tensorBasisFunctions);

firstLeftKnotSpan   = find(obj.CAGDDomain.BoundaryTopology(boundaryNumber).KnotVector.knotsWithoutMultiplicities>boundaryCondition.domainInterval(1), 1, 'first')-1;
LastLeftKnotSpan    = find(obj.CAGDDomain.BoundaryTopology(boundaryNumber).KnotVector.knotsWithoutMultiplicities<boundaryCondition.domainInterval(2), 1, 'last');

knotPatches = (firstLeftKnotSpan:LastLeftKnotSpan);





weightsInParentDomain  = numericalIntegration(1).weightsInParentDomain;
weightsInPhysicalDomain = repmat(weightsInParentDomain, 1, numOfKnotPatches).*obj.CAGDDomain.BoundaryTopologies(boundaryNumber).parent2PhysicalDetOfJacobians;

if knotSpanIndex == 1 || knotSpanIndex == LastLeftKnotSpan-firstLeftKnotSpan+1
    integrationFactor = doubleHeaviside(boundaryCondition.domainInterval(1), boundaryCondition.domainInterval(2), integrationPoints(knotSpanIndex, integrationPointIndex));
else integrationFactor = 1;
    
    %             subFormTensorFieldIndices           = BilinearFormSettings.tensorFieldIndices{subFormIndex};
    %             subFormTensorFieldComponentIndices  = BilinearFormSettings.tensorFieldComponentIndices{subFormIndex};
    %             subFormFunctionDerivativesOrder     = BilinearFormSettings.functionDerivativesOrder{subFormIndex};
    %             subFormFunctionDerivativeComponents = BilinearFormSettings.functionDerivativeComponents{subFormIndex};
    %             subFormConstitutiveLaw              = BilinearFormSettings.constitutiveLaw(subFormIndex);
    
    funs1 = [];
    componentsLocalDOF1 = [];
    for funIndex = 1:length(subFormFunctionDerivativesOrder{1})
        if subFormFunctionDerivativesOrder{1}(funIndex) == 1
            funs1 = cat(1, funs1, squeeze(obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).topologyGradients(:, subFormFunctionDerivativeComponents{1}(funIndex), :, :)));
        else funs1 = funs1 +squeeze(obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).BasisFunctions.tensorBasisFunctions(:, :, 1, :));
        end
        componentsLocalDOF1 = [componentsLocalDOF1 obj.DOFData.componentsLocalDOF{subFormTensorFieldIndices{1}(funIndex)}(subFormTensorFieldComponentIndices{1}(funIndex))];
    end
    
    funs2 = [];
    componentsLocalDOF2 = [];
    for funIndex = 1:length(subFormFunctionDerivativesOrder{2})
        if subFormFunctionDerivativesOrder{2}(funIndex) == 1
            funs2 = cat(1, funs2, squeeze(obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).topologyGradients(:, subFormFunctionDerivativeComponents{2}(funIndex), :, :)));
        else funs2 = funs2 +squeeze(obj.CAGDDomain.ClosureTopologies(boundaryTopologyIndex).BasisFunctions.tensorBasisFunctions(:, :, 1, :));
        end
        componentsLocalDOF2 = [componentsLocalDOF2 obj.DOFData.componentsLocalDOF{subFormTensorFieldIndices{2}(funIndex)}(subFormTensorFieldComponentIndices{2}(funIndex))];
    end
    
    for knotPatchIndex = 1:numOfKnotPatches
        knotPatchContribution = funs1(:, :, knotPatchIndex)...
            *(funs2(:, :, knotPatchIndex)'.*repmat(subFormConstitutiveLaw*weightsInPhysicalDomain(:, knotPatchIndex), 1, numOfFuns*length(componentsLocalDOF2)));
        
        DOFMap1 = obj.DOFData.mapOfDOFLocal2Global(reshape(repmat(numOfFuns*(componentsLocalDOF1-1), numOfFuns, 1) +repmat((1:numOfFuns)', 1, length(componentsLocalDOF1)), 1, []), knotPatchIndex);
        DOFMap2 = obj.DOFData.mapOfDOFLocal2Global(reshape(repmat(numOfFuns*(componentsLocalDOF2-1), numOfFuns, 1) +repmat((1:numOfFuns)', 1, length(componentsLocalDOF2)), 1, []), knotPatchIndex);
        obj.values(DOFMap1, DOFMap2) = obj.values(DOFMap1, DOFMap2) + knotPatchContribution;
        
    end
    
    
end

for knotSpanIndex = 1:LastLeftKnotSpan-firstLeftKnotSpan+1
    
    %                 knownDOF = zeros(2*(curveDegree+1),1);
    for integrationPointIndex = 1:numberOfIntegrationPoints
        
        
        
        %                     dx = boundaryCondition.direction{1}(integrationPoints(knotSpanIndex, integrationPointIndex));
        %                     dy = boundaryCondition.direction{2}(integrationPoints(knotSpanIndex, integrationPointIndex));
        dx = obj.CAGDDomain.BoundaryTopologies(boundaryNumber).parametric2PhysicalJacobian(1, 2, integrationPoints(knotSpanIndex, integrationPointIndex));
        dy = obj.CAGDDomain.BoundaryTopologies(boundaryNumber).parametric2PhysicalJacobian(2, 2, integrationPoints(knotSpanIndex, integrationPointIndex));
        distribution = integrationFactor*boundaryCondition.fieldFunction(integrationPoints(knotSpanIndex, integrationPointIndex))*[dx;dy];
        R = obj.CAGDDomain.BoundaryTopologies(boundaryNumber).basisfunctions(:, 1, integrationPointIndex, knotSpanIndex);
        
        % Computation of element's traction force vector
        knownDOF = knownDOF + reshape(distribution*R'*weightsInPhysicalDomain(integrationPointIndex, knotSpanIndex)*Subdomain.Properties.CrossSection.beamWidth, [], 1);
        
    end
    
    DOFMap = reshape(Subdomain.NumericalAnalysis.DOFData.globalDOFNum(controlPointsMap(currentControlPositions), :)', [], 1);
    
    Subdomain.NumericalAnalysis.Matrices.knownDOFvalues = cat(1, Subdomain.NumericalAnalysis.Matrices.knownDOFvalues, knownDOF);
    forceVector = Subdomain.NumericalAnalysis.Matrices.store{1}(:, DOFMap)*knownDOF;
    
    obj.values(DOFMap) = obj.values(DOFMap) + forceVector;
    obj.dirichletDOF = cat(1, Subdomain.NumericalAnalysis.DOFData.dirichletDOF, DOFMap);
    
end

end