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

function constructorProcesses(obj, varargin)

if nargin == 1
    obj.method = 'GaussLegendreQuadratures';
    obj.numberOfIntegrationPoints = 2;
    obj.gaussLegendreQuadratures;
    return
end

if isa(varargin{1}, 'char')
    obj.method = varargin{1};
    if isa(varargin{2}, 'numeric'); obj.numberOfIntegrationPoints = varargin{2};
    end
    
    switch obj.method
        case 'MidpointRule'
            obj.midpointRule;
        case 'TrapezoidalRule'
            obj.trapezoidalRule;
        case 'SimpsonsQuadraticRule'
            obj.simpsonsQuadraticRule;
        case 'SimpsonsCubicRule'
            obj.simpsonsCubicRule;
        case 'GaussLegendreQuadratures'
            obj.gaussLegendreQuadratures;
        otherwise; throw(MException('FEA:numericalIntegration', 'Wrong input data, provide a label corresponding to a valid numerical integration method.'));
    end
else
    throw(MException('FEA:numericalIntegration', 'Wrong input data, provide a label corresponding to a valid numerical integration method.'));
end


end