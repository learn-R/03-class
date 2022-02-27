
# 03 Práctico: Tipos de datos en R ----------------------------------------
# Código de procesamiento


# 1. Cargar librerías -----------------------------------------------------

pacman::p_load(tidyverse,
               haven,
               dplyr, 
               car,
               sjmisc,
               sjlabelled)

# 2. Cargar datos ---------------------------------------------------------

data <- read_sav(url("https://www.ine.cl/docs/default-source/seguridad-ciudadana/bbdd/2020/base-usuario-17-enusc-2020-sav.sav?sfvrsn=5352415b_4&download=true"))

# 3. Procesamiento --------------------------------------------------------

#rph_ID (identificador)
#rph_idgen (identidad de género)
#rph_edad (edad)
#VA_DC (victimización agregada delitos consumados) (TRUE/F)


# a) Selección y transformación de datos ----------------------------------

proc <- data %>% 
  select(id = rph_ID,
         idgen = rph_idgen,
         edad = rph_edad,
         cise = rph_p11,
         VA_DC) %>% 
  mutate(idgen = as.numeric(.$idgen)) %>% 
  mutate(id = as.character(.$id),
         idgen = as_factor(car::recode(.$idgen, 
                                       c("1 = 'Masculino';
                                         2 = 'Femenino';
                                         c(3,4) = 'Trans/Otro';
                                         c(88, 96, 99) = NA"))),
         edad = as.numeric(.$edad),
         VA_DC = ifelse(VA_DC == 1, T, F))


# b) Etiquetado -----------------------------------------------------------

proc$id <- set_label(proc$id, "Identificador de individuo")
proc$idgen <- set_label(proc$idgen, "Identidad de género")
proc$edad <- set_label(proc$edad, "Edad")
proc$cise <- set_label(proc$cise, "Situación de empleo")
proc$VA_DC <- set_label(proc$VA_DC, "Victimizacion agregada de delitos consumados")

# 4. Exportar datos ----------------------------------------------------------

saveRDS(proc, "output/data/enusc_proc.rds")

