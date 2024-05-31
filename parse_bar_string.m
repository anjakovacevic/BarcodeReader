function [barcode] = parse_bar_string(line, lengths, mapping)
    % PARSE_BAR_STRING Parses length mappings into a barcode string.
    % INPUTS:
    %   line     - Binarized line of the image
    %   lengths  - Vector of segment lengths
    %   mapping  - Vector mapping each length to the closest module
    % OUTPUT:
    %   barcode  - Parsed barcode string, where 0 represents a black bar module and 1 represents a white bar module

    barcode = zeros(95,1) - 1;
    pos = 1;
    i = 1;
    curr = 0;
    while pos < length(line)
        if mapping(i) == 5
            pos = pos + lengths(i);
        else
            for j = 1:mapping(i)
                if line(1,pos) == 1
                    barcode(curr+j) = 0;
                else
                    barcode(curr+j) = 1;
                end
            end
            curr = curr + mapping(i);
            pos = pos + lengths(i);
        end
        i = i + 1;
    end
    
    barcode = barcode + 1;
    barcode = nonzeros(barcode);
    barcode = barcode - 1;
end
