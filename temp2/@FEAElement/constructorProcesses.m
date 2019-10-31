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

function constructorProcesses(obj, varargin)

obj.ExceptionsData.msgID = 'FEA:finiteElementInstitution';

if nargin == 1
    obj.TensorFields    = [FEATensorField('Displacement', 1, [1 2], 2) FEATensorField('Pressure', 0, [1 2], 2)];
    obj.Connectivities  = bSplineConnectivities;
    
else
    [tensorFieldFlag, tensorFieldPosition]  = searchArguments(varargin, 'TensorFields', 'FEATensorField');
    [connectFlag, connectPosition]          = searchArguments(varargin, 'Connectivities', 'bSplineConnectivities');
    [bilinFormsFlag, bilinFormsPosition]    = searchArguments(varargin, 'BilinearForms', 'FEABilinearForm');
    
    if tensorFieldFlag && connectFlag && bilinFormsFlag; throw(MException(obj.ExceptionsData.msgID, 'Wrong input data, provide the minimum required data for the constructor, i.e. one or more objects of the class FEATensorField, an object of the class FEAConnectivities and optionally one or more FEABilinearForm objects. Provide the data presceding the proper flag label.')); end
    
    if tensorFieldFlag; obj.TensorFields    = varargin{tensorFieldPosition}; else obj.TensorFields = [FEATensorField('Displacement', 1, [1 2], 2) FEATensorField('Pressure', 0, [1 2], 2)]; end
    if connectFlag;     obj.Connectivities  = varargin{connectPosition}; else obj.Connectivities = bSplineConnectivities; end
    if bilinFormsFlag;  obj.BilinearForms   = varargin{bilinFormsPosition}; end
    
end

obj.numberOfUnknownTensorFields = length(obj.TensorFields);

end