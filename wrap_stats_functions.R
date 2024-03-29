library(NCmisc)
library(janitor)
library(tidyverse)
library(patchwork)
library(showtext)
library(ggtextures) # devtools::install_github("clauswilke/ggtextures")

fpath <- glue::glue(here::here("~"))
all_files <- list.files(path = fpath, recursive = TRUE, full.names = T, all.files = F)

to_search <- all_files %>%
  as_tibble() %>%
  mutate(filetype = str_extract(value, pattern = "\\..*")) %>%
  filter(filetype == ".R" | filetype == ".r") %>%
  filter(!grepl("forec_generic", value)) %>%
  filter(!grepl("projekt_Prognolite", value)) %>%
  filter(!grepl("fwg/plots-193", value)) %>%
  filter(!grepl("ex8", value)) %>%
  pull(value)

all_functions <- map(.x = to_search, .f = ~ list.functions.in.file(.x))

func_data <- unlist(all_functions) %>%
  unname() %>%
  tabyl() %>%
  as_tibble() %>%
  rename(func = ".") %>%
  slice_max(n, n = 5, with_ties = FALSE)

imgs <- tibble(img = c("https://www.r-project.org/logo/Rlogo.png",
                       "https://www.r-project.org/logo/Rlogo.png",
                       "https://www.r-project.org/logo/Rlogo.png",
                       "https://www.r-project.org/logo/Rlogo.png",
                       "https://www.r-project.org/logo/Rlogo.png"))
                       # "https://dplyr.tidyverse.org/logo.png"))

font_add_google("Raleway", "raleway")
showtext_auto()

ggplot() +
  # add text with the numbers 1 to 5
  geom_text(data = data.frame(),
            mapping = aes(x = rep(1, 5),
                          y = 1:5,
                          label = paste0("#", 1:5)),
            colour = "#1a2e72",
            size = 20,
            fontface = "bold",
            family = "raleway") +
  # add text with the names of the functions, and the number of times its used
  geom_text(data = func_data,
            mapping = aes(x = rep(2.25, 5),
                          y = 1:5,
                          label = paste0(func, "(), ", n, " times")),
            colour = "#143b1c",
            hjust = 0,
            size = 11,
            fontface = "bold",
            family = "raleway") +
  # add images for each package
  geom_textured_rect(data = imgs,
                     aes(xmin = rep(1.5, 5), xmax = rep(2.1, 5),
                         ymax = 1:5-0.3, ymin = 1:5+0.3, image = img),
                     lty = "blank",
                     fill="transparent",
                     nrow = 1,
                     ncol = 1,
                     img_width = unit(1, "null"),
                     img_height = unit(1, "null"),
                     position = "identity")  +
  # add title using geom_text() instead of labs()
  geom_text(data = data.frame(),
            aes(x = 2.45, y = 0, label = "My Top Functions"),
            colour = "#1a2e72",
            fontface = "bold",
            hjust = 0.5,
            size = 14,
            family = "raleway") +
  # set axis limits and reverse y axis
  scale_x_continuous(limits = c(0.9, 4)) +
  scale_y_reverse(limits = c(5.5, -0.2)) +
  # add a caption
  labs(caption = "#RStats")+
  # set the theme
  theme_void() +
  theme(plot.background = element_rect(fill = "#96efb7", colour = "#96efb7"),
        panel.background = element_rect(fill = "#96efb7", colour = "#96efb7"),
        plot.margin = margin(40, 15, 10, 15),
        plot.caption = element_text(colour = "#1a2e72",
                                    margin = margin(t = 15),
                                    face = "bold",
                                    hjust = 1,
                                    size = 30,
                                    family = "raleway"))





