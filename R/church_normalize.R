# Church-only extraction: museum normalization and its saved baseline stay fixed.
# Families are deliberately broad: a Baptist label cannot establish SBC affiliation.
DN_CHURCH_DENOM_PATTERNS <- c(
  christian_science='church of christ scien(tist|ce)|christian science',
  latter_day_saints='latter day saints|\\blds\\b',
  jehovahs_witness="jehovah'?s? witness|kingdom hall",
  seventh_day_adventist='seventh day adventist|\\bsda\\b',
  united_church_of_christ='united church of christ|\\bucc\\b',
  disciples_of_christ='disciples of christ',
  orthodox='\\borthodox\\b', catholic='\\bcatholic\\b',
  anglican_episcopal='\\banglican\\b|(?<!methodist )\\bepiscopal\\b',
  methodist='\\bmethodist\\b|\\bwesleyan\\b',
  presbyterian='\\bpresbyterian\\b', lutheran='\\blutheran\\b',
  baptist='\\bbaptist\\b', pentecostal='\\bpentecostal\\b|assembl(y|ies) of god|church of god in christ',
  church_of_christ='\\bchurch(es)? of christ\\b',
  nazarene='\\bnazarene\\b', reformed='\\breformed\\b',
  quaker='\\bquaker\\b|friends meeting', salvation_army='salvation army',
  unitarian_universalist='\\bunitarian\\b|\\buniversalist\\b',
  nondenominational='non denominational|nondenominational')

# A finite, explicit vocabulary handles compounds through 999. Larger/novel forms
# remain unparsed and appear in the ordinal review queue; they are never clipped.
dn_church_ordinal_words <- function() {
  small <- c('first','second','third','fourth','fifth','sixth','seventh','eighth','ninth','tenth',
    'eleventh','twelfth','thirteenth','fourteenth','fifteenth','sixteenth','seventeenth','eighteenth','nineteenth','twentieth')
  tens <- c('twenty','thirty','forty','fifty','sixty','seventy','eighty','ninety')
  tens_ord <- c('twentieth','thirtieth','fortieth','fiftieth','sixtieth','seventieth','eightieth','ninetieth')
  cardinal <- c('one','two','three','four','five','six','seven','eight','nine')
  words <- small[1:19]
  for (n in 20:99) words[n] <- if(n%%10==0L) tens_ord[n%/%10-1L] else paste(tens[n%/%10-1L],small[n%%10])
  for (n in 100:999) words[n] <- if(n%%100==0L) paste(cardinal[n%/%100],'hundredth') else paste(cardinal[n%/%100],'hundred',words[n%%100])
  stats::setNames(seq_along(words),words)
}
DN_CHURCH_ORDINALS <- dn_church_ordinal_words()

dn_church_name_expand <- function(clean) {
  # Retain the street meaning before the generic St -> Saint expansion.
  ordinal_pattern <- paste(c(names(DN_ORDINAL_WORDS),'[0-9]+(?:st|nd|rd|th)'),collapse='|')
  clean <- stringi::stri_replace_all_regex(clean,paste0('^(',ordinal_pattern,') st\\b'),'$1 street')
  x <- dn_name_expand(clean)
  matches <- stringi::stri_extract_all_regex(x,'\\b[0-9]+(?:st|nd|rd|th)\\b')
  nums <- unique(unlist(matches)); nums <- nums[!is.na(nums)]
  for (token in nums) {
    n <- suppressWarnings(as.integer(sub('(st|nd|rd|th)$','',token)))
    if(is.na(n)) next
    suffix <- if(n%%100 %in% 11:13) 'th' else c('th','st','nd','rd','th','th','th','th','th','th')[n%%10+1L]
    if(n>0L && n<=999L && token==paste0(n,suffix)) x <- stringi::stri_replace_all_regex(x,paste0('\\b',token,'\\b'),names(DN_CHURCH_ORDINALS)[n])
  }
  x
}

dn_church_parse_ordinal <- function(x) {
  out<-rep(NA_integer_,length(x));matched<-rep(NA_character_,length(x))
  # Six vectorized prefix lookups reuse a hash of the explicit vocabulary.
  # Per-row scans of 999 named words are prohibitively slow at national scale.
  for(k in 6:1) {
    prefix<-stringi::stri_extract_first_regex(x,paste0('^\\S+(?: \\S+){',k-1L,'}(?= |$)'))
    value<-unname(DN_CHURCH_ORDINALS[prefix])
    take<-is.na(out) & !is.na(value)
    out[take]<-value[take];matched[take]<-prefix[take]
  }
  rest<-stringi::stri_sub(x,from=nchar(matched)+2L)
  follower<-stringi::stri_extract_first_regex(rest,'^\\S+')
  # Day phrases describe Sabbath observance or theology, not congregation order.
  # An outer ordinal in First Seventh Day Baptist remains a congregation ordinal.
  held<-follower %in% c(DN_ORDINAL_TOPONYM_FOLLOWERS,'st','rd','and','psalm','century','annual','section','hour','day') |
    grepl('^episcopal district\\b',rest) |
    grepl('church of christ scien(tist|ce)|christian science|^seventh day adventist',x)
  out[held]<-NA_integer_
  out
}
dn_church_denom <- function(name, tags = rep(NA_character_,length(name))) {
  out <- rep(NA_character_,length(name))
  for(family in names(DN_CHURCH_DENOM_PATTERNS)) {
    hit <- !is.na(name) & stringi::stri_detect_regex(name,DN_CHURCH_DENOM_PATTERNS[[family]]) & is.na(out)
    out[hit] <- family
  }
  tag_map <- c(roman_catholic='catholic',catholic='catholic',baptist='baptist',pentecostal='pentecostal',
    anglican='anglican_episcopal',episcopal='anglican_episcopal',anglican_episcopal='anglican_episcopal',
    methodist='methodist',united_methodist='methodist',lutheran='lutheran',presbyterian='presbyterian',
    jehovahs_witness='jehovahs_witness',seventh_day_adventist='seventh_day_adventist',
    latter_day_saints='latter_day_saints',orthodox='orthodox',nondenominational='nondenominational')
  tagged <- unname(tag_map[tags])
  conflict <- !is.na(tagged) & !is.na(out) & tagged != out
  tibble::tibble(denom_norm=dplyr::coalesce(tagged,out), denom_from_name=out,
    denom_basis=ifelse(!is.na(tagged),'source_category',ifelse(!is.na(out),'name_heuristic','unknown')),
    denom_conflict=conflict)
}

dn_church_name_style <- function(expanded, core, ordinal) {
  out <- rep('other',length(expanded))
  put <- function(hit,value) { hit[is.na(hit)] <- FALSE; out[hit & out=='other'] <<- value }
  put(!is.na(ordinal),'ordinal')
  put(grepl('\\bsaint(e)?\\b',expanded) & !grepl('latter day saints',expanded),'saint')
  put(grepl('\\b(korean|chinese|vietnamese|hispanic|latino|latina|haitian|armenian|ethiopian|greek|russian|ukrainian|filipino|african american|slavic)\\b',expanded),'ethnolinguistic')
  put(grepl('\\b(grace|hope|faith|love|peace|charity|mercy|joy|redemption|salvation)\\b',expanded),'virtue')
  put(grepl('^(elevation|life|journey|mosaic|the rock|rock|crossroads)( church| fellowship)?$',core),'modern_brand')
  put(!is.na(expanded) & !is.na(core) & expanded!=core,'toponym')
  put(grepl('\\b(church|chapel|congregation|fellowship|assembly|meeting|cathedral|ministries|temple)\\b',expanded),'descriptive')
  out[is.na(expanded) | !nzchar(expanded)] <- NA_character_
  out
}

dn_normalize_churches <- function(raw,gazetteer) {
  dn_validate(raw,dn_schema_raw(),'church normalization input')
  unique_names<-unique(raw$name_raw);idx<-match(raw$name_raw,unique_names)
  clean<-dn_name_clean(unique_names)
  expanded<-dn_church_name_expand(clean)
  core<-dn_name_core(expanded,gazetteer)
  # Parse the geography-stripped name: First Mesa is a place, not ordinal one.
  # This also exposes ordinals following a locative prefix such as Peoria.
  ord<-dn_church_parse_ordinal(core)
  style<-dn_church_name_style(expanded,core,ord)
  denom<-dn_church_denom(expanded[idx],raw$denomination)
  out<-dplyr::bind_cols(raw,tibble::tibble(name_clean=clean[idx],name_expanded=expanded[idx],
    name_core=core[idx],name_key=dn_name_key(core)[idx],ordinal=ord[idx],
    scope_claim=dn_parse_scope_claim(clean)[idx],subject=rep(NA_character_,nrow(raw)),
    name_style=style[idx],denom_norm=denom$denom_norm))
  dn_validate(out,dn_schema_normalized(),'normalized churches')
}


