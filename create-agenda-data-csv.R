library(xml2)

create_one_agenda_day <-
function(n, xpaths, html)
{
    tbody <- xml_find_first(html, sprintf("//table//tbody[%d]", n))

    talk_colors <- xml_attr(xml_find_all(tbody, xpaths$talk_color), "color")
    talk_color_map <-
        c("#595959" = "",
          "#00008C" = "Keynote",
          "#CC7200" = "Lightning",
          "#894411" = "Talk")
    talk_type <- talk_color_map[talk_colors]
    blanks <- rep("", length(talk_type))
    #browser()

    talk_times <- xml_text(xml_find_all(tbody, "./tr/td[1]"))
    talk_times <- strsplit(talk_times, "-", fixed = TRUE)

    pattern <- "[^[:digit:]]([[:digit:]]{1,2}:[[:digit:]]{2}).*"
    # \u00A0 is &nbsp (non-breaking space)
    talk_start <- gsub("\u00A0", "", gsub(pattern, "\\1", sapply(talk_times, "[", 1)))
    talk_end   <- gsub("\u00A0", "", gsub(pattern, "\\1", sapply(talk_times, "[", 2)))
    talk_start <- ifelse(is.na(talk_start), "", talk_start)
    talk_end   <- ifelse(is.na(talk_end), "", talk_end)

    talk_text_all <- xml_text(xml_find_all(tbody, xpaths$talk_text_all))
    talk_author   <- xml_text(xml_find_all(tbody, xpaths$talk_author))

    talk_title <- talk_text_all
    for (i in seq_along(talk_title)) {
        talk_title[i] <- gsub(talk_author[i], "", talk_title[i], fixed = TRUE)
    }
    talk_title <- gsub(": ", "", talk_title)
    talk_title <- gsub("[[:punct:][:space:]]*\\((pdf|ppt|pptx|doc|docx|html|htm)\\)[[:punct:][:space:]]*.*", "", talk_title)

    make_url <- function(tbody) {
        talk_url <- xml_find_first(xml_find_all(tbody, "./tr"), ".//a")
        talk_url <- xml_attr(talk_url, "href")
        talk_url <- ifelse(is.na(talk_url), "", talk_url)

        s3_url <- "https://rinfinance.s3.amazonaws.com/"
        has_s3 <- grepl("past.rinfinance.com", talk_url, fixed = TRUE)
        talk_url[has_s3] <- gsub("http://", s3_url, talk_url[has_s3], fixed = TRUE)

        return(talk_url)
    }
    talk_url_s3 <- make_url(tbody)

#length(blanks)
#length(talk_start)
#length(talk_end)
#length(talk_type)
#length(blanks)
#length(talk_author)
#length(talk_title)
#length(talk_url_s3)

    data.frame(start = talk_start,
               duration = blanks,
               end = talk_end,
               type = talk_type,
               group = blanks,
               author = talk_author,
               title = talk_title,
               url = talk_url_s3)
}

create_agenda <-
function(year)
{
    if (year == "2018") {
        agenda_dir <- ""
        xpaths <-
            list(talk_text_all = "./tr/td[2]",
                 talk_author = "./tr/td[2]//font[@color]",
                 talk_color  = ".//font[@color]")
    } else if (year == "2017") {
        agenda_dir <- ""
        xpaths <-
            list(talk_text_all = "./tr/td[2]",
                 talk_author = "./tr/td[2]//font[@color]",
                 talk_color  = ".//font[@color]")
    } else {
        agenda_dir <- "/agenda"
        xpaths <-
            list(talk_text_all = "./tr/td[2]//font[@size]",
                 talk_author = "./tr/td[2]//font[@color]",
                 talk_color  = ".//font[@color]")
    }

    rf2_url <- paste0("https://raw.githubusercontent.com/eddelbuettel/rf2/refs/heads/",
                      "master/docs/RinFinance", year, agenda_dir, "/index.html")

    if (year == 2015) {
        # special-case because there's a typo in the HTML (<fonZt color="#595959"> in first table)

        rf2_data <- readLines(rf2_url)               # download data
        rf2_data <- gsub("fonZt", "font", rf2_data)  # fix typo

        # save to temp file
        tf <- tempfile()
        on.exit(unlink(tf), add = TRUE)
        writeLines(rf2_data, tf)

        # read into xml2 object
        rf2_html <- read_html(tf)
        browser()
    } else {
        rf2_html <- read_html(rf2_url)
    }

    list(create_one_agenda_day(1, xpaths, rf2_html),
         create_one_agenda_day(2, xpaths, rf2_html))
}

write_agenda <-
function(year, agenda = NULL, outdir = "assets/data-csv")
{
    if (is.null(agenda)) {
        agenda <- create_agenda(year)
    }

    outdir_year <- paste0(outdir, "/", year)
    dir.create(outdir_year, showWarnings = FALSE)
    for (i in seq_along(agenda)) {
        outfile <- paste0(outdir_year, sprintf("/agenda-day-%d.csv", i))
        write.table(agenda[[i]], outfile, row.names = FALSE, col.names = FALSE, sep = ",")
    }
}

create_and_write <-
function(yyyy)
{
    x <- create_agenda(yyyy)
    write_agenda(yyyy, x)
    invisible(x)
}

# NOTE: have to manually add "Tutorial" in column 4
create_and_write(2018)
create_and_write(2017)
create_and_write(2016)
create_and_write(2015)

