## Copyright (C) 1995, 1996, 1997  Kurt Hornik
## 
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details. 
## 
## You should have received a copy of the GNU General Public License
## along with this file.  If not, write to the Free Software Foundation,
## 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

## usage:  gamma_cdf (x, a, b)
##
## For each element of x, compute the cumulative distribution function
## (CDF) at x of the Gamma distribution with parameters a and b.

## Author:  TT <Teresa.Twaroch@ci.tuwien.ac.at>
## Description:  CDF of the Gamma distribution
  
function cdf = gamma_cdf (x, a, b)
  
  if (nargin != 3)
    usage ("gamma_cdf (x, a, b)");
  endif
  
  [retval, x, a, b] = common_size (x, a, b);
  if (retval > 0)
    error ("gamma_cdf:  x, a and b must be of common size or scalars");
  endif
  
  [r, c] = size (x);
  s = r * c;
  x   = reshape (x, s, 1);
  a   = reshape (a, s, 1);
  b   = reshape (b, s, 1);
  cdf = zeros (s, 1);
  
  k = find (!(a > 0) | !(b > 0) | isnan (x));
  if any (k)
    cdf (k) = NaN * ones (length (k), 1);
  endif
  
  k = find ((x > 0) & (a > 0) & (b > 0));
  if any (k)
    cdf (k) = gammai (a(k), b(k) .* x(k));
  endif
    
  cdf = reshape (cdf, r, c);
  
endfunction
