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

function addParameters(obj, varargin)

parameterIndex = 1;
Input.ParametricAnalysis.Parameters(parameterIndex).name = 'a';
Input.ParametricAnalysis.Parameters(parameterIndex).originalParameter = 'Input.Problem.parameters(1).value';
Input.ParametricAnalysis.Parameters(parameterIndex).minValue = 0;
Input.ParametricAnalysis.Parameters(parameterIndex).maxValue = 1000;
Input.ParametricAnalysis.Parameters(parameterIndex).rangeOfValues = [0 1 10 100];
% ...
% linspace(Input.ParametricAnalysis.Parameters(parameterIndex).minValue, ...
%          Input.ParametricAnalysis.Parameters(parameterIndex).maxValue, ...
%          6);

end