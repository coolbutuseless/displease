

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Interpolate (non-linearly) between two colours
#' 
#' @inheritParams seq_ease
#' @param col1,col2 the two colours to interpolate between
#' @param colorspace Color space in which to do the interpolation. Default: 'hcl'
#' Can be any colorspace understood by the \code{farver} package i.e.
#' "cmy", "cmyk", "hsl", "hsb", "hsv", "lab" (CIE L*ab), "hunterlab" 
#' (Hunter Lab), "oklab", "lch" (CIE Lch(ab) / polarLAB), "luv", "rgb" 
#' (sRGB), "xyz", "yxy" (CIE xyY), "hcl" (CIE Lch(uv) / polarLuv), 
#' or "oklch" (Polar form of oklab).
#' Note: Not all color spaces make sense for interpolation.
#' @return character vector containing a colour sequence
#'
#' @examples
#' seq_color('red', 'blue', type = 'cubic', direction = 'in-out', colorspace = 'hcl')
#' @importFrom farver decode_colour convert_colour encode_colour
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
seq_color <- function(col1, col2, n = 100, type = 'cubic', direction = 'in-out', 
                      colorspace = 'hcl') {
  
  # Original RGB colour space
  rgb <- farver::decode_colour(c(col1, col2))
  
  # Converted colour space
  cs <- farver::convert_colour(rgb, from = 'rgb', to = colorspace)
  
  # Interpolate between colour 1 and 2
  columns <- lapply(
    seq_len(ncol(cs)),
    function(idx) {
      seq_ease(cs[1, idx], cs[2, idx], n = n, type = type, direction = direction)
    }
  )

  # Re-assemble interpolated colours in Converted color space
  cs_new <- do.call(cbind, columns)
  
  # Convert colors back to hex strings for R
  rgb_new <- farver::convert_colour(cs_new, from = colorspace, to = 'rgb')
  rgb_new <- farver::encode_colour(rgb_new)
  
  
  rgb_new
}


if (FALSE) {
  
  library(farver)
  'hotpink' |>
    decode_colour() |>
    convert_colour(from = 'rgb', to = 'hcl')
  
}


