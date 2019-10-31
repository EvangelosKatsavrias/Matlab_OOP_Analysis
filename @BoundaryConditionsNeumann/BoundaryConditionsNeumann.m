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

classdef BoundaryConditionsNeumann < BoundaryConditions

    properties
        
    end
    
    methods
        function obj = BoundaryConditionsNeumann(varargin)
            obj@BoundaryConditions(varargin{:});
            obj.boundaryConditionType = 'Neumann';
        end
        
        function distributedOn3DFace(obj)
            obj.boundaryType                = 'FaceBoundary';
            obj.boundaryNumber              = 2;
            obj.direction                   = {@(u,v)0 @(u,v)1 @(u,v)0};            % {@(u, v, w)(0) @(u, v, w)(1) @(u, v, w)(0)} --> {cos(dy/dx) sin(dy/dx)}, {cos(dv/du) sin(dv/du)}
            obj.fieldFunction               = @(u, v)10000;        % @(u, v, w)(1000);
            obj.IntegrationRule             = [NumericalIntegration NumericalIntegration];      % [nu nv nw];

        end
        
    end
    
    events
    end
    
end


% function Subdomain = tractionForceVectorInPhysicalIsogeometric1D(Subdomain)
% 
% for tractionIndex = 1:length(AnalysisData.BoundaryConditions.Neumann.Traction.Physical.function)
%        
%     forceVector = zeros(2*(curveDegree+1), 1);
% 
%     for integrationPointIndex = 1:NumericalIntegration.numberOfIntegrationPoints    % scanning the integration points in u-direction
%         
%         if strcmp(tractionDirection, 'x')
%             txc = tractionFunction(integrationPointInPhysicalDomain(1), integrationPointInPhysicalDomain(2));
%             tyc = 0;
%         else
%             tyc = tractionFunction(integrationPointInPhysicalDomain(1), integrationPointInPhysicalDomain(2));
%             txc = 0;
%         end
%         
%         % Computation of element's traction force vector
%         forceVector = forceVector + reshape([txc;tyc] *R' ...
%             *integrationWeight*detparnt2param_jac ...
%             *detparam2phys_jac*bodyThinckness, [], 1);
%         
%     end
%                    
%     tractionForceVector = vectorAssembly(tractionForceVector, forceVector, DOFMap);
% 
% end
% 
% end
% 
% 
% 
% function Subdomain = tractionForceVectorInParametricIsogeometric1D(Subdomain)
% 
% tractionFunction = Subdomain.NumericalAnalysis.BoundaryConditions.Neumann.Distributed(Subdomain.ProcessData.functionIndex).function;
% impositionInterval = Subdomain.NumericalAnalysis.BoundaryConditions.Neumann.Distributed(Subdomain.ProcessData.functionIndex).domainInterval;
% direction = Subdomain.NumericalAnalysis.BoundaryConditions.Neumann.Distributed(Subdomain.ProcessData.functionIndex).direction;
% 
% knotSpans = Subdomain.Topology.CAGD.knotsWithoutMultiplicities{1};
% 
% firstLeftKnotSpan = find(knotSpans>impositionInterval(1), 1, 'first')-1;
% LastLeftKnotSpan = find(knotSpans<impositionInterval(2), 1, 'last');
% 
% for knotSpanIndex = 1:LastLeftKnotSpan-firstLeftKnotSpan+1
%     
%    for integrationPointIndex = 1:numberOfIntegrationPoints
%         
%         integrationFactor = doubleHeaviside(impositionInterval(1), impositionInterval(2), integrationPoints(knotSpanIndex, integrationPointIndex));
%         
%         dx = direction{1}(integrationPoints(knotSpanIndex, integrationPointIndex));
%         dy = direction{2}(integrationPoints(knotSpanIndex, integrationPointIndex));
%         traction = integrationFactor*tractionFunction(integrationPoints(knotSpanIndex, integrationPointIndex))*[dx;dy];
%         
%         detJacParent2Parametric = jacobiansParent2Parametric(knotSpanIndex);
%         % Computation of element's traction force vector
%         forceVector = forceVector + reshape(traction*R'*integrationWeights(integrationPointIndex)*detJacParent2Parametric*detJacParametric2Physical*Subdomain.Properties.CrossSection.beamWidth, [], 1);
%         
%     end
%     
%     DOFMap = reshape(Subdomain.NumericalAnalysis.DOFData.globalDOFNum(controlPointsMap(currentControlPositions), :)', [], 1);
%     Subdomain.NumericalAnalysis.Matrices.globalRHSVector = vectorAssembly(Subdomain.NumericalAnalysis.Matrices.globalRHSVector, forceVector, DOFMap);
% 
% end
% 
% end