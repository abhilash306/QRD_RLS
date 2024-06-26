# QRD_RLS
QR DECOMPOSITION USING TRIANGULAR SYSTOLIC ARRAY
THIS IS THE HARDWARE IMPLEMENTED FOR SOLVING LEAST SQUARE PROBLEM IN RLS ALGORITHM TO FIND WEIGHTS AND ERROR 
![Capture12](https://github.com/abhilash306/QRD_RLS/assets/29005113/5cafe95f-fa27-49a3-966f-80d525d20185)
THIS IS THE IMPLEMENTED DESIGN FOR 
![design_n=5](https://github.com/abhilash306/QRD_RLS/assets/29005113/1b7ee7d7-07e8-402a-b0f0-1129ee7b1bb1)
\chapter{Implementation of QR Array}

%Replace \lipsum with text.
% You may have as many sections as you please. This is just for reference.

\section{ QR-RLS Overview }

Adaptive filtering is a significant concept in signal processing, particularly for scenarios where the signal environment is dynamic or unknown. The most common adaptive filter structure is the Finite Impulse Response (FIR) filter, preferred over Infinite Impulse Response (IIR) filters due to stability concerns.Using QR decomposition in adaptive filtering provides a robust and efficient way to solve the least squares problem, avoiding the computational issues associated with matrix inversion. The iterative update of the filter coefficients allows the filter to adapt effectively to changes in the signal environment, maintaining optimal performance\cite{7110554}.


\subsection{Adaptive Filtering}

The primary goal of adaptive filtering is to minimize the error signal \( e(k) \), which is the difference between the desired signal \( d(k) \) and the actual output of the filter \( y(k) \) \cite{niu2013hardware}:

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.5]{MTech/Capture7.PNG} 
\caption{Adaptive Filtering Structure} 
\label{fig:pent}
\end{center}
\end{figure}

\[
e(k) = d(k) - y(k)
\]

The objective is to adjust the filter coefficients \( \mathbf{h} \) to minimize the sum of squared errors. This can be expressed mathematically as:
\[
\min \left( \sum_{k} \lambda^{k-n} e^2(k) \right)
\]
where:
\begin{itemize}
    \item \( \lambda \) is a forgetting factor (0 < \( \lambda \leq 1 \)),
    \item \( n \) is a reference time index,
    \item \( e(k) \) is the error at time \( k \).
\end{itemize}


The forgetting factor \( \lambda \) is used to give more weight to recent errors compared to older ones, making the filter more responsive to changes in the signal environment\cite{niu2013hardware}.



\subsection{Least Squares Solution and QR Decomposition}

In adaptive filtering, the error at time \( k \) is given by:
\[
e_k = d_k - X_k w_n
\]

The least squares solution for finding the optimal filter coefficients \( w_n \) can be derived from:
\[
w = (X^T X)^{-1} X^T d_k
\]
\[
=X^{-1} d_k
\]

This equation involves matrix inversion, which can be computationally expensive and potentially unstable for large matrices. To avoid matrix inversion, QR decomposition can be used. QR decomposition decomposes the input matrix \( X_k \) into an orthogonal matrix \( Q \) and an upper triangular matrix \( R \):
\[
X_k = QR
\]

Substituting this into the least squares problem, we get:
\[
R w_n = Q^T d_k
\]

Since \( R \) is an upper triangular matrix, the weight vector \( w_n \) can be solved iteratively using back substitution. This method is computationally efficient and numerically stable compared to direct matrix inversion\cite{niu2013hardware}.


\subsection{Advantages of QRD-Based Method}

\begin{itemize}
    \item \textbf{Avoids Matrix Inversion}: QR decomposition avoids the need for direct matrix inversion, which can be computationally expensive and unstable.
    \item \textbf{Numerical Stability}: The method improves numerical stability, especially for large-scale problems.
    \item \textbf{Iterative Update}: The filter coefficients are updated iteratively, allowing the filter to adapt to changing signal environments.
\end{itemize}



\section{Standard QR-RLS Systolic Array}

Figure 4.2 illustrates the Signal Flow Graph (SFG) representation of a real-valued QR-RLS systolic array for an \(N = 3\) weight FIR filter. This array employs the Givens rotation to transform the input data into an upper triangular matrix \(R\). Each element \(r_{ij}\) within the array represents a specific element in this matrix, with subscripts \(ij\) indicating its position.

The definitions of the boundary cell (BC) and internal cell (IC) within the QR-RLS array are also depicted in Figure 4.2.  Sine \(s(\theta)\) and cosine \(c(\theta)\) functions are utilized to compute the Givens rotation within a BC. The least square error \(e(k)\) can be determined from the final single multiplier. The non-recursive column of Processing Elements (PEs), highlighted by the dashed frame, generates the likelihood vector \(\gamma\), which is the product of all the \(c_i\). This operation is typically performed in the BCs. However, by incorporating the rightmost column of ICs, it becomes feasible to design BC and IC with similar architectures, facilitating the efficient folding of both cell types onto a single processing element \cite{lee1981rls}.



\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.65]{MTech/Capture9.PNG} 
\caption{Standard QR-RLS Systolic Array} 
\label{fig:pent}
\end{center}
\end{figure}

In many implementations, the final coefficient weight vector is derived from the outputs of the QR decomposition algorithm using back-substitution. Figure 4.2 demonstrates one approach to implement a systolic structure for back-substitution by appending a linear array to the upper triangular QR-RLS array. During this process, adaptation is halted, and the \(r\) and \(p\) values are clocked out from the triangular array\cite{kung1988vlsi}.

However, back-substitution involves division operations, which are prone to divide-by-zero errors, making the process numerically unstable or prone to overflow/underflow unless performed with high precision fixed-point or floating-point arithmetic.
    
Another challenge with the conventional QR array implementation is the difficulty in interfacing with the back-substitution array, which requires the \(r\) and \(p\) values to be "shifted" out from the QR array. Although QR decomposition is effectively implemented on FPGA-compatible data-flow triangular arrays, the back-substitution process is not suitable for FPGA dataflow arrays if weights are required. One way to manage this issue is to offload the task to an embedded processor, which performs a series of division operations. However, this approach incurs significant latency compared to a data-flow architecture.

The subsequent section introduces the extended (or downdating) QR-RLS algorithm for weight extraction. This method mitigates the need for back-substitution by adding a secondary lower triangular downdating array, enabling the extraction of adaptive filter weights through a single multiplication and subtraction operation.



\section{Extended QR-RLS Systolic Array}

To overcome the throughput limitations of back-substitution in the standard QRD-RLS systolic array implementation, an extended QRD-RLS architecture has been developed. This architecture adds a second lower-triangular downdating array interfaced with the upper-triangular QRD array to directly extract the final adaptive beamforming weights through a simple multiplication and addition operation\cite{gao2012fpga}. 

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.42]{MTech/Capture12.PNG} 
\caption{Inverse QRD Systolic Array SFG} 
\label{fig:pent}
\end{center}
\end{figure}

The reader is advised to review the works in \cite{alexander1993method}–\cite{chern2002adaptive} for more details on the numerical
analysis and proof of Inverse QR Decomposition for Recursive Least Squares
Filtering.This new systolic array architecture is also known as the Inverse QR Decomposition (IQRD) Systolic Array, and provides much lower latency for weight extraction compared to linear back-substitution. The IQRD Signal Flow Graph (SFG) is illustrated in Figure 4.3, and is the chosen digital architecture to be developed using Verilog Hardware Description Language.

The lower-triangle array rotates the \(R^{-1}\) matrix stored in the downdating cells using null input vectors. Two new processing cells are added to the systolic array: a downdating cell and a weight extraction cell.

The downdating cell is very similar to the QRD Internal Cell from previous implementations, with the main difference being the use of a \(1/\lambda\) forgetting factor in the internal operation. Thus, the downdating cell is also known as the Inverse Internal Cell.

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.40]{MTech/Capture10.PNG} 
\caption{Inverse Internal Cell [DownDating]} 
\label{fig:pent3}
\end{center}
\end{figure}

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.42]{MTech/Capture11.PNG} 
\caption{Weight Extraction Cell} 
\label{fig:pent}
\end{center}
\end{figure}

The weight extraction cell uses the final sample output from the upper-triangular array, along with the final sample outputs from its respective column of the lower-triangular inverse array, to form each of the adaptive output weights \(\hat{w}_i(k)\) using simple arithmetic operations as shown in \ref{fig:pent3}\cite{7110554}.




\subsection{QR-RLS Systolic Resource Utilisation }

The resource utilization report provides a detailed analysis of the hardware resources used for different configurations, specifically for \( N=3 \), \( N=4 \), and \( N=5 \), all running at a frequency of 90 MHz. 

For \( N=3 \), the utilization of Look-Up Tables (LUTs) is 5991 out of 17600, which corresponds to 34.04\%. The utilization of LUTRAM is minimal, with only 5 out of 6000 utilized, resulting in 0.95\%. Flip-Flops (FFs) usage is at 2957 out of 35200, accounting for 8.40\%. Digital Signal Processing (DSP) units have a utilization of 1 out of 80, equating to 1.25\%. Input/Output (IO) resources show a significant utilization of 67 out of 100, amounting to 67.00\%.

\begin{table}[ht]
    \centering
    \begin{tabular}{|c|c|c|c|}
        \hline
        Resource & Utilization & Available & Utilization \% \\
        \hline
        LUT & 5991 & 17600 & 34.04 \\
        \hline
        LUTRAM & 5 & 6000 & 0.95 \\
        \hline
        FF & 2957 & 35200 & 8.40 \\
        \hline
        DSP & 1 & 80 & 1.25 \\
        \hline
        IO & 67 & 100 & 67.0 \\
        \hline
    \end{tabular}
    \caption{Resource Utilization Table For \( N=3 \)}
    \label{tab:resource_utilization_N3}
\end{table}

For \( N=4 \), the utilization of LUTs increases to 9362 out of 17600, which is 53.19\%. The usage of LUTRAM rises to 96 out of 6000, giving a utilization percentage of 1.60\%. FF utilization is 4096 out of 35200, corresponding to 11.63\%. The DSP utilization remains constant at 1 out of 80, which is 1.25\%. The IO utilization also increases to 83 out of 100, resulting in 83.00\%.

\begin{table}[ht]
    \centering
    \begin{tabular}{|c|c|c|c|}
        \hline
        Resource & Utilization & Available & Utilization \% \\
        \hline
        LUT & 9362 & 17600 & 53.19 \\
        \hline
        LUTRAM & 96 & 6000 & 1.60 \\
        \hline
        FF & 4096 & 35200 & 11.63 \\
        \hline
        DSP & 1 & 80 & 1.25 \\
        \hline
        IO & 83 & 100 & 83.0 \\
        \hline
    \end{tabular}
    \caption{Resource Utilization Table For \( N=4 \)}
    \label{tab:resource_utilization_N4}
\end{table}

For \( N=5 \), the utilization of LUTs further increases to 13266 out of 17600, which is 75.38\%. The usage of LUTRAM rises to 143 out of 6000, giving a utilization percentage of 2.38\%. FF utilization is 5346 out of 35200, corresponding to 15.19\%. The DSP utilization remains constant at 1 out of 80, which is 1.25\%. The IO utilization also increases to 99 out of 100, resulting in 99.00\%.

\begin{table}[ht]
    \centering
    \begin{tabular}{|c|c|c|c|}
        \hline
        Resource & Utilization & Available & Utilization \% \\
        \hline
        LUT & 13266 & 17600 & 75.38 \\
        \hline
        LUTRAM & 143 & 6000 & 2.38 \\
        \hline
        FF & 5346 & 35200 & 15.19 \\
        \hline
        DSP & 1 & 80 & 1.25 \\
        \hline
        IO & 99 & 100 & 99.0 \\
        \hline
    \end{tabular}
    \caption{Resource Utilization Table For \( N=5 \)}
    \label{tab:resource_utilization_N5}
\end{table}

\textbf{Discussion and Inferences}

From the above tables, we can infer the following:

\begin{itemize}
    \item \textbf{Trend in LUT Utilization}:
    \begin{itemize}
        \item The LUT utilization increases significantly as the matrix size \( N \) increases. For \( N=3 \), the utilization is 34.04\%, which rises to 53.19\% for \( N=4 \), and further to 75.38\% for \( N=5 \). This indicates a higher demand on logic resources with increasing problem size.
    \end{itemize}
    
    \item \textbf{LUTRAM Utilization}:
    \begin{itemize}
        \item The LUTRAM utilization is minimal across all configurations but shows an increase with the matrix size. For \( N=3 \), it is 0.95\%, which increases to 1.60\% for \( N=4 \) and 2.38\% for \( N=5 \). This suggests that more memory resources are required for larger matrices.
    \end{itemize}
    
    \item \textbf{Flip-Flop (FF) Utilization}:
    \begin{itemize}
        \item FF utilization also increases with the matrix size. It is 8.40\% for \( N=3 \), 11.63\% for \( N=4 \), and 15.19\% for \( N=5 \). This indicates that the sequential logic requirements grow with the problem size.
    \end{itemize}
    
    \item \textbf{DSP Utilization}:
    \begin{itemize}
        \item The DSP utilization remains constant at 1.25\% for all matrix sizes (\( N=3, 4, 5 \)). This suggests that the number of DSP units used does not change with the increase in matrix size for these specific configurations.
    \end{itemize}
    
    \item \textbf{IO Utilization}:
    \begin{itemize}
        \item IO utilization shows a substantial increase with the matrix size. For \( N=3 \), it is 67.00\%, which rises to 83.00\% for \( N=4 \), and further to 99.00\% for \( N=5 \). This highlights a significant increase in the demand for input/output resources as the matrix size grows.
    \end{itemize}
\end{itemize}

The resource utilization report indicates that as the matrix size increases from \( N=3 \) to \( N=5 \), there is a notable rise in the usage of LUTs, LUTRAM, FFs, and IO resources. The DSP utilization, however, remains constant. This reflects the increased demand on hardware resources to accommodate larger problem sizes at the same operating frequency of 85 MHz.




\subsection{QR-RLS  Simulation}

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.40]{MTech/Capture14.PNG} 
\caption{ Error And Weights for QRD-RLS  For N=3 } 
\label{fig:pent1}
\end{center}
\end{figure}

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.55]{MTech/Capture18.PNG} 
\caption{ Timing summary for N=3 } 
\label{fig:pent1}
\end{center}
\end{figure}

From our simulations, we observe that the system is capable of simultaneously producing three weight vectors and the corresponding error values. This parallel computation is a significant advantage of our design, leveraging the inherent parallelism of the triangular systolic array architecture.

In traditional sequential processing, these computations would be performed one after the other, resulting in longer processing times. However, by utilizing a triangular systolic array, we can achieve concurrent calculation of the weight vectors and error values. This parallel processing capability not only accelerates the overall computation but also ensures that the system can handle high-dimensional data efficiently.

Furthermore, we observe that all timing conditions are met, with the hardware operating at approximately 85 MHz. This operating frequency indicates that the design meets the required performance criteria for real-time applications. The ability to maintain a stable frequency while performing complex calculations further validates the efficiency and robustness of our hardware design.

The combination of parallel processing and the ability to meet timing requirements underscores the effectiveness of our implementation in adaptive filtering and signal processing applications. This ensures rapid updates and real-time processing, which are critical in modern high-speed communication and radar systems.

\subsection{QR-RLS  Vitis Implementation }

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.6]{MTech/Capture13.PNG} 
\caption{Integration of ZYNQ Processing System and QR-RLS IP } 
\label{fig:pent1}
\end{center}
\end{figure}


The IP was created and synthesized using Vivado, and the design was further implemented in Vitis.
The system architecture is depicted in Figure~\ref{fig:pent1}. The design utilizes a Zynq-7000 Processing System, integrated with custom IP blocks and AXI interconnects to achieve the desired functionality. 

\textbf {Design Details}


The custom QRD-RLS IP is interfaced with the Zynq Processing System through AXI interfaces. The design includes the following key components:

\begin{itemize}
    \item \textbf{myip\_0}: Custom QRD-RLS IP block, interfaced with the AXI bus for data transfer.
    \item \textbf{processing\_system7\_0}: Zynq-7000 Processing System, providing the main processing capabilities and interfacing with DDR memory and fixed I/O.
    \item \textbf{rst\_ps7\_0\_50M}: Processor System Reset block, managing system resets for the Zynq Processing System and peripheral devices.
    \item \textbf{ps7\_0\_axi\_periph}: AXI Interconnect, facilitating communication between the Zynq Processing System and the custom IP block.
\end{itemize}

Implementation in Vitis
The design was exported from Vivado and imported into Vitis for further implementation and testing. The custom QRD-RLS IP was integrated with the software platform in Vitis, enabling the execution of the designed algorithms at an operational frequency of 85 MHz. The integration in Vitis ensures that the system can be programmed and debugged efficiently, leveraging the robust features of the Vitis development environment.


The QRD-RLS IP design demonstrates an effective integration of custom hardware IP with the Zynq-7000 Processing System. Running at 85 MHz, the design achieves the required performance metrics, facilitated by the comprehensive toolsets provided by Vivado and Vitis.


\subsection{QR-RLS  Performance}

In the field of computing, performance improvement is a critical aspect that drives both hardware and software development. One common measure of performance improvement is \textit{speedup}, which quantifies the relative performance gain of using a more efficient implementation, often in hardware, compared to a baseline implementation, typically in software. This document analyzes the speedup achieved by hardware implementations for different problem sizes.

In the field of computing, performance improvement is a critical aspect that drives both hardware and software development. One common measure of performance improvement is \textit{speedup}, which quantifies the relative performance gain of using a more efficient implementation, often in hardware, compared to a baseline implementation, typically in software. This document analyzes the speedup achieved by hardware implementations for different problem sizes.

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.5]{MTech/Capture15.PNG} 
\caption{Speed of Hardware and software for \( N = 3 \), \( N = 4 \), and \( N = 5 \)}
\label{fig:pent1}
\end{center}
\end{figure}

\textbf{Speedup Definition}

Speedup is defined as the ratio of the time taken to complete a task using a baseline approach (usually software) to the time taken using an improved approach (usually hardware). Mathematically, it can be expressed as:

\begin{equation}
\text{Speedup} = \frac{T_{\text{software}}}{T_{\text{hardware}}}
\end{equation}

where \( T_{\text{software}} \) is the time taken by the software implementation, and \( T_{\text{hardware}} \) is the time taken by the hardware implementation.

\textbf{Calculations}

Given the times for hardware and software implementations, the speedup can be calculated for different problem sizes.

For \( N = 3 \):
\begin{equation}
\text{Speedup}_{N=3} = \frac{\text{Time taken by Software}}{\text{Time taken by Hardware}} = \frac{147 \text{ microseconds}}{91 \text{ microseconds}} \approx 1.615
\end{equation}

For \( N = 4 \):
\begin{equation}
\text{Speedup}_{N=4} = \frac{\text{Time taken by Software}}{\text{Time taken by Hardware}} = \frac{191 \text{ microseconds}}{113 \text{ microseconds}} \approx 1.690
\end{equation}

For \( N = 5 \):
\begin{equation}
\text{Speedup}_{N=5} = \frac{\text{Time taken by Software}}{\text{Time taken by Hardware}} = \frac{305 \text{ microseconds}}{119 \text{ microseconds}} \approx 2.563
\end{equation}

\textbf{Observations}

\begin{itemize}
    \item \textbf{Trend in Calculation Times}:
    \begin{itemize}
        \item \textbf{Hardware Calculation Time}: The hardware calculation time increases gradually with the increase in matrix size \( N \). Specifically, it increases from 91 microseconds for \( N = 3 \) to 119 microseconds for \( N = 5 \).
        \item \textbf{Software Calculation Time}: The software calculation time increases more sharply compared to the hardware calculation time. It increases from 147 microseconds for \( N = 3 \) to 305 microseconds for \( N = 5 \).
    \end{itemize}
    
    \item \textbf{Performance Difference}:
    \begin{itemize}
        \item The gap between hardware and software calculation times widens as the matrix size \( N \) increases. This indicates that the hardware implementation scales better and is more efficient for larger matrix sizes.
    \end{itemize}
    
    \item \textbf{Speedup Analysis}:
    \begin{itemize}
        \item For \( N = 3 \), the hardware is approximately 1.615 times faster than the software.
        \item For \( N = 4 \), the hardware is approximately 1.690 times faster than the software.
        \item For \( N = 5 \), the hardware is approximately 2.563 times faster than the software.
    \end{itemize}

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.5]{MTech/untitled.jpg} 
\caption{Speed Up of Hardware for \( N = 3 \), \( N = 4 \), and \( N = 5 \)}
\label{fig:pent1}
\end{center}
\end{figure}

\begin{figure}[h]
\begin{center}
\includegraphics[scale=0.4]{MTech/timecalculation.jpg} 
\caption{Time Calculation Hardware and software for \( N = 3 \), \( N = 4 \), and \( N = 5 \)}
\label{fig:pent1}
\end{center}
\end{figure}

    \item \textbf{Efficiency}:
    \begin{itemize}
        \item The hardware implementation shows consistent performance with a smaller increase in calculation time as matrix size increases, demonstrating its efficiency and scalability.
        \item The software implementation, on the other hand, shows a significant increase in calculation time with larger matrix sizes, indicating lower efficiency and scalability compared to the hardware.
    \end{itemize}
    
    \item \textbf{Overall Observation}:
    \begin{itemize}
        \item The hardware implementation provides a significant performance improvement over the software implementation, especially for larger matrix sizes. This improvement can be attributed to the inherent advantages of hardware, such as parallel processing capabilities, optimized execution paths, and dedicated resources for specific tasks.
    \end{itemize}
\end{itemize}

\textbf{Conclusion}


The speedup metric is a valuable tool for comparing the performance of different implementations. The analysis presented here demonstrates the significant advantages of hardware implementations in terms of execution time, highlighting the importance of considering hardware solutions for performance-critical applications.

