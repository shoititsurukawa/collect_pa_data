function xn = interp1_makima_warn(t, x, tn)
    
    t_min = min(t);
    t_max = max(t);
    tn_min = min(tn);
    tn_max = max(tn);
    
    duration = t_max - t_min;
    tol = 1e-5 * duration;
    
    if (tn_min < (t_min - tol)) or (tn_max > (t_max + tol))
        warning('makima extrapolation detected');
    end
    
    xn = interp1(t, x, tn, 'makima', 'extrap');
end

