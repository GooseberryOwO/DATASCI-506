# Can the expected number of stalls predict confidence interval coverage?

Yuze Jin · STATS 506 · Final Project Proposal · November 10, 2026

**Research question.** A server usually responds quickly, but occasional long stalls raise its average response time. A sample that misses every stall may underestimate both the mean and its standard error, producing a narrow interval centered too low. Consider 20 requests with a 5% stall probability and 100 requests with a 1% probability. Both samples contain one stall on average, and each has about a 36% chance of seeing none. When stalls account for the same share of population variance, do these settings give similar coverage for the usual 95% t interval for the mean? How much of any coverage shortfall comes from samples with no stalls?

**Simulation design.** I will generate independent requests in R. For each request, $Z$ represents ordinary variation (standard normal), and $B$ indicates a stall (1 with probability $p$, otherwise 0), independently of $Z$. The standardized response time will be

$$
X=\sqrt{1-f}\,Z+\sqrt{f}\,\frac{B-p}{\sqrt{p(1-p)}}.
$$

Every setting has true mean zero and variance one. The parameter $f$ is the fraction of variance due to stalls. Holding $f$ fixed makes a rarer stall larger, so I can study how the frequency of delays matters at the same overall variability. I will cross four sample sizes (20, 50, 100, 200), four stall probabilities (1%, 2%, 5%, 10%), and two variance shares (25%, 75%).

**Analysis plan.** Using a fixed seed, I will draw 10,000 samples per setting. For each sample, I will construct a two-sided t interval using the sample mean, standard deviation, and $n-1$ degrees of freedom. Estimated coverage is the fraction of intervals containing zero. As checks, the normal case ($f=0$) should give about 95% coverage, and the simulated frequency of zero stalls should agree with $(1-p)^n$.

I will plot coverage against the expected stall count $np$ and estimate differences, with Monte Carlo standard errors, between settings sharing the same $np$ and $f$. For $np=1$, I will also tabulate intervals lying entirely below or above zero, separately for samples with and without stalls. Weighting each group's excess miss rate above the nominal 5% by its frequency will show how much that group contributes to the overall coverage shortfall.
