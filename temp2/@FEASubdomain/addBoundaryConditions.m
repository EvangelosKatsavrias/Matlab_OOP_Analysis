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

function addBoundaryConditions(obj, varargin)

if nargin == 1; obj.BoundaryConditions.Dirichlet = FEADirichletBoundaryConditions; return; end

if isa(varargin{1}, 'char'); boundCondType = varargin{1};
else throw(MException('FEA:addBoundaryConditions', 'Wrong input arguments, provide the type of boundary conditions with a proper label (''Dirichlet'', ''Neumann'', ''Robin''), in the first argument.'));
end

switch boundCondType
    case 'Dirichlet'
        if isa(varargin{2}, 'cell'); obj.BoundaryConditions.Dirichlet = cat(2, obj.BoundaryConditions.Dirichlet, FEADirichletBoundaryConditions(varargin{2}));
        elseif isa(varargin{2}, 'FEADirichletBoundaryConditions'); obj.BoundaryConditions.Dirichlet = cat(2, obj.BoundaryConditions.Dirichlet, varargin{2});
        end
        
    case 'Neumann'
        if isa(varargin{2}, 'cell'); obj.BoundaryConditions.Neumann = cat(2, obj.BoundaryConditions.Neumann, FEANeumannBoundaryConditions(varargin{2}));
        elseif isa(varargin{2}, 'FEANeumannBoundaryConditions'); obj.BoundaryConditions.Neumann = cat(2, obj.BoundaryConditions.Neumann, varargin{2});
        end
        
    case 'Robin'
        if isa(varargin{2}, 'cell'); obj.BoundaryConditions.Robin = cat(2, obj.BoundaryConditions.Robin, FEARobinBoundaryConditions(varargin{2}));
        elseif isa(varargin{2}, 'FEARobinBoundaryConditions'); obj.BoundaryConditions.Robin = cat(2, obj.BoundaryConditions.Robin, varargin{2});
        end
        
    otherwise
        throw(MException('FEA:addBoundaryConditions', 'Wrong input arguments, provide the type of boundary conditions with a proper label (''Dirichlet'', ''Neumann'', ''Robin''), in the first argument.'));
end

end