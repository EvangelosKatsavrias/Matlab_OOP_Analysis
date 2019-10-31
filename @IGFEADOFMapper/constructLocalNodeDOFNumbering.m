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

function constructLocalNodeDOFNumbering(obj)
% Map DOF global numbering to elemental nodes, based on connectivity and topology data
%
% GlobalDOFNumber = localNode2globalNodemapper(element, localElementalNodeNumber, fieldNumber-ComponentNumber)
% .-----> scanning the element's controlPoints
% |                                                                               scanning the elements
% |                                                                                 ---------------->  .-----> scanning the element's controlPoints
% v the corresponding global DOF numbers of the current control point                  (3rd-D)         |
%   of the current knot patch                                                                          |
%                                                                                                      v the corresponding global DOF numbers of the current control point of the current knot patch

if isempty(obj.globalDOFNum); obj.constructGlobalNodeDOFNumbering; end

obj.nodalMapOfDOFLocal2Global = zeros(obj.totalNumberOfDOFperControlPoint, obj.Connectivities.numberOfFunctionsPerKnotPatch, obj.Connectivities.numberOfKnotPatches);

for elementIndex = 1:obj.Connectivities.numberOfKnotPatches
%     for controlPointIndex = 1:obj.Connectivities.numberOfFunctionsPerKnotPatch
%       node = obj.Connectivities.knotPatch2MultiParametricFunctions(elementIndex, controlPointIndex);
        obj.nodalMapOfDOFLocal2Global(:, :, elementIndex) = obj.globalDOFNum(:, squeeze(obj.Connectivities.knotPatch2MultiParametricFunctions(elementIndex, :)));
%     end
end

end
