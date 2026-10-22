\name{rdpack_roclet}
\alias{rdpack_roclet}

\concept{Rd macros}
\concept{bibtex}
\concept{roxygen2}

\title{Expand citation macros when roxygen2 writes the Rd files}

\description{

  A roxygen2 alternative to the \code{rd} roclet that, by circumventing
  \verb{\Sexpr} calls, precludes the need for a second package
  installation when building a package.

}

\usage{
rdpack_roclet()
}

\details{

  Under the \code{rd} roclet, each citation macro expands to a build-stage
  \verb{\Sexpr}. \command{R CMD build} (or \code{remotes::install_github()},
  \code{pak::pkg_install()}) cannot evaluate such an expression without
  first installing the package, meaning that a package with compiled code
  is compiled once to build its tarball, and again when the tarball is
  installed.
  Rd files written by \code{rdpack_roclet()} write the same citations
  without \verb{\Sexpr}, and thus avoid the double installation.

  To use it, name it in place of \code{"rd"} in the \code{roclets} entry
  of the \code{Roxygen} field in \file{DESCRIPTION}:
  \preformatted{
Roxygen: list(markdown = TRUE,
              roclets = c("collate", "namespace", "Rdpack::rdpack_roclet"))
}

  If transitioning to \code{rdpack_roclet()}, then after the first run, the
  field \code{RdMacros: Rdpack} may be removed from \verb{DESCRIPTION}, and
  Rdpack can move from \code{Imports} to \code{Suggests}.

  Only the citation macros are expanded.  The macros \verb{\insertFig},
  \verb{\makeFig}, \verb{\runExamples} and \verb{\printExample} still
  require a package to be installed during the build.

}

\value{
  an object of class \code{"roclet_rdpack"}, inheriting from roxygen2's
  \code{"roclet_rd"}.
}

\author{\href{https://orcid.org/0000-0001-5660-1727}{Martin R. Smith}}

\seealso{
  \code{\link{insert_ref}} and \code{\link{insert_citeOnly}} for the
  macros.
}

\examples{
\dontrun{
roxygen2::roxygenise(roclets = c("namespace", "Rdpack::rdpack_roclet"))
}
}
