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

classdef BoundaryConditionsDirichlet < BoundaryConditions
    
    properties
%         ImpositionMethod = FEABoundCondAndConstraintsAppMethod.OnlyHomogeneousDirichletBC;
        relativeBilinearForm
        relativeConstraintDOF
    end
    
    methods
        function obj = BoundaryConditionsDirichlet(varargin)
            obj@BoundaryConditions(varargin{:});
            obj.boundaryConditionType = 'Dirichlet';
        end
        
        function distributedHomogeneousOn3DFace(obj)
            obj.boundaryType                = 'FaceBoundary';
            obj.boundaryNumber              = 1;
            obj.direction                   = {@(u,v)1 @(u,v)1 @(u,v)1};            % {@(u, v, w)(0) @(u, v, w)(1) @(u, v, w)(0)} --> {cos(dy/dx) sin(dy/dx)}, {cos(dv/du) sin(dv/du)}
            obj.fieldFunction               = @(u, v)0;        % @(u, v, w)(1000);
            obj.IntegrationRule             = [NumericalIntegration NumericalIntegration];      % [nu nv nw];

        end
        
    end
    
    events
    end
    
end