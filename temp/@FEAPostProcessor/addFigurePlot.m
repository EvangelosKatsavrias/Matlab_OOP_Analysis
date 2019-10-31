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

function addFigurePlot(obj, varargin)

Plot.plotName = {};
Plot.propertyNames = {'evaluationPointsPerElement'};
Plot.propertyValues = {10};

%  Snapshot of output figure plots
Plot.snapshotSwitch = 'on';

Plot.snapfolder = 'Output/Figures';
if (~isdir([obj.folderPath '/' snapfolder]))
    mkdir([obj.folderPath '/' snapfolder])
end
Plot.snapshotPath = [obj.folderPath '/' snapfolder '/'];
clear snapfolder

Plot.snapshotFormats = {'.jpg' '.eps'};


obj.Plots(1) = Plot;

end