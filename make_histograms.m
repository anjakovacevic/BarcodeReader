function [len_list, len_hist_w, len_hist_b] = make_histograms(bin_line)
    % MAKE_HISTOGRAMS Creates histograms of white and black pixel segment lengths 
    % from a binarized image line.
    % INPUT:
    %   bin_line - Binarized line (array) of pixels
    % OUTPUTS:
    %   len_list   - List of lengths of same-color pixel segments, from start to end of the line
    %   len_hist_w - Histogram of white pixel lengths
    %   len_hist_b - Histogram of black pixel lengths

    % Initialize output arrays
    len_list = zeros(length(bin_line), 1);
    len_hist_w = zeros(length(bin_line) + 1, 1);
    len_hist_b = zeros(length(bin_line) + 1, 1);

    % Initialize current length and pixel value
    curr_len = 1;
    curr_pix = bin_line(1);
    j = 1;
    counted = 0;

    % Iterate through the binarized line to calculate segment lengths
    for i = 2:length(bin_line)
        if curr_pix == bin_line(i)
            curr_len = curr_len + 1;
            counted = 1;
        else
            % Record the current segment length
            len_list(j) = curr_len;
            if curr_pix
                len_hist_w(curr_len) = len_hist_w(curr_len) + 1;
            else
                len_hist_b(curr_len) = len_hist_b(curr_len) + 1;
            end
            % Reset for the next segment
            curr_len = 1;
            curr_pix = bin_line(i);
            j = j + 1;
            counted = 0;
        end
    end

    % Record the last segment length if it was counted
    if counted
        len_list(j) = curr_len;
        if curr_pix
            len_hist_w(curr_len) = len_hist_w(curr_len) + 1;
        else
            len_hist_b(curr_len) = len_hist_b(curr_len) + 1;
        end
    end

    % Remove zero entries from the list of segment lengths
    len_list = nonzeros(len_list);
    % Trim trailing zeros from the histograms
    len_hist_w = cutoff_histogram(len_hist_w);
    len_hist_b = cutoff_histogram(len_hist_b);
end
