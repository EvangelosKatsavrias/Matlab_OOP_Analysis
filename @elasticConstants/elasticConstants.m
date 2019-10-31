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

classdef elasticConstants < handle

    properties
        mu      = 80.7692
        lambda  = 121.1538
        E       = 210
        nu      = 0.3
        G       = 80.7692
        K       = 175
    end
    
    methods
        function obj = elasticConstants(type, const1, const2)
            if nargin == 0; return; end
            switch type
                case 'Engineering'
                    obj.setEngineeringConstants(const1, const2);
                    
                case 'Lame'
                    obj.setLameConstants(const1, const2);
                    
                otherwise
                    throw(MException('elasticConstantsConverter:constructor', 'Provide valid input arguments.'));
                    
            end
        end
        
        function setLameConstants(obj, mu, lambda)
            obj.mu = mu; obj.lambda = lambda;
            obj.E = mu*(3*lambda+2*mu)/(lambda+mu);
            obj.nu = lambda/2/(lambda+mu);
            obj.G = obj.E/2/(1+obj.nu);
            obj.K = (3*lambda+2*mu)/3;
        end

        function setEngineeringConstants(obj, E, nu)
            obj.mu = E/2/(1+nu);
            obj.lambda = nu*E/(1+nu)/(1-2*nu);
            obj.E = E; obj.nu = nu;
            obj.G = obj.E/2/(1+obj.nu);
            obj.K = E/3/(1-2*nu);
        end
    end
    
    methods (Static)
        function [E, nu, G, K] = convertLame2Engineering(mu, lambda)
            if strcmp(obj.constantsType, 'Engineering'); return; end
            E = obj.mu*(3*lambda+2*mu)/(lambda+mu);
            nu = lambda/2/(lambda+mu);
            G = E/2/(1+nu);
            K = (3*lambda+2*mu)/3;
        end

        function [mu, lambda, K] = convertEngineering2Lame(E, nu)
            mu = E/2/(1+nu);
            lambda = nu*E/(1+nu)/(1-2*nu);
            K = E/3/(1-2*nu);
        end
    end

end