# correlated-timelines
blah

## Datasets used

datsets used for the user study presented in the submitted manucript `Investigating Collaboration Coupling Styles in Synchronous Asymmetric Interaction within the context of Collaborative Immersive Analytics` by Nico Reski, Aris Alissandrakis, and Andreas Kerren. 


## R code

The file `correlated-timelines_functions.r` includes the code for three useful functions: 
* `generate_timeline` to generate a timeline (a vector of length `sample_size`) according to various parameters, 
    * `min_val`, `max_val` -- minimum and maximum values,
    * `slope` -- regression slope,
    * `noise_amount` -- amplitude of normally distributed random noise to be added,
    * `bumps` -- a series of normal distributions to be added to the timeline, defined as a list of vectors containing values for  
        *  means `m` (where each bump is centered along the timeline),
        *  standard deviation `sd` (spread of each bump),
        *  peak amplitude `a` of each bump,
* `smooth_noise` to generate a smoothed spline that can be added as noise to any generated timelines, and 
* `scale_and_position_timeline` to scale and position vertically any previously generated timeline.

### Example of use

As an example of using these functions, the following code produced the data shown in the figure below:

    example_timeline = generate_timeline()
    example_timeline = smooth.spline(example_timeline, df=25)$y
    example_timeline = example_timeline + smooth_noise()
    example_timeline = scale_and_position_timeline(example_timeline, range=50, position = 75)

![fig1](/github_code_and_examples1.png)

Furthermore, the following code produced the data shown in the figure below; two timelines were generated (as above) and then were added in a weighted way to generate a third timeline which then _postively correlated_ with the first and _negatively_ correlated withe the second timeline. 

    reference_timeline1 = generate_timeline(bumps = list(m=c(25), sd=c(5), a=c(25)), slope=.1)
    reference_timeline1 = smooth.spline(reference_timeline1, df=25)$y
    reference_timeline1 = reference_timeline1 + smooth_noise()
    reference_timeline1 = scale_and_position_timeline(reference_timeline1, range=40, position = 20)

    reference_timeline2 = generate_timeline(bumps = list(m=c(125), sd=c(5), a=c(5)), slope=0, noise_amount = .05)
    reference_timeline2 = smooth.spline(reference_timeline2, df=25)$y
    reference_timeline2 = reference_timeline2 + smooth_noise()
    reference_timeline2 = scale_and_position_timeline(reference_timeline2, range=40, position = 40)

    correlated_timeline = reference_timeline1*1.0 + reference_timeline2*(-1.0)
    correlated_timeline = correlated_timeline + smooth_noise()
    correlated_timeline = scale_and_position_timeline(correlated_timeline, range=20, position = 80)

![fig1](/github_code_and_examples2.png)

In the above example, the Pearson correlation coefficient and the p-values between the correlated timeline and the timelines to be positively and negatively correlated are $\rho$=0.62, p=.00 and $\rho$=-0.56, p=.00 respectively. 

Note that due to randomness, executing the provieded code will not reproduce exactly these results.
