function xn = interp1_warn(t, x, tn)
%{
Description:
  Perform 1-D interpolation using MAKIMA and issue a warning if
  extrapolation is detected.

Inputs:
  t     - Original time vector
  x     - Original signal vector
  tn    - New time vector for interpolation

Output:
  xn    - New signal vector interpolated (or extrapolated) at tn
%}
    t_min = min(t);
    t_max = max(t);
    tn_min = min(tn);
    tn_max = max(tn);
    
    duration = t_max - t_min;
    tol = 1e-5 * duration;
    
    if (tn_min < (t_min - tol)) or (tn_max > (t_max + tol))
        warning('extrapolation detected');
    end
    
    xn = interp1(t, x, tn, 'makima', 'extrap');
end
