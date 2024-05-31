function [peaks] = find_peaks(hist)
    % FIND_PEAKS Identifies peaks in a histogram.
    % In the case of equal neighboring bins, the latter is chosen as a peak.
    % INPUT:
    %   hist  - Input histogram array
    % OUTPUT:
    %   peaks - Indices of the peaks in the histogram

    % Initialize the peaks array
    peaks = zeros(length(hist), 1);
    p = 1;

    % Iterate through the histogram to find peaks
    for i = 2:length(hist) - 1
        if (hist(i) >= hist(i - 1)) && (hist(i) > hist(i + 1))
            peaks(p) = i;
            p = p + 1;
        end
    end

    % Remove zero entries from the peaks array
    peaks = nonzeros(peaks);
end
