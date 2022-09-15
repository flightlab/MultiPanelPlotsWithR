# Group 1
library(gapminder)
library(tidyverse)
library(readxl)

# Group 2 and 3
library(ggthemes)
library(magick)
library(grid)
library(cowplot)

# Bonus
library(ggmap)
library(maps)


##############################   BEFORE BEGINNING  #############################
## Please click:
## Session --> Set Working Directory --> To Source File Location


#------------------------------------------------#
#####                GROUP 1                 #####
#------------------------------------------------#

## Import data using base R command, and give it the name `my.data`
my.data <- read.csv("gapminder.csv")
# In practise, read_csv() is often better

# Explore features of your data --- same as print(my_data)
my.data

# Inspect the structure of the data
str(my.data)

# Summarize column information
summary(my.data)

# Get column names (variables). This is handy for wide data sets i.e. many
# variables
names(my.data)

# Get first 6 lines/rows
head(my.data)
# Arguments can be added to a function using commas
# Note: arguments with the default setting are hidden, unless specified. Here
# `n` changes the default from 6 to 10 lines
head(my.data, n = 10)
# The helpfile lists what arguments are available for any given function
?head

# Get last 6 lines/rows
tail(my.data)

# Or simply explore the entire data frame
View(my.data)

# A better import option using Tidyverse
my_data <- read_csv("gapminder.csv")
# Cleaner import and print with read_csv, don't need head()
my_data
str(my_data)

# But underlying data is the same
summary(my.data)
summary(my_data)

# Other formats for import
my_data_c <- read_delim("gapminder.csv", ',')

my_data_x <- read_excel("gapminder.xlsx")
# Ignore the "New names:" note

# Inspect with head. Shows two junk rows
head(my_data_x)

# This can be solved by adding an argument
# `skip` is the number of rows to skip
my_data_x <- read_excel("gapminder.xlsx",
                        skip = 2)

my_data <- read_csv("gapminder.csv",
                      col_names = FALSE)
# Setting `col_names` to false made the column headers row one and added dummy
# column names
my_data

my_data <- read_csv("gapminder.csv",
                      col_names = TRUE)
# This looks correct. Note: true is the default argument so was not needed above
my_data

## See powerpoint slide for how to best structure data for tidyverse / ggplot

                          ######  Plotting #####
# This command makes a histogram of the `lifeExp` column of the `my_data`
# dataset
qplot(x = lifeExp, data = my_data)

# The same function here makes a scatter plot
qplot(x = gdpPercap, y = lifeExp, data = my_data)

# The same function here makes a dot plot because the x axis is categorical
qplot(x = continent, y = lifeExp, data = my_data)

# How can the same function make three different classes of plots?
# One of the hidden arguments is `geom` which specifies the type of plot.
# The default is `auto` which leads to a guess of the plot type based on the
# data type(s) in the column(s) you specify
?qplot

# Now let's specify the type of plot explicitly
qplot(x = lifeExp, data = my_data, geom = 'histogram')
qplot(x = gdpPercap, y = lifeExp, data = my_data, geom = 'point')

# Note that we are specifying boxplot instead of point plot
qplot(x = continent, y = lifeExp, data = my_data, geom = 'boxplot')

# Now let's change the number of bins in a histogram and make the plot prettier
# The hidden argument `bins` has a default valute of 30
qplot(x = lifeExp, data = my_data, geom = 'histogram')

# This changes the number of bins to 10
qplot(x = lifeExp, bins = 10, data = my_data, geom = 'histogram')

# Alternatively you can choose the width you want the bins to have
qplot(x = lifeExp, bins = 5, data = my_data, geom = 'histogram')

# Let's add a title
qplot(x = lifeExp, binwidth = 5, main = "Histogram of life expectancy", data = my_data, geom = 'histogram')

# Let's add x and y axes labels
qplot(x = lifeExp, binwidth = 5, main = "Histogram of life expectancy", xlab = "Life expectancy (years)", ylab = "Count", data = my_data, geom = 'histogram')

# This format is easier to read, but otherwise exactly the same
# The convention is to break lines after commas
qplot(x = lifeExp,
      binwidth = 5,
      main = "Histogram of life expectancy",
      xlab = "Life expectancy (years)",
      ylab = "Count",
      data = my_data,
      geom = 'histogram')

# Let's apply a log scale and add a trendline to a scatter plot
# Note that data points on the x axis are compressed with a linear scale
qplot(x = gdpPercap,
      y = lifeExp,
      data = my_data,
      geom = 'point')

# Here the x axis is log transformed
qplot(x = gdpPercap,
      y = lifeExp,
      log = 'x',
      data = my_data,
      geom = 'point')

# Let's add titles and a trendline to the data
# The linear regression model (`lm`) will be added as a layer on top of our
# previous plot
qplot(x = gdpPercap,
      y = lifeExp,
      log = 'x',
      main = "Scatter plot of life expectancy versus GDP per capita",
      xlab = "Log-transformed GDP per capita ($)",
      ylab = "Life expectancy (years)",
      data = my_data,
      # The following line adds a `smooth` trendline
      # We want our regression to be a linear model, or `lm`
      method = lm,
      # the `c()` function allows us to pass multiple variables
      # to the `geom` argument
      geom = c('point', 'smooth'))
## Ignore warning message


# Make of a plot of the relationship between life expectancy and continent
# - What plot type should you use?
# - Label all the axes
# - Should you transform any of the axes?

qplot(x = continent,
      y = lifeExp,
      main = "Boxplot of life expectancy by continent",
      xlab = "Continent",
      ylab = "Life expectancy (years)",
      data = my_data,
      geom = 'boxplot')

# These plots (or anything else really) can be assigned to an object using the
# "<-" symbol so that it is stored in your "global environment" and can be
# recalled, modified or worked with elsewhere in the script.
my_boxplot <-
  qplot(x = continent,
        y = lifeExp,
        main = "Boxplot of life expectancy by continent",
        xlab = "Continent",
        ylab = "Life expectancy (years)",
        data = my_data,
        geom = 'boxplot')

# Now displaying your plot is as simple as printing the original dataset
my_boxplot


#------------------------------------------------#
#####                GROUP 2                 #####
#------------------------------------------------#

## Before starting this section, please load all the packages from lines 1-14

## "To structure data to produce single plots that are ready for presentations
##  and publications"
# Objectives:
# - Articulate the advantages of literate programming
# - Employ piping to restructure data for tidyverse
# - Describe the grammar of graphics that underlies plotting in ggplot
# - Manipulate plots to improve clarity and maximize the data:ink ratio


#---------------------------------------------#
#####   _What is literate programming?    #####
#---------------------------------------------#

# "Literate programming" rethinks the "grammar" of traditional code to more
# closely resemble writing in a human language, like English.

# The primary goal of literate programming is to move away from coding "for
# computers" (ie, code that simplifies compilation) and instead to write in a
# way that more resembles how we think.

# In addition to making for much more readable code even with fewer comments, a
# good literate coding language should make it easier for you to translate ideas
# into code.

# In the tidyverse, we will largely use the analogy of variables as nouns and
# functions as verbs that operate on the nouns.
#
# The main way we will make our code literate however is with the pipe: `%>%`


#------------------------------#
#####   _What is a pipe?   #####
#------------------------------#

# A pipe, or %>% , is an operator that takes everything on the left and plugs
# it into the function on the right

# In short: x %>% f(y)  is equivalent to  f(x, y)

# So:
filter(gapminder, continent == 'Asia')

# Can be re-written as:
gapminder %>%
  filter(continent == 'Asia')

# In RStudio you can use the shortcut CTRL/CMD + SHIFT + M to insert a pipe


#-------------------------------------#
#####   _Why bother with pipes?   #####
#-------------------------------------#

# To see how pipes can make code more readable, let's translate this simple
# cake recipe into pseudo R code:

# 1. Cream together sugar and butter
# 2. Beat in eggs and vanilla
# 3. Mix in flour and baking powder
# 4. Stir in milk
# 5. Bake
# 6. Frost

## Saving Intermediate Steps

# One way you might approach coding this is by defining a lot of variables:

# batter_1   <- cream(sugar, butter)
# batter_2   <- beat_in(batter_1, eggs, vanilla)
# batter_3   <- mix_in(batter_2, flour, baking_powder)
# batter_4   <- stir_in(batter_3, milk)
# cake       <- bake(batter_3)
# cake_final <- frost(cake)

# The info is all there, but there's a lot of repetition and opportunity for
# typos. You also have to jump back and forth between lines to make sure you're
# calling the right variables

# A similar approach would be to keep overwriting a single variable

# cake <- cream(sugar, butter)
# cake <- beat_in(cake, eggs, vanilla)
# cake <- mix_in(cake, flour, baking_powder)
# cake <- stir_in(cake, milk)
# cake <- bake(cake)
# cake <- frost(cake)

# But it's still not as clear as the original recipe
# And if anything goes wrong you have to re-run the whole pipeline

## Function Composition

# If we don't want to save intermediates, we can just do all the steps in one
# line:

# frost(bake(stir_in(mix_in(beat_in(cream(sugar, butter), eggs, vanilla), flour, baking_powder), milk)))

# Or with better indentation:

# frost(
#   bake(
#     stir_in(
#       mix_in(
#         beat_in(
#           cream(sugar, butter),
#           eggs,
#           vanilla
#         ),
#         flour, baking_powder
#       ),
#     milk)
#   )
# )

# It's pretty clear why this is no good

## Piping

# Now for the piping approach:

# cake <-
#   cream(sugar, butter) %>%
#   beat_in(eggs, vanilla) %>%
#   mix_in(flour, baking_powder) %>%
#   stir_in(milk) %>%
#   bake() %>%
#   frost()

# When you are reading code, you can replace pipes with the phrase "and then"

# And remember, pipes just take everything on the left and plug it into the
# function on the right. If you step through this code, this chunk is exactly
# the same as the function composition example above, it's just written for
# people to read

# When you chain together multiple manipulations, piping makes it easy to
# focus on what's important at every step. One caveat is that you need the
# first argument of every function in the pipe to be the object you are
# manipulating. Tidyverse functions all follow this convention, as do many
# other functions

## Where do you find new verbs?

# The RStudio cheat sheets are a whole lot more useful once you start piping

# Data transformation:
# browseURL("https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf")

# Data import + restructuring
# browseURL("https://github.com/rstudio/cheatsheets/raw/master/data-import.pdf")

# More
# browseURL("https://www.rstudio.com/resources/cheatsheets/")


#-----------------------------#
#####   _Some prep work   #####
#-----------------------------#

# In this section our main goal will be to reproduce as closely as possible
# all the individual plots that make up Figure 3 in the Gaede et al. 2017 paper

# The one exception to that will be the legends and icons, which are easier
# to align and arrange when organizing the plots into a single multipanel
# figure, which is left for Group 3

# Let's start by opening up the paper and setting up some variables we will
# be using throughout the plotting

# Colours for the different birds
col_hb <- "#ED0080"
col_zb <- "#F48D00"
col_pg <- "#4AA4F2"


#----------------------------#
#####   _Fig 3 Panel D   #####
#----------------------------#
data_D <- read_csv("gaedeetal_data/Fig3D_data.csv")

# Visualize data
data_D


#----------------------------------#
#####   _Anatomy of a ggplot   #####
#----------------------------------#

# ggplot is built around the idea of a "Grammar of Graphics" -- a way of
# describing (almost) any graphic

# There are three key components to any graphic under the Grammar of Graphics:
# - data: the information to be conveyed
# - geometries: the things you actually draw on the plot. Lines, points,
#   polygons, etc.
# - aesthetic mapping: the connection between relevant parts of the data and
#   the aesthetics (size, colour, position, etc) of the geometries

# Any ggplot you make will at the very minimum require these three things and
# will usually look something like this:

# ggplot(data = my_data, mapping = aes(x = var1, y = var2)) +
#   geom_point()

# Or, equivalently:

# my_data %>%
#   ggplot(aes(x = var1, y = var2)) +
#   geom_point()

# But how do you know what geometries are available or what aesthetic
# mappings you can use for each?

# Use the plotting with ggplot2 cheat sheet
# browseURL("https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf")

# Other possibly relevant componenets include:
# - coordinate systems (eg cartesian vs polar plots)
# - scales (eg mapping specifc colours to groups)
# - facets (subpanels of similar plots)

# Let's make a ggplot!
data_D %>%
  ggplot(mapping = aes(x = perc_firing, y = num_bins, colour = species))

# Add points
data_D %>%
  ggplot(mapping = aes(x = perc_firing, y = num_bins, colour = species)) +
    geom_point(mapping = aes(shape = species))

# Separate points
data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, colour = species)) +
    geom_point(aes(shape = species), position = 'jitter')

# Add summary statistics
data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, colour = species)) +
    geom_point(aes(shape = species), position = 'jitter') +
    geom_boxplot()

# Fix x axis
data_D <- read_csv("gaedeetal_data/Fig3D_data.csv") %>%
  mutate(
    perc_firing = perc_firing * 100,
    perc_firing = as_factor(perc_firing)
  ) %>%
  tidyr::drop_na()

# Re-plot with new x
data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, colour = species)) +
    geom_point(aes(shape = species), position = 'jitter') +
    geom_boxplot()

# Swap colour to fill
data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, fill = species)) +
    geom_point(aes(shape = species), position = 'jitter') +
    geom_boxplot()

# Fix colours
# browseURL("http://www.sthda.com/english/wiki/ggplot2-point-shapes")
data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, fill = species)) +
    geom_point(aes(shape = species), position = 'jitter') +
    geom_boxplot() +
    scale_fill_manual(values = c(col_hb, col_zb)) +
    scale_shape_manual(values = c(24, 21))

# De-emphasize boxplots, remove outliers
data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, fill = species)) +
    geom_boxplot(alpha = 0.5, outlier.size = 0) +
    geom_point(aes(shape = species), position = 'jitter') +
    scale_fill_manual(values = c(col_hb, col_zb)) +
    scale_shape_manual(values = c(24, 21))

# Tune jitter
data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, fill = species)) +
    geom_boxplot(alpha = 0.5, outlier.size = 0) +
    geom_point(
      aes(shape = species),
      position = position_jitterdodge(jitter.height = 0.3, jitter.width = 0.2)
    ) +
    scale_fill_manual(values = c(col_hb, col_zb)) +
    scale_shape_manual(values = c(24, 21))

# Titles and theming and save
fig_D <- data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, fill = species)) +
    geom_boxplot(alpha = 0.5, outlier.size = 0) +
    geom_point(
      aes(shape = species),
      position = position_jitterdodge(jitter.height = 0.3, jitter.width = 0.2)
    ) +
    scale_fill_manual(values = c(col_hb, col_zb)) +
    scale_shape_manual(values = c(24, 21)) +
    labs(
      x = "Percent of maximum firing rate (threshold)",
      y = "Number of speed bins above threshold"
    ) +
    # theme_bw()
    # theme_light()
    # theme_dark()
    theme_classic()
fig_D

# Let's create a theme
theme_548 <- theme_classic() +
    theme(
      axis.title = element_text(size = 13),
      axis.text = element_text(size = 13, colour = "black"),
      axis.line = element_blank()
    )

# Let's see what it looks like
fig_D + theme_548


# Let's create a theme
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
        # Background of panel
      panel.background = element_rect(fill = "transparent"),
        # Background behind actual data points
      plot.background = element_rect(fill = "transparent", color = NA)
    )

fig_D + theme_548

# Draw in x and y axes
data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, fill = species)) +
    geom_boxplot(alpha = 0.5, outlier.size = 0) +
    geom_point(
      aes(shape = species),
      position = position_jitterdodge(jitter.height = 0.3, jitter.width = 0.2)
    ) +
    scale_fill_manual(values = c(col_hb, col_zb)) +
    scale_shape_manual(values = c(24, 21)) +
    labs(
      x = "Percent of maximum firing rate (threshold)",
      y = "Number of speed bins above threshold"
    ) +
    theme_548 +
    ggthemes::geom_rangeframe()

# Draw in x and y axes
fig_D <- data_D %>%
  ggplot(aes(x = perc_firing, y = num_bins, fill = species)) +
    geom_boxplot(alpha = 0.5, outlier.size = 0) +
    geom_point(
      aes(shape = species),
      position = position_jitterdodge(jitter.height = 0.3, jitter.width = 0.2)
    ) +
    scale_fill_manual(values = c(col_hb, col_zb)) +
    scale_shape_manual(values = c(24, 21)) +
    labs(
      x = "Percent of maximum firing rate (threshold)",
      y = "Number of speed bins above threshold"
    ) +
    theme_548 +
    geom_rangeframe() +
    annotate(geom = "segment", x = 0, xend = 0, y = 2.5, yend = 10)
fig_D


#----------------------------#
#####   _Fig 3 Panel E   #####
#----------------------------#

# Visualize the data
read_csv("./gaedeetal_data/Fig3E_data.csv")

# Restructure data for plotting

# Add the missing info
read_csv("./gaedeetal_data/Fig3E_data.csv") %>%
  mutate(species = c("hb", "zb", "pg"))

# Pull the y-values down from the header
data_E <- read_csv("./gaedeetal_data/Fig3E_data.csv") %>%
  mutate(species = c("hb", "zb", "pg")) %>%
  gather(key = speed, value = prop, -species)
data_E

# Plot data
data_E %>%
  ggplot(aes(x = speed, y = prop, fill = species)) +
    geom_col()

# But wait, the x-axis and species are out of order!
data_E

data_E <- data_E %>%
  mutate(
    species = fct_relevel(species, c("hb","zb","pg")),
    speed = as_factor(as.numeric(speed))
  )
data_E

# Plot data again
data_E %>%
  ggplot(aes(x = speed, y = prop, fill = species)) +
    geom_col()

# Unstack columns and add black outline
data_E %>%
  ggplot(aes(x = speed, y = prop, fill = species)) +
    geom_col(position = 'dodge', colour = "black")

# Space out column groups, thin out the columns, thin the outline
data_E %>%
  ggplot(aes(x = speed, y = prop, fill = species)) +
    geom_col(
      position = position_dodge(0.75),
      width = 0.75,
      size = 0.2,
      colour = "black"
    )

# Pick colours, add labels, add theme
data_E %>%
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
    theme_548

# Fix x axis, add y axis line
fig_E <- data_E %>%
  ggplot(aes(x = speed, y = prop, fill = species)) +
    # Plot data
    geom_col(
      position = position_dodge(0.75),
      width = 0.75,
      size = 0.2,
      colour = "black"
    ) +
    # Pick colours
    scale_fill_manual(values = c(col_hb, col_zb, col_pg)) +
    # Text
    labs(
      x = "Speed bins (degrees/s)",
      y = "Proportion of LM\ncell population"
    )+
    # Theme
    theme_548 +
    # Axes
    theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_text(margin = margin(t = 0))
    ) +
    geom_rangeframe(sides = 'l')
fig_E


#----------------------------#
#####   _Fig 3 Panel B   #####
#----------------------------#

# Visualize data
read_csv("gaedeetal_data/Fig3B_data.csv")

# Gather all the bin data into one column
read_csv("gaedeetal_data/Fig3B_data.csv") %>%
  gather(key = bin, value = count, starts_with("bin"))

# Group the data by trial, direction speed
read_csv("gaedeetal_data/Fig3B_data.csv") %>%
  gather(key = bin, value = count, starts_with("bin")) %>%
  group_by(trial, direction, speed)

# Calculate firing rate for each trial
read_csv("gaedeetal_data/Fig3B_data.csv") %>%
  gather(key = bin, value = count, starts_with("bin")) %>%
  group_by(trial, direction, speed) %>%
  summarize(
    raw_firing_rate = mean(count)
  )

# Finally let's ungroup and store this unnormalized data
data_B_raw <- read_csv("gaedeetal_data/Fig3B_data.csv") %>%
  gather(key = bin, value = count, starts_with("bin")) %>%
  group_by(trial, direction, speed) %>%
  summarize(
    raw_firing_rate = mean(count)
  ) %>%
  ungroup()
data_B_raw

# Now we need to normalize the data

# First calculate a baseline
tail(data_B_raw)

data_B_raw %>%
  filter(direction == 'NaN')

data_B_raw %>%
  filter(direction == 'NaN') %>%
  pull(raw_firing_rate)

baseline <- data_B_raw %>%
  filter(direction == 'NaN') %>%
  pull(raw_firing_rate) %>%
  mean
baseline

# Use the baseline to normalize the data
data_B_raw %>%
  filter(direction != 'NaN') %>%
  mutate(
    norm_firing_rate = raw_firing_rate - baseline,
    norm_firing_rate = norm_firing_rate / max(abs(norm_firing_rate))
  )

# Next let's find the mean and SE of firing rate across like trials
data_B_raw %>%
  filter(direction != 'NaN') %>%
  mutate(
    norm_firing_rate = raw_firing_rate - baseline,
    norm_firing_rate = norm_firing_rate / max(abs(norm_firing_rate))
  ) %>%
  group_by(direction, speed) %>%
  summarize(
    firing_rate = mean(norm_firing_rate),
    sem = sd(norm_firing_rate) / sqrt(n())
  )

# Finally ungroup the data and convert direction to a factor
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
data_B

# Plot the data
data_B %>%
  ggplot(aes(x = speed, y = firing_rate)) +
    geom_point(aes(colour = direction, shape = direction)) +
    geom_line(aes(colour = direction))

# Add error bars and threshold line
data_B %>%
  ggplot(aes(x = speed, y = firing_rate)) +
    geom_point(aes(colour = direction, shape = direction)) +
    geom_line(aes(colour = direction)) +
    geom_errorbar(
      aes(
        colour = direction,
        ymin = firing_rate - sem,
        ymax = firing_rate + sem
      ),
      width = 0.02
    ) +
    geom_hline(
      yintercept = 0.8 * max(data_B$firing_rate),
      colour = 'grey70',
      linetype = 'dashed'
    )

# Add a line segment indicating points over threshold
data_B %>%
  ggplot(aes(x = speed, y = firing_rate)) +
    geom_point(aes(colour = direction, shape = direction)) +
    geom_line(aes(colour = direction)) +
    geom_errorbar(
      aes(
        colour = direction,
        ymin = firing_rate - sem,
        ymax = firing_rate + sem
      ),
      width = 0.02
    ) +
    geom_hline(
      yintercept = 0.8 * max(data_B$firing_rate),
      colour = 'grey70',
      linetype = 'dashed'
    ) +
    annotate(
      geom = 'segment',
      x = 1.3,
      xend = 1.78,
      y = 1.2,
      yend = 1.2,
      size = 0.7,
      arrow = arrow(ends = 'both', length = unit(2, "pt"), angle = 90)
    )

# Set colours, shapes, labels, and themes
data_B %>%
  ggplot(aes(x = speed, y = firing_rate)) +
    geom_point(aes(colour = direction, shape = direction)) +
    geom_line(aes(colour = direction)) +
    geom_errorbar(
      aes(
        colour = direction,
        ymin = firing_rate - sem,
        ymax = firing_rate + sem
      ),
      width = 0.02
    ) +
    geom_hline(
      yintercept = 0.8 * max(data_B$firing_rate),
      colour = 'grey70',
      linetype = 'dashed'
    ) +
    annotate(
      geom = 'segment',
      x = 1.3, xend = 1.78,
      y = 1.2, yend = 1.2,
      size = 0.7,
      arrow = arrow(ends = 'both', length = unit(2, "pt"), angle = 90)
    ) +
    scale_colour_manual(values = c("black", "grey50")) +
    scale_shape_manual(values = c(15, 18)) +
    labs(y = "Normalized\nfiring rate", x = "") +
    theme_548

# Make the diamonds bigger, reorder layers to emphasize points, remove x axis
# title
data_B %>%
  ggplot(aes(x = speed, y = firing_rate)) +
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
    theme(axis.title.x = element_blank()) +
    theme_548

# Add axis lines
data_B %>%
  ggplot(aes(x = speed, y = firing_rate)) +
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
    theme(axis.title.x = element_blank()) +
    theme_548 +
    geom_rangeframe()

# Note the line lengths, y limits, and x breaks are all wrong
# To fudge the lines, let's make another dataset
fudge_axis_BC <- tibble(speed = c(-0.5,2), firing_rate = c(-1,2))
fudge_axis_BC

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
    # Select colours and shapes
    scale_colour_manual(values = c("black", "grey50")) +
    scale_shape_manual(values = c(15, 18)) +
    scale_size_manual(values = c(2, 3)) +
    # Text
    labs(y = "Normalized\nfiring rate", x = "") +
    # Theme
    theme_548 +
    # Axes
    geom_rangeframe(data = fudge_axis_BC) +
    lims(y = c(-1,2)) +
    scale_x_continuous(breaks = -1:4 / 2)
fig_B


#----------------------------#
#####   _Fig 3 Panel F   #####
#----------------------------#

# Visualize data
read_csv("./gaedeetal_data/Fig3F_data.csv")
speeds_F <- c(0.24,0.5,1,2,4,8,16,24,32,48,64,80)

# Remove any rows without data (dir1.area is NA)
read_csv("./gaedeetal_data/Fig3F_data.csv") %>%
  filter(!is.na(dir1.area))

# Remove unnecessary columns
read_csv("./gaedeetal_data/Fig3F_data.csv") %>%
  filter(!is.na(dir1.area))  %>%
  select(starts_with("sp"))

# Rename columns using speeds_F, change species to words
read_csv("./gaedeetal_data/Fig3F_data.csv") %>%
  filter(!is.na(dir1.area))  %>%
  select(starts_with("sp")) %>%
  rename_all(~c("species",as.character(speeds_F))) %>%
  mutate(
    species = case_when(
      species == 1 ~ "zb",
      species == 2 ~ "hb"
    )
  )

# Reshape data for plotting
read_csv("./gaedeetal_data/Fig3F_data.csv") %>%
  filter(!is.na(dir1.area))  %>%
  select(starts_with("sp")) %>%
  rename_all(~c("species",as.character(speeds_F))) %>%
  mutate(
    species = case_when(
      species == 1 ~ "zb",
      species == 2 ~ "hb"
    )
  ) %>%
  gather(key = speed, value = prop, -species)

# Summarize proporions by species and speed
read_csv("./gaedeetal_data/Fig3F_data.csv") %>%
  filter(!is.na(dir1.area))  %>%
  select(starts_with("sp")) %>%
  rename_all(~c("species",as.character(speeds_F))) %>%
  mutate(
    species = case_when(
      species == 1 ~ "zb",
      species == 2 ~ "hb"
    )
  ) %>%
  gather(key = speed, value = prop, -species) %>%
  group_by(species, speed) %>%
  summarise(prop = mean(prop)) %>%
  ungroup

# Finally fix the factor levels as before
data_F <- read_csv("./gaedeetal_data/Fig3F_data.csv") %>%
  filter(!is.na(dir1.area))  %>%
  select(starts_with("sp")) %>%
  rename_all(~c("species",as.character(speeds_F))) %>%
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
  mutate(
    species = fct_relevel(species, c('hb', 'zb')),
    speed = as_factor(as.numeric(speed))
  )
data_F

# Plot data as before
fig_F <- data_F %>%
  ggplot(aes(x = speed, y = prop, fill = species)) +
    # Plot data
    geom_col(
      position = position_dodge(0.75),
      width = 0.75,
      size = 0.2,
      colour = "black"
    ) +
    # Pick colours
    scale_fill_manual(values = c(col_hb, col_zb)) +
    # Text
    labs(
      x = "Speed bins (degrees/s)",
      y = "Proportion of LM\ncell population"
    ) +
    # Theme
    theme_548 +
    # Axes
    theme(
      axis.ticks.x = element_blank(),
      axis.text.x = element_text(margin = margin(t = 0))
    ) +
    geom_rangeframe(sides = 'l')
fig_F


#----------------------------#
#####   _Fig 3 Panel C   #####
#----------------------------#

# Reorganize raw data
data_C_raw <- read_csv("gaedeetal_data/Fig3C_data.csv") %>%
  gather(key = bin, value = count, starts_with("bin")) %>%
  group_by(trial, direction, speed) %>%
  summarize(
    raw_firing_rate = mean(count)
  ) %>%
  ungroup()
data_C_raw

# Calculate baseline
baseline <- data_C_raw %>%
  filter(direction == 'NaN') %>%
  pull(raw_firing_rate) %>%
  mean
baseline

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
data_C

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
    #theme(axis.title.x = element_blank()) +
    # Theme
    theme_548 +
    # Axes
    geom_rangeframe(data = fudge_axis_BC) +
    lims(y = c(-1,2)) +
    scale_x_continuous(breaks = -1:4 / 2)
fig_C

#------------------------------------#
#####   _Prep work for legends   #####
#------------------------------------#

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


#------------------------------------------------#
#####                GROUP 3                 #####
#------------------------------------------------#

## Before starting this section, please load all the packages from lines 1-13
## and also run all the code from Group 1's and 2's sections.
##
## Plots made from code before this section will be used here too!

## "To make a multi-panel figure with a clear narrative arc”
# Objectives:
# - Plan a sequence of plots that support a declarative statement of a result
# - Construct a multi-panel figure using cowplot
# - Evaluate which among a diversity of plotting options most effectively
#   communicates a logical argument


## Multi-panel figures can be driven by narrative.
# one example: raw data -> processing -> analyses -> punchline

# We will used Figure 3 from Gaede et al. 2017 (Current Biology) as an example.

# This study examined how neurons in the lentiformis mesencephali (LM) brain
# region of three species of birds respond to visual motion across the retina.

# This figure shows that in hummingbirds, these neurons respond to faster visual
# motion speeds than those in zebra finches or pigeons.


#----------------------------#
#####   _Fig 3 Panel A   #####
#----------------------------#
# Re-create panel A from Gaede et al. 2017
# First, import data
fig_A <-
  read_csv("./gaedeetal_data/Fig3A_data.csv") %>%
  # Now take every nth data point (produces plot faster)
  filter(row_number() %% 5 == 0) %>%
  # Clean outliers
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
fig_A


#-------------------------------#
#####   _Intro to cowplot   #####
#-------------------------------#
# We'll go over plot_grid() basics.
# draw_image() & draw_grob() can also be used with ggplot() & plot_grid().
library(cowplot)

## Basics
# Multiple panels can be combined via cowplot::plot_grid().
# Each panel should be saved as a separate ggplot object beforehand and then
# each will be fed in as an argument to plot_grid().

# Plot objects can be added sequentially
plot_grid(fig_B, fig_C)

# By default, additional panels are initially added within the same row.
# plot_grid() then tends to prefer to have ncol = nrow as best as possible:
plot_grid(fig_B, fig_C, fig_E,
          labels=c("1","2","3"))
plot_grid(fig_B, fig_C, fig_E, fig_F,
          labels=c("1","2","3","4"))
plot_grid(fig_B, fig_C, fig_E, fig_F, fig_B,
          labels=c("1","2","3","4","5"))
plot_grid(fig_B, fig_C, fig_E, fig_F, fig_B, fig_C,
          labels=c("1","2","3","4","5","6"))
plot_grid(fig_B, fig_C, fig_E, fig_F, fig_B, fig_C, fig_E,
          labels=c("1","2","3","4","5","6","7"))

# This looks okay, but we may prefer to have the plots arranged in one column.
# Let's first just focus on panels E and F.
plot_grid(fig_E, fig_F,
          ncol = 1)

# cowplot also allows you to add labels to panels as you'd see in a journal
# article.
plot_grid(fig_E, fig_F,
          ncol = 1,
          labels = c("E","F"))

# See the arguments of cowplot::plot_grid() to see how labels can be adjusted.
# We'll adjust the size and (temporarily) change to a serif font.
plot_grid(fig_E, fig_F,
          ncol = 1,
          labels = c("E","F"),
          label_size = 40,
          label_fontfamily = "serif")


#------------------------------------------------#
#####   _Re-create Gaede et al. 2017 Fig 3   #####
#------------------------------------------------#
# Let's try to re-create Fig 3 from Gaede et al. 2017.
# Lhe layout of the figure is complex; nrows and ncols can't be set easily.
# Luckily we can build sets of panels together, save each one, then stitch it
# all together at the end.

# Let's start with E and F.
cow_EF <- plot_grid(fig_E, fig_F,
                    ncol = 1,
                    labels = c("E","F"),
                    label_size = 18,
                    label_fontfamily = "sans")
cow_EF

# For fig A, we'll adjust the padding around the margin.
# Within the argument plot.margin, the order is top, right, bottom, left;
# think TRouBLe (T,R,B,L)
fig_A <- fig_A + theme(plot.margin = unit(c(5.5, 5.5, 0, 5.5), units = "pt"))
cow_A <- plot_grid(NULL, fig_A,
                   rel_widths = c(0.07, 0.93),
                   nrow = 1,
                   labels = c("A",""),
                   label_size = 18,
                   label_fontfamily = "sans")
cow_A

# When combining B and C, we should note that C has an x-axis label but B does
# not.
# Therefore, we will add blank plots (NULL) as padding and then adjust the
# relative heights to fit things comfortably.
# We still need to supply 4 labels, so "" will be used for blank plots.
cow_BC <- plot_grid(NULL, fig_B, NULL, fig_C,
                    rel_heights = c(0.1, 1, -0.15, 1),
                    ncol = 1,
                    label_y = 1.07,
                    labels = c("","B","","C"),
                    label_size = 18,
                    label_fontfamily = "sans")
cow_BC

# Similarly, with panel D, we'll add a NULL object to the cowplot and adjust
# the relative heights to the proportions we'd like.
fig_D <- fig_D + labs(y = "Number of speed bins above threshold    ")
cow_D <- plot_grid(NULL, fig_D,
                    rel_heights = c(0.1, 1.85),
                    ncol = 1,
                    label_y = 1 + 0.07 /1.85,
                    labels = c("","D"),
                    label_size = 18,
                    label_fontfamily = "sans")
cow_D

# You can cowplot multiple cowplots
cow_BCD <- plot_grid(cow_BC, cow_D,
                     rel_widths = c(2,3),
                      nrow = 1)
cow_BCD



# Now combine all the panels together.

# It may help to specify the dimensions of the plot window to ensure
# that the plot is made with correct overall proportions.
# try(dev.off(), silent = T)
# dev.new(width = 8, height = 11, units = "in")

# Now for the plot itself:
cow_A2F <- plot_grid(cow_A, NULL, cow_BCD, cow_EF,
          ncol = 1,
          # A negative rel_height shrinks space between elements
          rel_heights = c(1.2, -0.2, 2.5, 3),
          label_size = 18,
          label_fontfamily = "sans")
cow_A2F


#------------------------------------------------#
#####   _Adding icons to a multipanel plot   #####
#------------------------------------------------#

# The bird heads and other legend elements are conspicuously absent.

# The cowplot::draw_image() function allows for an image to be placed on the
# canvas, which we'll use for the bird heads.

# Similarly, cowplot::draw_grob() places grobs (GRaphical OBjects).
# We'll use this to add in colored rectangles for the legends.

# Each image's (or grob's) location is specified with x- and y- coordinates.
# Each runs from 0 to 1, with (0,0) being the lower left corner of the canvas.

# At the moment, vectorization of the code you see below doesn't seem possible.
# It's a bit tedious (and un-tidy!) but it works!

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

#---------------------------------------#
#####   _Saving multi-panel plots   #####
#---------------------------------------#

# cowplot::save_plot() tends to work better with multi-panel figures than
# ggsave() does.
# You can specify size via base_height and base_width

# For example:
#save_plot("Gaedeetal_Fig3.svg", cow_final, base_height = 11, base_width = 8.5)


#----------------------------------------------------#
#####   _Using photographs with ggplot/cowplot   #####
#----------------------------------------------------#

# Often, you may opt to add a photograph as its own panel.

# Here's a quick example:
photo <- "./graphics/photo.jpg"

# Now create a ggplot object that features only the image.
photo_panel <- ggdraw() + draw_image(photo, scale = 0.8)
photo_panel

# Now cowplot it!
plot_grid(fig_F, photo_panel, ncol = 1)


#---------------------------------------------#
#####   _Using maps with ggplot/cowplot   #####
#---------------------------------------------#

# Adding in maps can be useful to showing geographic trends.
# The 'maps' package allows for convenient plotting of (annotated) maps
# with ggplot.

# Quick example. Load the 'world' map:
w <- map_data("world")

# If you'd, for whatever reason, like to highlight certain countries:
fig_map <- ggplot(w) +
  # This outlines all countries in grey70
  geom_polygon(aes(x = long, y = lat, group = group),
               fill = "white", colour = "grey70") +
  # Let's highlight some countries in dogdgerblue fill
  geom_polygon(aes(x = long, y = lat, group = group),
               fill = "dodgerblue", colour = "black",
               data = filter(w, region %in% c("Chad", "China", "New Zealand",
                                              "Portugal", "Switzerland"))) +
  coord_fixed(1.3) +
  # Nuke the theme for simplicity.
  theme_nothing()
fig_map

# This can be added to a cowplot rather easily.
plot_grid(fig_map, photo_panel, fig_F, ncol = 1)


#------------------------------------#
#####   _Craft your own figure   #####
#------------------------------------#

# You now should have the tools to craft your own figure that delivers a clear
# point. We'd like to challenge you to ask your own question and then provide a
# figure that shows a clear answer to that question.

# Then:
# 1) Explain to me how you arrived at the answer.
# 2) Justify why you used the types of plots you did. Among the diversity of
#    plot types, could there have been other plots that communicate your
#    point more effectively?
# 3) Justify the order and arrangement of the plots within the figure. Why
#    did you lay the figure out the way you did?

# You are welcome to use your own data, the Gaede et al. data, or data from
# gapminder to ask & answer a question of your choosing.

# Or you can simply answer this question:

# Using gapminder, how has the relationship between gdp per capita and life
# expectancy changed between 1952, 1980, and 2007?
library(gapminder)
gapminder
