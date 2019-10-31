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

function trapezoidalRule(obj)

% A = dx/2*(fx_{i-1} + fx_{i})

if obj.numberOfIntegrationPoints < 2
    throw(MException('FEA:numericalIntegration', 'Wrong input data, provide a valid number of sample points, i.e. n >= 2.'));
end

obj.method          = 'TrapezoidalRule';
obj.parentDomain    = [-1 1];

interval = 2/(obj.numberOfIntegrationPoints-1);

obj.pointsInParentDomain        = (-1:interval:1);
obj.weightsInParentDomain       = [interval/2 repmat(interval, [1, obj.numberOfIntegrationPoints-2]) interval/2];


% error analysis
% E <= K*(b-a)^3 /(12*n^2),  |d2f(x)/dx2| <= K

end