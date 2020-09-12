write_example_data <- function(){
  file.copy(system.file("extdata", "gapminder.csv",
              package = "MultiPanelPlotsWithR"),
            "./gapminder.csv")
  file.copy(system.file("extdata", "gapminder.xlsx",
                        package = "MultiPanelPlotsWithR"),
            "./gapminder.xlsx")
}
