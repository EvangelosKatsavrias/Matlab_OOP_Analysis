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

function instituteFiniteElement(obj, varargin)

if nargin == 1
    obj.FiniteElementData = FEAElement('Connectivities', obj.Topologies.FEA.AnalysisDomain.Connectivities);
    return
end

if isa(varargin{1}, 'FEAElement')
    obj.FiniteElementData = varargin{1};
elseif isa(varargin{1}, 'cell')
    obj.FiniteElementData = FEAElement(varargin{1});
else
    throw(MException('FEA:instituteFiniteElement', 'Wrong input argument, provide a single input argument of class FEAElement or data for the constructor of the same class.'));
end

end