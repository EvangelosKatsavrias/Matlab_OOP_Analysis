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

classdef BoundaryConditionsRobin < BoundaryConditionsNeumann
% dudx + c_essential*u = naturalValues

    properties
        essentialFieldFunction = @(u)1000
        essentialFieldDirection = {@(u)0 @(u)1}
        
    end
    
    methods
        function obj = BoundaryConditionsRobin(varargin)
            obj@BoundaryConditionsNeumann(varargin{:});
            obj.boundaryConditionType = 'Robin';
        end
        
    end
    
    events
    end
    
end