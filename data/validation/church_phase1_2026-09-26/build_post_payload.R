for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
library(dplyr);library(ggplot2)
p<-'data/validation/church_phase1_2026-09-26'
bundle<-'posts/duplicate-church-names'
folder<-'data/processed/church_review'
required<-c('duplicate_counts','census_place_exclusivity','incorporated_place_exclusivity',
  'territory_summary','ordinal_ladders','naming_style_profile','municipal_multiplicity','coverage','publication_gates')
stopifnot(all(file.exists(file.path(folder,paste0(required,'.csv')))))
for(name in required) file.copy(file.path(folder,paste0(name,'.csv')),file.path(bundle,'payload',paste0(name,'.csv')),overwrite=TRUE)
# The post reads only the leading table; full rankings stay in the review exports.
counts<-readr::read_csv(file.path(folder,'duplicate_counts.csv'),show_col_types=FALSE) |>
  group_by(level) |> slice_head(n=200L) |> ungroup()
readr::write_csv(counts,file.path(bundle,'payload','duplicate_counts.csv'))
x<-targets::tar_read(church_named_analysis,store='_targets_churches')
points<-x |> filter(analysis_eligible,name_core=='first baptist church')
stopifnot(nrow(points)>1L,!anyDuplicated(points$entity_id),all(points$source=='overture'))
# Full-resolution polygons are used for analysis; simplify only this display copy.
states<-targets::tar_read(church_states,store='_targets_churches')
display<-sf::st_simplify(states,dTolerance=2500,preserveTopology=TRUE)
escape<-function(s) {
  s<-gsub('&','&amp;',s,fixed=TRUE);s<-gsub('<','&lt;',s,fixed=TRUE);s<-gsub('>','&gt;',s,fixed=TRUE)
  # mapgl's embedded GeoJSON crosses Windows encoding boundaries. HTML entities
  # keep exact visible Unicode names/aliases while this display payload is ASCII.
  vapply(enc2utf8(s),function(z) {
    if(is.na(z)) return('')
    paste0(vapply(utf8ToInt(z),function(cp) if(cp>127L) sprintf('&#x%X;',cp) else intToUtf8(cp),character(1)),collapse='')
  },character(1),USE.NAMES=FALSE)
}
points$popup<-paste0('<strong>',escape(points$primary_name),'</strong><br>',
  ifelse(is.na(points$place_name),'Outside a Census place',escape(points$place_name)),
  '<br>Source coordinates; factual review pending.<br>Overture ',DN_OVERTURE_RELEASE)
points$popup<-paste0(points$popup,ifelse(is.na(points$alt_names) | !nzchar(points$alt_names),'',
  paste0('<br>Source aliases: ',escape(points$alt_names))))
style<-list(version=8L,sources=list(empty=list(type='geojson',data=list(type='FeatureCollection',features=list()))),layers=list(list(id='background',type='background',
  paint=list('background-color'=dn_ink$page))))
map<-mapgl::maplibre(style=style,projection='mercator',center=c(-96,38),zoom=3) |>
  mapgl::add_fill_layer('states',source=display,fill_color=dn_ink$surface,fill_outline_color=dn_ink$axis) |>
  mapgl::add_circle_layer('churches',source=sf::st_as_sf(points[,c('entity_id','popup','lon','lat')],coords=c('lon','lat'),crs=4326),
    circle_radius=3,circle_color=dn_palette[['blue']],circle_opacity=.7,popup='popup') |>
  mapgl::fit_bounds(c(-125,24,-66,50)) |>
  mapgl::add_control(paste0('<div style="max-width:230px;padding:10px;font:12px/1.4 system-ui;background:white"><strong>First Baptist Church</strong><br>',format(nrow(points),big.mark=','),
    ' provisional sites<br>Factual review pending<br><small>Overture August 2026; Census 2023.<br>Source points; no visitor certification.</small></div>'),position='top-right')
# All boundaries, points and JS dependencies ship locally; no paid or remote tiles.
map<-htmlwidgets::onRender(map,"function(el,x){var m=this.getMap();m.addControl(new maplibregl.NavigationControl());var c={onAdd:function(){var d=document.createElement('div');d.className='maplibregl-ctrl maplibregl-ctrl-group';[['Lower 48',[-125,24,-66,50]],['Alaska',[-170,51,-130,72]],['Hawaii',[-161,18,-154,23]]].forEach(function(v){var b=document.createElement('button');b.textContent=v[0];b.style.cssText='display:block;width:auto;min-width:65px;padding:7px';b.onclick=function(){m.fitBounds([[v[1][0],v[1][1]],[v[1][2],v[1][3]]],{padding:35,duration:0});};d.appendChild(b);});this.node=d;return d;},onRemove:function(){this.node.remove();}};m.addControl(c,'top-left');}")
prov<-jsonlite::fromJSON('data/processed/tools/pandoc/provenance.json')
# Runtime path is recorded by the prior verified standalone museum build.
if(is.null(prov$executable)) {
  candidates<-list.files('data/processed/tools/pandoc',pattern='^pandoc[.]exe$',recursive=TRUE,full.names=TRUE)
  stopifnot(length(candidates)==1L);pandoc_dir<-dirname(normalizePath(candidates,winslash='/'))
}else pandoc_dir<-dirname(prov$executable)
Sys.setenv(RSTUDIO_PANDOC=pandoc_dir)
map_file<-dn_save_embed(map,'first-baptist','Provisional First Baptist worship sites',dir=file.path(bundle,'embeds'))
file.copy(map_file,'embeds/first-baptist.html',overwrite=TRUE)
# Display uses a contiguous-US static key view; other regions remain interactive.
points$region<-ifelse(points$state_fips=='02','Alaska',ifelse(points$state_fips=='15','Hawaii','Lower 48'))
display$region<-ifelse(display$STATEFP=='02','Alaska',ifelse(display$STATEFP=='15','Hawaii','Lower 48'))
plot<-ggplot()+geom_sf(data=display[display$region=='Lower 48',],fill=dn_ink$surface,color=dn_ink$axis,linewidth=.2)+
  geom_point(data=points[points$region=='Lower 48',],aes(lon,lat),color=dn_palette[['blue']],size=.5,alpha=.5)+
  coord_sf(xlim=c(-125,-66),ylim=c(24,50),expand=FALSE)+
  labs(title='Recorded First Baptist worship sites',subtitle='Contiguous-US key view; Alaska and Hawaii in the interactive map',
    caption='Provisional source points. Overture August 2026; Census 2023.')+
  theme_dupnames(base_size=14)+theme(axis.text=element_blank(),axis.title=element_blank())
dn_save_fallback(plot,'first-baptist',dir=bundle)
readr::write_csv(points[,c('entity_id','primary_name','alt_names','lon','lat','state_fips','place_geoid','place_name')],file.path(bundle,'payload','first-baptist-map.csv'))
jsonlite::write_json(list(draft=TRUE,published=FALSE,map_points=nrow(points),external_tiles=FALSE,
  source='Overture 2026-08-19.0; Census 2023',built=as.character(Sys.time())),file.path(p,'post_payload_build.json'),pretty=TRUE,auto_unbox=TRUE)






