function [modules] = find_modules(base_peak, peaks_w, peaks_b)
    % FIND_MODULES Calculates the module lengths based on the base peak and peaks
    % in white and black pixel length histograms.
    % INPUTS:
    %   base_peak - Base peak length for the module
    %   peaks_w   - Array of peak lengths for white segments
    %   peaks_b   - Array of peak lengths for black segments
    % OUTPUT:
    %   modules   - Calculated module lengths

    % Initialize the modules array with values based on the base peak
    modules = base_peak:base_peak:5*base_peak;
    modules(5) = modules(4) * 2;

    % Iterate to refine the module lengths based on the histogram peaks
    for j = 2:length(modules) - 1
        modules(j) = modules(j - 1) + modules(1);
        for i = 2:min(length(peaks_b), length(peaks_w))
            % Check if the black peak is close to the current module length
            if abs(peaks_b(i) - modules(j)) < modules(1) / 2
                % Check if the white peak is also close to the current module length
                if abs(peaks_w(i) - modules(j)) < modules(1) / 2
                    % Average the black and white peaks to refine the module length
                    modules(j) = (peaks_b(i) + peaks_w(i)) / 2;
                    break;
                end
            end
        end
    end
end
