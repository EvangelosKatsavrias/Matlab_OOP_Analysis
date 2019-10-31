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

function addGeometryProperties(obj, varargin)

if nargin == 1
    obj.Properties.Geometry.CrossSection = struct('beamWidth', 0.25, 'beamHeight', 0.5);
    obj.Properties.Geometry.beamLength = 10;
    return
end

for inputIndex = 1:length(varargin)/2
    labelIndex = (inputIndex-1)*2+1;
    valueIndex = (inputIndex-1)*2+2;
    if isa(varargin{labelIndex}, 'char')
        obj.Properties.Geometry.(varargin{labelIndex}) = varargin{valueIndex};
    else
        throw(MException('FEA:addGeometryProperties', 'Wrong input arguments sequence, provide couples of property-field name and values in this order.'));
    end
end

end