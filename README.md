# Adaptive Fourier decomposition based R-peak detection for noisy ECG Signals
Matlab codes of the AFD-based R peak detection. This method was described in 

> Wang, Z., Wong, C. M., & Wan, F. (2017, July). Adaptive Fourier decomposition based R-peak detection for noisy ECG Signals. In *2017 39th Annual International Conference of the IEEE Engineering in Medicine and Biology Society (EMBC)* (pp. 3501-3504). IEEE.

+ `R_detect_AFD_4_with_noise.m`: Adaptive Fourier decomposition based R-peak detection for noisy ECG Signals. The processed signal is the combinations of the ECG signals in the MIT-BIH Arrhythmia Database and the additive Gaussian white noise.
+ `R_result_check.m`: Detection results.
+ `AFD_filter_final.m`: AFD-based filter.
+ `AFD.m`: Core AFD
+ `ECG_100.mat` and `ECG_101.mat`: Real ECG signals from the MIT-BIH Arrhythmia Database

**Note**:

+ Because the noise is generated from the stochastic process, there may be slight differences between the computational results and the results presented in the conference paper.
+ In the paper, 25 records in the MIT-BIH Arrhythmia Database are cosidered. In this repository, only 2 sample records are provided.
+ A more fundamental AFD toolbox can be found in [Toolbox-for-Adaptive-Fourier-Decomposition](https://github.com/pikipity/Toolbox-for-Adaptive-Fourier-Decomposition)

References:

1. Wang, Z., Wong, C. M., & Wan, F. (2017, July). Adaptive Fourier decomposition based R-peak detection for noisy ECG Signals. In *2017 39th Annual International Conference of the IEEE Engineering in Medicine and Biology Society (EMBC)* (pp. 3501-3504). IEEE.
2. Moody GB, Mark RG. The impact of the MIT-BIH Arrhythmia Database. *IEEE Eng in Med and Biol* 20(3):45-50 (May-June 2001). (PMID: 11446209)
3. Goldberger AL, Amaral LAN, Glass L, Hausdorff JM, Ivanov PCh, Mark RG, Mietus JE, Moody GB, Peng C-K, Stanley HE. PhysioBank, PhysioToolkit, and PhysioNet: Components of a New Research Resource for Complex Physiologic Signals. *Circulation* 101(23):e215-e220 2000 (June 13).
