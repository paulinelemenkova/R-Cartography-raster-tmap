# R Cartography with tmap and raster — DEM Terrain Relief and Thematic Mapping

A collection of R scripts for cartographic visualisation using the tmap, raster
and sf ecosystem. The core theme is DEM-based terrain relief mapping (slope,
aspect, hillshade and elevation), computed from SRTM elevation grids and
rendered as publication-quality thematic maps; a secondary set demonstrates
thematic-mapping techniques (choropleth, proportional symbols, isopleth, grid,
discontinuities, labels and links).

## Related publication

The Bulgaria script (Bulgaria_SlopeAspect.r) produced the R figures in:

Lemenkova, P. Geocomputation of DEM Based Terrain Relief in Bulgaria Using GMT
and R Scripting Approaches. Annual of the University of Architecture, Civil
Engineering and Geodesy (UACEG), Sofia 2022, 55(1), 169-181.

- DOI (Zenodo): https://doi.org/10.5281/zenodo.6405154
- HAL:          https://hal.science/hal-03627173
- SSRN:         https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4072391
- Journal:      https://uacg.bg/?p=803&l=2 (ISSN 1310-814X)

The article combines two scripting toolsets, GMT (Generic Mapping Tools) and R;
this repository holds the R (tmap/raster) scripts.

## DEM terrain relief scripts

Bulgaria_SlopeAspect.r is the reference workflow:

- Downloads an SRTM elevation DEM for a country with raster::getData("alt", ...).
- Derives terrain characteristics from the DEM: slope and aspect with
  terrain(opt = "slope" / "aspect"), and a shaded relief with hillShade(slope,
  aspect, angle, direction).
- Renders slope, aspect, hillshade, elevation and a combined elevation-over-
  hillshade map with tmap (tm_shape + tm_raster), using perceptually-uniform and
  diverging palettes (plasma, Spectral, cividis, terrain), data classification
  (quantile, kmeans) with explicit breaks, legend histograms, graticules
  (tm_graticules), scale bars (tm_scale_bar), compass roses (tm_compass) and full
  layout control (tm_layout).
- Arranges paired maps with tmap_arrange and exports at 300 dpi with tmap_save.
- Summarises the elevation, slope, aspect and hillshade distributions with
  histograms.

The same workflow is provided for many countries and regions (e.g. Iran, Iraq,
Italy, Japan, Jordan, Lebanon, Pakistan, Peru, Saudi Arabia, Serbia, Tanzania,
Ethiopia, Ghana, Malawi, Mongolia, Rwanda, Uganda), plus bathymetric relief from
GEBCO (RedSea_GEBCO.r) and topographic scripts (Peru_Topography.r).

## Thematic-mapping series

The numbered 0X_cartography_*.r scripts form a thematic-cartography series built
on tmap and the cartography package: OpenStreetMap basemaps, choropleth maps,
proportional-symbol and typology maps, label and link maps, isopleth
(interpolated) maps, gridded and hexbin maps, discontinuity maps and mapping of
sp/sf spatial objects, illustrated with population, wealth and administrative
datasets.

## Methods and techniques

- Terrain derivatives from a DEM: slope, aspect and analytical hillshade
  (illumination model).
- Raster processing and statistics (raster package), vector handling (sf, sp).
- Thematic cartography with tmap: raster and vector layers, data classification,
  colour palettes, graticules, scale bars, compasses and multi-panel layout.
- SRTM elevation and GEBCO bathymetry as input grids.

## Requirements

- R (>= 3.5)
- Packages: tmap, raster, sf, sp, ncdf4, RColorBrewer, cartography

Install with:

    install.packages(c("tmap", "raster", "sf", "sp", "ncdf4", "RColorBrewer", "cartography"))

## Usage

Run a script directly, e.g.:

    Rscript Bulgaria_SlopeAspect.r

DEM download requires a network connection. Change the country argument of
getData to map a different area.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

If you use the Bulgaria terrain script, please cite:

Lemenkova, P. Geocomputation of DEM Based Terrain Relief in Bulgaria Using GMT
and R Scripting Approaches. Annual of the University of Architecture, Civil
Engineering and Geodesy (UACEG), Sofia 2022, 55(1), 169-181.
https://doi.org/10.5281/zenodo.6405154

## License

See the LICENSE file in this repository.
