function [base_peak, found] = find_base_peak(len_peaks_w, len_peaks_b)
    % FIND_BASE_PEAK Determines the base peak length for a module by comparing
    % the first peaks of the white and black length histograms.
    % INPUTS:
    %   len_peaks_w - Array of peak lengths for white segments
    %   len_peaks_b - Array of peak lengths for black segments
    % OUTPUTS:
    %   base_peak - Calculated base peak length for the module
    %   found     - Indicator if a valid base peak was found (1) or not (0)

    % Initialize the output variables
    base_peak = -1;
    found = 0;

    % Check if the first peaks of the white and black lengths are different
    if len_peaks_w(1) ~= len_peaks_b(1)
        % Check if the first black peak is approximately twice or half the first white peak
        if (len_peaks_b(1) > (len_peaks_w(1) / 2)) && ((len_peaks_b(1) * 2) > len_peaks_w(1))
            % Calculate the base peak as the average of the first peaks
            base_peak = round((len_peaks_b(1) + len_peaks_w(1)) / 2);
            found = 1;
        else
            % Set base peak to -1 and found to 0 if no valid base peak is found
            base_peak = -1;
            found = 0;
        end
    else
        % If the first peaks are the same, use the first white peak as the base peak
        base_peak = len_peaks_w(1);
        found = 1;
    end
end
