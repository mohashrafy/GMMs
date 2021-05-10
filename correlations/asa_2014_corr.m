function [ rho ] = asa_2014_corr( T1, T2) 
%
% Created by Jack Baker, circa 2015
% Updated 5/7/2021 to improve documentation and allow vector inputs
%
% Horizontal spectral correlation coefficients from the following
% reference
% 
% Akkar, S., Sandikkaya, M. A., and Ay, B. O. (2014). "Compatible ground-
% motion prediction equations for damping scaling factors and vertical-to-
% horizontal spectral amplitude ratios for the broader Europe region." 
% Bulletin of Earthquake Engineering, 12(1), 517-547.
%
% The function is fitted over the range the range 0.001s <= T1, T2 <= 4s
%
% INPUT
%
%   T1, T2      = Vectors of the two sets of SA periods of interest. 
%
% OUTPUT
%
%   rho         = The predicted correlation matrix. If length(T1)=n and
%                   length(T2)=m, then size(rho) = [n m]

%% tabulated model parameters

% Periods reported in Table 6 (PGA mapped to 0.001s)
Periods = [0.001 	0.01	0.02	0.03	0.04	0.05	0.075	0.1	0.15	0.2	0.3	0.4	0.5	0.75	1	1.5	2	3	4];

% digitized correlation coefficients from Table 6
RHO = [1	0.99966	0.99784	0.99198	0.98153	0.96686	0.93427	0.93426	0.91839	0.89789	0.834	0.77764	0.72497	0.62005	0.54546	0.47169	0.46411	0.41179	0.32908; ...
0.99966	1	0.99846	0.99296	0.98254	0.96805	0.93589	0.93534	0.91889	0.89695	0.83133	0.77413	0.72114	0.61654	0.54163	0.46768	0.46038	0.40905	0.32759; ...
0.99784	0.99846	1	0.99608	0.98639	0.97227	0.9372	0.93377	0.91548	0.8903	0.82278	0.76584	0.7126	0.61209	0.53828	0.46527	0.45893	0.40769	0.32748; ...
0.99198	0.99296	0.99608	1	0.99265	0.98009	0.9412	0.9326	0.90798	0.87569	0.7996	0.74114	0.68874	0.59241	0.52024	0.45063	0.44787	0.39706	0.31963; ...
0.98153	0.98254	0.98639	0.99265	1	0.99187	0.95046	0.93156	0.89437	0.85412	0.76727	0.70701	0.65557	0.56179	0.49043	0.42901	0.43238	0.38185	0.30985; ...
0.96686	0.96805	0.97227	0.98009	0.99187	1	0.96226	0.93485	0.88309	0.83332	0.73418	0.67099	0.61977	0.52614	0.4561	0.40005	0.40762	0.35783	0.28706; ...
0.93427	0.93589	0.9372	0.9412	0.95046	0.96226	1	0.96262	0.88845	0.82352	0.70328	0.62602	0.56314	0.45335	0.38092	0.32316	0.3293	0.29077	0.24481; ...
0.93426	0.93534	0.93377	0.9326	0.93156	0.93485	0.96262	1	0.9362	0.86357	0.72956	0.64721	0.5722	0.45198	0.37881	0.31776	0.32079	0.28606	0.24612; ...
0.91839	0.91889	0.91548	0.90798	0.89437	0.88309	0.88845	0.9362	1	0.9324	0.78904	0.69128	0.60976	0.47406	0.38947	0.3097	0.30067	0.26877	0.23962; ...
0.89789	0.89695	0.8903	0.87569	0.85412	0.83332	0.82352	0.86357	0.9324	1	0.88286	0.78939	0.70903	0.56265	0.47235	0.37342	0.35455	0.32109	0.26723; ...
0.834	0.83133	0.82278	0.7996	0.76727	0.73418	0.70328	0.72956	0.78904	0.88286	1	0.92243	0.8407	0.69909	0.60728	0.48496	0.4531	0.40003	0.30679; ...
0.77764	0.77413	0.76584	0.74114	0.70701	0.67099	0.62602	0.64721	0.69128	0.78939	0.92243	1	0.93712	0.79936	0.7063	0.57523	0.5291	0.46726	0.35461; ...
0.72497	0.72114	0.7126	0.68874	0.65557	0.61977	0.56314	0.5722	0.60976	0.70903	0.8407	0.93712	1	0.88239	0.79308	0.66474	0.61543	0.54678	0.42548; ...
0.62005	0.61654	0.61209	0.59241	0.56179	0.52614	0.45335	0.45198	0.47406	0.56265	0.69909	0.79936	0.88239	1	0.92838	0.80638	0.74174	0.64541	0.53024; ...
0.54546	0.54163	0.53828	0.52024	0.49043	0.4561	0.38092	0.37881	0.38947	0.47235	0.60728	0.7063	0.79308	0.92838	1	0.90458	0.84345	0.75232	0.63531; ...
0.47169	0.46768	0.46527	0.45063	0.42901	0.40005	0.32316	0.31776	0.3097	0.37342	0.48496	0.57523	0.66474	0.80638	0.90458	1	0.9411	0.85455	0.73478; ...
0.46411	0.46038	0.45893	0.44787	0.43238	0.40762	0.3293	0.32079	0.30067	0.35455	0.4531	0.5291	0.61543	0.74174	0.84345	0.9411	1	0.91408	0.79894; ...
0.41179	0.40905	0.40769	0.39706	0.38185	0.35783	0.29077	0.28606	0.26877	0.32109	0.40003	0.46726	0.54678	0.64541	0.75232	0.85455	0.91408	1	0.93102; ...
0.32908	0.32759	0.32748	0.31963	0.30985	0.28706	0.24481	0.24612	0.23962	0.26723	0.30679	0.35461	0.42548	0.53024	0.63531	0.73478	0.79894	0.93102	1];


%% compute correlations    
rho = nan*ones(length(T1), length(T2)); % initialize nans

% find indices of input periods that are within range
t1Idx = find(T1>=0.001 & T1<=4);
t2Idx = find(T2>=0.001 & T2<=4);

[X, Y] = meshgrid(log(T2(t2Idx)), log(T1(t1Idx)));

% compute correlations at periods that are within range
rho(t1Idx, t2Idx) = interp2(log(Periods), log(Periods), RHO, X, Y);


end

