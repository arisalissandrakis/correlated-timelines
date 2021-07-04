# correlated-timelines
blah


As an example of usage, the following code should produce the data shown in the figure below

`
  example_timeline = generate_timeline()
  
  example_timeline = smooth.spline(example_timeline, df=25)$y

  example_timeline = example_timeline +smooth_noise()

  example_timeline = scale_and_position_timeline(example_timeline, range=50, position = 75)
`  

and the following code should produce the data shown in the figure below

`
  reference_timeline1 = generate_timeline(bumps = list(m=c(25),sd=c(5),a=c(25)),slope=.1)
  reference_timeline1 = smooth.spline(reference_timeline1, df=25)$y
  reference_timeline1 = reference_timeline1 + smooth_noise()
  reference_timeline1 = scale_and_position_timeline(reference_timeline1, range=40, position = 20)

  reference_timeline2 = generate_timeline(bumps = list(m=c(125),sd=c(5),a=c(5)),slope=0,noise_amount = .05)
  reference_timeline2 = smooth.spline(reference_timeline2, df=25)$y
  reference_timeline2 = reference_timeline2 + smooth_noise()
  reference_timeline2 = scale_and_position_timeline(reference_timeline2, range=40, position = 40)

  correlated_timeline = reference_timeline1*1.0 + reference_timeline2*(-1.0)
  correlated_timeline = correlated_timeline + smooth_noise()
  correlated_timeline = scale_and_position_timeline(correlated_timeline, range=20, position = 80)

`

