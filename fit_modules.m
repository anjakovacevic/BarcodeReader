function [mapping] = fit_modules(lengths, modules)
    % FIT_MODULES Maps lengths to their closest module values.
    % INPUTS:
    %   lengths - Vector of segment lengths
    %   modules - Vector of module lengths
    % OUTPUT:
    %   mapping - Vector mapping each length to the closest module

    % Validate inputs
    if isempty(lengths) || isempty(modules)
        error('Input vectors "lengths" and "modules" must not be empty.');
    end
    
    if ~isvector(lengths) || ~isvector(modules)
        error('Input arguments "lengths" and "modules" must be vectors.');
    end

    % Initialize the mapping vector
    mapping = zeros(length(lengths), 1);
    
    % Iterate over each length
    for i = 1:length(lengths)
        % Initialize the minimum delta length and mapping index
        delta_len = abs(lengths(i) - modules(1));
        mapping(i) = 1;
        
        % Compare the current length to all module lengths
        for j = 2:length(modules)
            current_delta_len = abs(lengths(i) - modules(j));
            if delta_len > current_delta_len
                mapping(i) = j;
                delta_len = current_delta_len;
            end
        end
    end
end
