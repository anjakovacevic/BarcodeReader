function [bar_code, found] = read_barcode(I)
    % READ_BARCODE Reads the barcode from an image using multiple scan lines.
    % INPUTS:
    %   I          - Input image
    % OUTPUTS:
    %   bar_code   - Decoded barcode
    %   found      - Indicator if the barcode was found (1) or not (0)

    % Convert image to grayscale if it is not already
    try
        I = im2gray(I);
    catch
        error('Input image cannot be converted to grayscale.');
    end

    % Get image dimensions
    [y, x] = size(I);
    bar_code = -1 * ones(13, 1);
    found = 0;
    num_scans = 15;
    
    % Check for low quality image
    if x <= 95 || y <= 95
        disp('Low quality picture');
        return;
    else
        % Calculate distance between scan lines
        dscan_y = floor(y / (num_scans + 2));
        codes_found = 0;

        % Iterate over each scan line
        for line = dscan_y:dscan_y:dscan_y * (num_scans + 1)
            L = I(line, :);

            % Find optimal threshold for the scan line
            T = graythresh(L);
            bw_L = imbinarize(L, T);  % Binarized scan line

            % Create histograms of segment lengths
            [len_list, len_hist_w, len_hist_b] = make_histograms(bw_L);

            % Find peaks in the histograms
            len_peaks_w = find_peaks(len_hist_w);
            len_peaks_b = find_peaks(len_hist_b);

            % Check if peaks are found
            if isempty(len_peaks_b) || isempty(len_peaks_w)
                continue;
            end

            % Compare black and white peaks to find the base peak
            [base_peak, bp_found] = find_base_peak(len_peaks_w, len_peaks_b);
            if ~bp_found
                continue;
            end

            % Find module lengths
            len_moduli = find_modules(base_peak, len_peaks_w, len_peaks_b);

            % Categorize lengths by modules
            len_map = fit_modules(len_list, len_moduli);

            % Remove quiet zones
            [bw_L, len_list, len_map, flag] = remove_quiet_zones(bw_L, len_list, len_map);
            if ~flag
                continue;
            end
            
            % Create barcode string from lengths and modules
            bcode = parse_bar_string(bw_L, len_list, len_map);
            
            % Decode the barcode
            if length(bcode) == 95
                [kod, potvrda] = decode_bar_EAN_13(bcode);
            elseif length(bcode) == 67
                [kod, potvrda] = decode_bar_EAN_8(bcode);
                bar_code = bar_code(1:8);
            else
                potvrda = 0;
            end

            % Check if a valid barcode was found
            if potvrda
                bar_code = kod;
                codes_found = codes_found + 1;
            else
                continue;
            end
        end
    end

    % Set found flag if any barcodes were found
    if codes_found > 0
        found = 1;
    end
end
