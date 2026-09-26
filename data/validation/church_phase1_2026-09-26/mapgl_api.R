for(n in c('maplibre','add_circle_layer','add_fill_layer','add_source','add_control','fit_bounds')) {
  cat('\n',n,'\n');print(args(get(n,asNamespace('mapgl'))))
}
