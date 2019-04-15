library(tidyverse)

compute_metric <- function(path) {
  df <- read_csv(path) %>% 
    mutate(t = TP+TN+FP+FN) %>% 
    mutate(po = (TP+TN)/t) %>% 
    mutate(pyes = ((TP+FP)/t) * ((TP+FN)/t)) %>% 
    mutate(pno = ((TN+FN)/t) * ((TN+FP)/t)) %>% 
    mutate(pe = pyes + pno) %>% 
    mutate(kappa = (po - pe)/(1 - pe)) %>% 
    select(learning_rate, weight_decay, kappa, accuracy)
  return(df)
}

metrics_all = tribble(~study, ~model_num, ~accuracy, ~kappa)

for (study in c('elbow', 'wrist', 'shoulder', 'forearm', 'hand', 'finger', 'humerus')) {
  metrics = compute_metric(paste0('./accuracy_', study, '.csv'))
  metrics <- metrics %>% 
    group_by(learning_rate, weight_decay) %>% 
    filter(kappa == max(kappa)) %>% 
    ungroup() %>%
    mutate(model_num = row_number()) %>% 
    filter(kappa == max(kappa)) %>% 
    mutate(study = study) %>% 
    select(study, model_num, accuracy, kappa)

  metrics_all <- metrics_all %>% bind_rows(metrics)
 
}

write_csv(metrics_all, './best_models.csv')
