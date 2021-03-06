% JTL_3 test in matlab (Voltage Source Pulse)
clear;
%% Constants
hbar_2e = 3.038510188E15;
hn = 0.25E-12;
N = 4000;

%% JJ Model
rN = 16;
r0 = 160;
vG = 2.8E-3;
C = 0.07E-12;
Icrit = 0.1E-3;

%% Components
VA_mat = zeros(18, 18);
IB_mat = zeros(18, 18);
L1_mat = zeros(18, 18);
L2_mat = zeros(18, 18);
L3_mat = zeros(18, 18);
L4_mat = zeros(18, 18);
L5_mat = zeros(18, 18);
R1_mat = zeros(18, 18);
B1_mat = zeros(18, 18);
B2_mat = zeros(18, 18);
%% Component Values
L1 = 2E-12;
L2 = 2.4E-12;
L3 = 2.4E-12;
L4 = 2E-12;
L5 = 0.278E-12;
R1 = 2;
RB1 = 5.23;
RB2 = 5.23;
%% Component rubberstamps
% VA
VA_mat(1,9) = 1;
VA_mat(9,1) = 1;
% L1
L1_mat(1,10) = 1;
L1_mat(2,10) = -1;
L1_mat(10,1) = 1;
L1_mat(10,2) = -1;
L1_mat(10,10) = -2 * L1 / hn;
% L2
L2_mat(2,11) = 1;
L2_mat(3,11) = -1;
L2_mat(11,2) = 1;
L2_mat(11,3) = -1;
L2_mat(11,11) = -2 * L2 / hn;
% L3
L3_mat(3,12) = 1;
L3_mat(4,12) = -1;
L3_mat(12,3) = 1;
L3_mat(12,4) = -1;
L3_mat(12,12) = -2 * L3 / hn;
% L4
L4_mat(4,13) = 1;
L4_mat(5,13) = -1;
L4_mat(13,4) = 1;
L4_mat(13,5) = -1;
L4_mat(13,13) = -2 * L4 / hn;
% L5
L5_mat(6,14) = 1;
L5_mat(3,14) = -1;
L5_mat(14,6) = 1;
L5_mat(14,3) = -1;
L5_mat(14,14) = -2 * L5 / hn;
% IB
IB_mat(6,15) = -1;
IB_mat(15,15) = 1;
% R1
R1_mat(5,16) = 1;
R1_mat(16,5) = -1/R1;
R1_mat(16,16) = -1;
% B1
B1_mat(2,17) = 1;
B1_mat(7,2) = -hn/2 * hbar_2e;
B1_mat(7,7) = 1;
B1_mat(17,2) = 2*C / hn + 1/r0 + 1/RB1;
B1_mat(17,17) = -1;
% B2
B2_mat(4,18) = 1;
B2_mat(8,4) = -hn/2 * hbar_2e;
B2_mat(8,8) = 1;
B2_mat(18,4) = 2*C / hn + 1/r0 + 1/RB2;
B2_mat(18,18) = -1;

%% A Matrix Assembly
A_00 = VA_mat + IB_mat + L1_mat + L2_mat + L3_mat + L4_mat + L5_mat + R1_mat + B1_mat + B2_mat;
B1_mat(17,2) = (2 * C / hn) + (1/rN);
A_n0 = VA_mat + IB_mat + L1_mat + L2_mat + L3_mat + L4_mat + L5_mat + R1_mat + B1_mat + B2_mat;
B1_mat(17,2) = (2 * C / hn) + (1/r0);
B2_mat(18,4) = (2 * C / hn) + (1/rN);
A_0n = VA_mat + IB_mat + L1_mat + L2_mat + L3_mat + L4_mat + L5_mat + R1_mat + B1_mat + B2_mat;
B1_mat(17,2) = (2 * C / hn) + (1/rN);
B2_mat(18,4) = (2 * C / hn) + (1/rN);
A_nn = VA_mat + IB_mat + L1_mat + L2_mat + L3_mat + L4_mat + L5_mat + R1_mat + B1_mat + B2_mat;

%% Sources
VA = 0;
IB = 0;
VA = zeros(1, 800-1);
for i = (200E-12/hn - 1):(205E-12/hn - 1)
    VA = [VA, (600E-6 - 0)/(205E-12 - 200E-12) * (i*hn - 200E-12)];
end
for i = (205E-12/hn):(210E-12/hn - 1)
    VA = [VA, 600E-6 + (0 - 600E-6)/(210E-12 - 205E-12) * (i*hn - 205E-12)];
end
VA = [VA, zeros*ones(1, N-840)];
for i = 1:(5E-12/hn - 1)
    IB = [IB, (280E-6 - 0)/(5E-12 - 0) * (i*hn)];
end
IB = [IB, 280E-6*ones(1,N-20)];

%% Time, RHS, LHS and Storage variables
T = zeros(1, N);
RHS = zeros(1, 18);
LHS = zeros(1, 18);
V_N1 = zeros(1, N);
V_N2 = zeros(1, N);
V_N3 = zeros(1, N);
V_N4 = zeros(1, N);
V_N5 = zeros(1, N);
V_N6 = zeros(1, N);
V_Phi1 = zeros(1, N);
V_Phi2 = zeros(1, N);
I_VA = zeros(1, N);
I_L1 = zeros(1, N);
I_L2 = zeros(1, N);
I_L3 = zeros(1, N);
I_L4 = zeros(1, N);
I_L5 = zeros(1, N);
I_IB = zeros(1, N);
I_R1 = zeros(1, N);
I_B1 = zeros(1, N);
I_B2 = zeros(1, N);

%% A initial
A = A_00;

%% Initial conditions
VN2_2 = 0;
VN2_1d = 0;
VN2_2d = 0;
VN4_2 = 0;
VN4_1d = 0;
VN4_2d = 0;

%% Time loop
for i = 1:N
    % Previous Values
    VN1_1 = LHS(1);
    VN2_1 = LHS(2);
    VN2_1d = (2/hn)*(VN2_1 - VN2_2) - VN2_2d;
    VN2_2 = VN2_1;
    VN2_2d = VN2_1d;
    VN3_1 = LHS(3);
    VN4_1 = LHS(4);
    VN4_1d = (2/hn)*(VN4_1 - VN4_2) - VN4_2d;
    VN4_2 = VN4_1;
    VN4_2d = VN4_1d;
    VN5_1 = LHS(5);
    VN6_1 = LHS(6);
    VPhi1_1 = LHS(7);
    VPhi2_1 = LHS(8);
    IVA_1 = LHS(9);
    IL1_1 = LHS(10);
    IL2_1 = LHS(11);
    IL3_1 = LHS(12);
    IL4_1 = LHS(13);
    IL5_1 = LHS(14);
    IIB_1 = LHS(15);
    IR1_1 = LHS(16);
    IB1_1 = LHS(17);
    IB2_1 = LHS(18);
    % Junction current values
    IsB1 = -Icrit * sin(VPhi1_1 + hn/2 * hbar_2e * (VN2_1 + VN2_1 + hn*(VN2_1d))) + ((2*C/hn) * VN2_1) + (C * VN2_1d);
    IsB2 = -Icrit * sin(VPhi2_1 + hn/2 * hbar_2e * (VN4_1 + VN4_1 + hn*(VN4_1d))) + ((2*C/hn) * VN4_1) + (C * VN4_1d);
    % Right hand side in-time values
    RHS_N1 = 0;  
    RHS_N2 = 0;
    RHS_N3 = 0;
    RHS_N4 = 0;
    RHS_N5 = 0;
    RHS_N6 = 0;
    RHS_phi1 = VPhi1_1 + (hn/2 * hbar_2e)*(VN2_1);
    RHS_phi2 = VPhi2_1 + (hn/2 * hbar_2e)*(VN4_1);
    RHS_VA = VA(i);
    RHS_IL1 = (-2 * L1 / hn)*(IL1_1) - (VN2_1 - VN1_1);
    RHS_IL2 = (-2 * L2 / hn)*(IL2_1) - (VN3_1 - VN2_1);
    RHS_IL3 = (-2 * L3 / hn)*(IL3_1) - (VN4_1 - VN3_1);
    RHS_IL4 = (-2 * L4 / hn)*(IL4_1) - (VN5_1 - VN4_1);
    RHS_IL5 = (-2 * L5 / hn)*(IL5_1) - (VN3_1 - VN6_1);
    RHS_IB = IB(i);
    RHS_IR1 = 0;
    RHS_IB1 = IsB1;
    RHS_IB2 = IsB2;
    % RHS assembly
    RHS = [RHS_N1; RHS_N2; RHS_N3; RHS_N4; RHS_N5; RHS_N6; RHS_phi1; RHS_phi2; RHS_VA; RHS_IL1; RHS_IL2; RHS_IL3; RHS_IL4; RHS_IL5; RHS_IB; RHS_IR1; RHS_IB1; RHS_IB2];
    % Ax = b solve
    LHS = A\RHS;
    % Data storage
    V_N1(i) = abs(LHS(1));
    V_N2(i) = abs(LHS(2));
    V_N3(i) = abs(LHS(3));
    V_N4(i) = abs(LHS(4));
    V_N5(i) = abs(LHS(5));
    V_N6(i) = abs(LHS(6));
    V_Phi1(i) = abs(LHS(7));
    V_Phi2(i) = abs(LHS(8));
    I_VA(i) = LHS(9);
    I_L1(i) = LHS(10);
    I_L2(i) = LHS(11);
    I_L3(i) = LHS(12);
    I_L4(i) = LHS(13);
    I_L5(i) = LHS(14);
    I_IB(i) = LHS(15);
    I_R1(i) = LHS(16);
    I_B1(i) = LHS(17);
    I_B2(i) = LHS(18);
    % Time storage
    T(i) = hn*i;
    % Vgap threshold check
    if LHS(1) > vG
        if LHS(3) > vG
            A = A_nn;
        else
            A = A_n0;
        end
    else
        if LHS(3) > vG
            A = A_0n;
        else
            A = A_00;
        end
    end
end
%% Plotting
figure;
subplot(4, 2, 1);
plot(T, V_N1);
title('V\_N1');
subplot(4, 2, 2);
plot(T, V_N2);
title('V\_N2');
subplot(4, 2, 3);
plot(T, V_N3);
title('V\_N3');
subplot(4, 2, 4);
plot(T, V_N4);
title('V\_N4');
subplot(4, 2, 5);
plot(T, V_N5);
title('V\_N5');
subplot(4, 2, 6);
plot(T, V_N6);
title('V\_N6');
subplot(4, 2, 7);
plot(T, I_L5);
title('I\_L5');
subplot(4, 2, 8);
plot(T, I_B1);
title('I\_B1');