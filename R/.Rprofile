options(width=250)

.env <- new.env()
.env$theme_big <- function() {
ggplot2::theme_grey() + ggplot2::theme(text = ggplot2::element_text(size = 24))
}
attach(.env)

r <- getOption("repos")
r["CRAN"] <- "http://cran.stat.sfu.ca"
options(repos = r)
rm(r)

options(pdfviewer="xdg-open")
