function rotatedImg = manual_rotate(img, angle, bgColor)
    % MANUAL_ROTATE Rotates an image by a specified angle with a given background color.
    % INPUTS:
    %   img     - Input image to be rotated
    %   angle   - Rotation angle in degrees
    %   bgColor - Background color to fill in the empty spaces after rotation
    % OUTPUT:
    %   rotatedImg - Rotated image with specified background color

    % Convert angle from degrees to radians
    angle = deg2rad(angle);

    % Get image dimensions
    [rows, cols] = size(img);

    % Calculate the size of the new image
    newRows = ceil(abs(rows * cos(angle)) + abs(cols * sin(angle)));
    newCols = ceil(abs(cols * cos(angle)) + abs(rows * sin(angle)));

    % Create an empty image with the new size and fill it with the background color
    rotatedImg = bgColor * ones(newRows, newCols, 'like', img);

    % Calculate the center of the original image
    centerX = cols / 2;
    centerY = rows / 2;

    % Calculate the center of the new image
    newCenterX = newCols / 2;
    newCenterY = newRows / 2;

    % Iterate over every pixel in the new image
    for i = 1:newRows
        for j = 1:newCols
            % Calculate the coordinates of the corresponding pixel in the original image
            x = (j - newCenterX) * cos(angle) + (i - newCenterY) * sin(angle) + centerX;
            y = -(j - newCenterX) * sin(angle) + (i - newCenterY) * cos(angle) + centerY;

            % If the coordinates are within the bounds of the original image, copy the pixel value
            if x >= 1 && x <= cols && y >= 1 && y <= rows
                rotatedImg(i, j) = img(round(y), round(x));
            end
        end
    end
end
