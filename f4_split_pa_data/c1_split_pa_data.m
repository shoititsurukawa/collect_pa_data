%% c1_pa_data.m
%{
Description:
  This script splits the PA data into extraction and validation sets. The
  extraction set is chosen to contain the largest signal amplitude, so that
  the model does not need to extrapolate during validation.

Input:
  - pa_data.mat (f3_pa_demod)

Output:
  - pa_data_ext_val.mat
%}
clear variables; close all; clc;
tic

%% Parameters
split_point = 2500;

%% Import Data
current_folder = fileparts(mfilename('fullpath'));
root_folder = fileparts(current_folder);
mat_file = fullfile(root_folder, 'f3_pa_demod', 'pa_data.mat');
data = load(mat_file);

% Structure
signal_1_in = data.signal_1_in;
signal_2_in = data.signal_2_in;
signal_1_out = data.signal_1_out;
signal_2_out = data.signal_2_out;

%% Split Data
% in_1
in_1_head = signal_1_in(1:split_point, :);
in_1_tail = signal_1_in(split_point+1:end, :);

% in_2
in_2_head = signal_2_in(1:split_point, :);
in_2_tail = signal_2_in(split_point+1:end, :);

% out_1
out_1_head = signal_1_out(1:split_point, :);
out_1_tail = signal_1_out(split_point+1:end, :);

% out_2
out_2_head = signal_2_out(1:split_point, :);
out_2_tail = signal_2_out(split_point+1:end, :);

%% Voting Logic

% Helper function for peak detection
max_abs = @(x) max(abs(x(:)));

% Head
m_in1_h = max_abs(in_1_head);
m_in2_h = max_abs(in_2_head);
m_out1_h = max_abs(out_1_head);
m_out2_h = max_abs(out_2_head);

% Tail
m_in1_t = max_abs(in_1_tail);
m_in2_t = max_abs(in_2_tail);
m_out1_t = max_abs(out_1_tail);
m_out2_t = max_abs(out_2_tail);

% Calculate Head Score
head_score = 0;
if m_in1_h  >= m_in1_t; head_score = head_score + 1; end
if m_in2_h  >= m_in2_t; head_score = head_score + 1; end
if m_out1_h >= m_out1_t; head_score = head_score + 1; end
if m_out2_h >= m_out2_t; head_score = head_score + 1; end

%% Assign Extraction and Validation Sets
% Logic: Use the majority side for extraction for ALL signals
if head_score > 2
    fprintf('Decision: Majority favors HEAD for extraction.\n');
    % Extraction = Head
    in_1_extraction = in_1_head;
    in_2_extraction = in_2_head;
    out_1_extraction = out_1_head;
    out_2_extraction = out_2_head;
    % Validation = Tail
    in_1_validation = in_1_tail;
    in_2_validation = in_2_tail;
    out_1_validation = out_1_tail;
    out_2_validation = out_2_tail;
    
elseif head_score < 2
    fprintf('Decision: Majority favors TAIL for extraction.\n');
    % Extraction = Tail
    in_1_extraction = in_1_tail;
    in_2_extraction = in_2_tail;
    out_1_extraction = out_1_tail;
    out_2_extraction = out_2_tail;
    % Validation = Head
    in_1_validation = in_1_head;
    in_2_validation = in_2_head;
    out_1_validation = out_1_head;
    out_2_validation = out_2_head;
    
else
    % Tied (2 vs 2) - Defaulting to Head
    fprintf('Warning: 50/50 tie! Defaulting to HEAD for extraction.\n');
    % Extraction = Head
    in_1_extraction = in_1_head;
    in_2_extraction = in_2_head;
    out_1_extraction = out_1_head;
    out_2_extraction = out_2_head;
    % Validation = Tail
    in_1_validation = in_1_tail;
    in_2_validation = in_2_tail;
    out_1_validation = out_1_head;
    out_2_validation = out_2_head;
end

%% Print Summary Table
fprintf('\nSignal      | Head Val | Tail Val | Winner \n');
fprintf('Signal 1 In | %8.4f | %8.4f | %s\n', m_in1_h, m_in1_t, char(idx_to_str(m_in1_h >= m_in1_t)));
fprintf('Signal 2 In | %8.4f | %8.4f | %s\n', m_in2_h, m_in2_t, char(idx_to_str(m_in2_h >= m_in2_t)));
fprintf('Signal 1 Out| %8.4f | %8.4f | %s\n', m_out1_h, m_out1_t, char(idx_to_str(m_out1_h >= m_out1_t)));
fprintf('Signal 2 Out| %8.4f | %8.4f | %s\n', m_out2_h, m_out2_t, char(idx_to_str(m_out2_h >= m_out2_t)));
fprintf('Final Head Score: %d / 4\n', head_score);

%% Save Results
save_file = fullfile(current_folder, 'pa_data_ext_val.mat');

save(save_file, ...
    'in_1_extraction', 'in_1_validation', ...
    'in_2_extraction', 'in_2_validation', ...
    'out_1_extraction', 'out_1_validation', ...
    'out_2_extraction', 'out_2_validation');

fprintf('\nData successfully split and saved to:\n%s\n', save_file);
toc

%% Function
function s = idx_to_str(is_head)
    % Returns string 'Head' if true, otherwise 'Tail'
    if is_head
        s = "Head";
    else
        s = "Tail";
    end
end