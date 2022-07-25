#' Generate an octopus
#'
#' @param include_angry Should the angry expression be included as an option?
#' @param color_funs Optional, a list of `crayon::*` functions to use
#' for the octopus' coloring (see examples).
#'
#' @export
#'
#' @importFrom glue glue
#' @importFrom crayon white cyan blue magenta green
#'
#' @examples
#' # Disable the angry expression w/ `include_angry = FALSE`:
#' greeting_octopus(include_angry = FALSE)
#'
#' # Override the default color options w/ `color_funs`:
#' greeting_octopus(color_funs = list(crayon::yellow, crayon::magenta))
#' greeting_octopus(color_funs = list(crayon::white))
#'
greeting_octopus <- function(include_angry = TRUE, color_funs = NULL) {

  # Initialize art, split by newlines ---------------------------------------
  octopus_ascii <- "                        ___\n                     .-'   `'.\n                    /         \\\n                    |         ;\n                    |         |           ___.--,\n           _.._     |0) ~ (0) |    _.---'`__.-( (_.\n    __.--'`_.. '.__.\\    '--. \\_.-' ,.--'`     `\"\"`\n   ( ,.--'`   ',__ /./;   ;, '.__.'`    __\n   _`) )  .---.__.' / |   |\\   \\__..--\"\"  \"\"\"--.,_\n  `---' .'.''-._.-'`_./  /\\ '.  \\ _.-~~~````~~~-._`-.__.'\n        | |  .' _.-' |  |  \\  \\  '.               `~---`\n         \\ \\/ .'     \\  \\   '. '-._)\n          \\/ /        \\  \\    `=.__`~-.\n          / /\\         `) )    / / `\"\".`\\\n    , _.-'.'\\ \\        / /    ( (     / /\n     `--~`   ) )    .-'.'      '.'.  | (\n            (/`    ( (`          ) )  '-;\n             `      '-;         (-'"
  octopus_ascii <- strsplit(octopus_ascii, "\\n")[[1]]


  # Adjustments to ASCII art ------------------------------------------------

  # wink
  if (stats::runif(1) < 1/5) {
    octopus_ascii <- sub("(?<=\\()0", "-", octopus_ascii, perl = TRUE)
    octopus_ascii <- sub("~", " ", octopus_ascii)

    # blink
    if (stats::runif(1) < 1/3) {
      octopus_ascii <- sub("0", "-", octopus_ascii)

      # sleep
      if (stats::runif(1) < 1/2) {
        octopus_ascii[2] <- sub("^                  ", "{crayon::white('              Z  Z')}", octopus_ascii[2])
        octopus_ascii[3] <- sub("^                  ", "{crayon::white('             Z   Z')}", octopus_ascii[3])
        octopus_ascii[4] <- sub("^                  ", "{crayon::white('            Z Z   ')}", octopus_ascii[4])
        octopus_ascii[5] <- sub("^                  ", "{crayon::white('             Z  Z ')}", octopus_ascii[5])
      }
    }

  } else {

    # angry
    if (include_angry & stats::runif(1) < 1/5) {
      octopus_ascii <- gsub("0", '{crayon::bold(crayon::red("0"))}', octopus_ascii)
      octopus_ascii <- gsub("~", "v", octopus_ascii)

    }

  }

  # glue::glue() for various expressions
  octopus_ascii <- vapply(octopus_ascii, glue::glue, FUN.VALUE = character(1))


  # Assign colors -----------------------------------------------------------

  color_options <- c(
    "solid",
    "stripe",
    "rainbow"
  )

  if (is.null(color_funs)) {

    # default options for color_funs:
    color_funs <- list(
      crayon::cyan,
      crayon::blue,
      crayon::magenta,
      crayon::green
    )

  } else {

    # need to check user-supplied color_funs
    if (!is.list(color_funs) || any(!vapply(color_funs, is.function, logical(1)))) {
      stop("color_funs should be a list of functions from the crayon package \n  e.g. color_funs = list(crayon::blue, crayon::black, crayon::magenta)")
    }

  }


  # If there are more than 1 options of color_funs available,
  # choose pattern from color_options
  if (length(color_funs) == 1) {

    color_funs <- color_funs[[1]]

  } else {

    color_funs <-switch(
      sample(color_options, 1),
      "solid" = color_funs[[sample(1:length(color_funs), 1)]],
      "stripe" = color_funs[sample(1:length(color_funs), 2)],
      "rainbow" = color_funs
    )

  }


  # function to apply to each element ("row") of octopus_ascii
  color_ascii <- function(string) {

    if (length(color_funs) == 1) {
      color_fun <- color_funs
    } else {
      color_fun <- color_funs[[sample(1:length(color_funs), 1)]]
    }

    color_fun(string)
  }

  # Collapse back to vector of length 1, w/ newlines
  octopus_ascii <- lapply(octopus_ascii, color_ascii) |>
    paste(collapse = "\n")



  # cat, returning string invisibly -----------------------------------------
  cat(octopus_ascii, "\n", "\n")
  invisible(octopus_ascii)

}













