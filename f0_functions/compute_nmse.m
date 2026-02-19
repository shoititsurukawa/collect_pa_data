function nmse_dB = compute_nmse(x_ref, x_est)
    % Ensure column vectors
    x_ref = x_ref(:);
    x_est = x_est(:);

    error_signal = x_ref - x_est;

    nmse = mean(abs(error_signal).^2) / mean(abs(x_ref).^2);
    nmse_dB = 10*log10(nmse);
end
