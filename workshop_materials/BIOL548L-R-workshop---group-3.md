BIOL548L R workshop - group 3
================

## Introduction

This is an R workshop created for a graduate data visualization course
at the University of British Columbia by Vikram Baliga, Andrea Gaede and
Shreeram Senthivasan.

There are three groups with increasing levels of difficulty. Each group
has a set of learning opjectives.

## Group 3: Make a multi-panel figure with a clear narrative arc

### Learning Objectives:

1.  Plan a sequence of plots that support a declarative statement of a
    result
2.  Construct a multi-panel figure using cowplot
3.  Evaluate which among a diversity of plotting options most
    effectively communicates a logical argument

### Lesson:

#### Prep work for figure legends:

**Bird head icons**

``` r
icon_hb <- "graphics/hummingbird.png"
icon_zb <- "graphics/zeebie.png"
icon_pg <- "graphics/pigeon.png"

# Colours for the different birds
col_hb <- "#ED0080"
col_zb <- "#F48D00"
col_pg <- "#4AA4F2"

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
```

#### Multi-panel figures can be driven by narrative

one example: raw data -\> processing -\> analyses -\> punchline

We will used Figure 3 from [Gaede et al. 2017
paper](https://www.cell.com/current-biology/fulltext/S0960-9822\(16\)31394-X)
(Current Biology) as an example.

This study examined how neurons in the lentiformis mesencephali (LM)
brain region of three species of birds respond to visual motion across
the retina.

This figure shows that in hummingbirds, these neurons respond to faster
visual motion speeds than those in zebra finches or pigeons.

#### Figure 3 Panel A:

**Re-create panel A from Gaede et al. 2017**

``` r
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
```

    ## Parsed with column specification:
    ## cols(
    ##   time = col_double(),
    ##   stim = col_double(),
    ##   spike = col_double()
    ## )

``` r
fig_A
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

### Create and save panels as separate `ggplot` objects

#### Figure 3 Panel B:

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

#### Figure 3 Panel C:

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

#### Figure 3 Panel D:

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

#### Figure 3 Panel E:

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

#### Figure 3 Panel F:

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

#### Intro to cowplot

We’ll go over `plot_grid()` basics.  
`draw_image()` & `draw_grob()` can also be used with `ggplot()` &
`plot_grid()`

**Basics**

  - Multiple panels can be combined via `cowplot::plot_grid()`
  - Each panel should be saved as a separate ggplot object beforehand
    and then each will be fed in as an argument to `plot_grid()`

**Plot objects can be added
sequentially**

``` r
plot_grid(fig_B, fig_C)
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

**By default, additional panels are initially added within the same
row.**  
`plot_grid()` then tends to prefer to have ncol = nrow as best as
possible:

``` r
plot_grid(fig_B, fig_C, fig_E,
          labels=c("1","2","3"))
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

``` r
plot_grid(fig_B, fig_C, fig_E, fig_F,
          labels=c("1","2","3","4"))
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-9-2.png)<!-- -->

``` r
plot_grid(fig_B, fig_C, fig_E, fig_F, fig_B,
          labels=c("1","2","3","4","5"))
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-9-3.png)<!-- -->

``` r
plot_grid(fig_B, fig_C, fig_E, fig_F, fig_B, fig_C,
          labels=c("1","2","3","4","5","6"))
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-9-4.png)<!-- -->

``` r
plot_grid(fig_B, fig_C, fig_E, fig_F, fig_B, fig_C, fig_E,
          labels=c("1","2","3","4","5","6","7"))
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-9-5.png)<!-- -->

**This looks okay, but we may prefer to have the plots arranged in one
column.**  
Let’s first just focus on panels E and F.

``` r
plot_grid(fig_E, fig_F,
          ncol = 1)
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

**Cowplot also allows you to add labels to panels as you’d see in a
journal article.**

``` r
plot_grid(fig_E, fig_F,
          ncol = 1,
          labels = c("E","F"))
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

**See the arguments of `cowplot::plot_grid()` to see how labels can be
adjusted.**  
We’ll adjust the size and (temporarily) change to a serif font.

``` r
plot_grid(fig_E, fig_F,
          ncol = 1,
          labels = c("E","F"),
          label_size = 40,
          label_fontfamily = "serif")
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

#### Re-create Gaede et al. 2017 Fig 3

##### Let’s try to build Fig 3 from [Gaede et al. 2017](https://www.cell.com/current-biology/fulltext/S0960-9822\(16\)31394-X)

The layout of the figure is complex; nrows and ncols can’t be set
easily. Luckily we can build sets of panels together, save each one,
then stitch it all together at the end.

**Let’s start with panels E and F.**

``` r
cow_EF <- plot_grid(fig_E, fig_F,
                    ncol = 1,
                    labels = c("E","F"),
                    label_size = 18,
                    label_fontfamily = "sans")
cow_EF
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**For panel A, we’ll adjust the padding around the margin.**  
Within the argument `plot.margin`, the order is top, right, bottom,
left; think TRouBLe
(T,R,B,L)

``` r
fig_A <- fig_A + theme(plot.margin = unit(c(5.5, 5.5, 0, 5.5), units = "pt"))
cow_A <- plot_grid(NULL, fig_A,
                   rel_widths = c(0.07, 0.93),
                   nrow = 1,
                   labels = c("A",""),
                   label_size = 18,
                   label_fontfamily = "sans")
cow_A
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

**Panels B and C**  
When combining B and C, we should note that C has an x-axis label but B
does not. Therefore, we will add blank plots (NULL) as padding and then
adjust the relative heights to fit things comfortably. We still need to
supply 4 labels, so "" will be used for blank plots.

``` r
cow_BC <- plot_grid(NULL, fig_B, NULL, fig_C,
                    rel_heights = c(0.1, 1, -0.15, 1),
                    ncol = 1,
                    label_y = 1.07,
                    labels = c("","B","","C"),
                    label_size = 18,
                    label_fontfamily = "sans")
cow_BC
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

**Panel D**  
Similarly, with panel D, we’ll add a NULL object to the cowplot and
adjust the relative heights to the proportions we’d like.

``` r
fig_D <- fig_D + labs(y = "Number of speed bins above threshold    ")
cow_D <- plot_grid(NULL, fig_D,
                    rel_heights = c(0.1, 1.85),
                    ncol = 1,
                    label_y = 1 + 0.07 /1.85,
                    labels = c("","D"),
                    label_size = 18,
                    label_fontfamily = "sans")
```

    ## Warning: Removed 770 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 770 rows containing missing values (geom_point).

``` r
cow_D
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

**You can cowplot multiple cowplots**

``` r
cow_BCD <- plot_grid(cow_BC, cow_D,
                     rel_widths = c(2,3),
                      nrow = 1)
cow_BCD
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

##### Now combine all the panels together:

It may help to specify the dimensions of the plot window to ensure that
the plot is made with correct overall proportions.  
try(`dev.off(), silent = T`)  
`dev.new(width = 8, height = 11, units = "in")`

**Now for the plot itself:**

``` r
cow_A2F <- plot_grid(cow_A, NULL, cow_BCD, cow_EF,
          ncol = 1,
          # A negative rel_height shrinks space between elements
          rel_heights = c(1.2, -0.2, 2.5, 3),
          label_size = 18,
          label_fontfamily = "sans")
cow_A2F
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

##### Adding icons to a multipanel plot:

The bird heads and other legend elements are conspicuously absent. The
`cowplot::draw_image()` function allows for an image to be placed on the
canvas, which we’ll use for the bird heads.

Similarly, `cowplot::draw_grob()` places grobs (GRaphical OBjects).
We’ll use this to add in colored rectangles for the legends.

Each image’s (or grob’s) location is specified with x- and y-
coordinates. Each runs from 0 to 1, with (0,0) being the lower left
corner of the canvas.

At the moment, vectorization of the code you see below doesn’t seem
possible. It’s a bit tedious (and un-tidy\!) but it works\!

``` r
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
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

##### Saving multi-panel plots

`cowplot::save_plot()` tends to work better with multi-panel figures
than `ggsave()` does. You can specify size via base\_height and
base\_width

**For example:** `save_plot("Gaedeetal_Fig3.svg", cow_final, base_height
= 11, base_width = 8.5)`

##### Using photographs with ggplot/cowplot

Often, you may opt to add a photograph as its own panel.

**Here’s a quick example:**

``` r
photo <- "./graphics/photo.jpg"
```

**Now create a ggplot object that features only the image.**

``` r
photo_panel <- ggdraw() + draw_image(photo, scale = 0.8)
photo_panel
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Now cowplot
it\!**

``` r
plot_grid(fig_F, photo_panel, ncol = 1)
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

##### Using maps with ggplot/cowplot

Adding in maps can be useful to showing geographic trends. The `maps`
package allows for convenient plotting of (annotated) maps with
`ggplot`.

**Quick example. Load the ‘world’ map:**

``` r
w <- map_data("world")
```

**If you’d, for whatever reason, like to highlight certain countries:**

``` r
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
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

**This can be added to a cowplot rather
easily:**

``` r
plot_grid(fig_map, photo_panel, fig_F, ncol = 1)
```

![](BIOL548L-R-workshop---group-3_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->
