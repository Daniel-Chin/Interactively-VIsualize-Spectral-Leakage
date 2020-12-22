# Interactive Visualization of Spectral Leakage
How does Spectral Leakage respond to frame length under different windows?  

## Motivation
The leaked power in a "wrong" frequency bin will decrease as `frame_len` increases. I hypothesize that an algorithm can try multiple `frame_len`s, observe the decrease behavior, and offset Spectral Leakage without having to take a large frame. 

## Usage
Hover the mouse over the window to control `frame_len`, the size of the frame that goes into Fourier Transform.  
Click to toggle the window between Hann and Rectangular.  

## Implementation
SFT (Slow Fourier Transform). See function `sft` in source code. 

## Results 
It is confirmed that the leaked power in a "wrong" frequency bin will decrease as `frame_len` increases if you use the Hann window.  
However, marginal power decreases depends on the current `frame_len` and how close to the "correct" frequency we are. It is thus not apparent how to distinguish leaked power from real power. The task may even be strictly impossible. Maybe Shanon proved it a long time ago and I just don't know. 
