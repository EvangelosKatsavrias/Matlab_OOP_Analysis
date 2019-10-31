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

classdef FEAnalysisType
    
    enumeration
        Eigenvalue1D    ('Eigenvalue',  1)
        Steady1D        ('Steady',      1)
        Parabolic1D     ('Parabolic',   1)
        Hyperbolic1D    ('Hyperbolic',  1)
        Eigenvalue2D    ('Eigenvalue',  2)
        Steady2D        ('Steady',      2)
        Parabolic2D     ('Parabolic',   2)
        Hyperbolic2D    ('Hyperbolic',  2)
        Eigenvalue3D    ('Eigenvalue',  3)
        Steady3D        ('Steady',      3)
        Parabolic3D     ('Parabolic',   3)
        Hyperbolic3D    ('Hyperbolic',  3)
    end
    
    properties
        analysisType
        spatialDimensions
    end
    
    methods
        function obj = FEAnalysisType(varargin)
            obj.analysisType        = varargin{1};
            obj.spatialDimensions   = varargin{2};
        end
    end
    
end