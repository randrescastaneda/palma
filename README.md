# palma
Palma inequality index in  Stata

```{stata}

levelsof urban, local(areas)
foreach area of local areas {
  disp as text _n " Palama index for `: label urban `area''"
  palma welfare if urban == `area' [w = weight]
}

```
