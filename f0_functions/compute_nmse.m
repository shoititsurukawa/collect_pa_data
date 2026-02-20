function nmse_dB = compute_nmse(x_ref, x_est)
%{
Description:
  Compute normalized mean square error (NMSE) in dB between a reference
  signal and an estimated signal.

Inputs:
  x_ref - Reference signal
  x_est - Estimated signal

Output:
  nmse_dB = NMSE value in dB
%}
    % Ensure column vectors
    x_ref = x_ref(:);
    x_est = x_est(:);

    error_signal = x_ref - x_est;

    nmse = mean(abs(error_signal).^2) / mean(abs(x_ref).^2);
    nmse_dB = 10*log10(nmse);
end
