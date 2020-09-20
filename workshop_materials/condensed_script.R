# Group 1
library(tidyverse)
library(ggthemes)
library(magick)
library(grid)
library(cowplot)


#-------------------------------#
#####   General Prep Work   #####
#-------------------------------#

# General theme for all plots
theme_548 <- theme_classic() +
    theme(
      # Text
      axis.title = element_text(size = 13),
      axis.text = element_text(size = 13, colour = "black"),
      axis.text.x = element_text(margin = margin(t = 10, unit = "pt")),
      axis.text.y = element_text(margin = margin(r = 10)),
      # Axis line
      axis.line = element_blank(),
      axis.ticks.length = unit(-5,"pt"),
      # Legend
      legend.position = 'none',
      # Background transparency
      panel.background = element_rect(fill = "transparent"),
      plot.background = element_rect(fill = "transparent", color = NA)
    )

# Colours for the different birds
col_hb <- "#ED0080"
col_zb <- "#F48D00"
col_pg <- "#4AA4F2"

# Bird head icons
icon_hb <- "graphics/hummingbird.png"
icon_zb <- "graphics/zeebie.png"
icon_pg <- "graphics/pigeon.png"

# Parts for drawing legends
rect_hb   <- rectGrob(width = 2, height = 1, gp = gpar(fill = col_hb))
rect_hb_t <- rectGrob(
               width = 2,
               height = 1,
               gp = gpar(fill = col_hb, alpha = 0.5)
             )
rect_zb   <- rectGrob(width = 2, height = 1, gp = gpar(fill = col_zb))
rect_zb_t <- rectGrob(
               width = 2,
               height = 1,
               gp = gpar(fill = col_zb, alpha = 0.5)
             )
rect_pg   <- rectGrob(width = 2, height = 1, gp = gpar(fill = col_pg))
point_hb  <- pointsGrob(
               x = 0,
               y = 0,
               pch = 24,
               size = unit(0.5, units = "char"),
               gp = gpar(fill = col_hb)
             )
point_zb  <- pointsGrob(
               x = 0,
               y = 0,
               pch = 21,
               size = unit(0.5, units = "char"),
               gp = gpar(fill = col_zb)
             )


#----------------------------#
#####    Fig 3 Panel A   #####
#----------------------------#

fig_A <-
  read_csv("./gaedeetal_data/Fig3A_data.csv") %>%
  # Subsample data
  filter(row_number() %% 3 == 0) %>%
  # Remove outliers
  filter(abs(spike) < 7 * sd(spike)) %>%
  ggplot(aes(time, spike)) +
    geom_path(size = 0.1) +
    theme_void() +
    # Y-axis vertical scale
    annotate(geom = "segment",
             y = 0.00278 - 0.01, yend = 0.00278 + 0.01,
             x = -1.5, xend = -1.5,
             lwd = 1.2) +
    # Y-axis scale label
    annotate(geom = "text", y = 0.00278, x = -3,
             label = "0.2 mV", size = 5, angle = 90) +
    # X-axis scale bar
    annotate(geom = "segment",
             y = -0.035, yend = -0.035,
             x = 70 + 1.5, xend = 75 + 1.5,
             lwd = 1.2) +
    # X-axis scale label
    annotate(geom = "text", y = -0.04, x = 74,
             label = "5s", size = 5) +
    # Large ticks
    annotate(geom = "segment",
             y = -0.03, yend = -0.025,
             x = 1.5 + 1:15 * 5, xend = 1.5 + 1:15 * 5,
             lwd = 1) +
    # Small ticks within large ticks
    annotate(geom = "segment",
             y = -0.027, yend = -0.028,
             x = 1.5 + 1:79, xend = 1.5 + 1:79,
             lwd = 0.8) +
    # Arrows
    annotate(
      geom = "segment",
      y = -0.0275,
      yend = -0.0275,
      x = -10 + 2.5 + 1:8 * 10,
      xend = -10 + 5.5 + 1:8 * 10,
      lwd = 1.2,
      arrow = arrow(
        # Control the direction of each arrow. first = left; last = right
        ends = c("first", "last", "last", "last",
                 "first", "first", "first", "last"),
        # Control the size of each arrow head
        length = unit(c(1, 6, 10, 10, 6, 10, 1, 6), "pt"),
        type = "closed"
        ),
      # Use 'sharp' arrow heads
      linejoin = 'mitre')


#----------------------------#
#####    Fig 3 Panel B   #####
#----------------------------#

# Reshape raw data
data_B_raw <- read_csv("gaedeetal_data/Fig3B_data.csv") %>%
  gather(key = bin, value = count, starts_with("bin")) %>%
  group_by(trial, direction, speed) %>%
  summarize(
    raw_firing_rate = mean(count)
  ) %>%
  ungroup()

# Calculate baseline firing rate
baseline <- data_B_raw %>%
  filter(direction == 'NaN') %>%
  pull(raw_firing_rate) %>%
  mean

# Use the baseline to normalize the data
data_B <- data_B_raw %>%
  filter(direction != 'NaN') %>%
  mutate(
    norm_firing_rate = raw_firing_rate - baseline,
    norm_firing_rate = norm_firing_rate / max(abs(norm_firing_rate))
  ) %>%
  group_by(direction, speed) %>%
  summarize(
    firing_rate = mean(norm_firing_rate),
    sem = sd(norm_firing_rate) / sqrt(n())
  ) %>%
  ungroup() %>%
  mutate(direction = as_factor(direction))

# Create a dataset to force axis ranges for Panels B,C
fudge_axis_BC <- tibble(speed = c(-0.5,2), firing_rate = c(-1,2))

fig_B <- data_B %>%
  ggplot(aes(x = speed, y = firing_rate)) +
    # Plot data and threshold
    geom_hline(
      yintercept = 0.8 * max(data_B$firing_rate),
      colour = 'grey70',
      linetype = 'dashed'
    ) +
    geom_line(aes(colour = direction)) +
    geom_errorbar(
      aes(
        colour = direction,
        ymin = firing_rate - sem,
        ymax = firing_rate + sem
      ),
      width = 0.02
    ) +
    geom_point(aes(colour = direction, shape = direction, size = direction)) +
    # Annotate points over threshold
    annotate(
      geom = 'segment',
      x = 1.3, xend = 1.78,
      y = 1.2, yend = 1.2,
      size = 0.7,
      arrow = arrow(ends = 'both', length = unit(2, "pt"), angle = 90)
    ) +
    scale_colour_manual(values = c("black", "grey50")) +
    scale_shape_manual(values = c(15, 18)) +
    scale_size_manual(values = c(2, 3)) +
    labs(y = "Normalized\nfiring rate", x = "") +
    theme_548 +
    # Axes
    geom_rangeframe(data = fudge_axis_BC) +
    scale_x_continuous(breaks = -1:4 / 2)


#----------------------------#
#####    Fig 3 Panel C   #####
#----------------------------#

# Reorganize raw data
data_C_raw <- read_csv("gaedeetal_data/Fig3C_data.csv") %>%
  gather(key = bin, value = count, starts_with("bin")) %>%
  group_by(trial, direction, speed) %>%
  summarize(
    raw_firing_rate = mean(count)
  ) %>%
  ungroup()

# Calculate baseline
baseline <- data_C_raw %>%
  filter(direction == 'NaN') %>%
  pull(raw_firing_rate) %>%
  mean

# Normalize data and calculate mean, SE
data_C <- data_C_raw %>%
  filter(direction != 'NaN') %>%
  mutate(
    norm_firing_rate = raw_firing_rate - baseline,
    norm_firing_rate = norm_firing_rate / max(abs(norm_firing_rate))
  ) %>%
  group_by(direction, speed) %>%
  summarize(
    firing_rate = mean(norm_firing_rate),
    sem = sd(norm_firing_rate) / sqrt(n())
  ) %>%
  ungroup() %>%
  mutate(direction = as_factor(direction))

# Plot data
fig_C <- data_C %>%
  ggplot(aes(x = speed, y = firing_rate)) +
    # Plot data and threshold
    geom_hline(
      yintercept = 0.8 * max(data_C$firing_rate),
      colour = 'grey70', linetype = 'dashed'
    ) +
    geom_line(aes(colour = direction)) +
    geom_errorbar(
      aes(
        colour = direction,
        ymin = firing_rate - sem,
        ymax = firing_rate + sem
      ),
      width = 0.02
    ) +
    geom_point(aes(colour = direction, shape = direction, size = direction)) +
    # Annotate points over threshold
    annotate(
      geom = "segment",
      x = 0.5, xend = 1.9,
      y = 1.2, yend = 1.2,
      size = 0.7,
      arrow = arrow(ends = 'both', length = unit(2, "pt"), angle = 90)
    ) +
    # Select colours and shapes
    scale_colour_manual(values = c("black", "grey50")) +
    scale_shape_manual(values = c(15, 18)) +
    scale_size_manual(values = c(2, 3)) +
    # Text
    labs(y = "Normalized\nfiring rate", x = "log(degrees/s)") +
    # Theme
    theme_548 +
    # Axes
    geom_rangeframe(data = fudge_axis_BC) +
    scale_x_continuous(breaks = -1:4 / 2)



#----------------------------#
#####    Fig 3 Panel D   #####
#----------------------------#

fig_D <- read_csv("gaedeetal_data/Fig3D_data.csv") %>%
  mutate(
    perc_firing = perc_firing * 100,
    perc_firing = as_factor(perc_firing)
  ) %>%
  ggplot(aes(x = perc_firing, y = num_bins, fill = species)) +
    geom_boxplot(alpha = 0.5, outlier.size = 0) +
    geom_point(
      aes(shape = species),
      position = position_jitterdodge(jitter.height = 0.3, jitter.width = 0.2)
    ) +
    scale_fill_manual(values = c(col_hb, col_zb)) +
    # Use shapes that make use of fill
    scale_shape_manual(values = c(24, 21)) +
    labs(
      x = "Percent of maximum firing rate (threshold)",
      y = "Number of speed bins above threshold"
    ) +
    theme_548 +
    # Draw x axis
    geom_rangeframe() +
    # Draw y axis
    annotate(geom = "segment", x = 0, xend = 0, y = 2.5, yend = 10)


#----------------------------#
#####    Fig 3 Panel E   #####
#----------------------------#

fig_E <- read_csv("./gaedeetal_data/Fig3E_data.csv") %>%
  # Add missing info
  mutate(species = c("hb", "zb", "pg")) %>%
  gather(key = speed, value = prop, -species) %>%
  # Reorder factors
  mutate(
    species = fct_relevel(species, c("hb","zb","pg")),
    speed = as_factor(as.numeric(speed))
  ) %>%
  ggplot(aes(x = speed, y = prop, fill = species)) +
    geom_col(
      position = position_dodge(0.75),
      width = 0.75,
      size = 0.2,
      colour = "black"
    ) +
    scale_fill_manual(values = c(col_hb, col_zb, col_pg)) +
    labs(
      x = "Speed bins (degrees/s)",
      y = "Proportion of LM\ncell population"
    )+
    theme_548 +
    # Bump axis text up (remove top margin)
    theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_text(margin = margin(t = 0))
    ) +
    # Draw y axis
    geom_rangeframe(sides = 'l')


#----------------------------#
#####    Fig 3 Panel F   #####
#----------------------------#

speeds_F <- c(0.24,0.5,1,2,4,8,16,24,32,48,64,80)
fig_F <- read_csv("./gaedeetal_data/Fig3F_data.csv") %>%
  # filter out rows without data
  filter(!is.na(dir1.area))  %>%
  # remove unnecessary columns
  select(starts_with("sp")) %>%
  # rename columns
  rename_all(~c("species",as.character(speeds_F))) %>%
  # use characters to indicate species
  mutate(
    species = case_when(
      species == 1 ~ "zb",
      species == 2 ~ "hb"
    )
  ) %>%
  gather(key = speed, value = prop, -species) %>%
  group_by(species, speed) %>%
  summarise(prop = mean(prop)) %>%
  ungroup %>%
  # Reorder factors
  mutate(
    species = fct_relevel(species, c('hb', 'zb')),
    speed = as_factor(as.numeric(speed))
  ) %>%
  ggplot(aes(x = speed, y = prop, fill = species)) +
    geom_col(
      position = position_dodge(0.75),
      width = 0.75,
      size = 0.2,
      colour = "black"
    ) +
    scale_fill_manual(values = c(col_hb, col_zb)) +
    labs(
      x = "Speed bins (degrees/s)",
      y = "Proportion of LM\ncell population"
    ) +
    theme_548 +
    # Axes
    theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_text(margin = margin(t = 0))
    ) +
    geom_rangeframe(sides = 'l')


#------------------------------------------------#
#####    Re-create Gaede et al. 2017 Fig 3   #####
#------------------------------------------------#

fig_A <- fig_A + theme(plot.margin = unit(c(5.5, 5.5, 0, 5.5), units = "pt"))
cow_A <- plot_grid(NULL, fig_A,
                   rel_widths = c(0.07, 0.93),
                   nrow = 1,
                   labels = c("A",""),
                   label_size = 18,
                   label_fontfamily = "sans")

cow_BC <- plot_grid(NULL, fig_B, NULL, fig_C,
                    rel_heights = c(0.1, 1, -0.15, 1),
                    ncol = 1,
                    label_y = 1.07,
                    labels = c("","B","","C"),
                    label_size = 18,
                    label_fontfamily = "sans")

fig_D <- fig_D + labs(y = "Number of speed bins above threshold    ")
cow_D <- plot_grid(NULL, fig_D,
                    rel_heights = c(0.1, 1.85),
                    ncol = 1,
                    label_y = 1 + 0.07 /1.85,
                    labels = c("","D"),
                    label_size = 18,
                    label_fontfamily = "sans")

cow_BCD <- plot_grid(cow_BC, cow_D,
                     rel_widths = c(2,3),
                      nrow = 1)

cow_EF <- plot_grid(fig_E, fig_F,
                    ncol = 1,
                    labels = c("E","F"),
                    label_size = 18,
                    label_fontfamily = "sans")

cow_A2F <- plot_grid(cow_A, NULL, cow_BCD, cow_EF,
          ncol = 1,
          # A negative rel_height shrinks space between elements
          rel_heights = c(1.2, -0.2, 2.5, 3),
          label_size = 18,
          label_fontfamily = "sans")


#------------------------------------------------#
#####    Adding icons to a multipanel plot   #####
#------------------------------------------------#

cow_final <- ggdraw() +
  draw_plot(cow_A2F) +
  # Hummingbird heads
  draw_image(image = icon_hb, x = -0.445, y =  0.445, scale = 0.060) +# Panel A
  draw_image(image = icon_hb, x = -0.350, y =  0.305, scale = 0.060) +# Panel B
  draw_image(image = icon_hb, x =  0.445, y =  0.280, scale = 0.060) +# Panel D
  draw_image(image = icon_hb, x = -0.280, y = -0.073, scale = 0.060) +# Panel E
  draw_image(image = icon_hb, x = -0.280, y = -0.313, scale = 0.060) +# Panel F
  # Zebra finch heads
  draw_image(image = icon_zb, x = -0.360, y =  0.135, scale = 0.052) +# Panel C
  draw_image(image = icon_zb, x =  0.435, y =  0.250, scale = 0.052) +# Panel D
  draw_image(image = icon_zb, x = -0.290, y = -0.100, scale = 0.052) +# Panel E
  draw_image(image = icon_zb, x = -0.290, y = -0.340, scale = 0.052) +# Panel F
  # Pigeon head
  draw_image(image = icon_pg, x = -0.290, y = -0.130, scale = 0.055) +# Panel E
  # Boxes
  draw_grob(grob = rect_hb_t, x =  0.390, y =  0.280, scale = 0.010) +
  draw_grob(grob = rect_zb_t, x =  0.390, y =  0.253, scale = 0.010) +
  draw_grob(grob = rect_hb,   x = -0.340, y = -0.073, scale = 0.010) +
  draw_grob(grob = rect_zb,   x = -0.340, y = -0.099, scale = 0.010) +
  draw_grob(grob = rect_pg,   x = -0.340, y = -0.125, scale = 0.010) +
  draw_grob(grob = rect_hb,   x = -0.340, y = -0.313, scale = 0.010) +
  draw_grob(grob = rect_zb,   x = -0.340, y = -0.337, scale = 0.010) +
  # Points
  draw_grob(grob = point_hb,  x =  0.390, y =  0.280, scale = 0.001) +
  draw_grob(grob = point_zb,  x =  0.390, y =  0.253, scale = 0.001)

cow_final
