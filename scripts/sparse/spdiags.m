## Copyright (C) 2000-2001 Paul Kienzle
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

## -*- texinfo -*-
## @deftypefn {function File} {[@var{b}, @var{c}]} = spdiags (@var{a})
## @deftypefnx {function File} {@var{b}} = spdiags (@var{a}, @var{c})
## @deftypefnx {function File} {@var{b}} = spdiags (@var{v}, @var{c}, @var{a})
## @deftypefnx {function File} {@var{b}} = spdiags (@var{v}, @var{c}, @var{m}, @var{n})
## A generalization of the function @code{spdiag}. Called with a single
## input argument, the non-zero diagonals @var{c} of @var{A} are extracted.
## With two arguments the diagonals to extract are given by the vector 
## @var{c}.
##
## The other two forms of @code{spdiags} modify the input matrix by
## replacing the diagonals. They use the columns of @var{v} to replace
## the columns represented by the vector @var{c}. If the sparse matrix
## @var{a} is defined then the diagonals of this matrix are replaced.
## Otherwise a matrix of @var{m} by @var{n} is created with the
## diagonals given by @var{v}.
##
## Negative values of @var{c} representive diagonals below the main
## diagonal, and positive values of @var{c} diagonals above the main
## diagonal.
##
## For example
##
## @example
## @group
## spdiags (reshape (1:12, 4, 3), [-1 0 1], 5, 4)
## @result{}    5 10  0  0
##       1  6 11  0
##       0  2  7 12
##       0  0  3  8
##       0  0  0  4
## @end group
## @end example
##
## @end deftypefn

function [A, c] = spdiags(v,c,m,n)

  wfi = warn_fortran_indexing;
  unwind_protect
    warn_fortran_indexing = 0;
    
    if nargin == 1 || nargin == 2
      ## extract nonzero diagonals of v into A,c
      [i,j,v,nr,nc] = spfind(v);
      if nargin == 1
        c = unique(j-i);  # c contains the active diagonals
      endif
      ## FIXME: we can do this without a loop if we are clever
      offset = max(min(c,nc-nr),0);
      A = zeros(min(nr,nc),length(c));
      for k=1:length(c)
	idx = find(j-i == c(k));
	A(j(idx)-offset(k),k) = v(idx);
      end
    elseif nargin == 3
      ## Replace specific diagonals c of m with v,c
      [nr,nc] = size(m);
      B = spdiags(m,c);
      A = m - spdiags(B,c,nr,nc) + spdiags(v,c,nr,nc);
    else
      ## Create new matrix of size mxn using v,c
      [j,i,v] = find(v);
      offset = max(min(c(:),n-m),0);
      j+=offset(i);
      i=j-c(:)(i);
      idx = i>0 & i<=m & j>0 & j<=n;
      A = sparse(i(idx),j(idx),v(idx),m,n);
      
    endif
    
  unwind_protect_cleanup
    warn_fortran_indexing = wfi;
  end_unwind_protect

endfunction
