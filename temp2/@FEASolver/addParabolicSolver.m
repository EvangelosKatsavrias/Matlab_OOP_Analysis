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

function addParabolicSolver(obj, varargin)

if ~isempty(obj.findprop('ParabolicSolver')); obj.addprop('ParabolicSolver'); end

%  Parabolic Time Scheme Solver
obj.ParabolicSolver.timeSchemeSolver = 'ode23t'; % 'Explicit-Euler', 'Central-Differences', 'Trapezoidal-CrankNicolson', 'Euler_Enhanced', 'ode15s', 'ode23t', 'ode23s', 'odetb', 'ode45', 'ode23'
obj.ParabolicSolver.TimeSchemeOptions = odeset('InitialStep', TimeDomain.intervalTime, 'MaxStep', TimeDomain.intervalTime);%odeset('RelTol', 1e-4, 'AbsTol', 1e-4);

end