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

classdef (Abstract) DomainConditions < handle & hgsetget & dynamicprops & matlab.mixin.Copyable

    properties
        domainOfDefinition
        conditionedTopology
        coordSystem
        direction
        fieldFunction
        IntegrationRule
        
    end
    
    %%
    methods
        function obj = DomainConditions(varargin)
            if nargin == 0
                obj.setDistributedCondition('Parametric', [0 1], 'Global', {@(u)0 @(u)0}, @(u)0, NumericalIntegration);
            else
                switch varargin{1}
                    case 'Concentrated'
                        obj.setConcentratedCondition(varargin{2:end});
                    case 'Distributed'
                        obj.setDistributedCondition(varargin{2:end});
                end
            end
        end
        
        function setConcentratedCondition(obj, domainOfDefinition, pointCoordinates, coordSystem, direction, fieldFunction, IntegrationRule)
            obj.domainOfDefinition         = domainOfDefinition;    % 'Parametric', 'Physical'
            obj.conditionedTopology        = pointCoordinates;      % Intervals in normalized parametric (0-1), or point coordinates for concentrated
            obj.coordSystem                = coordSystem;           % 'Global', 'Covariant', 'Contravariant', 'other'
            obj.direction                  = direction;             % {@(u, v, w)(0) @(u, v, w)(1) @(u, v, w)(0)} --> global:{cos(dy/dx) sin(dy/dx)}, covariant:{cos(dv/du) sin(dv/du)}
            obj.fieldFunction              = fieldFunction;         % @(u, v, w)(1000);
            obj.IntegrationRule            = IntegrationRule;       % [nu nv nw];
            
        end
        
        function setDistributedCondition(obj, domainOfDefinition, domainInterval, coordSystem, direction, fieldFunction, IntegrationRule)
            obj.domainOfDefinition          = domainOfDefinition;   % 'Parametric', 'Physical
            obj.conditionedTopology         = domainInterval;       % Intervals in normalized parametric (0-1), or point coordinates for concentrated. % [0.1 0.8] --> In normalized parametric (0-1), [start end]
            obj.coordSystem                 = coordSystem;          % 'Global', 'Covariant', 'Contravariant', 'other'
            obj.direction                   = direction;            % {@(u, v, w)(0) @(u, v, w)(1) @(u, v, w)(0)} --> {cos(dy/dx) sin(dy/dx)}, {cos(dv/du) sin(dv/du)}
            obj.fieldFunction               = fieldFunction;        % @(u, v, w)(1000);
            obj.IntegrationRule             = IntegrationRule;      % [nu nv nw];
            
        end
    end
    
    methods (Access = private)
        constructorProcesses(obj, varargin);
    end
    

    %%
    events
    end
    
end