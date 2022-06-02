function [u] = PID(e,e_p,u_p)
    Z_r = 45;
    T_i = 6;
    T_s = 1;
    u_d = Z_r*(e-e_p)+ Z_r/T_i*T_s*e;
    u = u_p+u_d;
end