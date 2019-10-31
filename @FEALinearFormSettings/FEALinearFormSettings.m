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

classdef FEALinearFormSettings < handle
    
    properties
        DomainConditions = InteriorConditions
        tensorFieldIndices
        tensorFieldComponentIndices
        functionDerivativesOrder
        functionDerivativeComponents
        numericalIntegration
        numberOfSubforms = 1
        
    end
    
    methods
        function obj = FEALinearFormSettings(varargin)
            if nargin == 0
                obj.setDirichletLinearForm;
            end
        end
        
        function setTractionLinearForm(obj, varargin)
            obj.DomainConditions             = BoundaryConditionsNeumann;
            obj.tensorFieldIndices           = {[1 1]};
            obj.tensorFieldComponentIndices  = {[1 2]};
            obj.functionDerivativesOrder     = {[0 0]};
            obj.functionDerivativeComponents = {[0 0]};
            obj.numericalIntegration         = obj.DomainConditions.IntegrationRule;
            
            obj.DomainConditions.direction     = {@(u)0 @(u)1};
            obj.DomainConditions.fieldFunction = @(u)100000;
            
        end
        
        function setDirichletLinearForm(obj, varargin)
            obj.DomainConditions             = BoundaryConditionsDirichlet;
            obj.tensorFieldIndices           = {[1 1]};
            obj.tensorFieldComponentIndices  = {[1 2]};
            obj.functionDerivativesOrder     = {[0 0]};
            obj.functionDerivativeComponents = {[0 0]};
            obj.numericalIntegration         = obj.DomainConditions.IntegrationRule;
            
        end
        
        function setDirichletLinearFormEdge3D(obj, varargin)
            obj.DomainConditions             = BoundaryConditionsDirichlet;
            obj.tensorFieldIndices           = {[1 1 1]};
            obj.tensorFieldComponentIndices  = {[1 2 3]};
            obj.functionDerivativesOrder     = {[0 0 0]};
            obj.functionDerivativeComponents = {[0 0 0]};
            obj.numericalIntegration         = obj.DomainConditions.IntegrationRule;
            
            obj.DomainConditions.direction     = {@(u)1 @(u)1 @(u)1};
            
        end
        
        function setDirichletLinearFormFace3D(obj, varargin)
            obj.DomainConditions             = BoundaryConditionsDirichlet;
            obj.DomainConditions.distributedHomogeneousOn3DFace;
            obj.tensorFieldIndices           = {[1 1 1]};
            obj.tensorFieldComponentIndices  = {[1 2 3]};
            obj.functionDerivativesOrder     = {[0 0 0]};
            obj.functionDerivativeComponents = {[0 0 0]};
            obj.numericalIntegration         = obj.DomainConditions.IntegrationRule;
                        
        end
        
        function setNeumannLinearFormFace3D(obj, varargin)
            obj.DomainConditions             = BoundaryConditionsNeumann;
            obj.DomainConditions.distributedOn3DFace;
            obj.tensorFieldIndices           = {[1 1 1]};
            obj.tensorFieldComponentIndices  = {[1 2 3]};
            obj.functionDerivativesOrder     = {[0 0 0]};
            obj.functionDerivativeComponents = {[0 0 0]};
            obj.numericalIntegration         = obj.DomainConditions.IntegrationRule;
                        
        end
        
        function setRobinLinearFormEdge2D(obj, varargin)
            obj.DomainConditions             = BoundaryConditionsRobin;
            obj.tensorFieldIndices           = {[1 1]};
            obj.tensorFieldComponentIndices  = {[1 2]};
            obj.functionDerivativesOrder     = {[0 0]};
            obj.functionDerivativeComponents = {[0 0]};
            obj.numericalIntegration         = obj.DomainConditions.IntegrationRule;
            
            obj.DomainConditions.direction     = {@(u)0 @(u)0};
            obj.DomainConditions.fieldFunction = @(u)0;
            obj.DomainConditions.boundaryNumber = 2;
            
        end
        
        function setRobinLinearFormEdge2DScalarField(obj, varargin)
            obj.DomainConditions             = BoundaryConditionsRobin;
            obj.tensorFieldIndices           = {[1 1]};
            obj.tensorFieldComponentIndices  = {[1 1]};
            obj.functionDerivativesOrder     = {[0 0]};
            obj.functionDerivativeComponents = {[0 0]};
            obj.numericalIntegration         = obj.DomainConditions.IntegrationRule;
            
            obj.DomainConditions.direction     = {@(u)0 @(u)0};
            obj.DomainConditions.fieldFunction = @(u)0;
            obj.DomainConditions.boundaryNumber = 2;
            
        end
        
    end
    
end