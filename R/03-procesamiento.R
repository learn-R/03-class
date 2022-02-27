
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

data <- read_dta(url("https://www.ine.cl/docs/default-source/encuesta-suplementaria-de-ingresos/bbdd/stata_esi/2020/esi-2020---personas.dta?sfvrsn=7a4b0e2b_4&download=true"))

# 3. Procesamiento --------------------------------------------------------

#a6_otro otras razones de ausencia del trabajo
#ing_t_d Total ingresos sueldos y salarios
#nivel Nivel educacional más alto aprobado
#b7a_1 empleador cotiza en sistema previsional o de pension (T/F)
#idrph identificador unico personas 

# a) Selección y transformación de datos ----------------------------------

proc <- data %>% 
  select(id = idrph,
         a6_otro,
         nivel,
         ingresos = ing_t_d,
         afp = b7a_1) %>% 
  mutate(nivel = as.numeric(.$nivel)) %>% 
  mutate(id = as.character(.$id),
         nivel = as_factor(car::recode(.$nivel, 
                                       c("c(0, 1, 2) = 'Menos que basica/primaria';
                                         3 = 'Basica o primaria';
                                         c(4,5, 6) = 'Media o humanidades';
                                         c(7, 8) = 'Tecnico profesional';
                                         c(9, 10,11, 12) = 'Universitaria o mas';
                                         c(14, 88, 99, 902) = NA")),
                           as.factor = T,
                           levels = c('Menos que basica/primaria',
                                      'Basica o primaria',
                                      'Media o humanidades',
                                      'Tecnico profesional',
                                      'Universitaria o mas')),
         afp = ifelse(afp == 1, T, F))


# b) Etiquetado -----------------------------------------------------------

proc$id <- set_label(proc$id, "Identificador de individuo")
proc$a6_otro <- set_label(proc$a6_otro, "Otras razones de ausencia al trabajo")
proc$nivel <- set_label(proc$nivel, "Nivel educacional mas alto aprobado")
proc$ingresos <- set_label(proc$ingresos, "Ingresos por sueldos y salarios")
proc$afp <- set_label(proc$afp, "Empleador cotiza en prevision (AFP)")

# 4. Exportar datos ----------------------------------------------------------

saveRDS(proc, "output/data/esi_proc.rds")

