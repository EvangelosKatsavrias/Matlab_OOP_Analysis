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

function obj = constructorProcesses(obj, varargin)

obj.ExceptionsData.msgID = 'FEA:AnalysisDomainTopology';

if nargin == 1
    return
end

[geoFlag, geoPosition]      = searchArguments(varargin, 'AnalysisDomain', 'nurbs');
[meshFlag, meshPosition]    = searchArguments(varargin, 'MeshRefineData', 'cell');
[funcFlag, funcPosition]    = searchArguments(varargin, 'BasisFunctionsDegree', 'cell');
% [connFlag, connPosition]    = searchArguments(varargin, 'ConnectivitiesData', 'handle');

if geoFlag; obj.AnalysisDomain = varargin{geoPosition};
else throw(MException(obj.ExceptionsData.msgID, 'Wrong input data, provide a valid geometry object after the label ''Geometry''.'));
end
if meshFlag
    obj.RefineData.MeshData = [];
    for index = 1:length(varargin{meshPosition})
        MeshData.parametricCoordNumber  = varargin{meshPosition}{index}{1};
        MeshData.refineMethod           = varargin{meshPosition}{index}{2};
        MeshData.numberOfSubdivisions   = varargin{meshPosition}{index}{3};
        obj.RefineData.MeshData = cat(2, obj.RefineData.MeshData, MeshData);
    end
end
if funcFlag
    for index = 1:length(varargin{meshPosition})
        parametricCoordinateNumber = varargin{meshPosition}{index}{1};
        obj.RefineData.basisFunctionsDegree(parametricCoordinateNumber) = varargin{funcPosition}{index}{2};
    end
end
% if connFlag; obj.Connectivities = varargin{connPosition};
% end

end