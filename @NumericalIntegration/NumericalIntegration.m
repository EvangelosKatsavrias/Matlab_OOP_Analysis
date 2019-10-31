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

classdef NumericalIntegration < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    
    properties
        method
        numberOfIntegrationPoints
        pointsInParentDomain
        weightsInParentDomain
        parentDomain
    end
    
    methods (Access = private)
        constructorProcesses(obj, varargin);
    end
    methods
        function obj = NumericalIntegration(varargin)
            obj.constructorProcesses(varargin{:});
        end
        
        midpointRule(obj, varargin);
        trapezoidalRule(obj, varargin);
        simpsonsQuadraticRule(obj, varargin);
        simpsonsCubicRule(obj, varargin);
        gaussLegendreQuadratures(obj, varargin);
        changeIntegrationPoints(obj, varargin);
        addaptiveSimpsonsMethod(obj, varargin);
        
    end
    
    events
        changeOfIntegrationPointsInduced
    end
    
end