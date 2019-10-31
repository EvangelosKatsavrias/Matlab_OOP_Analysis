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

classdef InteriorConditions < DomainConditions
    
    properties
        interiorConditionType = 'BodyForces'
    end
    
    methods
        function obj = InteriorConditions(varargin)
            obj@DomainConditions(varargin{:});
        end
    end
    
    methods (Access = private)
        constructorProcesses(obj, varargin);
    end
    
    events
    end
    
end


% function elementBodyForceVector = elementBodyForcesInParametricIsogeometricPlane2D(Subdomain)
% 
% elementBodyForceVector = zeros(Subdomain.NumericalAnalysis.DOFData.numberOfDOFperElement, 1);
% 
% integrationCases = Subdomain.NumericalAnalysis.InteriorConditions(Subdomain.ProcessData.bodyForceFunctionIndex).integrationCase;
% 
% % Numerical integration
% for currentIntegrPointInDirection2 = 1:Subdomain.NumericalAnalysis.NumericalIntegrationData{2}.cases(integrationCases(2)).numberOfIntegrationPoints        % scanning the integration points in u-direction
%     
%     for currentIntegrPointInDirection1 = 1:Subdomain.NumericalAnalysis.NumericalIntegrationData{1}.cases(integrationCases(1)).numberOfIntegrationPoints     % scanning the integration points in v-direction
%         
%         integrationPointInParametric2 = Subdomain.NumericalAnalysis.NumericalIntegrationData{2}.cases(integrationCases(2)).pointsInParametricDomain;
%         integrationPointInParametric1 = Subdomain.NumericalAnalysis.NumericalIntegrationData{1}.cases(integrationCases(1)).pointsInParametricDomain;
%         
%         pointValueOfRationalBasisFunctions = Subdomain.NumericalAnalysis.DomainBasisFunctions(:, :, currentIntegrPointInDirection1, currentIntegrPointInDirection2, Subdomain.ProcessData.elementNumber);
%         
%         % Reshaping the matrix of the basis functions evaluations
%         pointValueOfRationalBasisFunctions = reshape(permute(pointValueOfRationalBasisFunctions, Subdomain.NumericalAnalysis.DOFData.dofCountingDirection), 1, []);
%         
%         bodyForceFunction = Subdomain.NumericalAnalysis.InteriorConditions(Subdomain.ProcessData.bodyForceFunctionIndex).function;
%         
%         bodyForceFieldValue = bodyForceFunction(integrationPointInParametric2, integrationPointInParametric1);
%         
%         pointBodyForceIn_x = bodyForceFieldValue*Subdomain.NumericalAnalysis.InteriorConditions(Subdomain.ProcessData.bodyForceFunctionIndex).direction{1}(integrationPointInParametric2, integrationPointInParametric1);
%         
%         pointBodyForceIn_y = bodyForceFieldValue*Subdomain.NumericalAnalysis.InteriorConditions(Subdomain.ProcessData.bodyForceFunctionIndex).direction{2}(integrationPointInParametric2, integrationPointInParametric1);
%         
%         % Calculating the body force vector
%         elementBodyForceVector = elementBodyForceVector + reshape([pointBodyForceIn_x;pointBodyForceIn_y]*pointValueOfRationalBasisFunctions*...
%                     Subdomain.Properties.Material.materialDensity*Subdomain.NumericalAnalysis.integrationVolumes(currentIntegrPointInDirection1, currentIntegrPointInDirection2, Subdomain.ProcessData.elementNumber), [], 1);
%         
%     end
%     
% end
% 
% end
% 
% 
% function elementBodyForceVector=...
%     BodyForcesVectorParametricCoord2D(numberOfIntegrationPoints_u,...
%                     numberOfIntegrationPoints_v,...
%                     bodyThickness,...
%                     BodyForces.Parametric.X.function,...
%                     BodyForces.Parametric.Y.function,...
%                     numberOfDOFperElement,...
%                     dofCountingDirectionFlag,...
%                     NumerIntegrUWeights,NumerIntegrVWeights,...
%                     IntegrationPointsInParametricU,...
%                     IntegrationPointsInParametricV,...
%                     Pare2ParamDetOfJacobian,...
%                     Para2PhysDetOfJacobian,...
%                     basisFunctions,...
%                     currentElement)
% 
% elementBodyForceVector=zeros(numberOfDOFperElement,1);
% 
% % Numerical integration
% for currentIntegrPointInDirection_u=1:numberOfIntegrationPoints_u        % scanning the integration points in u-direction
%     
%     for currentIntegrPointInDirection_v=1:numberOfIntegrationPoints_v     % scanning the integration points in v-direction
%                 
%         pointValueOfRationalBasisFunctions=basisFunctions(:,:,...
%                                         currentIntegrPointInDirection_v,...
%                                         currentIntegrPointInDirection_u,...
%                                         currentElement);
%         
%         % Reshaping the matrix of the basis functions evaluations
%         if dofCountingDirectionFlag==1
%             pointValueOfRationalBasisFunctions=reshape(pointValueOfRationalBasisFunctions,1,[]);                   % control points scanned in v direction at dof numbering
%         else                             
%             pointValueOfRationalBasisFunctions=reshape(pointValueOfRationalBasisFunctions',1,[]);                  % control points scanned in u direction at dof numbering
%         end
%         
%         pointBodyForceIn_x=0;
%         for i=1:size(BodyForces.Parametric.X.function)
%             if isempty(BodyForces.Parametric.X.function)
%                 continue
%             elseif isnumeric(BodyForces.Parametric.X.function)
%                 pointBodyForceIn_x=pointBodyForceIn_x+BodyForces.Parametric.X.function;
%             else
%                 pointBodyForceIn_x=pointBodyForceIn_x+BodyForces.Parametric.X.function(...
%                     IntegrationPointsInParametricU(...
%                     currentIntegrPointInDirection_v,...
%                     currentIntegrPointInDirection_u,...
%                     currentElement),...
%                     IntegrationPointsInParametricV(...
%                     currentIntegrPointInDirection_v,...
%                     currentIntegrPointInDirection_u,...
%                     currentElement));
%             end
%         end
%         
%         pointBodyForceIn_y=0;
%             for i=1:size(BodyForces.Parametric.Y.function)
%                 if isempty(BodyForces.Parametric.Y.function)
%                     continue
%                 elseif isnumeric(BodyForces.Parametric.Y.function)
%                     pointBodyForceIn_y=pointBodyForceIn_y+BodyForces.Parametric.Y.function;
%                 else
%                     pointBodyForceIn_y=pointBodyForceIn_y+BodyForces.Parametric.Y.function(...
%                         IntegrationPointsInParametricU(...
%                         currentIntegrPointInDirection_v,...
%                         currentIntegrPointInDirection_u,...
%                         currentElement),...
%                         IntegrationPointsInParametricV(...
%                         currentIntegrPointInDirection_v,...
%                         currentIntegrPointInDirection_u,...
%                         currentElement));
%                 end
%             end
%         
%         % Calculating the body force vector
%         elementBodyForceVector=elementBodyForceVector+...
%             reshape([pointBodyForceIn_x;pointBodyForceIn_y]*...
%             pointValueOfRationalBasisFunctions*...
%             NumerIntegrUWeights(currentIntegrPointInDirection_u)*...
%             NumerIntegrVWeights(currentIntegrPointInDirection_v)*...
%             Pare2ParamDetOfJacobian(currentIntegrPointInDirection_v,...
%                                     currentIntegrPointInDirection_u,...
%                                     currentElement)*...
%             Para2PhysDetOfJacobian(currentIntegrPointInDirection_v,...
%                                    currentIntegrPointInDirection_u,...
%                                    currentElement)*...
%             bodyThickness,[],1);
%         
%     end
%     
% end
% 
% end
% 
% 
% function elementBodyForceVector = elementBodyForcesInPhysicalIsogeometricPlane2D(Subdomain)
% 
% elementBodyForceVector = zeros(Subdomain.NumericalAnalysis.DOFData.numberOfDOFperElement, 1);
% 
% % Numerical integration
% for currentIntegrPointInDirection_u = 1:Subdomain.NumericalAnalysis.NumericalIntegrationData{2}.cases{1}.numberOfIntegrationPoints        % scanning the integration points in u-direction
%     
%     for currentIntegrPointInDirection_v = 1:Subdomain.NumericalAnalysis.NumericalIntegrationData{1}.cases{1}.numberOfIntegrationPoints     % scanning the integration points in v-direction
%         
%         integrationPointInPhysical = Subdomain.NumericalAnalysis.pointsInPhysicalDomain(:, currentIntegrPointInDirection_v, currentIntegrPointInDirection_u, Subdomain.ProcessData.elementNumber);
%         
%         pointValueOfRationalBasisFunctions = Subdomain.NumericalAnalysis.DomainBasisFunctions(:, :, currentIntegrPointInDirection_v, currentIntegrPointInDirection_u, Subdomain.ProcessData.elementNumber);
%         
%         % Reshaping the matrix of the basis functions evaluations
%         pointValueOfRationalBasisFunctions = reshape(permute(pointValueOfRationalBasisFunctions, Subdomain.NumericalAnalysis.DOFData.dofCountingDirection), 1, []);
%         
%         pointBodyForceIn_x=0;
%         for i=1:size(BodyForces.Physical.X.function)
%             if isempty(BodyForces.Physical.X.function)
%                 continue
%             elseif isnumeric(BodyForces.Physical.X.function)
%                 pointBodyForceIn_x=pointBodyForceIn_x+BodyForces.Physical.X.function;
%             else
%                 pointBodyForceIn_x=pointBodyForceIn_x+...
%                     BodyForces.Physical.X.function(integrationPointInPhysical(1),...
%                     integrationPointInPhysical(2));
%             end
%         end
%         
%         pointBodyForceIn_y=0;
%         for i=1:size(BodyForces.Physical.Y.function)
%             if isempty(BodyForces.Physical.Y.function)
%                 continue
%             elseif isnumeric(BodyForces.Physical.Y.function)
%                 pointBodyForceIn_y=pointBodyForceIn_y+BodyForces.Physical.Y.function;
%             else
%                 pointBodyForceIn_y=pointBodyForceIn_y+...
%                     BodyForces.Physical.Y.function(integrationPointInPhysical(1),...
%                     integrationPointInPhysical(2));
%             end
%         end
%         
%         % Calculating the body force vector
%         elementBodyForceVector = elementBodyForceVector + reshape([pointBodyForceIn_x;pointBodyForceIn_y]*pointValueOfRationalBasisFunctions*...
%             integrationVolumes(currentIntegrPointInDirection_v, currentIntegrPointInDirection_u, currentElement), [], 1);
%         
%     end
%     
% end
% 
% end