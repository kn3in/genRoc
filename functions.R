final_results <-  function(k, lambda_s, h_2_l, est_auc) {
 
 T0 <- qnorm(1 - k)
 z  <- dnorm(T0)
 i  <- z / k
 
 if (is.na(h_2_l)) {
   T1 <- qnorm(1 - lambda_s * k)
   h_2_l <- 2 * (T0 - T1 * sqrt(1 - (T0^2 - T1^2) * (1 - T0 / i))) / (i + T1^2 * (i - T0)) # eq 1
 } else {
   T1 <- (2 * T0 - i * h_2_l) / sqrt(4 - h_2_l^2 * i * (i - T0))
   lambda_s <- (1 - pnorm(T1)) / k
 }
 
 v  <- -i * (k / (1-k))

 dn <- function(rho) {
   (i - v) * h_2_l * rho / sqrt(h_2_l * rho * (1 - h_2_l * rho * i * (i - T0) + 1 - h_2_l * rho * v * (v - T0)))
 }

 auc <- function(rho) pnorm(dn(rho))

 auc_max <- auc(1)
 auc.5  <- auc(0.5)
 auc.25  <- auc(0.25)

 lambda_r <- lambda_s
 auc_fh2parent <- (((2 - lambda_r * k) * lambda_r + (k - 3)) * k + 1) / (2 * (1 - k))

 q <- qnorm(est_auc)
 h_2_x <- 2 * q^2 / ((v - i)^2 + q^2 * i * (i - T0) + v * (v - T0)) # eq 4
 rho_ghat_g <- h_2_x / h_2_l # eq 5
 T1_x <- (T0 - (h_2_x * i) / 2) / sqrt(1 - (h_2_x^2 * i * (i - T0)) / 4) # eq6
 lambda_s_x <- (1 - pnorm(T1_x)) / k # ~ eq 6
 risk_expl <- (lambda_s_x - 1) / (lambda_s - 1)

 results <- data.frame(
    Parameter = c("AUC_max",
                  "AUChalf",
                  "AUCquarter",
                  "AUCfh2parent",
                  "H^2_lx",
                  "Rho_gg",
                  "Lambda_sx",
                  "Prop_risk_expl",
                  "h_2_l"),
    Value = c(auc_max,
              auc.5,
              auc.25,
              auc_fh2parent,
              h_2_x,
              rho_ghat_g,
              lambda_s_x,
              risk_expl,
              h_2_l))
}

# Estimate at which lambda_s h_2_l become > 1
# use to restrict user input

lambda_sup <- function(k) {
  
  hlsq_minus_1 <- function(lambda_s, k) {
    T0 <- qnorm(1 - k)
    z  <- dnorm(T0)
    i  <- z / k
    T1 <- qnorm(1 - lambda_s * k)
    2 * (T0 - T1 * sqrt(1 - (T0^2 - T1^2) * (1 - T0 / i))) / (i + T1^2 * (i - T0)) - 1 # h_2_l - 1
  }
  
  tolerance <- 0.0001
  xmin <- 1
  # xmax exactly 1 over k, leads to numeric instability infinity/infinity due to 
  # qnorm(1 - lambda_s * k) = Inf, see definition of hlsq_minus_1 above or h_2_l
  # via equation 1. However, when k is fixed h_2_l - 1 is a monotonically increasing function of lambda_s.
  # i.e. root exists and unique (given signs of the function differ on the ends of a search interval)
  # Hence we can move upper bound by the tolerance level.
  xmax <- 1 / k - tolerance
  sup <- uniroot(hlsq_minus_1, c(xmin, xmax), tol = tolerance, k = k)
  sup$root

}


# ROC plotting
plotROC <- function(k, h_2_l, auc_max) {
  
  dt <- data.frame(hl_grid = seq(0.01, 1, by=0.01))
  dt$auc_m <- sapply(dt$hl_grid, function(x) final_results(k, NA, x, NA)[1,2])
  
  qplot(x = hl_grid, y = auc_m, data = dt, geom = "line") +
  geom_point(x = h_2_l, y = auc_max, color = "steelblue", size = 2) +
  geom_linerange(aes(x = h_2_l, ymin = 0.5, ymax = auc_max), color = "darkred", linetype = "longdash", size = 0.1) +
  geom_line(data = data.frame(x = c(0, h_2_l), y = c(auc_max, auc_max)), aes(x, y), color = "darkred", linetype = "longdash", size = 0.5) +
  theme_bw() +
  xlab(expression(h[L]^2)) +
  ylab(expression(AUC[max])) +
  ylim(c(0.5, 1)) +
  xlim(c(0, 1))
}


# Annotate output

annotateResults <- function(results_df) {
  annotation <- read.table("parameters_info.txt", sep = "\t", header = TRUE)
  annotation <- merge(results_df, annotation, by.x = "Parameter", by.y = "param", all.x = TRUE)
  annotation <- annotation[match(c("AUC_max","AUCfh2parent", "AUChalf", "AUCquarter", "Lambda_sx", "H^2_lx", "Rho_gg", "Prop_risk_expl"), annotation$Parameter), ]
  annotation <- annotation[ ,c("nice", "Value", "long")]
}

annotate_input <- function(input_values) {
  data.frame(     values = c(input_values$K, input_values$lambda_s, input_values$h_2_l, input_values$est_auc),
             description = c("Disease Prevalence",
                             "Sibling recurrence (risk)",
                             "Heritability of liability",
                             "AUC estimated by user from genetic risk score predicting case-control status"))
}




















