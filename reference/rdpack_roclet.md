# Expand citation macros when roxygen2 writes the Rd files

A roxygen2 alternative to the `rd` roclet that writes citations as text
rather than `\Sexpr`s, so `R CMD build` need not install the package.

## Usage

``` r
rdpack_roclet()
```

## Details

Under the `rd` roclet, citation macros are written verbatim to `.Rd`
files, and thence expanded to build-stage `\Sexpr`s. `R CMD build` (or
`remotes::install_github()`,
[`pak::pkg_install()`](https://pak.r-lib.org/reference/pkg_install.html))
cannot evaluate such an expression without first installing the package,
meaning that a package with compiled code is compiled once to build its
tarball, and again when the tarball is installed. `rdpack_roclet()`
writes the same citations without `\Sexpr`, thus avoiding the double
installation.

To use it, name it in place of `"rd"` in the `roclets` entry of the
`Roxygen` field in `DESCRIPTION`:


    Roxygen: list(markdown = TRUE,
                  roclets = c("collate", "namespace", "Rdpack::rdpack_roclet"))

If transitioning to `rdpack_roclet()`, then after the first run, the
field `RdMacros: Rdpack` may be removed from `DESCRIPTION`, and Rdpack
can move from `Imports` to `Suggests`.

Only the citation macros are expanded. The macros `\insertFig`,
`\makeFig`, `\runExamples` and `\printExample` still cause the package
to be installed during the build.

## Value

an object of class `"roclet_rdpack"`, inheriting from roxygen2's
`"roclet_rd"`.

## Author

[Martin R. Smith](https://orcid.org/0000-0001-5660-1727)

## See also

[`insert_ref`](https://geobosh.github.io/Rdpack/reference/insert_ref.md)
and
[`insert_citeOnly`](https://geobosh.github.io/Rdpack/reference/insert_citeOnly.md)
for the macros.

## Examples

``` r
if (FALSE) { # \dontrun{
roxygen2::roxygenise(roclets = c("namespace", "Rdpack::rdpack_roclet"))
} # }
```
