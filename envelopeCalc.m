% Samuel Rohrer and Bob Malinas
% 11/30/16
% envelopes
% take in filename and return feature vector of envelopes

function [envelopes] = envelopeCalc( frames )
    
    % read in the file
    % [y, Fs] = audioread(filename);
    % y = y(:,1);
    envelopes = [];
    for i=1:size(frames,2)
        % find what y should be
        y = frames(:, i);

        % normalize to account for different signal amplitudes
        valSignal = trapz(abs(y)).^2;
        y = y / valSignal;

        % calculate the signal envelope from taking abs of 
        % Hilbert transform
        envelope = abs(hilbert(y));
        % calculate total spectral energy of signal
        % env_coeff(1) = trapz(envelope);
        
        % find max value
        maxVal = max(envelope);
        
        % compute the magnitude of envelope with threshold
        % we threshold (somewhat arbitrarily) at 1/2, 5/9, 2/3, 5/8, 3/4, 7/8
        env_coeff(1) = trapz(envelope(envelope > (maxVal/2)));
        env_coeff(2) = trapz(envelope(envelope > (5*maxVal/9)));
        env_coeff(3) = trapz(envelope(envelope > (5*maxVal/8)));
        env_coeff(4) = trapz(envelope(envelope > (2*maxVal/3)));
        env_coeff(5) = trapz(envelope(envelope > (3*maxVal/4)));
        env_coeff(6) = trapz(envelope(envelope > (7*maxVal/8)));

        % to make it the same magnitude as the MFCCs
        env_coeff = 1e7 * env_coeff;
        envelopes = [ envelopes env_coeff.'];
    end
end