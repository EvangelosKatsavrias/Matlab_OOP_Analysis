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

function addFromTensorFieldsDomainConditions(obj, TensorFields, varargin)

for tensorFieldIndex = 1:length(TensorFields)
    
    obj.tensorFieldIndices = cat(1, obj.tensorFieldIndices, tensorFieldIndex);
    
    for boundaryConditionIndex = 1:length(TensorFields(tensorFieldIndex).BoundaryConditions)
        
        switch TensorFields(tensorFieldIndex).BoundaryConditions(boundaryConditionIndex).boundaryConditionType
            
            case 'DirichletHomogeneous'
                
                distributionFunction    = TensorFields(tensorFieldIndex).BoundaryConditions(boundaryConditionIndex).function;
                impositionInterval      = Subdomain.NumericalAnalysis.BoundaryConditions.Dirichlet.Distributed(Subdomain.ProcessData.functionIndex).domainInterval;
                direction               = Subdomain.NumericalAnalysis.BoundaryConditions.Dirichlet.Distributed(Subdomain.ProcessData.functionIndex).direction;
                
                knotSpans = Subdomain.Topology.CAGD.knotsWithoutMultiplicities{1};
                
                firstLeftKnotSpan   = find(knotSpans > impositionInterval(1), 1, 'first')-1;
                LastLeftKnotSpan    = find(knotSpans < impositionInterval(2), 1, 'last');
                
                for knotSpanIndex = 1:LastLeftKnotSpan-firstLeftKnotSpan+1
                    
                    knownDOF = zeros(2*(curveDegree+1),1);
                    
                    for integrationPointIndex = 1:numberOfIntegrationPoints
                        
                        integrationFactor = doubleHeaviside(impositionInterval(1), impositionInterval(2), integrationPoints(knotSpanIndex, integrationPointIndex));
                        
                        dx = direction{1}(integrationPoints(knotSpanIndex, integrationPointIndex));
                        dy = direction{2}(integrationPoints(knotSpanIndex, integrationPointIndex));
                        distribution = integrationFactor*distributionFunction(integrationPoints(knotSpanIndex, integrationPointIndex))*[dx;dy];
                        
                        detJacParent2Parametric = Subdomain.Topology.Mappings.Parent2Parametric.detOfJacobian(knotSpanIndex);
                        % Computation of element's traction force vector
                        knownDOF = knownDOF + reshape(distribution*R'*integrationWeights(integrationPointIndex)*detJacParent2Parametric*detJacParametric2Physical*Subdomain.Properties.CrossSection.beamWidth, [], 1);
                        
                    end
                    
                    DOFMap = reshape(Subdomain.NumericalAnalysis.DOFData.globalDOFNum(controlPointsMap(currentControlPositions), :)', [], 1);
                    
                    if ~isfield(Subdomain.NumericalAnalysis.Matrices, 'knownDOFvalues')
                        Subdomain.NumericalAnalysis.Matrices.knownDOFvalues = knownDOF;
                    else
                        Subdomain.NumericalAnalysis.Matrices.knownDOFvalues = cat(1, Subdomain.NumericalAnalysis.Matrices.knownDOFvalues, knownDOF);
                    end
                    
                    forceVector = Subdomain.NumericalAnalysis.Matrices.store{1}(:, DOFMap)*knownDOF;
                    
                    Subdomain.NumericalAnalysis.Matrices.globalRHSVector = vectorAssembly(Subdomain.NumericalAnalysis.Matrices.globalRHSVector, forceVector(DOFMap), DOFMap);
                    
                    Subdomain.NumericalAnalysis.DOFData.dirichletDOF = cat(1, Subdomain.NumericalAnalysis.DOFData.dirichletDOF, DOFMap);
                    
                end
                
            case 'Dirichlet'
                
            case 'Neumann'
                
            case 'Robin'
                
        end
    end
    
end

end