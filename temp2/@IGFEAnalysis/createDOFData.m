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

function createDOFData(obj, varargin)

obj.DOFData.totalNumberOfDOFperControlPoint = sum([obj.SpatialSubdomains.TensorFields.numberOfDOFperControlPoint]);
obj.DOFData.totalNumberOfDOFperElement      = obj.Connectivities.numberOfFunctionsPerKnotPatch*obj.DOFData.totalNumberOfDOFperControlPoint;
obj.DOFData.totalNumberOfDOFinSubdomain     = obj.Connectivities.numberOfFunctionsInBSplinePatch*obj.DOFData.totalNumberOfDOFperControlPoint;

% Global nodal DOF numbering
globalNodeDOFNumbering(obj, varargin{:});

% Map DOF global numbering to elemental nodes, based on connectivity and topology data
localNodeDOFNumbering(obj);

% Map DOF from local elemental numbering to global
localElementalDOF2GlobalDOF(obj, varargin{:});

end


%%  
function globalNodeDOFNumbering(obj, varargin)
% DOF numbering with respect to the global control points numbering
%
% GlobalDOFNumber = globalDOFNumberingMethod(ControlPointNumber, fieldNumber-ComponentNumber)
% .-----> scanning the control points in global numbering sequence
% |
% |
% v scanning sequencially firstly the fields and for each field its components (but the DOF numbering of them is not unique, scanning in system outside->inside order(in for-loops): controlPoints-fields-components or fields-controlPoints-components or components-controlPoints)

if nargin > 1; numberingType = varargin{1}; else numberingType = 'EachField'; end

obj.DOFData.globalDOFNum = zeros(obj.DOFData.totalNumberOfDOFperControlPoint, obj.Connectivities.numberOfFunctionsInBSplinePatch);

switch numberingType
    case 'AllFields' % controlPoints-fields-components
        for controlPointIndex = 1:obj.Connectivities.numberOfFunctionsInBSplinePatch
            obj.DOFData.globalDOFNum(:, controlPointIndex) = (controlPointIndex-1)*obj.DOFData.totalNumberOfDOFperControlPoint +(1:obj.DOFData.totalNumberOfDOFperControlPoint);
        end

    case 'EachField' % fields-controlPoints-components  (classical segregated form)
        nodeDOFShift    = 0;
        fieldDOFShift   = 0;
        for fieldIndex = 1:obj.numberOfUnknownTensorFields
            numberOfDOF = obj.TensorFields(fieldIndex).numberOfDOFperControlPoint;
            for controlPointIndex = 1:obj.Connectivities.numberOfFunctionsInBSplinePatch
                obj.DOFData.globalDOFNum((1:numberOfDOF)+nodeDOFShift, controlPointIndex) = fieldDOFShift +(controlPointIndex-1)*numberOfDOF +(1:numberOfDOF);
            end
            nodeDOFShift    = nodeDOFShift +numberOfDOF;
            fieldDOFShift   = nodeDOFShift*obj.Connectivities.numberOfFunctionsInBSplinePatch;
        end
        
    case 'EachComponent' % components-controlPoints (each component scans sequencially all the controlPoints)
        totalNumberOfComponents = sum([obj.TensorFields.numberOfDOFperControlPoint]);
        for componentIndex = 1:totalNumberOfComponents
            obj.DOFData.globalDOFNum(componentIndex, :) = (componentIndex -1)*obj.Connectivities.numberOfFunctionsInBSplinePatch +(1:obj.Connectivities.numberOfFunctionsInBSplinePatch);
        end
        
end

end

%%  
function localNodeDOFNumbering(obj)
% Map DOF global numbering to elemental nodes, based on connectivity and topology data
%
% GlobalDOFNumber = localNode2globalNodemapper(element, localElementalNodeNumber, fieldNumber-ComponentNumber)
% .-----> scanning the element's controlPoints                       
% |                                                                               scanning the elements
% |                                                                                 ---------------->  .-----> scanning the element's controlPoints
% v scanning sequencially firstly the fields and for each field its components         (3rd-D)         |
%                                                                                                      |
%                                                                                                      v scanning sequencially firstly the fields and for each field its components

obj.DOFData.nodalMapOfDOFLocal2Global = zeros(obj.DOFData.totalNumberOfDOFperControlPoint, obj.Connectivities.numberOfFunctionsPerKnotPatch, obj.Connectivities.numberOfKnotPatches);

for elementIndex = 1:obj.Connectivities.numberOfKnotPatches
    for controlPointIndex = 1:obj.Connectivities.numberOfFunctionsPerKnotPatch
        node = obj.Connectivities.knotPatch2MultiParametricFunctions(elementIndex, controlPointIndex);
        obj.DOFData.nodalMapOfDOFLocal2Global(:, controlPointIndex, elementIndex) = obj.DOFData.globalDOFNum(:, node);
    end
end

end


%%  
function localElementalDOF2GlobalDOF(obj, varargin)
% Map DOF from local elemental numbering to global
%
% GlobalDOFNumber = localElementDOF2globalDOFMapper(element, localElementalNodeNumber-fieldNumber-ComponentNumber)
% .-----> scanning the element's DOF with various ways (scanning in element outside->inside order(in for-loops): controlPoints-fields-components or fields-controlPoints-components or components-controlPoints)
% |
% |
% v scanning the elements

[flag, position] = searchArguments(varargin, 'ElementalDOFNumbering', 'char');
if flag; elementDOFNumberingType = varargin{position}; else elementDOFNumberingType = 'EachComponent'; end

obj.DOFData.mapOfDOFLocal2Global = zeros(obj.DOFData.totalNumberOfDOFperElement, obj.Connectivities.numberOfKnotPatches);

switch elementDOFNumberingType
    case 'AllFields' % controlPoints-fields-components
        for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
            obj.DOFData.mapOfDOFLocal2Global(:, knotPatchIndex) = reshape(obj.DOFData.nodalMapOfDOFLocal2Global(:, :, knotPatchIndex), 1, []);
        end
        
    case 'EachField' % fields-controlPoints-components
        nodeDOFShift    = 0;
        fieldDOFShift   = 0;
        for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
            for fieldIndex = 1:obj.numberOfUnknownTensorFields
                numberOfDOF = obj.TensorFields(fieldIndex).numberOfDOFperControlPoint;
                obj.DOFData.mapOfDOFLocal2Global((1:numberOfDOF*obj.Connectivities.numberOfFunctionsPerKnotPatch)+fieldDOFShift, knotPatchIndex) = reshape(obj.DOFData.nodalMapOfDOFLocal2Global((1:numberOfDOF)+nodeDOFShift, :, knotPatchIndex), 1, []);
                nodeDOFShift    = nodeDOFShift  +numberOfDOF;
                fieldDOFShift   = fieldDOFShift +numberOfDOF*obj.Connectivities.numberOfFunctionsPerKnotPatch;
            end
        end

    case 'EachComponent' % components-fields-controlPoints (each component scans sequencially all the controlPoints)
        totalNumberOfComponents = sum([obj.TensorFields.numberOfDOFperControlPoint]);
        for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
            for componentIndex = 1:totalNumberOfComponents
                DOFShift = (componentIndex-1)*obj.Connectivities.numberOfFunctionsPerKnotPatch;
                obj.DOFData.mapOfDOFLocal2Global((1:obj.Connectivities.numberOfFunctionsPerKnotPatch)+DOFShift, knotPatchIndex) = obj.DOFData.nodalMapOfDOFLocal2Global(componentIndex, :, knotPatchIndex);
            end
        end
        
end

end