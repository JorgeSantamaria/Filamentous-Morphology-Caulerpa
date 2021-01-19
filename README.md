# Filamentous Morphology Caulerpa

## Article title:
Stressful Conditions Give Rise to a Novel and Cryptic Filamentous Form of <i>Caulerpa cylindracea</i>

#### Journal:
Frontiers in Marine Science

##### Authors:
Jorge Santamaría, Raül Golo, Emma Cebrian, María García, Alba Vergés

##### Script authors:
J. Santamaría (jorge.santamaria@udg.edu) & R. Golo (raul.gonzalez@udg.edu)


## Abstract

Morphological plasticity can enable algae to adapt to environmental change and increase their invasibility when introduced into new habitats. Nevertheless, there is still a lack of knowledge on how such plasticity can affect the invasion process of an invasive species. In this context, the high plasticity in the genus Caulerpa is well documented. However, after an extremely hot summer, a previously unreported filamentous morphology of Caulerpa cylindracea was detected; indeed, this morphology could only be confirmed taxonomically after in-depth morphological characterization and molecular analysis with the genetic marker tufA. We describe an ex situ culture experiment which showed that stressful conditions, such as high temperatures, can trigger this morphological change. Almost all of the thalli maintained at a constant extreme temperature of 29ºC died, but after being returned to optimum temperature conditions, the filamentous morphology began to develop from the surviving microscopic tissue. In contrast, thalli at a control temperature of 21ºC maintained the regular morphology throughout the experiment. When C. cylindracea develops this filamentous morphology, it may act as a cryptic invader because it is difficult to detect in the field. Furthermore, the filaments likely improve C. cylindracea’s invasive capabilities with regard to resistance, persistence and dispersion and may have an important role in the re-colonization process, after a population disappears following a period of stressful conditions. Possibly, C. cylindracea’s ability to respond plastically to stressful conditions might explain its remarkable success as an invasive species.

## Methods

1) The effects of the extreme temperatures we applied to C. cylindracea were assessed by measuring the macroscopic morphometric changes. The structure and area of Caulerpa were measured by means of macroscopic photographs taken with an Olympus TG-5 camera, which were then analyzed with AdobePhotoshop CC 2018. Living parts of C. cylindracea were manually selected and measured using the “analysis tool.”
2) The morphological characterization of the cultured stolons and filaments was assessed by means of microscopic photographs, taken using a Zeiss AXIO Imager A.2 (Carl Zeiss, Berlin, Germany) equipped with an AxioCam MRc5 camera and a stereomicroscope Stemi 2000-C (Carl Zeiss, Berlin, Germany) equipped with an AxioCam ERc 5s camera; and the images were analyzed with Zen2011 software (Blue Edition). Also, to account for regional morphological variability, the mean stolon thickness of 10 randomly sampled stolons from each of the natural populations (Roses, Funtana, Split, Ponta Veslo, and Kallm) was compared to the thickness of filaments obtained at extreme temperatures.
3)Marine heat wave (MHW) events during 2018 at Ponta Veslo, Montenegro were calculated with the heatwaveR package using Reynolds Optimally Interpolated Sea Surface Temperature (OISST) data.

## Usage Notes

### FilamentousGrowth.R
Rcode to: i) Compare the area of Caulerpa cylindracea, between treatments, at the beginning and end of the extreme temperature experiment, and to: ii) Compare the thickness of C. cylindracea´s filaments vs the thickness of C. cylindracea´s stolons from different populations.

### Area.RData
Dataset with the measurements of C. cylindracea´s area at the beginning and end of the extreme temperature experiment. It is needed to perform the statistical model to compare the area of C. cylindracea between treatments.

### Filaments.RData
Dataset with the thickness measurements for C. cylindracea´s filaments and C. cylindracea´s stolons from different populations. It is needed to perform the statistical model to compare the thickness between morphological structures (filaments vs. stolons) and between stolons from different populations.

### MarineHeatWaves.R
Rcode to: i) Download Sea Surface Temperature (SST) data from NOAA (Reynolds Optimally Interpolated Sea Surface Temperature (OISST)), and to: ii) Calculate Marine Heat Waves (MHWs) at the location of interes with the heatwaveR package

