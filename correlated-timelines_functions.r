#   R version: 4.0.2 x64
#   RStudio version: Version 1.3.1056 (Win 10)
#
#   Author: Aris Alissandrakis
#   Web: https://arisalissandrakis.wordpress.com/
#   Twitter: @AAlissandrakis


# Timelines are vectors of length equal to the number of time events (sample size, n, etc)

# The generate_timeline function returns a vector or length "sample_size", 
# with minimum and maximum values "min_val" and "max_val",
# regression slope "slope",
# amplitude of noise "noise_amount",
# and a series of "bumps" (normal distributions added to the timeline) defined as a list of vectors
# containing values for where each bump is centered along the timeline "m", the spread of each bump "sd"
# and their peak amplitudes "a"

generate_timeline <- function(sample_size = 150, min_val = 0, max_val = 100, slope = .5, noise_amount = .1, bumps = list(m=c(75),sd=c(5),a=c(25)))
{
  if (!is.null(bumps))
  {
    n_bumps = length(bumps$m) 
  }

  X = c()
  Y = c()
  
  for (t in c(1:sample_size))
  {
    x = t
    
    y = min_val + (max_val-min_val)/2 
    
    y = y +  x * slope # add a slope
    
    if (!is.null(bumps))
    {
      for (b in c(1:n_bumps))
      {
        m = bumps$m[b]
        sd = bumps$sd[b]
        a = bumps$a[b] / dnorm(m,m,sd)
        y = y + a * dnorm(x,m,sd)
      }
    }
    
    y = y + (noise_amount * y) * rnorm(1)  # add noise
    
    X = c(X, x)
    Y = c(Y, y)
  }
  
  Y = Y - min(Y) # set minimum to zero
  Y = Y * (max_val - min_val) / max(Y) # set maximum value
  Y = Y + min_val # adjust minimum
  
  Y = round(Y)
  
  return(Y)
}


# The smooth_noise function generates a smoothed spline (of length "n" and amplitude "a") 
# that can be added as additional noise to any generated timeline (of length "n").

smooth_noise <- function(n=150, a=10)
{
  noize = rnorm(n)

  # generate random normally distributed noise, with sample size n
  
  noize[1] = 0
  noize[n] = 0
  
  # make sure the first and last values are zero
  
  w = rep(0,n)
  
  # initialize a vector of size n
  
  w0 = sample(c(1:n),15)

  # randomly choose 15 indexes from 1 to n
  
  for (i in w0)
  {
    w[i] = 1
  }
  
  w[1] = 1
  w[n] = 1
  
  # assign a value of 1 to these indexes, also the first and last ones
  
  noize = smooth.spline(noize,w=w,df=20)$y
  
  # use smooth.spline() with noize and w
  
  noize = noize - min(noize)
  
  # subtract the min value, so the noize min value becomes zero
  
  noize = noize * a/max(noize)
  
  # multiply with the provided a value, to normalize noize values between zero and a
  
  noize = noize - a/2
  
  # make the mean value of noize zero
  
  return(noize)
}


# The scale_and_position_timeline function vertically scales (acording to "range") 
# and repositions (centered at "position") a previously generated timeline "tl".

scale_and_position_timeline <- function(tl, range=50, position=50)
{
  range_tl = max(tl)-min(tl)
  
  if (range_tl>range)
  {
    tl = tl - min(tl)
    tl = tl * (range/max(tl))
  }

  # adjust range only if timeline range is larger than the provided range
  
  tl = tl - (mean(tl)-position)
  
  # adjust the vertical position of the timeline, centered around the provided position
  
  return(tl)
}