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

function midpointRule(obj)

% A = dx*fx_{i}

obj.method          = 'MidpointRule';
obj.parentDomain    = [-1 1];

halfInterval = 1/obj.numberOfIntegrationPoints;

obj.pointsInParentDomain    = (-1+halfInterval:2*halfInterval:1-halfInterval);
obj.weightsInParentDomain   = repmat(2*halfInterval, [1, obj.numberOfIntegrationPoints]);

% error analysis
% E <= K*(b-a)^3 /(24*n^2),  |d2f(x)/dx2| <= K

end