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

classdef FEABilinearFormSettings < handle
    
    properties
        tensorFieldIndices
        tensorFieldComponentIndices
        functionDerivativesOrder
        functionDerivativeComponents
        constitutiveLaw
        numericalIntegration
        numberOfSubforms
        RobinConditions
        
    end
    
    methods
        function obj = FEABilinearFormSettings(varargin)
            if nargin == 0
                obj.setTheElasticityPlaneStrainProblem(varargin);
            end
            obj.numberOfSubforms = length(obj.tensorFieldIndices);
        end
        
        function setTheElasticityPlaneStrainProblem(obj, varargin)
            % the default settings correspond to the 2D plane elasticity
            % problems, the three subforms correspond to the three virtual
            % works: de11*D11*e11, de22*D22*e22, de12*D12*e12 and the
            % corresponding formed gradients of the displacement field:
            % du,1*D11*u,1, dv,2*D22*v,2, (du,2+dv,1)*D12*(u,2+v,1)
            obj.tensorFieldIndices           = {{1 1}   {1 1}   {[1 1] [1 1]} };
            obj.tensorFieldComponentIndices  = {{1 1}   {2 2}   {[1 2] [1 2]} };
            obj.functionDerivativesOrder     = {{1 1}   {1 1}   {[1 1] [1 1]} };
            obj.functionDerivativeComponents = {{1 1}   {2 2}   {[2 1] [2 1]} };
            % the constitutive constants correspond to the plane strain
            % problem for steel material
            const = elasticConstants;
            obj.constitutiveLaw              = [(2*const.mu+const.lambda) (2*const.mu+const.lambda) const.mu];
            obj.numericalIntegration         = [NumericalIntegration('GaussLegendreQuadratures', 2) ...
                                                NumericalIntegration('GaussLegendreQuadratures', 2)];
            obj.numberOfSubforms = length(obj.tensorFieldIndices);
            
        end
        
        function setThe3DElasticityProblem(obj, varargin)
            % the default settings correspond to the 2D plane elasticity
            % problems, the three subforms correspond to the three virtual
            % works: de11*D11*e11, de22*D22*e22, de12*D12*e12 and the
            % corresponding formed gradients of the displacement field:
            % du,1*D11*u,1, dv,2*D22*v,2, (du,2+dv,1)*D12*(u,2+v,1)
            obj.tensorFieldIndices           = {{1 1}   {1 1}   {1 1}    {[1 1] [1 1]}   {[1 1] [1 1]}  {[1 1] [1 1]}};
            obj.tensorFieldComponentIndices  = {{1 1}   {2 2}   {3 3}    {[1 2] [1 2]}   {[1 3] [1 3]}  {[2 3] [2 3]}};
            obj.functionDerivativesOrder     = {{1 1}   {1 1}   {1 1}    {[1 1] [1 1]}   {[1 1] [1 1]}  {[1 1] [1 1]}};
            obj.functionDerivativeComponents = {{1 1}   {2 2}   {3 3}    {[2 1] [2 1]}   {[3 1] [3 1]}  {[3 2] [3 2]}};
            % the constitutive constants correspond to the plane strain
            % problem for steel material
            const = elasticConstants;
            obj.constitutiveLaw              = [(2*const.mu+const.lambda) (2*const.mu+const.lambda) (2*const.mu+const.lambda) const.mu const.mu const.mu];
            obj.numericalIntegration         = [NumericalIntegration('GaussLegendreQuadratures', 2) ...
                                                NumericalIntegration('GaussLegendreQuadratures', 2) ...
                                                NumericalIntegration('GaussLegendreQuadratures', 2)];
            obj.numberOfSubforms = length(obj.tensorFieldIndices);
            
        end
        
        function setForMassForm(obj, varargin)
            % plain mass
            obj.tensorFieldIndices           = {{1 1} {1 1}};
            obj.tensorFieldComponentIndices  = {{1 1} {2 2}};
            obj.functionDerivativesOrder     = {{0 0} {0 0}};
            obj.functionDerivativeComponents = {{0 0} {0 0}};
            if nargin > 1; obj.constitutiveLaw = [varargin{1} varargin{1}];
            else obj.constitutiveLaw = [7850 7850];
            end
            obj.numericalIntegration         = [NumericalIntegration('GaussLegendreQuadratures', 2) ...
                                                NumericalIntegration('GaussLegendreQuadratures', 2)];
            obj.numberOfSubforms = length(obj.tensorFieldIndices);
        end
        
        function setRobinFormEdge2D(obj, varargin)
            obj.RobinConditions              = BoundaryConditionsRobin;
            obj.tensorFieldIndices           = {{1 1} {1 1}};
            obj.tensorFieldComponentIndices  = {{1 1} {2 2}};
            obj.functionDerivativesOrder     = {{0 0} {0 0}};
            obj.functionDerivativeComponents = {{0 0} {0 0}};
            obj.numericalIntegration         = obj.RobinConditions.IntegrationRule;
            
            obj.numberOfSubforms = length(obj.tensorFieldIndices);
            obj.RobinConditions.boundaryNumber = 2;
                                    
        end
        
        function setRobinFormEdge2DScalarField(obj, varargin)
            obj.RobinConditions              = BoundaryConditionsRobin;
            obj.tensorFieldIndices           = {{1 1}};
            obj.tensorFieldComponentIndices  = {{1 1}};
            obj.functionDerivativesOrder     = {{0 0}};
            obj.functionDerivativeComponents = {{0 0}};
            obj.numericalIntegration         = obj.RobinConditions.IntegrationRule;
            
            obj.numberOfSubforms = length(obj.tensorFieldIndices);
            obj.RobinConditions.boundaryNumber = 2;
                                    
        end
        
        function setIncompressiblePotentialFlow2D(obj, varargin)
            obj.tensorFieldIndices           = {{1 1}   {1 1}};
            obj.tensorFieldComponentIndices  = {{1 1}   {1 1}};
            obj.functionDerivativesOrder     = {{1 1}   {1 1}};
            obj.functionDerivativeComponents = {{1 1}   {2 2}};
            obj.constitutiveLaw              = [1 1];
            obj.numericalIntegration         = [NumericalIntegration('GaussLegendreQuadratures', 2) ...
                                                NumericalIntegration('GaussLegendreQuadratures', 2)];
            obj.numberOfSubforms = length(obj.tensorFieldIndices);
            
        end
        
        
    end
    
end