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

function addExactSolution(obj, varargin)


ExactSolution.name = {};
ExactSolution.propertyNames = {};
ExactSolution.propertyValues = {};
ExactSolution.functions = {@(x, y)(x^2+y^2)};

obj.ExactSolutions(1) = ExactSolution;


%%  Exact solutions of the problem

%  Exact solutions evaluation points
% Input.PostProcess.Plots.exactEvaluationPoints = ...
% linspace(Input.Problem.physicalDomainLeftBoundary, ...
%          Input.Problem.physicalDomainRightBoundary, ...
%          Input.PostProcess.Plots.numberOfExactEvalPointsTotalDomain);

%%  Expression of solution
% Analytical solution for f(x)=1
% Input.PostProcess.seriesTerms = 1000;
% Input.PostProcess.exactSolutionExpression = @(n, x, t) -2/pi()*sum( (cos((1:n)*pi())-1)./(1:n).*sin((1:n)*pi()*x/Input.Problem.beamLength).*exp(-t*(pi()*(1:n)/Input.Problem.beamLength).^2) );
% 
% Input.PostProcess.exactSolutions{1} = ...
%     {'syms n x t', ...
%      'subs(Input.PostProcess.exactSolutionExpression(n, x, t), n, x, t)', ...
%      'Exact eigenfrequency f', 'f'};  % 1)symbolic variables, 2) calculation formula, 3) Title, 4) axis label

% % Analytical solution for f(x)=sin(pi*x)
% Input.PostProcess.exactSolutionExpression = ...
% @(n, x, t) 2*sum( ((1:n).*cos((1:n)*pi())*sin(Input.Problem.beamLength*pi())- ...
%                     Input.Problem.beamLength*sin((1:n)*pi())*cos(Input.Problem.beamLength*pi())) ...
%                   ./(Input.Problem.beamLength^2-(1:n).^2)/pi() ...
%                   .*sin((1:n)*pi()*x/Input.Problem.beamLength).*exp(-t*(pi()*(1:n)/Input.Problem.beamLength).^2) );

% % Analytical solution for the accelerations
% Input.PostProcess.exactSolutionExpression3 = ...
% @(n, x, t) sum( (2*pi()^3*(1:n).^4.*sin((pi()*(1:n)*x)/Input.Problem.beamLength).*((1:n)*sin(pi()*Input.Problem.beamLength).*cos(pi()*(1:n)) - ...
%                  Input.Problem.beamLength*cos(pi()*Input.Problem.beamLength)*sin(pi()*(1:n)))).* ...
%                  exp(-(pi()^2*(1:n).^2*t)/Input.Problem.beamLength^2) ...
%                  ./(Input.Problem.beamLength^4*(Input.Problem.beamLength^2 - (1:n).^2)) );
% 
% % Analytical solution for the gradient of accelerations
% Input.PostProcess.exactSolutionExpression4 = ...
% @(n, x, t) sum( (2*pi()^4*(1:n).^5.*cos((pi()*(1:n)*x)/Input.Problem.beamLength).*((1:n)*sin(pi()*Input.Problem.beamLength).*cos(pi()*(1:n)) - ...
%                  Input.Problem.beamLength*cos(pi()*Input.Problem.beamLength)*sin(pi()*(1:n)))).* ...
%                  exp(-(pi()^2*(1:n).^2*t)/Input.Problem.beamLength^2) ...
%                  ./(Input.Problem.beamLength^5*(Input.Problem.beamLength^2 - (1:n).^2)) );

% Input.PostProcess.exactSolutions{2} = ...
%     {'syms n x t', ...
%      'subs(Input.PostProcess.exactSolutionExpression1(n, x, t), n, x, t)', ...
%      'Exact eigenfrequency f', 'f'};  % 1)symbolic variables, 2) calculation formula, 3) Title, 4) axis label

 
% clear l1



end