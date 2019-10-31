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

function addMaterialProperties(obj, varargin)

if ~isfield(obj.Properties, 'Material')
    obj.Properties.Material = [];
end
if nargin == 1   
    obj.Properties.Material = cat(2, obj.Properties.Material, ...
        struct('elasticModulus', 2e11, 'poissonsRatio', 0.3, 'materialDensity', 7850));
    constMat = obj.Properties.Material.elasticModulus/(1-obj.Properties.Material.poissonsRatio^2)* ...
    [1           obj.Properties.Material.poissonsRatio     0;
     obj.Properties.Material.poissonsRatio     1           0;
     0           0           (1-obj.Properties.Material.poissonsRatio)/2];
    obj.Properties.Material.constitutiveMatrix = constMat;
    
    return
end

for inputIndex = 1:length(varargin)/2
    labelIndex = (inputIndex-1)*2+1;
    valueIndex = (inputIndex-1)*2+2;
    if isa(varargin{labelIndex}, 'char')
        obj.Properties.Material.(varargin{labelIndex}) = varargin{valueIndex};
    else
        throw(MException('FEA:addGeometryProperties', 'Wrong input arguments sequence, provide couples of property-field names and values in this order.'));
    end
end

end