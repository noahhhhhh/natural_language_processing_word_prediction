require(ggplot2)
require(scales)
RankingChart <- function(tb){
    tb$y <- factor(tb$y, levels = tb$y[order(tb$prob, - rank(tb$y))])
    g <- ggplot(tb, aes(x = y, y = prob))
    g <- g + geom_bar(stat = "identity", fill = "skyblue2")
    g <- g + xlab("predictions")
    g <- g + scale_y_continuous(name = "prob.", labels = percent)
    g <- g + theme_bw()
    g <- g + theme(axis.text.x = element_text(angle = 45, hjust = 1))
    last_plot() + coord_flip()
}