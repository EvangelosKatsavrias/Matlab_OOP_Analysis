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

function simpsonsCubicRule(obj)

% A = 3*dx/8*(fx_{i-1} + 3*fx_{i} + 3*fx_{i+1} + fx_{i+2})

if obj.numberOfIntegrationPoints<4 || mod(obj.numberOfIntegrationPoints-1, 3)~=0
    throw(MException('FEA:numericalIntegration', 'Wrong input data, provide a valid number of sample points, i.e. n >= 4 and mod(n-1, 3)=0.'));
end

obj.method          = 'SimpsonsCubicRule';
obj.parentDomain    = [-1 1];

numOfSubdomains = (obj.numberOfIntegrationPoints-1)/3;
interval        = 2/(obj.numberOfIntegrationPoints-1);

obj.pointsInParentDomain    = (-1:interval:1);
interiorWeights             = repmat([3 3 2], 1, numOfSubdomains);
obj.weightsInParentDomain   = 3*interval/8*[1 interiorWeights(1:end-1) 1];


% error analysis
% E <= M*(b-a)^5 /(6480),  |d4f(x)/dx4| <= M
% Since the error term is proportional to the fourth derivative of f at \xi,
% this shows that Simpson's rule provides exact results for any polynomial 
% f of degree three or less, since the fourth derivative of such a polynomial 
% is zero at all points.
end