# correlated-timelines

This depository contains the datasets used for the user study presented in the submitted manucript `Investigating Collaboration Coupling Styles in Synchronous Asymmetric Interaction within the context of Collaborative Immersive Analytics` by Nico Reski, Aris Alissandrakis, and Andreas Kerren, as well as the R code used to generate them and examples of using the provided functions. 

The study required a multivariate spatio-temproal dataset that participants could collaborate on to complete analytics tasks.
We came up with the approach of generating correlated (according to a given model) timeline data as a flexible way to have tasks of comparable structure and complexity for when the participants needed to switch interfaces.
Please see the article for more details on the study results and analysis.

## Datasets used

The two datasets used in the study are provieded in the directory `datasets`.

The subdirectories `fruits task` and `veggies task` contain the full dataset for each task.
In each task there were seven parameters: two for _climate_ (_sunlight_ and _humidity_) and five for _plants_ (either _Apples_, _Oranges_, _Bananas_, _Berries_, and _Grapes_ for the fruits task dataset, or _Tomatoes_, _Carrots_, _Potatoes_, _Cabbages_, and _Lettuces_ for the veggies task dataset). 
Each of the two subdirectories contains 39 CSV files (named after European countries) that corresponded to spatial locations in our study.
Each CSV has three columns: _dimension_ (parameter name), _time_, and _value_.

Independent of the location, the climate and plant data are correlated to each other as follows for the _fruits_ task:

|              | Apples   | Oranges  | Bananas  | Berries  | Grapes   |
|-------------:|----------|----------|----------|----------|----------|
| **humidity** | positive | positive | negative | negative | positive |
| **sunlight** | positive | negative | negative | positive | positive |

and for the _veggies_ task:

|              | Tomatoes | Carrots  | Potatoes | Cabbages | Letuces  |
|-------------:|----------|----------|----------|----------|----------|
| **humidity** | negative | positive | positive | positive | negative |
| **sunlight** | positive | positive | positive | negative | negative |

The datasets were generated using the provided R functions -- for each location first the humidity and sunlight timelines were generated, and then the timelines for each of the five plants, according to the model above (adding the two climate timelines using the weights from the model, either one or minus one).



## R code

The method used can easily be generalized to have any number of timeline data correlated in various ways, therefore we provide here the R code used.
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

In the above example, the Pearson correlation coefficient and the p-values between the correlated timeline and the timelines to be positively and negatively correlated to are ρ=0.62, p=.00 and ρ=-0.56, p=.00 respectively, confirming statistically the impression that can be obtained by visual inspection. 

Note that due to randomness, executing the provieded two snippets of code will not reproduce exactly the same results.
