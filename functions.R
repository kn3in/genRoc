final_results <-  function(k, lambda_s, h_2_l, est_auc) {
 # if (missing(h_2_l)) {
 T0 <- qnorm(1 - k)
 T1 <- qnorm(1 - lambda_s * k)
 z  <- dnorm(T0)
 i  <- z / k
 h_2_l <- 2 * (T0 - T1 * sqrt(1 - (T0^2 - T1^2) * (1 - T0 / i))) / (i + T1^2 * (i - T0)) # eq 1
 # } else {
 
 
 v  <- -i * (k / (1-k))

 dn <- function(rho) {
   (i-v) * h_2_l * rho / sqrt(h_2_l * rho * (1 - h_2_l * rho * i * (i - T0) + 1 - h_2_l * rho * v * (v - T0)))
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
    Parameter = c("AUCmax",
                  "AUChalf",
                  "AUCquarter",
                  "AUCfh2parent",
                  "H^2_lx",
                  "Rho_gg",
                  "Lambda_sx",
                  "Prop_risk_expl"),
    Value = c(auc_max,
              auc.5,
              auc.25,
              auc_fh2parent,
              h_2_x,
              rho_ghat_g,
              lambda_s_x,
              risk_expl))
  results$Value <- as.character(round(results$Value, 2))
  results
}
