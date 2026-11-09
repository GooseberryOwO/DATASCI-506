# HW4 data

Downloaded November 9, 2026. Keep these files beside the QMD in `HW4/data`.

- `nzge.rds`: [course-provided copy](https://phuongov.github.io/stats506-f26/data_f26/nzge.rds) of the archived nzelect dataset. [Variable documentation](https://rdrr.io/cran/nzelect/man/nzge.html).
- `atp_matches_2019.csv`: [assignment repository](https://raw.githubusercontent.com/azhou5849/tennis-atp-sackmann-data/master/atp_matches_2019.csv), originally Jeff Sackmann / Tennis Abstract. [Repository attribution and CC BY-NC-SA 4.0 license](https://github.com/azhou5849/tennis-atp-sackmann-data#license).
- `us-states.csv`: [assignment's NYT rolling-average file](https://raw.githubusercontent.com/nytimes/covid-19-data/refs/heads/master/rolling-averages/us-states.csv), covering January 21, 2020–March 23, 2023. [Definitions and methodology](https://github.com/nytimes/covid-19-data/tree/master/rolling-averages); [license](https://github.com/nytimes/covid-19-data/blob/master/LICENSE). Data from The New York Times, based on reports from state and local health agencies.
- `population_2019.csv`: [Census Bureau 2019 population estimates](https://www2.census.gov/programs-surveys/popest/datasets/2010-2019/national/totals/nst-est2019-alldata.csv); the analysis uses `NAME` and `POPESTIMATE2019`. This matches the population vintage documented by NYT.

The QMD reads these local copies, so subsequent execution does not require data downloads or the archived nzelect package. Required R packages: `tidyverse` and `knitr`.
