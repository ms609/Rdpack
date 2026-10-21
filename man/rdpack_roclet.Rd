\name{rdpack_roclet}
\alias{rdpack_roclet}

\concept{Rd macros}
\concept{bibtex}
\concept{roxygen2}

\title{Expand citation macros when roxygen2 writes the Rd files}

\description{

  A roxygen2 roclet that replaces the \code{rd} roclet.  It writes the
  same Rd files, but with the citation macros \verb{\insertRef},
  \verb{\insertCite}, \verb{\insertCiteOnly}, \verb{\insertNoCite},
  \verb{\insertAllCited} and \verb{\insertCited} already replaced by the
  text they would produce.

}

\usage{
rdpack_roclet()
}

\details{

  Each citation macro expands to a build-stage \verb{\Sexpr}.
  \command{R CMD build} cannot evaluate such an expression without first
  installing the package, so it does: a package with compiled code is
  compiled once to build its tarball, and again when the tarball is
  installed.  The same happens whenever a package is installed from a
  source directory, for example by \code{remotes::install_github()} or
  \code{pak::pkg_install()}.

  Rd files written by \code{rdpack_roclet()} contain no such
  \verb{\Sexpr}, so the package is not installed during the build.
  The roxygen comments are unchanged: citations are still written with
  the usual macros.

  Each Rd file is processed as the macros would process it: citations
  are collected in the order in which they appear in the file, including
  any brought in by \verb{@inheritParams} or similar tags, and
  \verb{\insertAllCited\{\}} lists those that precede it.  The package's
  own \file{inst/REFERENCES.bib} is read afresh on every run.

  To use it, name it in place of \code{"rd"} in the \code{roclets} entry
  of the \code{Roxygen} field in \file{DESCRIPTION}:
  \preformatted{
Roxygen: list(markdown = TRUE,
              roclets = c("collate", "namespace", "Rdpack::rdpack_roclet"))
}
  Once every Rd file has been written by \code{rdpack_roclet()}, the
  field \code{RdMacros: Rdpack} is no longer needed, and Rdpack is needed
  only to document the package: it can move from \code{Imports} to
  \code{Suggests}.  Keep both if any Rd file is written by hand and uses
  the macros.

  Only the citation macros are expanded.  The macros \verb{\insertFig},
  \verb{\makeFig}, \verb{\runExamples} and \verb{\printExample} are left
  as they are, so a package that uses them is still installed during the
  build.

}

\value{
  an object of class \code{"roclet_rdpack"}, inheriting from roxygen2's
  \code{"roclet_rd"}.
}

\author{Martin R. Smith}

\seealso{
  \code{\link{insert_ref}} and \code{\link{insert_citeOnly}} for the
  macros.
}

\examples{
\dontrun{
roxygen2::roxygenise(roclets = c("namespace", "Rdpack::rdpack_roclet"))
}
}
