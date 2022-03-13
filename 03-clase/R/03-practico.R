
# 03 Práctico: Tipos de datos ---------------------------------------------


# Cargar librerías --------------------------------------------------------

pacman::p_load(sjPlot, sjmisc)

# Cargar datos ------------------------------------------------------------

data <- readRDS("output/data/esi_proc.rds")

# Explorar datos ----------------------------------------------------------

view_df(data, encoding = "UTF-8")

# Tipos de datos ----------------------------------------------------------


## character ---------------------------------------------------------------

class(data$a6_otro)

## Factor ------------------------------------------------------------------

class(data$nivel)
frq(data$nivel)

## numeric ---------------------------------------------------------------

class(data$ingresos)
# ¡Sólo podemos hacer operaciones aritméticas con datos de clase numeric!
mean(data$nivel) #Tipo Factor
mean(data$ingresos) #Tipo numeric

## dbl + lbl -----------------------------------------------------------------

class(data$a6)
frq(data$a6)

## logical -----------------------------------------------------------------

class(data$afp)
frq(data$afp)
