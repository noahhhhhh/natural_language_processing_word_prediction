require(ggplot2)
require(scales)
RankingChart <- function(tb){
    tb$y <- factor(tb$y, levels = tb$y[order(tb$prob, - rank(tb$y))])
    g <- ggplot(tb, aes(x = y, y = prob))
    g <- g + geom_bar(stat = "identity", fill = "skyblue2", width = .5)
    g <- g + xlab("")
    g <- g + scale_y_continuous(name = "", labels = percent)
    g <- g + theme(panel.background = element_rect(fill = "white")
                   , plot.background = element_rect(fill = "white"))
    
    last_plot() + coord_flip()
}
