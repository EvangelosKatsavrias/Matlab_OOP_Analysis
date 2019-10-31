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

function add_hRefinementData(obj, varargin)

Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.minNumberOfKnotSpans_u = 2;
Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.maxNumberOfKnotSpans_u = 8;
Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.rangeOfKnotSpans_u = ...
    pow2(linspace(floor(log2(Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.minNumberOfKnotSpans_u)), ...
                   ceil(log2(Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.maxNumberOfKnotSpans_u)), ...
                   ceil(log2(Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.maxNumberOfKnotSpans_u)) - ...
                  floor(log2(Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.minNumberOfKnotSpans_u))+1));

Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.minNumberOfKnotSpans_v = 2;
Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.maxNumberOfKnotSpans_v = 8;
Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.rangeOfKnotSpans_v = ...
    pow2(linspace(floor(log2(Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.minNumberOfKnotSpans_v)), ...
                   ceil(log2(Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.maxNumberOfKnotSpans_v)), ...
                   ceil(log2(Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.maxNumberOfKnotSpans_v)) - ...
                  floor(log2(Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.minNumberOfKnotSpans_v))+1));


% %%  
% Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.fields = {{'unknownVector'} ...
%                             {'DOFData'} ...
%                             {'MeshData'} ...
%                             {'Jacobians'}};
%                         
% Subdomain.NumericalAnalysis.RefinedAnalysis.hRefinement.analysisData = {'Solution.unknownVector' ...
%                                   'Input.AnalysisData.DOFData' ...
%                                   'Input.AnalysisData.MeshData' ...
%                                   'Input.AnalysisData.NumericalIntegration.Jacobians'};

end