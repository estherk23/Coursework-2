
function temp_monitor(a, tempLowThreshold, tempHighThreshold, blinkIntervalLow, blinkIntervalHigh)
    % digital pins for each LED
    redLED = 'D8';
    yellowLED = 'D10';
    greenLED = 'D12';

    % Configure digital pins as outputs
    configurePin(a, redLED, 'DigitalOutput');
    configurePin(a, yellowLED, 'DigitalOutput');
    configurePin(a, greenLED, 'DigitalOutput');

    % Creating a live plot to display temperature
    figure;
    h = animatedline('Color', 'b', 'Marker', 'o', 'LineWidth', 2);
    xlabel('Time');
    ylabel('Temperature (°C)');
    title('Real-Time Temperature Monitoring');
    grid on;
    ax = gca; % Get the current axis
    ax.XGrid = 'on'; % Ensure the grid is turned on
    ax.YGrid = 'on';

    startTime = datetime('now');

    % Continuous monitoring loop
    while true
        % Read temperature from the sensor
        voltage = readVoltage(a, 'A2');  % conversion from voltage to temperature
        temperature = (voltage - 0.5) * 100;  % conversion formula
        
        % Add new data to the plot
        timeElapsed =  datetime('now');
        addpoints(h, datenum(timeElapsed), temperature); % Plotting using datetime converted to datenum
        ax.XLim = datenum([timeElapsed - minutes(1), timeElapsed]); % Update x-axis limits to show last 1 minute
        datetick('x', 'HH:MM:SS', 'keeplimits'); % Keep the limits fixed
        drawnow;

        % Control LEDs based on temperature
        if temperature < tempLowThreshold
            blinkLED(a, yellowLED, blinkIntervalLow);
        elseif temperature > tempHighThreshold
            blinkLED(a, redLED, blinkIntervalHigh);
        else
            writeDigitalPin(a, greenLED, 1);  % Turn green LED on
            writeDigitalPin(a, redLED, 0);    % Turn red LED off
            writeDigitalPin(a, yellowLED, 0); % Turn yellow LED off
        end

        pause(1);  % Update every second
    end
end

function blinkLED(a, ledPin, interval)
    writeDigitalPin(a, ledPin, 1);
    pause(interval / 2);
    writeDigitalPin(a, ledPin, 0);
    pause(interval / 2);
end

