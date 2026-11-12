#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: setup
#| message: false
library(tidyverse)
library(knitr)

# Support running from either HW4 or the course repository in VS Code.
data_dir <- "data"
if (!file.exists(file.path(data_dir, "nzge.rds"))) {
  data_dir <- file.path("HW4", "data")
}
#
#
#
#
#
#
#
#| label: nz-import
nzge <- read_rds(file.path(data_dir, "nzge.rds")) %>%
  as_tibble()
#
#
#
#
#
#| label: nz-total-votes
vote_totals <- nzge %>%
  group_by(election_year, voting_type) %>%
  summarize(votes = sum(votes), .groups = "drop") %>%
  arrange(desc(votes))

kable(vote_totals %>% mutate(election_year = as.character(election_year)),
      col.names = c("Year", "Vote type", "Votes"),
      format.args = list(big.mark = ","),
      caption = "Total votes by year and type, in descending order")
#
#
#
#
#
#| label: nz-candidate-2014
candidate_2014 <- nzge %>%
  filter(election_year == 2014, voting_type == "Candidate") %>%
  group_by(party) %>%
  summarize(votes = sum(votes), .groups = "drop") %>%
  mutate(proportion = votes / sum(votes), percent = 100 * proportion) %>%
  arrange(desc(proportion))

kable(candidate_2014, digits = c(0, 0, 4, 2),
      col.names = c("Party or vote category", "Votes", "Proportion", "Percent"),
      caption = "Party shares of the 2014 Candidate vote")
#
#
#
#
#
#
#
#| label: nz-winning-parties
winning_parties <- nzge %>%
  group_by(election_year, voting_type, party) %>%
  summarize(votes = sum(votes), .groups = "drop") %>%
  group_by(election_year, voting_type) %>%
  filter(votes == max(votes)) %>%
  ungroup() %>%
  select(election_year, voting_type, party) %>%
  pivot_wider(names_from = voting_type, values_from = party) %>%
  arrange(election_year)

kable(winning_parties, col.names = c("Year", "Candidate", "Party"),
      caption = "Party with the most votes in each election and vote type")
#
#
#
#
#
#
#
#
#
#| label: tennis-import
tennis <- read_csv(file.path(data_dir, "atp_matches_2019.csv"),
                   show_col_types = FALSE)
#
#
#
#
#
#| label: tennis-tournaments
tournament_counts <- tennis %>%
  summarize(matches = n(), events = n_distinct(tourney_id),
            davis_cup_ids = n_distinct(tourney_id[tourney_level == "D"]),
            events_with_finals = n_distinct(tourney_id[round == "F"]))

kable(tournament_counts,
      col.names = c("Matches", "Event IDs", "Davis Cup IDs", "Events with finals"),
      caption = "Events represented in the 2019 match file")
#
#
#
#
#
#
#
#| label: tennis-repeat-champions
title_counts <- tennis %>%
  filter(round == "F") %>%
  group_by(winner_id, winner_name) %>%
  summarize(titles = n(), .groups = "drop") %>%
  arrange(desc(titles), winner_name)

multiple_champions <- title_counts %>%
  filter(titles > 1)
top_champions <- title_counts %>%
  filter(titles == max(titles))

kable(multiple_champions %>% select(winner_name, titles),
      col.names = c("Player", "Titles"),
      caption = "Players winning more than one tournament")
#
#
#
#
#
#
#
#
#
#| label: tennis-aces
ace_pairs <- tennis %>%
  filter(!is.na(w_ace), !is.na(l_ace)) %>%
  mutate(difference = w_ace - l_ace)

ace_summary <- ace_pairs %>%
  summarize(matches = n(),
            mean_winner_aces = mean(w_ace),
            mean_loser_aces = mean(l_ace),
            mean_difference = mean(difference),
            median_difference = median(difference))

ace_comparison <- ace_pairs %>%
  summarize(winner_more = sum(difference > 0),
            equal = sum(difference == 0),
            loser_more = sum(difference < 0)) %>%
  pivot_longer(everything(), names_to = "comparison", values_to = "matches") %>%
  mutate(percent = 100 * matches / sum(matches))

kable(ace_summary, digits = 2, caption = "Aces in matched winner–loser pairs")
kable(ace_comparison, digits = 2,
      caption = "Which player served more aces in each match?")
#
#
#
#
#
#
#
#| label: tennis-win-rates
player_results <- bind_rows(
  tennis %>% transmute(player_id = winner_id, player = winner_name, won = 1),
  tennis %>% transmute(player_id = loser_id, player = loser_name, won = 0)
)

win_rates <- player_results %>%
  group_by(player_id, player) %>%
  summarize(matches = n(), wins = sum(won), .groups = "drop") %>%
  mutate(win_rate = wins / matches) %>%
  filter(matches >= 5) %>%
  arrange(desc(win_rate))

best_players <- win_rates %>%
  filter(win_rate == max(win_rate))

kable(best_players %>% select(player, matches, wins, win_rate), digits = 4,
      col.names = c("Player", "Matches", "Wins", "Win rate"),
      caption = "Highest win rate among players with at least five matches")
#
#
#
#
#
#
#
#
#
#| label: covid-import
covid <- read_csv(file.path(data_dir, "us-states.csv"),
                  show_col_types = FALSE) %>%
  filter(state %in% state.name) %>%
  arrange(state, date)

population <- read_csv(file.path(data_dir, "population_2019.csv"),
                       show_col_types = FALSE) %>%
  filter(NAME %in% state.name) %>%
  select(state = NAME, population = POPESTIMATE2019)

theme_set(theme_bw(base_size = 12) +
            theme(panel.grid.minor = element_blank(),
                  legend.position = "bottom",
                  plot.title = element_text(face = "bold"),
                  plot.caption = element_text(hjust = 0)))
#
#
#
#
#
#
#
#| label: covid-waves
#| fig-width: 9.5
#| fig-height: 5.5
#| fig-cap: "Broad waves in reported cases across the 50 U.S. states. Points mark the maximum within each visually chosen period."
national <- covid %>%
  group_by(date) %>%
  summarize(daily_average = sum(cases_avg), .groups = "drop") %>%
  arrange(date)

# cut() assigns each date to one of the visually chosen wave periods.
wave_breaks <- as.Date(c("2020-01-20", "2020-06-01", "2020-10-01",
                         "2021-03-01", "2021-06-15", "2021-11-01",
                         "2022-04-01", "2022-10-15", "2023-03-24"))
wave_peaks <- national %>%
  mutate(wave = cut(date, breaks = wave_breaks, right = FALSE, labels = FALSE)) %>%
  group_by(wave) %>%
  filter(daily_average == max(daily_average)) %>%
  ungroup() %>%
  mutate(type = ifelse(daily_average >= 100000, "Major", "Minor"))

wave_plot <- ggplot(national, aes(x = date, y = daily_average / 1000)) +
  geom_line(color = "#174A6E", linewidth = 0.7) +
  geom_hline(yintercept = 100, linetype = "dashed", color = "gray55") +
  geom_point(data = wave_peaks, aes(color = type, shape = type), size = 2.7) +
  geom_text(data = wave_peaks, aes(label = format(date, "%b %Y")),
            nudge_y = 50, size = 3.2) +
  scale_color_manual(values = c(Major = "#B24727", Minor = "#007B83")) +
  scale_x_date(breaks = seq(as.Date("2020-01-01"), as.Date("2023-01-01"),
                            by = "6 months"), date_labels = "%b %Y") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(title = "Eight broad waves in reported COVID-19 cases",
       subtitle = "Sum of NYT seven-day averages; dashed line = 100,000 cases/day",
       x = NULL, y = "Daily new cases (thousands)", color = NULL, shape = NULL,
       caption = "Source: The New York Times, January 2020–March 2023; 50 states.")
wave_plot
#
#
#
#
#
#
#
#
#
#| label: covid-extreme-states
#| fig-width: 9.5
#| fig-height: 5.5
#| fig-cap: "Daily reported case rates for the states with the highest and lowest cumulative rates, using a common vertical scale."
state_rates <- covid %>%
  group_by(state) %>%
  summarize(total_cases = sum(cases), .groups = "drop") %>%
  left_join(population, by = "state") %>%
  mutate(cases_per_100k = 100000 * total_cases / population) %>%
  arrange(desc(cases_per_100k))

extreme_states <- state_rates %>%
  filter(cases_per_100k == max(cases_per_100k) |
           cases_per_100k == min(cases_per_100k))

kable(extreme_states, digits = 1,
      col.names = c("State", "Total reported cases", "2019 population", "Cases/100,000"),
      caption = "Highest and lowest cumulative reported case rates")

extreme_trajectory <- covid %>%
  filter(state %in% extreme_states$state)

extreme_plot <- ggplot(extreme_trajectory,
                       aes(x = date, y = cases_avg_per_100k,
                           color = state, linetype = state)) +
  geom_line(linewidth = 0.75) +
  scale_color_manual(values = c(Maryland = "#0072B2", "Rhode Island" = "#D55E00")) +
  scale_x_date(date_breaks = "6 months", date_labels = "%b %Y") +
  scale_y_continuous(limits = c(0, NA)) +
  labs(title = "Rhode Island has the highest cumulative reported case rate",
       subtitle = "Compared with Maryland, the lowest-rate state; seven-day averages",
       x = NULL, y = "Daily new cases per 100,000 residents", color = NULL,
       linetype = NULL,
       caption = "Source: The New York Times; rates use 2019 Census populations.")
extreme_plot
#
#
#
#
#
#
#
#
#
#| label: covid-first-five
#| fig-width: 9.5
#| fig-height: 5.5
#| fig-cap: "Early cumulative case trajectories. Colored lines identify the first five states to reach 100 reported cases; gray lines show the other states."
early_cases <- covid %>%
  group_by(state) %>%
  arrange(date, .by_group = TRUE) %>%
  mutate(cumulative_cases = cumsum(cases)) %>%
  ungroup() %>%
  filter(date <= as.Date("2020-03-31"))

onset_dates <- early_cases %>%
  filter(cumulative_cases >= 100) %>%
  group_by(state) %>%
  summarize(first_100 = min(date), .groups = "drop") %>%
  arrange(first_100, state)

# No tie crosses the fifth-place boundary for this threshold.
first_five <- onset_dates %>% head(5)
crossings <- early_cases %>%
  inner_join(first_five, by = "state") %>%
  filter(date == first_100)

kable(first_five, col.names = c("State", "First date with 100 cases"),
      caption = "First five states reaching the exploratory outbreak threshold")

onset_plot <- ggplot(early_cases %>% filter(cumulative_cases > 0),
                     aes(x = date, y = cumulative_cases, group = state)) +
  geom_line(color = "gray85", linewidth = 0.4) +
  geom_line(data = early_cases %>%
              filter(state %in% first_five$state, cumulative_cases > 0),
            aes(color = state), linewidth = 0.85) +
  geom_hline(yintercept = 100, linetype = "dashed", color = "gray35") +
  geom_point(data = crossings, aes(color = state), size = 2.6) +
  scale_color_manual(values = c(California = "#0072B2", Colorado = "#D55E00",
                                 Massachusetts = "#009E73", "New York" = "#CC79A7",
                                 Washington = "#7A5900")) +
  scale_x_date(date_breaks = "2 weeks", date_labels = "%b %d") +
  scale_y_log10(breaks = c(1, 10, 100, 1000, 10000, 100000),
                labels = c("1", "10", "100", "1,000", "10,000", "100,000")) +
  labs(title = "Five states reached 100 reported cases first",
       subtitle = "Points mark threshold crossings; dashed line = 100 cases",
       x = "2020", y = "Cumulative reported cases (log scale)", color = NULL,
       caption = "Source: The New York Times; gray lines represent other states.")
onset_plot
#
#
#
#
#
#
