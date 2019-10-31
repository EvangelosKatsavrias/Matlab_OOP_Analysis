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

function refineMesh(obj, varargin)

globalRefinement = [];
for index = 1:length(obj.RefineData.MeshData)
    switch obj.RefineData.MeshData(index).refineMethod
        case 'LinearDiscretization'
            globalRefinement = cat(2, globalRefinement, obj.RefineData.MeshData(index).numberOfSubdivisions);
    end
end

discretizeLinearly(obj, globalRefinement);

end

function discretizeLinearly(obj, globalRefinement)

% Knot insertion
uu = linspace(obj.AnalysisDomain.KnotVectors(1).knots(1), obj.AnalysisDomain.KnotVectors(1).knots(end), globalRefinement(1)+1);
vv = linspace(obj.AnalysisDomain.KnotVectors(2).knots(1), obj.AnalysisDomain.KnotVectors(1).knots(end), globalRefinement(2)+1);
insertionKnots = {uu(2:end-1) vv(2:end-1)};
obj.AnalysisDomain.knotRefinement('insertKnots', insertionKnots);

end