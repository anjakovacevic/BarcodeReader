function [rotatedImg, angle] = rotate_barcode(img)
    % ROTATE_BARCODE Rotates the input image to align the barcode horizontally.
    % INPUTS:
    %   img     - Input image containing a barcode
    % OUTPUTS:
    %   rotatedImg - Rotated image with the barcode aligned horizontally
    %   angle      - Angle by which the image was rotated

    % Check if the image is in color and convert to grayscale if necessary
    if size(img, 3) == 3
        img = rgb2gray(img); % Convert to grayscale if it is a color image
    end

    % Compute the 2D Fourier Transform of the image
    F = fft2(double(img));
    F = fftshift(F); % Center the FFT
    magnitude = abs(F); % Get the magnitude
    magnitude = log(magnitude + 1);

    % Define thresholds and find points above the threshold
    threshold = max(magnitude(:)) * 0.5; % Threshold at 50% of the max value
    [Y, X] = find(magnitude > threshold);

    % Adjust coordinates to center
    [rows, cols] = size(img);
    X = X - cols / 2;
    Y = Y - rows / 2;

    % Perform linear regression to find the angle of the barcode
    if var(X) > var(Y)
        p = polyfit(X, Y, 1); % Fit Y = p1*X + p2
        angle = atan(p(1)) - 0.05; % Angle relative to the horizontal axis
    else
        p = polyfit(Y, X, 1); % Fit X = p1*Y + p2
        angle = atan(1 / p(1)) - 0.05;
    end

    % Convert angle to degrees and adjust for rotation
    angle = rad2deg(angle);
    if angle > 90
        angle = angle - 180;
    elseif angle < -90
        angle = angle + 180;
    end

    % Rotate the image to make the barcode horizontal using manual_rotate function
    rotatedImg = manual_rotate(img, -angle, 255);
end
