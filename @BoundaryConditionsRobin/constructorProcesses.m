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
%     obj.essentialPartValue          = [10 10 10 10];
%     obj.NaturalPartValue            = [10 10 10 10];
%     obj.impositionMethod            = 1;
%     return
% end


% ConcentratedRobin.tensorFieldNumber = 1;
% ConcentratedRobin.tensorFieldDerivativeOrder = 1;
% ConcentratedRobin.boundaryNumber = 1;
% ConcentratedRobin.domainOfDefinition = 'Parametric';
% ConcentratedRobin.pointLocation = 0.2; % In normalized parametric (0-1)
% ConcentratedRobin.directionCoordSystem = 'Physical';
% ConcentratedRobin.direction = {@(u)(0) @(u)(1)};   % [dx dy]
% ConcentratedRobin.essentialPartfunction = @(u)(1000);
% ConcentratedRobin.naturalPartfunction = @(u)(1000);
% ConcentratedRobin.numberOfIntegrationPoints = 2;
% 
% DistributedRobin.tensorFieldNumber = 1;
% DistributedRobin.tensorFieldDerivativeOrder = 1;
% DistributedRobin.boundaryNumber = 2;
% DistributedRobin.domainOfDefinition = 'Parametric';
% DistributedRobin.domainInterval = [0.1 0.9]; % In normalized parametric (0-1)
% DistributedRobin.directionCoordSystem = 'Physical';
% DistributedRobin.direction = {@(u)(0) @(u)(1)};   % [dx dy]
% DistributedRobin.essentialPartfunction = @(u)(u);
% DistributedRobin.naturalPartfunction = @(u)(u);
% DistributedRobin.numberOfIntegrationPoints = 2;

end