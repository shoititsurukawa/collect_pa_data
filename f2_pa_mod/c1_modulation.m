%% c1_modulation.m
%{
Description:
  This script implements the modulation for a dual-band system. It uses as
  input the data collected in Cadence sources. The transmitted signal
  is saved in a .pwl file.

Input:
  - source_signal_1 (f1_source_data)

Output:
  - transmitted_signal.pwl
%}
clear; clc; close all;
tic

%% Importing functions
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
functions_folder = fullfile(root_folder, 'f0_functions');
addpath(functions_folder);

%% Parameters
cfg = simulation_config();
freq_carrier_1 = cfg.freq_carrier_1;
freq_carrier_2 = cfg.freq_carrier_2;

% Local
P_dB = -34;
do_plot = true;

%% Importing data
% Path
source_folder = fullfile(root_folder, 'f1_source_data');
source_file = fullfile(source_folder, 'source_signal_1.mat');
disp(['Data imported from: ', source_file]);

% Structure
data = load(source_file);
time_baseband = data.time_baseband;
s1_baseband = data.s1_baseband;
s2_baseband = data.s2_baseband;

%% Normalization
P1 = mean(abs(s1_baseband).^2);
P2 = mean(abs(s2_baseband).^2);

s1_baseband = s1_baseband / sqrt(P1);
s2_baseband = s2_baseband / sqrt(P2);

%% Modulation
[freq_oversampling, time_oversampled, transmitted_signal] = modulate_makima(freq_carrier_1, freq_carrier_2, time_baseband, s1_baseband, s2_baseband, do_plot);

%% Normalization
% Normalize to unit average power
transmitted_signal = transmitted_signal / sqrt(mean(abs(transmitted_signal).^2));

% Apply desired relative power level (dB)
transmitted_signal = transmitted_signal * 10^(P_dB/20);

% Check power
P_check_dB = 10*log10(mean(abs(transmitted_signal).^2));
fprintf('PA input power = %.2f dB\n', P_check_dB);

% Check peak value
max_val = max(abs(transmitted_signal));
fprintf('Peak magnitude = %.2e\n', max_val);

%% Save in .pwl file
% Get folder of current script
script_folder = fileparts(mfilename('fullpath'));
pwl_filename = fullfile(script_folder, 'transmitted_signal.pwl');

% Combine time and signal into two columns
data_to_save = [time_oversampled, transmitted_signal];

% Open file
fid = fopen(pwl_filename, 'w');
if fid == -1
    error('Could not open file %s for writing.', pwl_filename);
end

% Write data as two columns: time, signal
% note the transpose for column-wise fprintf
fprintf(fid, '%.16e,%.16e\n', data_to_save.');
fclose(fid);

disp(['Data saved as: ', pwl_filename]);

toc
