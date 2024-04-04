
% HOMEWORK 1

% using the file 'C1Rcdisch00000.txt', practice the commands above
% 1 - open and store data from file
% 2 - plot diagram; what could it be?
% 3 - smooth out data; find the best number of smoothing terms
% 4 - find maximum/minimum (which one?) of the curve and evaluate
%     the discrepancy between raw and smoothed data; is it worth it?
% 5 - the very last part (select carefully) is flat... could be just noise
%     section it out and take an average value of that part; is it zero?
% 6 - try doing a logarithmic plot on the y axis and meditate on that
%     what info would you like to extract from it?

% HOMEWORK 2

% use 'cazdata.txt'
% 1 - using the linear fit and subtracting it, extract the noise;
%     the noise is pretty evidently gaussian (normally distributed)
%     -> learn how to make a fit with a custom function using
%     the 'fit' command [see 'doc' to learn about the 'fit' command]
%     and choosing with a gaussian curve as the custom function; do it
%     a) using the stdnoise as a width of the gaussian curve;
%     b) leaving width as a free parameter, but using some reasonable value
%     in the range of stdnoise as an indication to help the fitting routine

% use 'C1Rcdisch00000.txt'
% 2 - calculate the charge on the collector using this discharge signal
%     and compare
%     a) the approximation Vmax*Capacitance
%     b) the current integral up to the end
%     c) the general formula (current integral plus residual V*Capacitance)
%     things to beware of:
%     - overall signal offset (affects all methods)
%     - noise/signal smoothing (affects determination of Vmax)
%     - determination of capacitance: how do you estimate it?
%     - hint: remember this is an exponential discharge with tau = R*C
%     - R = 1 MOhm, if you fit the exponential portion of the signal
%       or take the logarithm and fit the straight line you get C!
%       but check both, you may get slightly different results; why?

% HOMEWORK 3

% 1 - visualize the three different images you have been given:
%     'plasma.tiff'
%     'dark.tiff'
%     'ring.tiff'
% 2 - a) sum the values of all pixels in the 'dark' image and compare it
%     to the sum of values of the 'plasma' image
%     how much does the dark noise count?
%     b) average the values in the 'dark' image and get an idea
%     of the 'noise floor'
%     NOTE: in the future you will need to prepare a routine
%     to load and average many 'dark' images for dark noise subtraction
%     as detailed in the next task c)
%     c) unpack the compressed folder 'dark.rar'
%     there are 80 'dark' noise images; average them pixel by pixel;
%     this is an example of the noise image to subtract from all
%     'real' plasma images (noise cleaning operation #1);
%     (note: any negative-valued pixel must be reset to zero)
%     how uniform is it across the area?
% 3 - observe the 'ring' image; there is a thick ring structure
%     you can saturate the image (change colorbar limits) and see
%     there is a thinner, more intense line on the inner edge of the ring;
%     this thin line is the 90-mm edge of the electrode
%     zoom in and mark the pixel position of the diameters
%     in order to get the pixwl to mm conversion and the center position);
%     what is the equivalent length of a pixel?
% 4 - prepare a routine where you take an image file of a plasma
%     and set to zero all pixels distant more than a trap radius length
%     from the center (noise cleaning operation #2)
% 5 - once you have the 'plasma.tiff' image cleaned (#1 and #2)
%     plot a matrix row more or less through the plasma (and trap) center
%     and try to distinguish the residual noise that is simultaneously
%     (a) in the trap, (b) clearly outside the plasma core
%     select this ring area and average its value to get the last noise
%     contribution that will be subtracted uniformly from each pixel
%     (reset to zero any negative-valued pixel inside and outside)

% HOMEWORK 4

% 1 - create and plot a mode l=1 current signal as per the theory
%     * include a large number of harmonics (use FOR loop)
%     * use realistic values
%       B = 0.1 T, n = 1e7 cm^-3, Rp/Rw = 0.2, Lp = 80 cm, Rw = 45 mm,
%       D/Rw = 0.1, 0.4, 0.7
%     * verify the typical current amplitude and compare to experimental needs
%     (e.g. 10 mV amplitude, with a transimpedance gain G = 10^6)
%     * try different sector spans: pi, pi/2
%     * try the given different plasma offsets
%       and observe the signal shape turning on/off the harmonics > 1
%     * observe how the signal shape changes for varying sector span and offset
%     NOTE: want to hear the sound of these signals?
%           use the 'sound' command (see syntax on 'doc')

% HOMEWORK 5

% look at the plot obtained in pt5_fft_sketch.m: it is so crappy!
% 1 - improve it now
%     * use semilogy or loglog for logarithmic scaling
%     and get a much clearer (and meaningful) visualization
%     * cut the second (useless) half of the spectrum
%     * create frequency array and use it as horizontal axis for the plot
%     * use the matlab command 'find' to find value and frequency of the
%     * maximum peak in the spectrum (check command syntax in 'doc')
% 2 - perform Fourier spectrum of the realistic l=1 mode signal
%     generated in pt4_signalsynthesis.m observing what changes
%     with different parameters like pick-up electrode etc.
% 3 - create a signal including a frequency component
%     beyond the Nyquist-Shannon limit and check aliasing phenomenon

% HOMEWORK 6

% 1 - create a function that opens a camera photo file,
%     converts it to a matrix and produces a surface plot;
%     the arguments are the name of the image file (a string)
%     and the size, i.e. number of columns and rows
%     hence the declaration will be something like
%     'function M = imageconverter(filename, ncols, nrows);'
%     this function can be useful to quickly inspect the image of a plasma
%     when luminosity is too low to see directly by opening the image
%     with a conventional image viewer
