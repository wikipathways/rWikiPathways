#!/usr/bin/env Rscript
# Script to colorize WikiPathways with differential expression data
# NO CYTOSCAPE REQUIRED - programmatic visualization only
# This script reads log2fold change data and generates colored pathway diagrams

library(rWikiPathways)
library(XML)
library(dplyr)
library(igraph)
library(ggraph)
library(ggplot2)
supp_rsvg <- requireNamespace("rsvg", quietly = TRUE)
rsvg_convert_bin <- Sys.which("rsvg-convert")

# CLI parsing
optparse_ok <- requireNamespace("optparse", quietly = TRUE)
if (!optparse_ok) {
  message("Package 'optparse' not found; falling back to defaults and env vars.")
}

# Configuration defaults (can be overridden by CLI)
# Note: TSV file and species have NO defaults and are required.
DEFAULT_MIN_GENES <- 3
DEFAULT_OUTPUT_DIR <- "pathway_images"
DEFAULT_LIMIT <- 5
WIKIPATHWAYS_DATA_BASE <- "https://data.wikipathways.org/current"

# Parse CLI options
if (optparse_ok) {
  op <- getNamespace("optparse")
  option_list <- list(
    op$make_option(c("-t", "--tsv"), type = "character", default = NULL,
                   help = "Path to input TSV with columns 'gene' and 'log2FoldChange' [required]"),
    op$make_option(c("-s", "--species"), type = "character", default = NULL,
                   help = "Species/organism name recognized by WikiPathways [required]"),
    op$make_option(c("-m", "--min-genes"), type = "integer", default = DEFAULT_MIN_GENES,
                   help = "Minimum matching genes required per pathway [default: %default]"),
    op$make_option(c("-o", "--output-dir"), type = "character", default = DEFAULT_OUTPUT_DIR,
                   help = "Output directory for images and tables [default: %default]"),
    op$make_option(c("-l", "--limit"), type = "integer", default = DEFAULT_LIMIT,
                   help = "Maximum number of pathways to process (set 0 for all) [default: %default]")
  )
  parser <- op$OptionParser(option_list = option_list, description = "Colorize WikiPathways from differential expression data (no Cytoscape required)")
  args <- op$parse_args(parser)

  TSV_FILE <- args$tsv
  SPECIES <- args$species
  MIN_GENES_THRESHOLD <- as.integer(args$`min-genes`)
  OUTPUT_DIR <- args$`output-dir`
  MAX_PATHWAYS <- as.integer(args$limit)

  # Enforce required arguments
  missing <- character(0)
  if (is.null(TSV_FILE) || TSV_FILE == "") missing <- c(missing, "--tsv")
  if (is.null(SPECIES) || SPECIES == "") missing <- c(missing, "--species")
  if (length(missing) > 0) {
    op$print_help(parser)
    stop(sprintf("Missing required option(s): %s", paste(missing, collapse = ", ")), call. = FALSE)
  }
} else {
  # Fallback to environment variables or defaults
  TSV_FILE <- Sys.getenv("WP_TSV_FILE", unset = "")
  SPECIES <- Sys.getenv("WP_SPECIES", unset = "")
  MIN_GENES_THRESHOLD <- as.integer(Sys.getenv("WP_MIN_GENES", unset = DEFAULT_MIN_GENES))
  OUTPUT_DIR <- Sys.getenv("WP_OUTPUT_DIR", unset = DEFAULT_OUTPUT_DIR)
  MAX_PATHWAYS <- as.integer(Sys.getenv("WP_LIMIT", unset = DEFAULT_LIMIT))

  if (TSV_FILE == "" || SPECIES == "") {
    stop("Missing required inputs. Provide 'WP_TSV_FILE' and 'WP_SPECIES' environment variables when 'optparse' is not available.", call. = FALSE)
  }
}

# Create output directory if it doesn't exist
if (!dir.exists(OUTPUT_DIR)) {
  dir.create(OUTPUT_DIR, recursive = TRUE)
}

# Backend state and helpers
use_archive_backend <- FALSE
archive_cache <- new.env(parent = emptyenv())
archive_gpml_map <- setNames(character(0), character(0))
archive_svg_dir <- NULL

normalize_species_token <- function(species) {
  gsub("[ _]+", "_", trimws(species))
}

find_species_archive_url <- function(kind, species) {
  index_url <- paste0(WIKIPATHWAYS_DATA_BASE, "/", kind, "/")
  html <- tryCatch(
    paste(readLines(index_url, warn = FALSE), collapse = "\n"),
    error = function(e) ""
  )
  if (html == "") return(NULL)

  pat <- paste0("wikipathways-[0-9]{8}-", kind, "-[A-Za-z0-9_\\.-]+\\.zip")
  m <- gregexpr(pat, html, perl = TRUE)
  files <- unique(regmatches(html, m)[[1]])
  if (length(files) == 0) return(NULL)

  species_norm <- tolower(normalize_species_token(species))
  suffix_pat <- paste0("^wikipathways-[0-9]{8}-", kind, "-(.*)\\.zip$")
  species_tokens <- tolower(sub(suffix_pat, "\\1", files, perl = TRUE))
  idx <- which(species_tokens == species_norm)
  if (length(idx) == 0) return(NULL)

  paste0(index_url, files[idx[1]])
}

ensure_species_archive_dir <- function(kind, species) {
  key <- paste(kind, tolower(normalize_species_token(species)), sep = ":")
  if (exists(key, envir = archive_cache, inherits = FALSE)) {
    return(get(key, envir = archive_cache, inherits = FALSE))
  }

  archive_url <- find_species_archive_url(kind, species)
  if (is.null(archive_url)) return(NULL)

  zip_path <- file.path(tempdir(), basename(archive_url))
  ok <- tryCatch({
    utils::download.file(archive_url, zip_path, quiet = TRUE, mode = "wb")
    file.exists(zip_path) && file.info(zip_path)$size > 0
  }, error = function(e) FALSE, warning = function(w) FALSE)

  if (!ok) return(NULL)

  extract_dir <- file.path(tempdir(), paste0("wp_", kind, "_", normalize_species_token(species)))
  if (!dir.exists(extract_dir)) dir.create(extract_dir, recursive = TRUE)

  unzip_ok <- tryCatch({
    utils::unzip(zip_path, exdir = extract_dir, overwrite = TRUE)
    TRUE
  }, error = function(e) FALSE, warning = function(w) FALSE)

  if (!unzip_ok) return(NULL)

  assign(key, extract_dir, envir = archive_cache)
  extract_dir
}

extract_wpid_from_filename <- function(path) {
  b <- basename(path)
  m <- regexpr("WP[0-9]+", b, perl = TRUE)
  if (m[1] == -1) return(NA_character_)
  regmatches(b, m)
}

extract_pathway_name_from_gpml_file <- function(gpml_file) {
  tryCatch({
    doc <- xmlParse(gpml_file, useInternalNodes = TRUE)
    p <- getNodeSet(doc, "//*[local-name()='Pathway']")
    if (length(p) == 0) return(NA_character_)
    nm <- xmlGetAttr(p[[1]], "Name", default = NA_character_)
    if (!is.na(nm) && nzchar(trimws(nm))) return(nm)
    NA_character_
  }, error = function(e) NA_character_)
}

list_pathways_from_archive <- function(species) {
  gpml_dir <- ensure_species_archive_dir("gpml", species)
  if (is.null(gpml_dir)) {
    stop(sprintf("Could not locate GPML archive for species '%s' on %s/gpml", species, WIKIPATHWAYS_DATA_BASE))
  }

  gpml_files <- list.files(gpml_dir, pattern = "\\.gpml$", full.names = TRUE)
  if (length(gpml_files) == 0) {
    stop(sprintf("No GPML files found in extracted archive for species '%s'", species))
  }

  ids <- vapply(gpml_files, extract_wpid_from_filename, character(1))
  names <- vapply(gpml_files, extract_pathway_name_from_gpml_file, character(1))
  fallback_names <- sub("_WP[0-9]+_.*$", "", tools::file_path_sans_ext(basename(gpml_files)))
  fallback_names <- gsub("_", " ", fallback_names)
  names[is.na(names) | names == ""] <- fallback_names[is.na(names) | names == ""]

  out <- data.frame(id = ids, name = names, gpml_file = gpml_files, stringsAsFactors = FALSE)
  out <- out[!is.na(out$id) & out$id != "", , drop = FALSE]
  out <- out[!duplicated(out$id), , drop = FALSE]
  out
}

get_pathway_gpml <- function(wpid) {
  if (use_archive_backend) {
    gpml_path <- unname(archive_gpml_map[wpid])
    if (length(gpml_path) == 0 || is.na(gpml_path) || !file.exists(gpml_path)) return(NULL)
    return(paste(readLines(gpml_path, warn = FALSE), collapse = "\n"))
  }
  tryCatch(getPathway(wpid), error = function(e) NULL)
}

convert_svg_to_png <- function(svg_path, png_path) {
  if (!file.exists(svg_path)) return(FALSE)

  if (supp_rsvg) {
    ok <- tryCatch({
      rsvg::rsvg_png(svg_path, png_path)
      file.exists(png_path) && file.info(png_path)$size > 0
    }, error = function(e) FALSE, warning = function(w) FALSE)
    if (ok) return(TRUE)
  }

  if (nzchar(rsvg_convert_bin)) {
    ok <- tryCatch({
      status <- suppressWarnings(system2(rsvg_convert_bin, args = c("-o", png_path, svg_path), stdout = FALSE, stderr = FALSE))
      is.numeric(status) && length(status) == 1 && status == 0 && file.exists(png_path) && file.info(png_path)$size > 0
    }, error = function(e) FALSE, warning = function(w) FALSE)
    if (ok) return(TRUE)
  }

  FALSE
}

# Read the TSV file with differential expression data
cat("Reading differential expression data...\n")
de_data <- read.table(TSV_FILE, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# Extract gene IDs (before the ::)
de_data$gene_id <- sapply(strsplit(de_data$gene, "::"), `[`, 1)

# Create a named vector of log2FoldChange values
log2fc_values <- setNames(de_data$log2FoldChange, de_data$gene_id)

cat(sprintf("Loaded %d genes with log2 fold change values\n", length(log2fc_values)))
cat(sprintf("Log2FC range: %.2f to %.2f\n", min(log2fc_values), max(log2fc_values)))

# Search for all pathways for the species
cat(sprintf("\nSearching for %s pathways...\n", SPECIES))
all_pathways <- tryCatch(listPathways(organism = SPECIES), error = function(e) {
  cat(sprintf("WikiPathways webservice lookup failed (%s). Falling back to monthly archive backend...\n", e$message))
  NULL
})

if (is.null(all_pathways) || nrow(all_pathways) == 0) {
  archive_pathways <- list_pathways_from_archive(SPECIES)
  use_archive_backend <- TRUE
  archive_gpml_map <- setNames(archive_pathways$gpml_file, archive_pathways$id)
  archive_svg_dir <- ensure_species_archive_dir("svg", SPECIES)
  all_pathways <- archive_pathways[, c("id", "name")]
}

if (nrow(all_pathways) == 0) {
  stop("No pathways found for the specified species!")
}

cat(sprintf("Found %d pathways for %s\n", nrow(all_pathways), SPECIES))

extract_genes_from_gpml <- function(gpml_string) {
  tryCatch({
    doc <- xmlParse(gpml_string, useInternalNodes = TRUE)
    # Select DataNode elements likely to represent genes/proteins
    nodes <- getNodeSet(doc, "//*[local-name()='DataNode' and (@Type='GeneProduct' or @Type='Protein')]")
    if (length(nodes) == 0) return(data.frame(graph_id=character(), name=character(), xref_id=character(), xref_db=character(), stringsAsFactors=FALSE))

    res <- lapply(nodes, function(n) {
      graph_id <- xmlGetAttr(n, "GraphId", default = NA_character_)
      name <- xmlGetAttr(n, "TextLabel", default = NA_character_)
      xnode <- getNodeSet(n, ".//*[local-name()='Xref']")
      xref_id <- if (length(xnode) > 0) xmlGetAttr(xnode[[1]], "ID", default = NA_character_) else NA_character_
      xref_db <- if (length(xnode) > 0) xmlGetAttr(xnode[[1]], "Database", default = NA_character_) else NA_character_
      data.frame(graph_id = graph_id, name = name, xref_id = xref_id, xref_db = xref_db, stringsAsFactors = FALSE)
    })
    df <- unique(do.call(rbind, res))
    df
  }, error = function(e) {
    data.frame(graph_id=character(), name=character(), xref_id=character(), xref_db=character(), stringsAsFactors=FALSE)
  })
}

# Match input gene IDs to pathway gene table (by symbol or xref ID)
match_input_genes <- function(genes_df, log2fc_values) {
  if (nrow(genes_df) == 0) return(data.frame(graph_id=character(), gene_name=character(), log2fc=numeric(), stringsAsFactors = FALSE))
  input_ids <- tolower(names(log2fc_values))
  sym <- tolower(genes_df$name)
  xid <- tolower(genes_df$xref_id)

  hits_sym <- input_ids[input_ids %in% sym]
  hits_xid <- input_ids[input_ids %in% xid]
  hits <- unique(c(hits_sym, hits_xid))
  if (length(hits) == 0) return(data.frame(graph_id=character(), gene_name=character(), log2fc=numeric(), stringsAsFactors = FALSE))

  # Build matched table preferring symbol matches when available
  matched <- lapply(hits, function(h) {
    rows <- genes_df[ which(sym == h | xid == h), , drop=FALSE]
    idx <- which(tolower(names(log2fc_values))==h)[1]
    gene_label <- ifelse(is.na(rows$name[1]) || rows$name[1] == "", rows$xref_id[1], rows$name[1])
    data.frame(graph_id = rows$graph_id[1], gene_name = gene_label, log2fc = unname(log2fc_values[idx]), stringsAsFactors = FALSE)
  })
  do.call(rbind, matched)
}

# Function to count matching genes in a pathway
count_matching_genes <- function(wpid) {
  pathway_gpml <- get_pathway_gpml(wpid)
  if (is.null(pathway_gpml)) return(0)
  genes_df <- extract_genes_from_gpml(pathway_gpml)
  matched <- match_input_genes(genes_df, log2fc_values)
  nrow(matched)
}

# Filter pathways based on gene overlap
cat("\nAnalyzing pathway gene overlap...\n")
pathway_gene_counts <- data.frame(
  wpid = all_pathways$id,
  name = all_pathways$name,
  gene_count = sapply(all_pathways$id, count_matching_genes),
  stringsAsFactors = FALSE
)

# Show top pathways by overlap to help diagnostics
top_preview <- pathway_gene_counts %>% arrange(desc(gene_count)) %>% head(10)
cat("\nTop pathways by matched gene count (preview):\n")
print(top_preview)

# Filter pathways with at least MIN_GENES_THRESHOLD matching genes
filtered_pathways <- pathway_gene_counts %>%
  filter(gene_count >= MIN_GENES_THRESHOLD) %>%
  arrange(desc(gene_count))

cat(sprintf("\nFound %d pathways with at least %d matching genes:\n", 
            nrow(filtered_pathways), MIN_GENES_THRESHOLD))
print(filtered_pathways)

if (nrow(filtered_pathways) == 0) {
  stop("No pathways meet the minimum gene threshold!")
}

# Function to create a simple network visualization
create_pathway_visualization <- function(wpid, pathway_name, gene_count, log2fc_values) {
  cat(sprintf("\n--- Processing: %s (%s) ---\n", pathway_name, wpid))
  cat(sprintf("Matching genes: %d\n", gene_count))
  
  tryCatch({
    # Get pathway GPML
    pathway_gpml <- get_pathway_gpml(wpid)
    if (is.null(pathway_gpml)) {
      cat("Warning: Could not retrieve GPML for pathway\n")
      return(FALSE)
    }
    genes_df <- extract_genes_from_gpml(pathway_gpml)
    
    if (is.null(genes_df) || nrow(genes_df) == 0) {
      cat("Warning: Could not extract genes from pathway\n")
      return(FALSE)
    }
    
    # Match genes with expression data
    matched_genes <- match_input_genes(genes_df, log2fc_values)
    
    cat(sprintf("Matched %d genes with expression data\n", nrow(matched_genes)))
    
    if (nrow(matched_genes) == 0) {
      cat("Warning: No genes matched\n")
      return(FALSE)
    }
    
    # Create a simple visualization using ggplot (keep barplot output)
    # Normalize log2fc for color mapping
    max_abs_log2fc <- max(abs(matched_genes$log2fc), na.rm = TRUE)
    matched_genes$color_value <- matched_genes$log2fc / max_abs_log2fc
    
    # Define color function
    get_color <- function(value) {
      if (value < -0.3) return("#0000FF")  # Blue for downregulated
      if (value < 0.3) return("#FFFFFF")   # White for neutral
      return("#FF0000")                    # Red for upregulated
    }
    
    matched_genes$color <- sapply(matched_genes$color_value, get_color)
    
    # Create a simple bar plot as visualization
    p <- ggplot(matched_genes, aes(x = reorder(gene_name, log2fc), y = log2fc, fill = color)) +
      geom_col() +
      scale_fill_identity() +
      coord_flip() +
      theme_minimal() +
      labs(
        title = paste0(wpid, ": ", pathway_name),
        subtitle = paste0("Matching genes: ", nrow(matched_genes)),
        x = "Gene",
        y = "log2 Fold Change",
        caption = "Blue: downregulated | White: neutral | Red: upregulated"
      ) +
      theme(
        plot.title = element_text(size = 14, face = "bold"),
        plot.subtitle = element_text(size = 12),
        axis.text = element_text(size = 10),
        panel.grid.major.x = element_line(color = "gray90"),
        panel.background = element_rect(fill = "white")
      )
    
    # Export barplot image
    output_file <- file.path(OUTPUT_DIR, paste0(wpid, "_barplot.png"))
    png(output_file, width = 1200, height = nrow(matched_genes) * 30 + 300, res = 100)
    print(p)
    dev.off()
    cat(sprintf("Exported barplot: %s\n", output_file))
    
    # Also save a summary table
    summary_file <- file.path(OUTPUT_DIR, paste0(wpid, "_genes.tsv"))
    write.table(matched_genes[, c("gene_name", "log2fc", "color")], 
                file = summary_file, sep = "\t", row.names = FALSE, quote = FALSE)
    cat(sprintf("Exported gene summary: %s\n", summary_file))
    
    # Overlay colors on official pathway SVG
    svg_file <- fetch_pathway_svg(wpid)
    if (!is.null(svg_file) && file.exists(svg_file)) {
      recolored_svg <- recolor_pathway_svg(svg_file, genes_df, matched_genes, OUTPUT_DIR)
      if (!is.null(recolored_svg) && file.exists(recolored_svg)) {
        png_out <- sub("\\.svg$", ".png", recolored_svg)
        if (convert_svg_to_png(recolored_svg, png_out)) {
          cat(sprintf("Exported recolored PNG: %s\n", png_out))
        } else {
          cat("Warning: Could not convert recolored SVG to PNG (install R package 'rsvg' or binary 'rsvg-convert').\n")
          cat(sprintf("Kept recolored SVG fallback: %s\n", recolored_svg))
        }
      } else {
        cat("Warning: Could not recolor pathway SVG\n")
      }
    } else {
      cat("Warning: Could not retrieve pathway SVG for overlay\n")
    }

    return(TRUE)
    
  }, error = function(e) {
    cat(sprintf("Error processing pathway: %s\n", e$message))
    return(FALSE)
  })
}

# Try to fetch per-pathway SVG directly; fallback to archive download
fetch_pathway_svg <- function(wpid) {
  if (use_archive_backend) {
    if (is.null(archive_svg_dir) || !dir.exists(archive_svg_dir)) {
      archive_svg_dir <<- ensure_species_archive_dir("svg", SPECIES)
    }
    if (!is.null(archive_svg_dir) && dir.exists(archive_svg_dir)) {
      svgs <- list.files(archive_svg_dir, pattern = "\\.svg$", full.names = TRUE)
      hit <- svgs[grepl(paste0("(^|_)", wpid, "(_|\\.)"), basename(svgs), ignore.case = TRUE)]
      if (length(hit) > 0) return(hit[1])
    }
  }

  # Try static asset URL pattern
  url1 <- paste0("https://www.wikipathways.org/wikipathways-assets/pathways/", wpid, "/", wpid, ".svg")
  dest1 <- file.path(tempdir(), paste0(wpid, ".svg"))
  ok <- tryCatch({
    utils::download.file(url1, dest1, quiet = TRUE, mode = "wb"); TRUE
  }, error = function(e) FALSE, warning = function(w) FALSE)
  if (ok && file.exists(dest1) && file.info(dest1)$size > 0) return(dest1)

  # Fallback: download/extract the species SVG archive from current data site
  svg_dir <- ensure_species_archive_dir("svg", SPECIES)
  if (!is.null(svg_dir) && dir.exists(svg_dir)) {
    svgs <- list.files(svg_dir, pattern = "\\.svg$", full.names = TRUE)
    hit <- svgs[grepl(paste0("(^|_)", wpid, "(_|\\.)"), basename(svgs), ignore.case = TRUE)]
    if (length(hit) > 0) {
      return(hit[1])
    }
  }
  NULL
}

# Helper: set fill color on an SVG element (style or attribute)
set_svg_fill <- function(node, color) {
  # Set fill attribute
  XML::xmlAttrs(node)["fill"] <- color
  # Update style string if present
  st <- XML::xmlGetAttr(node, "style", default = NA)
  if (!is.na(st)) {
    if (grepl("fill:", st)) {
      st <- sub("fill:[^;]*", paste0("fill:", color), st)
    } else {
      st <- paste0(st, ";fill:", color)
    }
    XML::xmlAttrs(node)["style"] <- st
  }
}

# Recolor SVG rectangles corresponding to matched DataNodes
recolor_pathway_svg <- function(svg_path, genes_df, matched, output_dir) {
  if (!file.exists(svg_path) || nrow(matched) == 0) return(NULL)
  doc <- tryCatch(XML::xmlParse(svg_path, useInternalNodes = TRUE), error = function(e) NULL)
  if (is.null(doc)) return(NULL)

  # Build lookup by graph_id -> color using a gradient scale
  max_abs_log2fc <- max(abs(matched$log2fc), na.rm = TRUE)
  denom <- ifelse(max_abs_log2fc == 0, 1, max_abs_log2fc)
  vals <- matched$log2fc / denom  # Normalized to [-1, 1]
  
  # Color function: gradient from blue through white to red
  get_color_gradient <- function(val) {
    # val is in [-1, 1]
    if (val < -0.001) {
      # Blue scale: from dark blue to light blue
      intensity <- (val + 1) / 2  # Map [-1, 0] to [0, 0.5]
      r <- as.integer(intensity * 100)
      g <- as.integer(intensity * 100)
      b <- 255
      sprintf("#%02X%02X%02X", r, g, b)
    } else if (val > 0.001) {
      # Red scale: from light red to dark red
      intensity <- val / 1  # Map [0, 1] to [0, 1]
      r <- 255
      g <- as.integer((1 - intensity) * 100)
      b <- as.integer((1 - intensity) * 100)
      sprintf("#%02X%02X%02X", r, g, b)
    } else {
      # Near-zero: light gray/white
      "#F0F0F0"
    }
  }
  
  colors <- sapply(vals, get_color_gradient)
  lut <- setNames(colors, matched$graph_id)

  gids <- unique(names(lut))
  for (gid in gids) {
    if (is.na(gid) || gid == "") next
    # Find node/group by id
    g_nodes <- XML::getNodeSet(doc, paste0("//*[@id='", gid, "']"))
    if (length(g_nodes) == 0) {
      g_nodes <- XML::getNodeSet(doc, paste0("//*[contains(@id,'", gid, "')]"))
    }
    if (length(g_nodes) == 0) next
    col <- lut[[gid]]
    # Color rect (preferred) or first path under node
    rects <- unique(c(XML::getNodeSet(g_nodes[[1]], ".//*[local-name()='rect']"),
                      if (tolower(XML::xmlName(g_nodes[[1]])) == 'rect') list(g_nodes[[1]]) else list()))
    if (length(rects) == 0) {
      rects <- XML::getNodeSet(g_nodes[[1]], ".//*[local-name()='path']")
    }
    for (r in rects) {
      set_svg_fill(r, col)
    }
  }

  # Extract wpid from svg_path and save to output_dir
  wpid <- sub("^.*/(WP[0-9]+)\\.svg$", "\\1", svg_path)
  if (wpid == svg_path) wpid <- sub("\\.svg$", "", basename(svg_path))
  out <- file.path(output_dir, paste0(wpid, "_overlay.svg"))
  XML::saveXML(doc, file = out)
  out
}

# Process each filtered pathway
cat("\n=== Starting pathway analysis and visualization ===\n")
successful_pathways <- 0

for (i in 1:nrow(filtered_pathways)) {
  result <- create_pathway_visualization(
    filtered_pathways$wpid[i],
    filtered_pathways$name[i],
    filtered_pathways$gene_count[i],
    log2fc_values
  )
  
  if (result) {
    successful_pathways <- successful_pathways + 1
  }
  
  # Respect limit if set (>0)
  if (!is.na(MAX_PATHWAYS) && MAX_PATHWAYS > 0 && i >= MAX_PATHWAYS) {
    cat(sprintf("\nProcessed %d pathways (limit reached).\n", MAX_PATHWAYS))
    break
  }
}

cat(sprintf("\n=== Summary ===\n"))
cat(sprintf("Total pathways with >= %d genes: %d\n", MIN_GENES_THRESHOLD, nrow(filtered_pathways)))
cat(sprintf("Successfully visualized: %d\n", successful_pathways))
cat(sprintf("\nOutput saved in: %s/\n", OUTPUT_DIR))
cat("Files generated:\n")
cat("  - *_barplot.png: visualization of matched genes with log2FC values\n")
cat("  - *_overlay.png: pathway overlay with matched-gene coloring (when SVG->PNG conversion is available)\n")
cat("  - *_genes.tsv: table of matched genes and their log2FC values\n")
