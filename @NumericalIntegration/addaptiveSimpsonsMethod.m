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

function addaptiveSimpsonsMethod(obj)

% // Recursive auxiliary function for adaptiveSimpsons() function below
% //
% double adaptiveSimpsonsAux(double (*f)(double), double a, double b, double epsilon,
% double S, double fa, double fb, double fc, int bottom) {
% double c = (a + b)/2, h = b - a;
% double d = (a + c)/2, e = (c + b)/2;
% double fd = f(d), fe = f(e);
% double Sleft = (h/12)*(fa + 4*fd + fc);
% double Sright = (h/12)*(fc + 4*fe + fb);
% double S2 = Sleft + Sright;
% if (bottom <= 0 || fabs(S2 - S) <= 15*epsilon)
%     return S2 + (S2 - S)/15;
%     return adaptiveSimpsonsAux(f, a, c, epsilon/2, Sleft,  fa, fc, fd, bottom-1) +
%     adaptiveSimpsonsAux(f, c, b, epsilon/2, Sright, fc, fb, fe, bottom-1);
%     }
%     
%     //
%     // Adaptive Simpson's Rule
%     //
%     double adaptiveSimpsons(double (*f)(double),   // ptr to function
%     double a, double b,  // interval [a,b]
%     double epsilon,  // error tolerance
%     int maxRecursionDepth) {   // recursion cap
%     double c = (a + b)/2, h = b - a;
%     double fa = f(a), fb = f(b), fc = f(c);
%     double S = (h/6)*(fa + 4*fc + fb);
%     return adaptiveSimpsonsAux(f, a, b, epsilon, S, fa, fb, fc, maxRecursionDepth);
%     }
%     
%     
%     int main(){
%     double I = adaptiveSimpsons(sin, 0, 1, 0.000000001, 10); // compute integral of sin(x)
%     // from 0 to 1 and store it in
%     // the new variable I
%     printf("I = %lf\n",I); // print the result
%     return 0;
%     }
%     
end