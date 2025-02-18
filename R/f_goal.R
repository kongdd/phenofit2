#' Goal function of fine curve fitting methods
#'
#' @inheritParams optim_pheno
#' @inheritParams doubleLog_Beck
#'
#' @param fun A curve fitting function, can be one of `doubleAG`,
#' `doubleLog.Beck`, `doubleLog.Elmore`, `doubleLog.Gu`,
#' `doubleLog.Klos`, `doubleLog.Zhang`, see [Logistic()]
#' for details.
#' @param ... others will be ignored.
#'
#' @return RMSE Root Mean Square Error of curve fitting values.
#'
#' @example R/examples/ex-f_goal.R
#'
#' @export
f_goal <- function(
    par, fun, y, t,
    pred, w, ylu, ...)
{
    if (missing(pred)) pred = y*0
    # FUN <- match.fun(fun)
    if (!all(is.finite(par))) return(9999)

    # fun is c++ function, pred address will be reused
    # fun(par, t, pred)
    pred = fun(par, t)
    # If have no finite values, return 9999
    if (!all(is.finite(pred))) return(9999) # for Klos fitting

    if (!missing(w)) {
        # if (!missing(ylu)){
        #     # points out of ylu should be punished!
        #     w[pred < ylu[1] | pred > ylu[2]] <- 0
        #     # pred   <- check_ylu(pred, ylu)
        # }
        SSE  <- sum((y - pred)^2 * w)
    } else {
        SSE  <- sum((y - pred)^2)
    }
    return(SSE)
    # if (missing(w)) w <- rep(1, length(y))
    # RMSE <- sqrt(SSE/length(y))
    # return(RMSE)

    # NSE  <- SSE/sum((y - mean(pred))^2)
    # 1. better handle low and high values simulation
    # xpred_2 <- sqrt(xpred_2)
    # x_2     <- sqrt(x_2)
    # xpred_2 <- log(xpred_2+1)
    # x_2     <- log(x_2+1)
    # xpred_2 <- 1/pred          # inverse NSE
    # x_2     <- 1/y

    # xpred_2 <- pred - mean(y)
    # x_2     <- y - mean(y)
    # NSE2 <- sum((x_2 - xpred_2)^2 * w)/sum((x_2 - mean(x_2))^2) #NSE

    # const <- ylu[2]
    # xpred_2 <- pred - ylu[1]; xpred_2[xpred_2 < 0] <- const
    # x_2     <- y     - ylu[1]; x_2[x_2 < 0] <- const
}

# f_goal2 <- function(
#     par, fun, y, t, pred,
#     w = NULL, ylu = NULL, ...){
#     f_goal_cpp(par, fun, y, t, pred, w, ylu)
# }
