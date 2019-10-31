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

classdef IGFEADOFMapper < handle
    
    properties
        Connectivities
        TensorFields
        
        globalDOFNumberingType = 'EachField' % AllFields, EachField, EachComponent
        elementalDOFNumberingType = 'EachComponent' % AllFields, EachField, EachComponent

        globalDOFNum
        nodalMapOfDOFLocal2Global
        mapOfDOFLocal2Global
        numberOfUnknownTensorFields
        componentsLocalDOF
        totalNumberOfDOFperControlPoint
        totalNumberOfDOFperElement
        totalNumberOfDOFinSubdomain
        
    end
    
    methods
        function obj = IGFEADOFMapper(varargin)
            if nargin == 0
                obj.Connectivities = bSplineConnectivities;
                obj.TensorFields = FEATensorField;
            else
                obj.Connectivities  = varargin{1};
                obj.TensorFields    = varargin{2};
            end
            
            obj.totalNumberOfDOFperControlPoint = sum([obj.TensorFields.numberOfDOFperControlPoint]);
            obj.totalNumberOfDOFperElement      = obj.Connectivities.numberOfFunctionsPerKnotPatch*obj.totalNumberOfDOFperControlPoint;
            obj.totalNumberOfDOFinSubdomain     = obj.Connectivities.numberOfFunctionsInBSplinePatch*obj.totalNumberOfDOFperControlPoint;
            obj.numberOfUnknownTensorFields     = length(obj.TensorFields);
            
            obj.componentsLocalDOF{1} = (1:obj.TensorFields(1).numberOfDOFperControlPoint);
            for fieldIndex = 2:obj.numberOfUnknownTensorFields
                obj.componentsLocalDOF{fieldIndex} = obj.componentsLocalDOF{fieldIndex-1}(end)+(1:obj.TensorFields(fieldIndex).numberOfDOFperControlPoint);
            end
            
        end
        
        constructGlobalNodeDOFNumbering(obj, varargin);
        constructLocalNodeDOFNumbering(obj);
        constructLocalElementalDOF2GlobalDOF(obj, varargin);
        createDOFData(obj, varargin);
        
    end
    
end