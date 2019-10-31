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

function addHyperbolicSolver(obj, varargin)

if ~isempty(obj.findprop('HyperbolicSolver')); obj.addprop('HyperbolicSolver'); end

obj.HyperbolicSolver.massMatrixType = 'Consistent'; % 'Consistent', 'Lumped'

%  Hyperbolic Time Scheme Solver
obj.HyperbolicSolver.dynamicSolverType = 'Mode-Superposition'; % 'Central-Differences', 'Houbolt', 'theta-Wilson', 'Newmark', 'Mode-Superposition'
% Time integration scheme for the standart form of the mode-superposition method
obj.HyperbolicSolver.standartFormTimeIntegration = 'Newmark'; % 'Exact', 'Central-Differences', 'Houbolt', 'theta-Wilson', 'Newmark'

% Houbolt method parameters
obj.HyperbolicSolver.HouboltParameters.timeIntervalFraction = 1;

% Theta-Wilson method parameters
obj.HyperbolicSolver.ThetaWilsonParameters.theta = 1.4;

% Newmark method parameters
obj.HyperbolicSolver.NewmarkParameters.delta = 0.5;
obj.HyperbolicSolver.NewmarkParameters.alpha = 0.25;

end