function cfg = simulation_config()
    
    % f1_source_data > c1_split_data
    cfg.freq_baseband = 123e6;
    
    % f2_pa_mod > c1_modulation
    cfg.freq_carrier_1 = 1.800e9;
    cfg.freq_carrier_2 = 5.400e9;
    
    % f3_pa_demod > c1_resample
    cfg.freq_passband = 37.8e9;
    
end
