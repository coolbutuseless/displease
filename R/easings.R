

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a sequence interpolating between two values with the specified 
#' non-linear easing.
#'
#' @param x1,x2 The start and end values of the sequence. Default: 0, 1
#' @param n Number of steps for the transition (including the endpoints)
#' @param type Type of motion easing. Default: 'cubic'.  Valid values are
#'        are 'sine', 'quad', 'cubic', 'quart', 'quint', 'exp', 'circle', 'back',
#'        'elastic', 'linear'.
#' @param direction When should the easing apply? Default: "in-out". 
#'        Valid values are 'in', 'out', in-out'. Default: 'in-out'
#'
#' @return Numeric vector of length \code{n}
#' @examples
#' x <- seq_ease(x1 = 0, x2 = 1, n = 20, type = 'cubic', direction = 'in-out')
#' x
#' plot(x)
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
seq_ease <- function(x1 = 0, x2 = 1, n = 100, type = 'cubic', direction = 'in-out') {
  loc <- seq(0, 1, length.out = n)
  
  if (type == 'linear') {
    return(loc)
  }

  stopifnot(direction %in% c('in', 'out', 'in-out'))
  type <- paste0(type, '-', direction)

  fac <- switch(
    type,

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Sine
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `sine-in`     = 1 - cos((loc * pi) / 2),
    `sine-out`    = sin((loc * pi) / 2),
    `sine-in-out` = -(cos(loc * pi) - 1) / 2,

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Quad
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `quad-in`     = loc^2,
    `quad-out`    = 1 - (1 - loc)^2,
    `quad-in-out` = ifelse(loc < 0.5,
                         2 * loc^2,
                         1 - 0.5 * (-2 * loc + 2)^2),

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Cubic
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `cubic-in`  = loc^3,
    `cubic-out` = 1 - (1 - loc)^3,
    `cubic-in-out` = ifelse(loc < 0.5,
                          4 * loc^3,
                          1 - 0.5 * (-2 * loc + 2)^3),

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Quart
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `quart-in`     = loc^4,
    `quart-out`    = 1 - (1 - loc)^4,
    `quart-in-out` = ifelse(loc < 0.5,
                          8 * loc^4,
                          1 - 0.5 * (-2 * loc + 2)^4),

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Quint
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `quint-in`     = loc^5,
    `quint-out`    = 1 - (1 - loc)^5,
    `quint-in-out` = ifelse(loc < 0.5,
                          16 * loc^5,
                          1 - 0.5 * (-2 * loc + 2)^5),

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Exp
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `exp-in`     = 2^(10 * loc - 10),
    `exp-out`    = 1 - 2^(-10 * loc),
    `exp-in-out` = ifelse(loc == 0, 0,
                        ifelse(loc == 1, 1,
                               ifelse(loc < 0.5,
                                      2 ^ (20 * loc - 10)/2,
                                      (2 - 2^(-20 * loc + 10)) / 2
                               )
                        )
    ),

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Circle
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `circle-in`     = 1 - sqrt(1 - loc^2),
    `circle-out`    = sqrt(1 - (loc - 1)^2),
    `circle-in-out` = suppressWarnings({
      ifelse(loc < 0.5,
             (1 - sqrt(1 - (2 * loc)^2)) / 2,
             0.5 * (sqrt(1 - (-2 * loc + 2)^2) + 1))
    }),

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Back
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `back-in`     = 2.70158 * loc^3 - 1.70158 * loc^2,
    `back-out`    = 1 + 2.70158 * (loc - 1)^3 + 1.70158 * (loc - 1)^2,
    `back-in-out` = {
      c1 <- 1.70158
      c2 <- c1 * 1.525
      ifelse(loc < 0.5,
             (2*loc)^2 * ((c2 + 1) * 2 * loc - c2) / 2,
             ((2*loc-2)^2 * ((c2 + 1) * (loc * 2 - 2) + c2) + 2) / 2
             )
    },

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Elastic
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    `elastic-in`     = ifelse(
      loc == 0, 0,
      ifelse(loc == 1,
             1,
             -(2 ^ (10*loc-10)) * sin((loc * 10 - 10.75) * 2 * pi / 3)
             )
    ),
    `elastic-out`    = ifelse(
      loc == 0, 0,
      ifelse(loc == 1,
             1,
             2^(-10*loc) * sin((loc * 10 - 0.75) * 2 * pi / 3) + 1)
    ),
    `elastic-in-out` = ifelse(
      loc == 0, 0,
      ifelse(loc == 1, 1,
             ifelse(loc < 0.5,
                    -(2^( 20*loc - 10) * sin((20 * loc - 11.125) * 2 * pi/4.5)) / 2,
                     (2^(-20*loc + 10) * sin((20 * loc - 11.125) * 2 * pi/4.5)) / 2 + 1
             ))
    ),


    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Ooops!
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    stop("No such ease type: ", type)
  )

  x1 + fac * (x2 - x1)
}
