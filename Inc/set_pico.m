function [] = set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, channel, range)
%SET_PICO Summary of this function goes here
%   Detailed explanation goes here
    if channel == 'A'
        [status.setChA] = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_A, PicoConstants.TRUE, ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC, range, 0.0);
    elseif channel == 'B'
        [status.setChB] = invoke(ps5000aDeviceObj, 'ps5000aSetChannel', ps5000aEnuminfo.enPS5000AChannel.PS5000A_CHANNEL_B, PicoConstants.TRUE, ps5000aEnuminfo.enPS5000ACoupling.PS5000A_AC, range, 0.0);
    else
        disp('Only Channels "A" and  "B" are supported');
    end
end

