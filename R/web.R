
sesameDataGetAnno1 = function(title, base = alt_base) {
    download_path <-
        sprintf('%s/InfiniumAnnotation/current/%s', base, title)

    anno <- NULL
    tryCatch(
        if (endsWith(title, ".tsv.gz")) {
            z <- gzcon(url(download_path))
            raw <- textConnection(readLines(z))
            close(z)
            cat("Retrieving annotation from ",download_path, "... ")
            anno <- read.table(raw, header=TRUE, sep="\t")
            close(raw)
            cat("Done.\n")
        } else if (endsWith(title, ".rds")) {
            cat("Retrieving annotation from ",download_path, "... ")
            anno <- readRDS(url(download_path))
            cat("Done.\n")
        },
        error = function(cond) {
            message("Networking failure. Please report.")
            message(cond)
            return(NULL)
        },
        warning = function(cond) {
            message("sesameDataGetAnno causes an issue:")
            message(cond)
            return(NULL)
        })
    anno
}

#' Retrieve manifest file from the supporting website
#' at http://zwdzwd.github.io/InfiniumAnnotation
#' and https://github.com/zhou-lab/InfiniumAnnotation
#'
#' @param title title of the annotation file
#' @return annotation file
#' @examples
#'
#' mft <- sesameDataGetAnno("HM27/HM27.hg19.manifest.tsv.gz")
#' annoS <- sesameDataGetAnno("EPIC/EPIC.hg19.typeI_overlap_b151.rds")
#' 
#' @export
sesameDataGetAnno <- function(title) {
    anno = sesameDataGetAnno1(title, base = alt_base)
    if (is.null(anno)) {
        anno = sesameDataGetAnno1(title, base = alt_base2)
    }
    anno
}


sesameDataDownloadFile = function(file_name, dest_file, base = alt_base) {
    url = sprintf(
        "%s/sesameData/raw/%s", base, file_name)
    tryCatch(
        download.file(url, dest_file, mode="wb"),
        error = function(cond) {
            message("In .sesameDataDownloadFile:")
            message(cond, "\n")
        },
        warning = function(cond) {
            message("In .sesameDataDownloadFile:")
            message(cond, "\n")
        })
    url
}
        

#' Download auxiliary data for sesame function and documentation
#'
#' @param file_name name of file to download
#' @param dest_dir directory to hold downloaded file.
#' use the temporary directory if not given
#' @return a list with url, dest_dir, dest_file and file_name
#' @examples
#' if(FALSE) { sesameDataDownload("3999492009_R01C01_Grn.idat") }
#' @export
sesameDataDownload = function(file_name, dest_dir=NULL) {
    if (is.null(dest_dir)) {
        dest_dir = tempdir()
    }
    dest_file = sprintf("%s/%s", dest_dir, file_name)

    url = sesameDataDownloadFile(file_name, dest_file, base=alt_base)
    if (!file.exists(dest_file) || file.info(dest_file)$size == 0) { # backup
        url = sesameDataDownloadFile(file_name, dest_file, base=alt_base2)
    }
    
    list(
        url = url,
        dest_dir = dest_dir,
        dest_file = dest_file,
        file_name = file_name)
}

#' Retrieve variant annotation file for explicit rs probes
#' from the supporting website
#' at http://zwdzwd.github.io/InfiniumAnnotation
#'
#' @param platform Infinium platform
#' @param refversion human reference version, irrelevant for mouse array
#' @param version manifest version, default to the latest/current.
#' @return variant annotation file of explicit rs probes
#' @examples
#'
#' annoS <- sesameDataPullVariantAnno_SNP('EPIC', 'hg38')
#' 
#' @export
sesameDataPullVariantAnno_SNP <- function(
    platform = c('EPIC'),
    refversion = c('hg19','hg38'),
    version = '20200704') {

    platform <- match.arg(platform)
    refversion <- match.arg(refversion)

    download_path <-
        sprintf(
            paste0(
                '%s/InfiniumAnnotation/',
                '%s/%s/%s.%s.snp_overlap_b151.rds'),
            alt_base, version, platform, platform, refversion)

    cat("Retrieving SNP annotation from ",download_path, "... ")
    anno <- readRDS(url(download_path))
    cat("Done.\n")
    
    anno
}

#' Retrieve variant annotation file for Infinium-I probes
#' from the supporting website
#' at http://zwdzwd.github.io/InfiniumAnnotation
#'
#' @param platform Infinium platform
#' @param refversion human reference version, irrelevant for mouse array
#' @param version manifest version, default to the latest/current.
#' @return variant annotation file of infinium I probes
#' @examples
#'
#' annoI <- sesameDataPullVariantAnno_InfiniumI('EPIC', 'hg38')
#' 
#' @export
sesameDataPullVariantAnno_InfiniumI <- function(
    platform = c('EPIC'),
    refversion = c('hg19','hg38'),
    version = '20200704') {

    platform <- match.arg(platform)
    refversion <- match.arg(refversion)

    download_path <-
        sprintf(
            paste0(
                '%s/InfiniumAnnotation/',
                '%s/%s/%s.%s.typeI_overlap_b151.rds'),
            alt_base, version, platform, platform, refversion)

    cat("Retrieving SNP annotation from ",download_path, "... ")
    anno <- readRDS(url(download_path))
    cat("Done.\n")
    
    anno
}

