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

classdef IGFEATopology < FEATopology
    
    properties
    end
    
    methods
        function obj = IGFEATopology(varargin)
            constructorData = constructorPreprocesses(varargin{:});
            obj@FEATopology(constructorData{:});
            obj = constructorPostprocesses(obj, varargin{:});
        end
        setBasisFunctionsDegree(obj, varargin);
        refineMesh(obj, varargin);
    end
    
    events
    end
    
end

%%  
function constructorData = constructorPreprocesses(varargin)

if nargin == 0
    Geometry                = nurbsRectangularGeometry(10, 10);
    meshRefineData          = {{1, 'LinearDiscretization', 10}, {2, 'LinearDiscretization', 10}};
    basisFunctionsDegree    = {{1, 2}, {2, 2}};

    constructorData         = {'AnalysisDomain', Geometry, 'MeshRefineData', meshRefineData, 'BasisFunctionsDegree', basisFunctionsDegree}; %'ConnectivitiesData', Geometry.Connectivities
    return
end

constructorData = varargin;

end

%%  
function obj = constructorPostprocesses(obj, varargin)

obj.RefineData.IGATopologyData.numberOfKnotSpans   = cell2mat({obj.RefineData.MeshData.numberOfSubdivisions});
obj.RefineData.IGATopologyData.bSplineDegreeChange = (obj.RefineData.basisFunctionsDegree-obj.AnalysisDomain.InfoProperties.degree);

obj.setBasisFunctionsDegree;
obj.refineMesh;

end