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

function constructGlobalNodeDOFNumbering(obj, varargin)
% DOF numbering with respect to the global control points numbering
%
% GlobalDOFNumber = globalDOFNumberingMethod(ControlPointNumber, fieldNumber-ComponentNumber)
% .-----> scanning the control points in global numbering sequence
% |
% |
% v scanning sequencially firstly the fields and for each field its components (but the DOF numbering of them is not unique, scanning in system outside->inside order(in for-loops): controlPoints-fields-components or fields-controlPoints-components or components-controlPoints)

if nargin > 1; obj.globalDOFNumberingType = varargin{1}; end

switch obj.globalDOFNumberingType
    case 'AllFields' % controlPoints-fields-components (for-loops from outside to inside), [u11, v11, th11, u12, v12, th12, ...]
        obj.globalDOFNum = reshape((1:obj.totalNumberOfDOFperControlPoint*obj.Connectivities.numberOfFunctionsInBSplinePatch), obj.totalNumberOfDOFperControlPoint, obj.Connectivities.numberOfFunctionsInBSplinePatch);

    case 'EachField' % fields-controlPoints-components  (classical segregated form) (for-loops from outside to inside), [u11, v11, u12, v12, ..., th11, th12, ...]
        obj.globalDOFNum = zeros(obj.totalNumberOfDOFperControlPoint, obj.Connectivities.numberOfFunctionsInBSplinePatch);
        nodeDOFShift    = 0;
        fieldDOFShift   = 0;
        for fieldIndex = 1:obj.numberOfUnknownTensorFields
            numberOfDOF = obj.TensorFields(fieldIndex).numberOfDOFperControlPoint;
            for controlPointIndex = 1:obj.Connectivities.numberOfFunctionsInBSplinePatch
                obj.globalDOFNum((1:numberOfDOF)+nodeDOFShift, controlPointIndex) = fieldDOFShift +(controlPointIndex-1)*numberOfDOF +(1:numberOfDOF);
            end
            nodeDOFShift    = nodeDOFShift +numberOfDOF;
            fieldDOFShift   = nodeDOFShift*obj.Connectivities.numberOfFunctionsInBSplinePatch;
        end
        
    case 'EachComponent' % fields-components-controlPoints (each component scans sequencially all the controlPoints) (for-loops from outside to inside), [u11, u12, ..., v11, v12, ..., th11, th12, ...]
        obj.globalDOFNum = zeros(obj.totalNumberOfDOFperControlPoint, obj.Connectivities.numberOfFunctionsInBSplinePatch);
        totalNumberOfComponents = sum([obj.TensorFields.numberOfDOFperControlPoint]);
        for componentIndex = 1:totalNumberOfComponents
            obj.globalDOFNum(componentIndex, :) = (componentIndex -1)*obj.Connectivities.numberOfFunctionsInBSplinePatch +(1:obj.Connectivities.numberOfFunctionsInBSplinePatch);
        end
        
end

end