% Matlab DCSFQ Simulation
% Constants
hn = 0.25E-12;
phi0 = 2.06783383113E-15;
hbar_2e = 2 * pi / phi0;
T = 1000E-12;
N = 4000;
% JJ model properties
jjVgap = 2.8E-3;
jjCap = 0.07E-12;
jjR0 = 160;
jjRn = 16;
jjIcrit = 0.1E-3;
% Components
L01 = 0.848E-12;L02 = 7.712E-12;L03 = 1.778E-12;L04 = 0.543E-12;L05 = 3.149E-12;
L06 = 1.323E-12;L07 = 1.095E-12;L08 = 2.951E-12;L09 = 1.63E-12;LP01 = 0.398E-12;
LP02 = 0.211E-12;LP03 = 0.276E-12;LP04 = 0.224E-12;LPR01 = 0.915E-12;
LPR02 = 0.307E-12;LRB01 = 1E-12;LRB02 = 1E-12;LRB03 = 1E-12;LRB04 = 1E-12;
LRB05 = 1E-12;RB01 = 8.56;RB02 = 11.30;RB03 = 7.53;RB04 = 5.77;RB05 = 5.77;
ROUT = 2;
% Junctions
B01AREA = 1.32;B01CAP = jjCap * B01AREA;B01RN = jjRn / B01AREA;B01R0 = jjR0 / B01AREA;B01ICRIT = jjIcrit * B01AREA;
B02AREA = 1;B02CAP = jjCap * B02AREA;B02RN = jjRn / B02AREA;B02R0 = jjR0 / B02AREA;B02ICRIT = jjIcrit * B02AREA;
B03AREA = 1.5;B03CAP = jjCap * B03AREA;B03RN = jjRn / B03AREA;B03R0 = jjR0 / B03AREA;B03ICRIT = jjIcrit * B03AREA;
B04AREA = 1.96;B04CAP = jjCap * B04AREA;B04RN = jjRn / B04AREA;B04R0 = jjR0 / B04AREA;B04ICRIT = jjIcrit * B04AREA;
B05AREA = 1.96;B05CAP = jjCap * B05AREA;B05RN = jjRn / B05AREA;B05R0 = jjR0 / B05AREA;B05ICRIT = jjIcrit * B05AREA;
% Column indices
C_PB01 = 1;C_NV5 = 2;C_NV3 = 3;C_PB02 = 4;C_NV6 = 5;C_PB03 = 6;C_NV9 = 7;
C_NV10 = 8;C_PB04 = 9;C_NV13 = 10;C_NV14 = 11;C_PB05 = 12;C_NV15 = 13;
C_NV16 = 14;C_NV8 = 15;C_NV12 = 16;C_NV2 = 17;C_IL01 = 18;C_NV1 = 19;
C_IL02 = 20;C_IL03 = 21;C_IL04 = 22;C_NV7 = 23;C_IL05 = 24;C_IL06 = 25;
C_NV11 = 26;C_IL07 = 27;C_IL08 = 28;C_IL09 = 29;C_NV17 = 30;C_ILP01 = 31;
C_ILP02 = 32;C_ILP03 = 33;C_ILP04 = 34;C_ILPR01 = 35;C_ILPR02 = 36;
C_ILRB01 = 37;C_NV4 = 38;C_ILRB02 = 39;C_NV18 = 40;C_ILRB03 = 41;
C_NV19 = 42;C_ILRB04 = 43;C_NV20 = 44;C_ILRB05 = 45;C_NV21 = 46;
% Row indices
R_B01 = 1;R_N5 = 2;R_N3 = 3;R_B02 = 4;R_N6 = 5;R_B03 = 6;R_N9 = 7;R_N10 = 8;
R_B04 = 9;R_N13 = 10;R_N14 = 11;R_B05 = 12;R_N15 = 13;R_N16 = 14;R_N8 = 15;
R_N12 = 16;R_N2 = 17;R_L01 = 18;R_N1 = 19;R_L02 = 20;R_L03 = 21;R_L04 = 22;
R_N7 = 23;R_L05 = 24;R_L06 = 25;R_N11 = 26;R_L07 = 27;R_L08 = 28;R_L09 = 29;
R_N17 = 30;R_LP01 = 31;R_LP02 = 32;R_LP03 = 33;R_LP04 = 34;R_LPR01 = 35;
R_LPR02 = 36;R_LRB01 = 37;R_N4 = 38;R_LRB02 = 39;R_N18 = 40;R_LRB03 = 41;
R_N19 = 42;R_LRB04 = 43;R_N20 = 44;R_LRB05 = 45;R_N21 = 46;
% A Matrix Creation
B01_mat = zeros(46,46);B02_mat = zeros(46,46);B03_mat = zeros(46,46);B04_mat = zeros(46,46);B05_mat = zeros(46,46);
L01_mat = zeros(46,46);L02_mat = zeros(46,46);L03_mat = zeros(46,46);L04_mat = zeros(46,46);
L05_mat = zeros(46,46);L06_mat = zeros(46,46);L07_mat = zeros(46,46);L08_mat = zeros(46,46);L09_mat = zeros(46,46);
LP01_mat = zeros(46,46);LP02_mat = zeros(46,46);LP03_mat = zeros(46,46);LP04_mat = zeros(46,46);
LPR01_mat = zeros(46,46);LPR02_mat = zeros(46,46);
LRB01_mat = zeros(46,46);LRB02_mat = zeros(46,46);LRB03_mat = zeros(46,46);LRB04_mat = zeros(46,46);LRB05_mat = zeros(46,46);
RB01_mat = zeros(46,46);RB02_mat = zeros(46,46);RB03_mat = zeros(46,46);RB04_mat = zeros(46,46);RB05_mat = zeros(46,46);
ROUT_mat = zeros(46,46);

B01_mat(R_N5,C_NV5) = (2 * B01CAP / hn) + (1 / B01R0);
B01_mat(R_N5,C_NV3) = -((2 * B01CAP / hn) + (1 / B01R0));
B01_mat(R_N3,C_NV5) = -((2 * B01CAP / hn) + (1 / B01R0));
B01_mat(R_N3,C_NV3) = (2 * B01CAP / hn) + (1 / B01R0);
B01_mat(R_B01,C_NV5) = -(hn/2)*hbar_2e;
B01_mat(R_B01,C_NV3) = (hn/2)*hbar_2e;
B01_mat(R_B01,C_PB01) = 1;

B02_mat(R_N5,C_NV5) = (2 * B02CAP / hn) + (1 / B02R0);
B02_mat(R_N5,C_NV6) = -((2 * B02CAP / hn) + (1 / B02R0));
B02_mat(R_N6,C_NV5) = -((2 * B02CAP / hn) + (1 / B02R0));
B02_mat(R_N6,C_NV6) = (2 * B02CAP / hn) + (1 / B02R0);
B02_mat(R_B02,C_NV5) = -(hn/2)*hbar_2e;
B02_mat(R_B02,C_NV6) = (hn/2)*hbar_2e;
B02_mat(R_B02,C_PB02) = 1;

B03_mat(R_N9,C_NV9) = (2 * B03CAP / hn) + (1 / B03R0);
B03_mat(R_N9,C_NV10) = -((2 * B03CAP / hn) + (1 / B03R0));
B03_mat(R_N10,C_NV9) = -((2 * B03CAP / hn) + (1 / B03R0));
B03_mat(R_N10,C_NV10) = (2 * B03CAP / hn) + (1 / B03R0);
B03_mat(R_B03,C_NV9) = -(hn/2)*hbar_2e;
B03_mat(R_B03,C_NV10) = (hn/2)*hbar_2e;
B03_mat(R_B03,C_PB03) = 1;

B04_mat(R_N13,C_NV13) = (2 * B04CAP / hn) + (1 / B04R0);
B04_mat(R_N13,C_NV14) = -((2 * B04CAP / hn) + (1 / B04R0));
B04_mat(R_N14,C_NV13) = -((2 * B04CAP / hn) + (1 / B04R0));
B04_mat(R_N14,C_NV14) = (2 * B04CAP / hn) + (1 / B04R0);
B04_mat(R_B04,C_NV13) = -(hn/2)*hbar_2e;
B04_mat(R_B04,C_NV14) = (hn/2)*hbar_2e;
B04_mat(R_B04,C_PB04) = 1;

B05_mat(R_N15,C_NV15) = (2 * B05CAP / hn) + (1 / B05R0);
B05_mat(R_N15,C_NV16) = -((2 * B05CAP / hn) + (1 / B05R0));
B05_mat(R_N16,C_NV15) = -((2 * B05CAP / hn) + (1 / B05R0));
B05_mat(R_N16,C_NV16) = (2 * B05CAP / hn) + (1 / B05R0);
B05_mat(R_B05,C_NV15) = -(hn/2)*hbar_2e;
B05_mat(R_B05,C_NV16) = (hn/2)*hbar_2e;
B05_mat(R_B05,C_PB05) = 1;

L01_mat(R_N2,C_IL01) = 1;
L01_mat(R_N1,C_IL01) = -1;
L01_mat(R_L01,C_NV2) = 1;
L01_mat(R_L01,C_NV1) = -1;
L01_mat(R_L01,C_IL01) = -2*(L01 / hn);

L02_mat(R_N1,C_IL02) = -1;
L02_mat(R_L02,C_NV1) = -1;
L02_mat(R_L02,C_IL02) = -2*(L02 / hn);

L03_mat(R_N1,C_IL03) = 1;
L03_mat(R_N2,C_IL03) = -1;
L03_mat(R_L03,C_NV1) = 1;
L03_mat(R_L03,C_NV3) = -1;
L03_mat(R_L03,C_IL03) = -2*(L03 / hn);

L04_mat(R_N5,C_IL04) = 1;
L04_mat(R_N7,C_IL04) = -1;
L04_mat(R_L04,C_NV5) = 1;
L04_mat(R_L04,C_NV7) = -1;
L04_mat(R_L04,C_IL04) = -2*(L04 / hn);

L05_mat(R_N7,C_IL05) = 1;
L05_mat(R_N9,C_IL05) = -1;
L05_mat(R_L05,C_NV7) = 1;
L05_mat(R_L05,C_NV9) = -1;
L05_mat(R_L05,C_IL05) = -2*(L05 / hn);

L06_mat(R_N9,C_IL06) = 1;
L06_mat(R_N11,C_IL06) = -1;
L06_mat(R_L06,C_NV9) = 1;
L06_mat(R_L06,C_NV11) = -1;
L06_mat(R_L06,C_IL06) = -2*(L06 / hn);

L07_mat(R_N11,C_IL07) = 1;
L07_mat(R_N13,C_IL07) = -1;
L07_mat(R_L07,C_NV11) = 1;
L07_mat(R_L07,C_NV13) = -1;
L07_mat(R_L07,C_IL07) = -2*(L07 / hn);

L08_mat(R_N13,C_IL08) = 1;
L08_mat(R_N15,C_IL08) = -1;
L08_mat(R_L08,C_NV13) = 1;
L08_mat(R_L08,C_NV15) = -1;
L08_mat(R_L08,C_IL08) = -2*(L08 / hn);

L09_mat(R_N15,C_IL09) = 1;
L09_mat(R_N17,C_IL09) = -1;
L09_mat(R_L09,C_NV15) = 1;
L09_mat(R_L09,C_NV17) = -1;
L09_mat(R_L09,C_IL09) = -2*(L09 / hn);

LP01_mat(R_N6,C_ILP01) = -1;
LP01_mat(R_LP01,C_NV6) = -1;
LP01_mat(R_LP01,C_ILP01) = -2*(LP01 / hn);

LP02_mat(R_N10,C_ILP02) = -1;
LP02_mat(R_LP02,C_NV10) = -1;
LP02_mat(R_LP02,C_ILP02) = -2*(LP02 / hn);

LP03_mat(R_N14,C_ILP03) = -1;
LP03_mat(R_LP03,C_NV14) = -1;
LP03_mat(R_LP03,C_ILP03) = -2*(LP03 / hn);

LP04_mat(R_N16,C_ILP04) = -1;
LP04_mat(R_LP04,C_NV16) = -1;
LP04_mat(R_LP04,C_ILP04) = -2*(LP04 / hn);

LPR01_mat(R_N7,C_ILPR01) = 1;
LPR01_mat(R_N8,C_ILPR01) = -1;
LPR01_mat(R_LPR01,C_NV7) = 1;
LPR01_mat(R_LPR01,C_NV8) = -1;
LPR01_mat(R_LPR01,C_ILPR01) = -2*(LPR01 / hn);

LPR02_mat(R_N11,C_ILPR02) = 1;
LPR02_mat(R_N12,C_ILPR02) = -1;
LPR02_mat(R_LPR02,C_NV11) = 1;
LPR02_mat(R_LPR02,C_NV12) = -1;
LPR02_mat(R_LPR02,C_ILPR02) = -2*(LPR02 / hn);

LRB01_mat(R_N4,C_ILRB01) = 1;
LRB01_mat(R_N5,C_ILRB01) = -1;
LRB01_mat(R_LRB01,C_NV4) = 1;
LRB01_mat(R_LRB01,C_NV5) = -1;
LRB01_mat(R_LRB01,C_ILRB01) = -2*(LRB01 / hn);

LRB02_mat(R_N18,C_ILRB02) = 1;
LRB02_mat(R_N6,C_ILRB02) = -1;
LRB02_mat(R_LRB02,C_NV18) = 1;
LRB02_mat(R_LRB02,C_NV6) = -1;
LRB02_mat(R_LRB02,C_ILRB02) = -2*(LRB02 / hn);

LRB03_mat(R_N19,C_ILRB03) = 1;
LRB03_mat(R_N10,C_ILRB03) = -1;
LRB03_mat(R_LRB03,C_NV19) = 1;
LRB03_mat(R_LRB03,C_NV10) = -1;
LRB03_mat(R_LRB03,C_ILRB03) = -2*(LRB03 / hn);

LRB04_mat(R_N20,C_ILRB04) = 1;
LRB04_mat(R_N14,C_ILRB04) = -1;
LRB04_mat(R_LRB04,C_NV20) = 1;
LRB04_mat(R_LRB04,C_NV14) = -1;
LRB04_mat(R_LRB04,C_ILRB04) = -2*(LRB04 / hn);

LRB05_mat(R_N21,C_ILRB05) = 1;
LRB05_mat(R_N16,C_ILRB05) = -1;
LRB05_mat(R_LRB05,C_NV21) = 1;
LRB05_mat(R_LRB05,C_NV16) = -1;
LRB05_mat(R_LRB05,C_ILRB05) = -2*(LRB05 / hn);

RB01_mat(R_N3,C_NV3) = 1/RB01;
RB01_mat(R_N3,C_NV4) = -1/RB01;
RB01_mat(R_N4,C_NV3) = -1/RB01;
RB01_mat(R_N4,C_NV4) = 1/RB01;

RB02_mat(R_N18,C_NV18) = 1/RB02;
RB02_mat(R_N18,C_NV5) = -1/RB02;
RB02_mat(R_N5,C_NV18) = -1/RB02;
RB02_mat(R_N5,C_NV5) = 1/RB02;

RB03_mat(R_N19,C_NV19) = 1/RB03;
RB03_mat(R_N19,C_NV9) = -1/RB03;
RB03_mat(R_N9,C_NV19) = -1/RB03;
RB03_mat(R_N9,C_NV9) = 1/RB03;

RB04_mat(R_N20,C_NV20) = 1/RB04;
RB04_mat(R_N20,C_NV13) = -1/RB04;
RB04_mat(R_N13,C_NV20) = -1/RB04;
RB04_mat(R_N13,C_NV13) = 1/RB04;

RB05_mat(R_N21,C_NV21) = 1/RB05;
RB05_mat(R_N21,C_NV15) = -1/RB05;
RB05_mat(R_N15,C_NV21) = -1/RB05;
RB05_mat(R_N15,C_NV15) = 1/RB05;

ROUT_mat(R_N17,C_NV17) = 1/ROUT;

A = B01_mat + B02_mat + B03_mat + B04_mat + B05_mat + L01_mat + L02_mat + L03_mat + L04_mat + L05_mat + L06_mat + L07_mat + L08_mat + L09_mat + LP01_mat + LP02_mat + LP03_mat + LP04_mat + LPR01_mat + LPR02_mat + LRB01_mat + LRB02_mat + LRB03_mat + LRB04_mat + LRB05_mat + RB01_mat + RB02_mat + RB03_mat + RB04_mat + RB05_mat + ROUT_mat;
% Sources
IB01 = 0;
for i = 1:(5E-12/hn - 1)
    IB01 = [IB01, (162.5E-6 - 0)/(5E-12 - 0) * (i*hn)];
end
[IB01_rows,IB01_cols] = size(IB01);
IB01 = [IB01, 162.5E-6*ones(1,N-IB01_cols)];
IB02 = 0;
for i = 1:(5E-12/hn - 1)
    IB02 = [IB02, (260E-6 - 0)/(5E-12 - 0) * (i*hn)];
end
[IB02_rows,IB02_cols] = size(IB02);
IB02 = [IB02, 260E-6*ones(1,N-IB02_cols)];
Iin = zeros(1, 4000);
pulseRepeat = 100E-12;
timeDelay = 200E-12;
timeRise = 1E-12;
timeFall = 1E-12;
pulseWidth = 50E-12;
PR = pulseRepeat / hn;
TD = timeDelay / hn;
timestep = 0;
timesteps = 0;
values = 0;
for i = 1:((4000 - TD)/PR)
   timestep = timeDelay + (pulseRepeat * (i - 1));
   if timestep < 4000*hn
       timesteps = [timesteps, timestep];
   else
       break;
   end
   values = [values, 0.0];
   timestep = timeDelay + (pulseRepeat * (i - 1)) + timeRise;
   if timestep < 4000*hn
       timesteps = [timesteps, timestep];
   else
       break;
   end
   values = [values, 600E-6];
   timestep = timeDelay + (pulseRepeat * (i - 1)) + timeRise + pulseWidth;
   if timestep < 4000*hn
       timesteps = [timesteps, timestep];
   else
       break;
   end
   values = [values, 600E-6];
   timestep = timeDelay + (pulseRepeat * (i - 1)) + timeRise + pulseWidth + timeFall;
   if timestep < 4000*hn
       timesteps = [timesteps, timestep];
   else
       break;
   end
   values = [values, 0.0];
end
timesteps = timesteps(2:end);
values = values(2:end);
for i = 2:size(timesteps,2)
	endpoint = int32(timesteps(i) / hn);
    startpoint = int32(timesteps(i-1) / hn);
	for j = startpoint:endpoint
        if values(i - 1) < values(i)
            value = values(i) / double(endpoint - startpoint) * double(j - startpoint);
        elseif values(i - 1) > values(i)
                value = values(i - 1) - (values(i - 1) / double(endpoint - startpoint) * double(j - startpoint));
        elseif values(i - 1) == values(i)
            value = values(i);
        end
        Iin(j) = value;
    end
end
% Initialize Storage Variables
T = zeros(1, N);
RHS = zeros(46,1);
LHS = zeros(46,1);
V_N1 = zeros(1, N);
V_N2 = zeros(1, N);
V_N3 = zeros(1, N);
V_N4 = zeros(1, N);
V_N5 = zeros(1, N);
V_N6 = zeros(1, N);
V_N7 = zeros(1, N);
V_N8 = zeros(1, N);
V_N9 = zeros(1, N);
V_N10 = zeros(1, N);
V_N11 = zeros(1, N);
V_N12 = zeros(1, N);
V_N13 = zeros(1, N);
V_N14 = zeros(1, N);
V_N15 = zeros(1, N);
V_N16 = zeros(1, N);
V_N17 = zeros(1, N);
V_N18 = zeros(1, N);
V_N19 = zeros(1, N);
V_N20 = zeros(1, N);
V_N21 = zeros(1, N);
V_Phi1 = zeros(1, N);
V_Phi2 = zeros(1, N);
V_Phi3 = zeros(1, N);
V_Phi4 = zeros(1, N);
V_Phi5 = zeros(1, N);
I_L01 = zeros(1, N);
I_L02 = zeros(1, N);
I_L03 = zeros(1, N);
I_L04 = zeros(1, N);
I_L05 = zeros(1, N);
I_L06 = zeros(1, N);
I_L07 = zeros(1, N);
I_L08 = zeros(1, N);
I_L09 = zeros(1, N);
I_LP01 = zeros(1, N);
I_LP02 = zeros(1, N);
I_LP03 = zeros(1, N);
I_LP04 = zeros(1, N);
I_LPR01 = zeros(1, N);
I_LPR02 = zeros(1, N);
I_LRB01 = zeros(1, N);
I_LRB02 = zeros(1, N);
I_LRB03 = zeros(1, N);
I_LRB04 = zeros(1, N);
I_LRB05 = zeros(1, N);
% Initialize Junction Initial Values
VB1_prev = 0;
VB1_dt_prev = 0;
PB1_prev = 0;
IsB1 = 0;

VB2_prev = 0;
VB2_dt_prev = 0;
PB2_prev = 0;
IsB2 = 0;

VB3_prev = 0;
VB3_dt_prev = 0;
PB3_prev = 0;
IsB3 = 0;

VB4_prev = 0;
VB4_dt_prev = 0;
PB4_prev = 0;
IsB4 = 0;

VB5_prev = 0;
VB5_dt_prev = 0;
PB5_prev = 0;
IsB5 = 0;
% Initialize intial voltage and current values
VN1_prev = 0;
VN2_prev = 0;
VN3_prev = 0;
VN4_prev = 0;
VN5_prev = 0;
VN6_prev = 0;
VN7_prev = 0;
VN8_prev = 0;
VN9_prev = 0;
VN10_prev = 0;
VN11_prev = 0;
VN12_prev = 0;
VN13_prev = 0;
VN14_prev = 0;
VN15_prev = 0;
VN16_prev = 0;
VN17_prev = 0;
VN18_prev = 0;
VN19_prev = 0;
VN20_prev = 0;
VN21_prev = 0;
IL01_prev = 0;
IL02_prev = 0;
IL03_prev = 0;
IL04_prev = 0;
IL05_prev = 0;
IL06_prev = 0;
IL07_prev = 0;
IL08_prev = 0;
IL09_prev = 0;
ILP01_prev = 0;
ILP02_prev = 0;
ILP03_prev = 0;
ILP04_prev = 0;
ILPR01_prev = 0;
ILPR02_prev = 0;
ILRB01_prev = 0;
ILRB02_prev = 0;
ILRB03_prev = 0;
ILRB04_prev = 0;
ILRB05_prev = 0;
% Time loop
for i = 1:N 
    % Construct RHS
    RHS(R_B01) = LHS(C_PB01) + (hn/2 * hbar_2e)*(LHS(C_NV5)-LHS(C_NV3));
    RHS(R_N5) = IsB1 + IsB2;
    RHS(R_N3) = -IsB1;
    RHS(R_B02) = LHS(C_PB02) + (hn/2 * hbar_2e)*(LHS(C_NV5)-LHS(C_NV6));
    RHS(R_N6) = -IsB2;
    RHS(R_B03) = LHS(C_PB03) + (hn/2 * hbar_2e)*(LHS(C_NV9)-LHS(C_NV10));
    RHS(R_N9) = IsB3;
    RHS(R_N10) = -IsB3;
    RHS(R_B04) = LHS(C_PB04) + (hn/2 * hbar_2e)*(LHS(C_NV13)-LHS(C_NV14));
    RHS(R_N13) = IsB4;
    RHS(R_N14) = -IsB4;
    RHS(R_B05) = LHS(C_PB05) + (hn/2 * hbar_2e)*(LHS(C_NV15)-LHS(C_NV16));
    RHS(R_N15) = IsB5;
    RHS(R_N16) = -IsB5;
    RHS(R_N8) = IB01(i);
    RHS(R_N12) = IB02(i);
    RHS(R_N2) = Iin(i);
    RHS(R_L01) = -(2*L01 / hn)*LHS(C_IL01) - (LHS(C_NV2) - LHS(C_NV1));
    RHS(R_L02) = -(2*L02 / hn)*LHS(C_IL02) - (-LHS(C_NV1));
    RHS(R_L03) = -(2*L03/hn)*LHS(C_IL03) - (LHS(C_NV1) - LHS(C_NV3));
    RHS(R_L04) = -(2*L04/hn)*LHS(C_IL04) - (LHS(C_NV5) - LHS(C_NV7));
    RHS(R_L05) = -(2*L05/hn)*LHS(C_IL05) - (LHS(C_NV7) - LHS(C_NV9));
    RHS(R_L06) = -(2*L06/hn)*LHS(C_IL06) - (LHS(C_NV9) - LHS(C_NV11));
    RHS(R_L07) = -(2*L07/hn)*LHS(C_IL07) - (LHS(C_NV11) - LHS(C_NV13));
    RHS(R_L08) = -(2*L08/hn)*LHS(C_IL08) - (LHS(C_NV13) - LHS(C_NV15));
    RHS(R_L09) = -(2*L09/hn)*LHS(C_IL09) - (LHS(C_NV15) - LHS(C_NV17));
    RHS(R_LP01) = -(2*LP01/hn)*LHS(C_ILP01) - (-LHS(C_NV6));
    RHS(R_LP02) = -(2*LP02/hn)*LHS(C_ILP02) - (-LHS(C_NV10));
    RHS(R_LP03) = -(2*LP03/hn)*LHS(C_ILP03) - (-LHS(C_NV14));
    RHS(R_LP04) = -(2*LP04/hn)*LHS(C_ILP04) - (-LHS(C_NV16));
    RHS(R_LPR01) = -(2*LPR01/hn)*LHS(C_ILPR01) - (LHS(C_NV7) - LHS(C_NV8));
    RHS(R_LPR02) = -(2*LPR01/hn)*LHS(C_ILPR02) - (LHS(C_NV11) - LHS(C_NV12));
    RHS(R_LRB01) = -(2*LRB01/hn)*LHS(C_ILRB01) - (LHS(C_NV4) - LHS(C_NV5));
    RHS(R_LRB02) = -(2*LRB02/hn)*LHS(C_ILRB02) - (LHS(C_NV18) - LHS(C_NV6));
    RHS(R_LRB03) = -(2*LRB03/hn)*LHS(C_ILRB03) - (LHS(C_NV19) - LHS(C_NV10));
    RHS(R_LRB04) = -(2*LRB04/hn)*LHS(C_ILRB04) - (LHS(C_NV20) - LHS(C_NV14));
    RHS(R_LRB05) = -(2*LRB05/hn)*LHS(C_ILRB05) - (LHS(C_NV21) - LHS(C_NV16));
    % Solve linear system
    LHS = A\RHS;
    % Guess junction voltage and phase for next time step
    VB1 = (LHS(C_NV5)-LHS(C_NV3));
    PB1 = LHS(C_PB01);
    VB1_dt = (2/hn)*(VB1 - VB1_prev) - VB1_dt_prev;
    VB1_guess = VB1 + VB1_dt*hn;
    PB1_guess = PB1 + (hn/2 * hbar_2e)*(VB1 + VB1_guess);
    
    VB2 = (LHS(C_NV5)-LHS(C_NV6));
    PB2 = LHS(C_PB02);    
    VB2_dt = (2/hn)*(VB2 - VB2_prev) - VB2_dt_prev;
    VB2_guess = VB2 + VB2_dt*hn;
    PB2_guess = PB2 + (hn/2 * hbar_2e)*(VB2 + VB2_guess);
        
    VB3 = (LHS(C_NV9)-LHS(C_NV10));
    PB3 = LHS(C_PB03);    
    VB3_dt = (2/hn)*(VB3 - VB3_prev) - VB3_dt_prev;
    VB3_guess = VB3 + VB3_dt*hn;
    PB3_guess = PB3 + (hn/2 * hbar_2e)*(VB3 + VB3_guess);
        
    VB4 = (LHS(C_NV13)-LHS(C_NV14));
    PB4 = LHS(C_PB04);    
    VB4_dt = (2/hn)*(VB4 - VB4_prev) - VB4_dt_prev;
    VB4_guess = VB4 + VB4_dt*hn;
    PB4_guess = PB4 + (hn/2 * hbar_2e)*(VB4 + VB4_guess);
        
    VB5 = (LHS(C_NV15)-LHS(C_NV16));
    PB5 = LHS(C_PB05);    
    VB5_dt = (2/hn)*(VB5 - VB5_prev) - VB5_dt_prev;
    VB5_guess = VB5 + VB5_dt*hn;
    PB5_guess = PB5 + (hn/2 * hbar_2e)*(VB5 + VB5_guess);
    % Calculate junction currents for next time step
    IsB1 = -B01ICRIT * sin(PB1_guess) +  ((2*B01CAP/hn) * VB1) + (B01CAP * VB1_dt);
    IsB2 = -B02ICRIT * sin(PB2_guess) + ((2*B02CAP/hn) * VB2) + (B02CAP * VB2_dt);
    IsB3 = -B03ICRIT * sin(PB3_guess) + ((2*B03CAP/hn) * VB3) + (B03CAP * VB3_dt);
    IsB4 = -B04ICRIT * sin(PB4_guess) + ((2*B04CAP/hn) * VB4) + (B04CAP * VB4_dt);
    IsB5 = -B05ICRIT * sin(PB5_guess) + ((2*B05CAP/hn) * VB5) + (B05CAP * VB5_dt);
    % Store junction voltage and phase for next time step
    VB1_prev = VB1;
    VB1_dt_prev = VB1_dt;
    
    VB2_prev = VB2;
    VB2_dt_prev = VB2_dt;
    
    VB3_prev = VB3;
    VB3_dt_prev = VB3_dt;
    
    VB4_prev = VB4;
    VB4_dt_prev = VB4_dt;
    
    VB5_prev = VB5;
    VB5_dt_prev = VB5_dt;
    % Store current time step for output
    T(i) = hn*i;
    V_N1(i) = LHS(C_NV1);
    V_N2(i) = LHS(C_NV2);
    V_N3(i) = LHS(C_NV3);
    V_N4(i) = LHS(C_NV4);
    V_N5(i) = LHS(C_NV5);
    V_N6(i) = LHS(C_NV6);
    V_N7(i) = LHS(C_NV7);
    V_N8(i) = LHS(C_NV8);
    V_N9(i) = LHS(C_NV9);
    V_N10(i) = LHS(C_NV10);
    V_N11(i) = LHS(C_NV11);
    V_N12(i) = LHS(C_NV12);
    V_N13(i) = LHS(C_NV13);
    V_N14(i) = LHS(C_NV14);
    V_N15(i) = LHS(C_NV15);
    V_N16(i) = LHS(C_NV16);
    V_N17(i) = LHS(C_NV17);
    V_N18(i) = LHS(C_NV18);
    V_N19(i) = LHS(C_NV19);
    V_N20(i) = LHS(C_NV20);
    V_N21(i) = LHS(C_NV21);
    I_L01(i) = LHS(C_IL01);
    I_L02(i) = LHS(C_IL02);
    I_L03(i) = LHS(C_IL03);
    I_L04(i) = LHS(C_IL04);
    I_L05(i) = LHS(C_IL05);
    I_L06(i) = LHS(C_IL06);
    I_L07(i) = LHS(C_IL07);
    I_L08(i) = LHS(C_IL08);
    I_L09(i) = LHS(C_IL09);
    I_LP01(i) = LHS(C_ILP01);
    I_LP02(i) = LHS(C_ILP02);
    I_LP03(i) = LHS(C_ILP03);
    I_LP04(i) = LHS(C_ILP04);
    I_LPR01(i) = LHS(C_ILPR01);
    I_LPR02(i) = LHS(C_ILPR02);
    I_LRB01(i) = LHS(C_ILRB01);
    I_LRB02(i) = LHS(C_ILRB02);
    I_LRB03(i) = LHS(C_ILRB03);
    I_LRB04(i) = LHS(C_ILRB04);
    I_LRB05(i) = LHS(C_ILRB05);
    V_Phi1(i) = LHS(C_PB01);
    V_Phi2(i) = LHS(C_PB02);
    V_Phi3(i) = LHS(C_PB03);
    V_Phi4(i) = LHS(C_PB04);
    V_Phi5(i) = LHS(C_PB05);
end

figure(2);
subplot(3, 1, 1);
plot(T, V_Phi1);
subplot(3, 1, 2);
plot(T, I_L01);
subplot(3, 1, 3);
plot(T, V_N17);