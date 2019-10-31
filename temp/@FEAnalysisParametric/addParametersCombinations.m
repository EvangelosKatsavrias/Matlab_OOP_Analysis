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

function addParametersCombinations(obj, varargin)

%  Cartesian product of the parameters values
[A, B, C] = ndgrid(Input.ParametricAnalysis.Parameters(1).rangeOfValues, ...
             Input.ParametricAnalysis.Parameters(2).rangeOfValues, ...
             Input.ParametricAnalysis.Parameters(3).rangeOfValues);
Input.ParametricAnalysis.parametersGrid = {reshape(A, [], 1) reshape(B, [], 1) reshape(C, [], 1)};

Input.ParametricAnalysis.numberOfGridParameters = 1;
for index = 1: parameterIndex
    Input.ParametricAnalysis.numberOfGridParameters = ...
        Input.ParametricAnalysis.numberOfGridParameters* ...
        length(Input.ParametricAnalysis.Parameters(index).rangeOfValues);
end


%  Variable Data
Input.ParametricAnalysis.fields = {{'unknownVector'}};

Input.ParametricAnalysis.analysisData = {'Solution.hpRefinementResults(basisOrderIndex).hVariableData'};

end