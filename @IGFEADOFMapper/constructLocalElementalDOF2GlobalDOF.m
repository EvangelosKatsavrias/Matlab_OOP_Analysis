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

function constructLocalElementalDOF2GlobalDOF(obj, varargin)
% Map DOF from local elemental numbering to global
%
% GlobalDOFNumber = localElementDOF2globalDOFMapper(element, localElementalNodeNumber-fieldNumber-ComponentNumber)
% .-----> scanning the elements
% |
% |
% v scanning the element's DOF with various ways (scanning in element outside->inside order(in for-loops): controlPoints-fields-components or fields-controlPoints-components or components-controlPoints)

if nargin > 1; obj.elementalDOFNumberingType = varargin{1}; end

if isempty(obj.nodalMapOfDOFLocal2Global); obj.constructLocalNodeDOFNumbering; end

obj.mapOfDOFLocal2Global = zeros(obj.totalNumberOfDOFperElement, obj.Connectivities.numberOfKnotPatches);

switch obj.elementalDOFNumberingType
    case 'AllFields' % controlPoints-fields-components (outside to inside for-loops), [u11, v11, th11, u12, v12, th12, ...]
        for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
            obj.mapOfDOFLocal2Global(:, knotPatchIndex) = reshape(obj.nodalMapOfDOFLocal2Global(:, :, knotPatchIndex), 1, []);
        end
        
    case 'EachField' % fields-controlPoints-components, [u11, v11, u12, v12, ..., th11, th12, ...]
        nodeDOFShift    = 0;
        fieldDOFShift   = 0;
        for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
            for fieldIndex = 1:obj.numberOfUnknownTensorFields
                numberOfDOF = obj.TensorFields(fieldIndex).numberOfDOFperControlPoint;
                obj.mapOfDOFLocal2Global((1:numberOfDOF*obj.Connectivities.numberOfFunctionsPerKnotPatch)+fieldDOFShift, knotPatchIndex) = reshape(obj.nodalMapOfDOFLocal2Global((1:numberOfDOF)+nodeDOFShift, :, knotPatchIndex), 1, []);
                nodeDOFShift    = nodeDOFShift  +numberOfDOF;
                fieldDOFShift   = fieldDOFShift +numberOfDOF*obj.Connectivities.numberOfFunctionsPerKnotPatch;
            end
        end
        
    case 'EachComponent' % fields-components-controlPoints, [u11, u12, ..., v11, v12, ..., th11, th12, ...]
        totalNumberOfComponents = sum([obj.TensorFields.numberOfDOFperControlPoint]);
        for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
            for componentIndex = 1:totalNumberOfComponents
                DOFShift = (componentIndex-1)*obj.Connectivities.numberOfFunctionsPerKnotPatch;
                obj.mapOfDOFLocal2Global((1:obj.Connectivities.numberOfFunctionsPerKnotPatch)+DOFShift, knotPatchIndex) = obj.nodalMapOfDOFLocal2Global(componentIndex, :, knotPatchIndex);
            end
        end
        
end

end