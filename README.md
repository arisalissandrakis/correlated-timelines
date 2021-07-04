# correlated-timelines
blah

## R code

The file XXX includes the code for three useful functions: **generate_timeline()** to generate a time according to various parameters, **smooth_noise()** to generate additional smoothed noise to add to any timelines, and **scale_and_position_timeline()** to scale and position vertically any generated timeline.

## Example of use

As an example of using the **generate_timeline()**, **smooth_noise()**, and **scale_and_position_timeline()** functions, the following code should produce the data shown in the figure below:

    example_timeline = generate_timeline()
    example_timeline = smooth.spline(example_timeline, df=25)$y
    example_timeline = example_timeline + smooth_noise()
    example_timeline = scale_and_position_timeline(example_timeline, range=50, position = 75)

![fig1](/github_code_and_examples1.png)

Furthermore, and the following code should produce the data shown in the figure below; generating two timelines and then adding them in a weighted way to generate a third timeline which is postively correlated with the first timeline and negatively correlated withe the second. 

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

In the above example, the Pearson correlation coefficient and the p-values between the correlated timeline and the timelines to be positively and negatively correlated are $\rho$= , p=. and $\rho$= , p=. respectively. 

