

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Interpolate (non-linearly) between two colors
#' 
#' @inheritParams seq_ease
#' @param col1,col2 the two colors to interpolate between
#' @param colorspace Color space in which to do the interpolation. Default: 'hcl'
#' Can be any colorspace understood by the \code{farver} package i.e.
#' "cmy", "cmyk", "hsl", "hsb", "hsv", "lab" (CIE L*ab), "hunterlab" 
#' (Hunter Lab), "oklab", "lch" (CIE Lch(ab) / polarLAB), "luv", "rgb" 
#' (sRGB), "xyz", "yxy" (CIE xyY), "hcl" (CIE Lch(uv) / polarLuv), 
#' or "oklch" (Polar form of oklab).
#' Note: Not all color spaces make sense for interpolation.
#' @return character vector containing a color sequence
#' @examplesIf requireNamespace('farver', quietly = TRUE)
#' n <- 20
#' cols <- seq_color('red', 'blue', n = n, direction = 'in-out', colorspace = 'hcl')
#' cols
#' grid::grid.rect(x = seq(0, 0.95, length.out = n), width = 0.1, 
#'                 gp = grid::gpar(fill = cols, col = NA))
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
seq_color <- function(col1, col2, n = 100, type = 'cubic', direction = 'in-out', 
                      colorspace = 'hcl') {
  
  if (requireNamespace('farver', quietly = TRUE)) {
    # Original RGB color space
    rgb <- farver::decode_colour(c(col1, col2))
    
    # Converted color space
    cs <- farver::convert_colour(rgb, from = 'rgb', to = colorspace)
    
    # Interpolate between color 1 and 2
    columns <- lapply(
      seq_len(ncol(cs)),
      function(idx) {
        seq_ease(cs[1, idx], cs[2, idx], n = n, type = type, direction = direction)
      }
    )
    
    # Re-assemble interpolated colors in Converted color space
    cs_new <- do.call(cbind, columns)
    
    # Convert colors back to hex strings for R
    rgb_new <- farver::convert_colour(cs_new, from = colorspace, to = 'rgb')
    rgb_new <- farver::encode_colour(rgb_new)
    
    
    rgb_new
  } else {
    stop("Color interpolation requires the 'farver' package")
  }
}


