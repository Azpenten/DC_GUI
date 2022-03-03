classdef DC_motor
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        La_mH;
        Ra;
        J;
        nn;
        Uan;
        Ian;
        Mc;
        % Надо посчитать
        La;
        kFi;
    end
    
    methods (Access = public)
        function obj = DC_motor()
        end
        function obj = importData(obj)
            mas = importdata(uigetfile('.mot','select file'));
            obj.La_mH = mas(1);
            obj.Ra = mas(2);
            obj.J = mas(3);
            obj.nn = mas(4);
            obj.Uan = mas(5);
            obj.Ian = mas(6);
            obj.Mc = mas(7);
            obj.La = obj.La_mH * 0.001;
            obj.kFi = (obj.Uan - obj.Ian * obj.Ra) / (2 * pi / 60 * obj.nn);
        end
        function dydt = DC_motor_eq(y,Uan,Ra,kFi,La,Mc,J)
        dydt = zeros(2,1);
        dydt(1) = (Uan - y(1) * Ra - kFi * y(2)) / La;
        dydt(2) = (kFi * y(1) - Mc) / J;
        end
    end
end

