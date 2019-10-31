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

function add_pRefinementData(obj, varargin)


Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.minBasisDegree_u = 1;
Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.maxBasisDegree_u = 6;
Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.rangeOfBasisDegree_u = ...
                linspace(Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.minBasisDegree_u, ...
                         Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.maxBasisDegree_u, ...
                         Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.maxBasisDegree_u - ...
                         Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.minBasisDegree_u+1);
                     
Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.minBasisDegree_v = 1;
Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.maxBasisDegree_v = 6;
Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.rangeOfBasisDegree_v = ...
                linspace(Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.minBasisDegree_v, ...
                         Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.maxBasisDegree_v, ...
                         Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.maxBasisDegree_v - ...
                         Subdomain.NumericalAnalysis.RefinedAnalysis.pRefinement.minBasisDegree_v+1);


% %%  
% Subdomain.NumericalAnalysis.RefinedAnalysis.hpRefinement.fields = {{'parentDomainLeftBoundary'} ...
%                              {'parentDomainRightBoundary'} ...
%                              {'generalizedCoords'} ...
%                              {'Quadratures'} ...
%                              {'basisFunctions'} ...
%                              {'IntegrationQuadratures'}};
%                         
% Subdomain.NumericalAnalysis.RefinedAnalysis.hpRefinement.analysisData = {'Input.AnalysisData.NumericalIntegration.parentDomainLeftBoundary' ...
%                                    'Input.AnalysisData.NumericalIntegration.parentDomainRightBoundary' ...
%                                    'Input.AnalysisData.NumericalIntegration.generalizedCoords' ...
%                                    'Input.AnalysisData.NumericalIntegration.Quadratures' ...
%                                    'Input.AnalysisData.NumericalIntegration.basisFunctions' ...
%                                    'Input.AnalysisData.NumericalIntegration.IntegrationQuadratures'};


end