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

% if nargin == 1
%     obj.tensorFieldNumber           = 1;
%     obj.tensorFieldDerivativeOrder  = 1;
%     obj.controlPoints               = [1 1 2 2];
%     obj.directions                  = [1 2 1 2];
%     obj.values                      = [10 10 10 10];
%     obj.impositionMethod            = 1;
%     return
% end


% ConcentratedNeumann.tensorFieldNumber = 1;
% ConcentratedNeumann.tensorFieldDerivativeOrder = 1;
% ConcentratedNeumann.boundaryNumber = 1;
% ConcentratedNeumann.domainOfDefinition = 'Parametric';
% ConcentratedNeumann.pointLocation = 0.2; % In normalized parametric (0-1)
% ConcentratedNeumann.directionCoordSystem = 'Physical';
% ConcentratedNeumann.direction = {@(u)(0) @(u)(1)};   % [dx dy]
% ConcentratedNeumann.function = @(u)(1000);
% ConcentratedNeumann.numberOfIntegrationPoints = 2;
% 
% 
% DistributedNeumann.tensorFieldNumber = 1;
% DistributedNeumann.tensorFieldDerivativeOrder = 1;
% DistributedNeumann.boundaryNumber = 2;
% DistributedNeumann.domainOfDefinition = 'Parametric';
% DistributedNeumann.domainInterval = [0 1]; % In normalized parametric (0-1)
% DistributedNeumann.directionCoordSystem = 'Physical';
% DistributedNeumann.direction = {@(u)(0) @(u)(1)};   % [dx dy]
% DistributedNeumann.function = @(u)(1000000);
% DistributedNeumann.numberOfIntegrationPoints = 2;


end