% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/toGRanges.R
\name{toGRanges}
\alias{toGRanges}
\title{toGRanges}
\usage{
toGRanges(A, ..., genome=NULL)
}
\arguments{
\item{A}{a \code{\link{data.frame}} containing a region set, a \code{\link{GRanges}} object, a BED file or any type of file supported by \code{rtracklayer}. If there are more than 1 argument, it will build a dataframe out ouf them and process it as usual. If there's only a single argument and it's a character, if it's not an existing file name it will be treated as the definition of a genomic region in the UCSC/IGV format (i.e. "chr9:34229289-34982376") and parsed.}

\item{...}{further arguments to be passed to other methods.}

\item{genome}{(character or BSgenome) The genome info to be attached to the created GRanges. If NULL no genome info will be attached. (defaults to NULL)}
}
\value{
A \code{\link{GRanges}} object with the regions in A
}
\description{
Transforms a file or an object containing a region set into a \code{\link{GRanges}} object.
}
\details{
If A is already a \code{\link{GRanges}} object, it will be returned untouched. 

If A is a file name or connection to a file in any of the formats supported by \code{rtracklayer}'s import function (BED, GFF...) 
it will be imported using \code{rtracklayer}.
 
If A is a data frame, the function will assume the first three columns are chromosome, start and end and create a \code{\link{GRanges}} object. Any additional 
column will be considered metadata and stored as such in the \code{\link{GRanges}} object. 

If A is not a data.frame and there are more parameters, it will try to build a data.frame with all 
parameters and use that data.frame to build the GRanges. This allows the user to call it like
 \code{toGRanges("chr1", 10, 20)}.
 
If A is a character or a character vector and it's not a file or a URL, it 
assumes it's a genomic position description in the form used by UCSC or 
IGV, "chr2:1000-2000". It will try to parse the character strings into
chromosome, start and end and create a GRanges. The parser can deal with 
commas separating thousands (e.g. "chr2:1,000-2,000") and with the comma 
used as a start/end separator (e.g. "chr2:1000,2000"). These different 
variants can be mixed in the same character vector.

The \code{genome} parameter can be used to set the genome information of
the created GRanges. It can be either a \code{\link{BSgenome}} object or a 
character string defining a genome (e.g. "hg19", "mm10"...) as accepted 
by the \code{BSgenome::getBSgenome} function. If a valid genome is
given and the corresponding BSgenome package is installed, the genome
information will be attached to the GRanges. If the chromosome naming style
from the GRanges and the genome object are different, it will try to change 
the GRanges styles to match those of the genome using 
\code{GenomeInfoDb::seqlevelsStyle}.
}
\examples{
A <- data.frame(chr=1, start=c(1, 15, 24), end=c(10, 20, 30),  x=c(1,2,3), y=c("a", "b", "c"))
gr1 <- toGRanges(A)

#No need to give the data.frame columns any specific name
A <- data.frame(1, c(1, 15, 24), c(10, 20, 30),  x=c(1,2,3), y=c("a", "b", "c"))
gr2 <- toGRanges(A)

#We can pass the data without building the data.frame
gr3 <- toGRanges("chr9", 34229289, 34982376, x="X")

#And each argument can be a vector (they will be recycled as needed)
gr4 <- toGRanges("chr9", c(34229289, 40000000), c(34982376, 50000000), x="X", y=c("a", "b"))

#toGRanges will automatically convert the second and third argument into numerics
gr5 <- toGRanges("chr9", "34229289", "34982376") 

#It can be a file from disk
bed.file <- system.file("extdata", "my.special.genes.bed", package="regioneR")
gr6 <- toGRanges(bed.file)

#Or a URL to a valid file
gr7 <- toGRanges("http://molb7621.github.io/workshop/_downloads/lamina.bed")

#It can also parse genomic location strings
gr8 <- toGRanges("chr9:34229289-34982376")

#more than one
gr9 <- toGRanges(c("chr9:34229289-34982376", "chr10:1000-2000"))

#even with mixed strange and mixed syntaxes
gr10 <- toGRanges(c("chr4:3873-92928", "chr4:3873,92928", "chr5:33,444-45,555"))

#if the genome is given it is used to annotate the resulting GRanges
gr11 <- toGRanges(c("chr9:34229289-34982376", "chr10:1000-2000"), genome="hg19")


#and the genome is added to the GRanges even if A is a GRanges
gr12 <- toGRanges(gr6, genome="hg19")

#And it will change the chromosome naming of the GRanges to match that of the
#genome if it is possible (using GenomeInfoDb::seqlevelsStyle)
gr2
gr13 <- toGRanges(gr2, genome="hg19")



}
\seealso{
\code{\link{toDataframe}}
}
