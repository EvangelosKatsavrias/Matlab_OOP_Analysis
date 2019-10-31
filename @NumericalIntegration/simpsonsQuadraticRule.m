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

function simpsonsQuadraticRule(obj)

% A = dx/3*(fx_{i-1} + 4*fx_{i} + fx_{i+1})

if obj.numberOfIntegrationPoints<3 || mod(obj.numberOfIntegrationPoints, 2)~=1
    throw(MException('FEA:numericalIntegration', 'Wrong input data, provide a valid number of sample points, i.e. n >= 3 and mod(n, 2)=1.'));
end

obj.method          = 'SimpsonsQuadraticRule';
obj.parentDomain    = [-1 1];

interval = 2/(obj.numberOfIntegrationPoints-1);

obj.pointsInParentDomain    = (-1:interval:1);
interiorWeights             = reshape([repmat(4, 1, (obj.numberOfIntegrationPoints-1)/2); repmat(2, 1, (obj.numberOfIntegrationPoints-1)/2-1) 0], 1, []);
obj.weightsInParentDomain   = interval/3*[1 interiorWeights(1:end-1) 1];


% error analysis
% E <= M*(b-a)^5 /(180*n^4),  |d4f(x)/dx4| <= M
% Since the error term is proportional to the fourth derivative of f at \xi,
% this shows that Simpson's rule provides exact results for any polynomial 
% f of degree three or less, since the fourth derivative of such a polynomial 
% is zero at all points.
end