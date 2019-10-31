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

function addPDeltaPlot(obj, varargin)

%  Internal-External state curves (P-Delta)
obj.PDeltaPlot(1).nodes = [50 50]; % first node for the unknown component and second node for the internal state component
obj.PDeltaPlot(1).unknownTensorField = 1;
obj.PDeltaPlot(1).unknownTensorFieldComponent = 1;
obj.PDeltaPlot(1).internalStateTensorField = 1;
obj.PDeltaPlot(1).internalStateTensorFieldComponent = 2;
obj.PDeltaPlot(1).data = zeros(Input.SolverData.NonLinearSolver.numberOfExternalStateSteps, 2);
obj.PDeltaPlot(1).fileHandle = fopen([obj.folderPath 'Output/PlotFiles/PDeltaData1.txt'], 'w');

end