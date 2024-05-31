function [cut_hist] = cutoff_histogram(hist)
    % CUTOFF_HISTOGRAM Trims the trailing zeros from the end of a histogram.
    % INPUT:
    %   hist    - Input histogram array
    % OUTPUT:
    %   cut_hist - Trimmed histogram with trailing zeros removed

    % Initialize the maximum index where the histogram has a non-zero value
    max_hist = 0;

    % Iterate through the histogram to find the last non-zero value
    for i = 1:length(hist)
        if hist(i) > 0
            max_hist = i;
        end
    end

    % Cut off the histogram at the last non-zero value
    cut_hist = hist(1:max_hist + 1);
end
