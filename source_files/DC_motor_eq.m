    function dydt = DC_motor_eq(y,Uan,Ra,kFi,La,Mc,J)
            dydt = zeros(2,1);
            dydt(1) = (Uan - y(1) * Ra - kFi * y(2)) / La;
            dydt(2) = (kFi * y(1) - Mc) / J;
    end

